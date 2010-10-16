/*jslint white: true, browser: true, devel: true, evil: true, onevar: true, undef: true, nomen: true, eqeqeq: true, bitwise: true, regexp: true, newcap: true, immed: true, strict: true */

/*global $: true, window:true, jQuery:true */

"use strict";

var world = (function () {

    var zAxis = 0,
        yAngle = 0,
        xAngle = 0,
        zAxisInc = 400,
        pos = 0,
        maxPos = 5,
        yAngInt = 90,

    reset = function () {
        zAxis = 0;
        yAngle = 0;
        xAngle = 0;
        zAxisInc = 400;
        pos = 0;
        maxPos = 5;
        yAngInt = 90;
    },

    faceMap = {
        north: 'three',
        south: 'one',
        east: 'two',
        west: 'five'
    },

    base_url = 'http://localhost:3000/',

    location = {
        x: 0,
        y: 0
    },
    direction = 'north',
    editor = false,

    toggleShape = function () {
        reset();
        if ($('.shape').hasClass('cube')) {
            $('.shape').removeClass('cube');
        } else {
            $('.shape').addClass('cube');
        }
    },

    inputHandler = function (e) {

        var transformation = "";

        switch (e.keyCode) {

        case 32:
            // space
            toggleShape();
            break;

        case 37:
            // left
            yAngle -= yAngInt;
            break;

        case 38:
            // up
            xAngle += 90;
            break;

        case 39:
            // right
            yAngle += yAngInt;
            break;

        case 40:
            // down
            xAngle -= 90;
            break;

        case 189:
            // minus
            if (pos > 0) {
                zAxis -= zAxisInc;
                pos -= 1;
                $('.rack .face > div')[pos].style.opacity = "1";
            }
            break;

        case 187:
            // plus
            if (pos < maxPos) {
                zAxis += zAxisInc;
                pos += 1;
                $('.rack .face > div')[pos - 1].style.opacity = "0";
            }
            break;

        }

        transformation = "translateZ(" + zAxis + "px)" + " rotateX(" + xAngle + "deg)" + " rotateY(" + yAngle + "deg)";

        $('.shape')[0].style.webkitTransform = transformation;

        e.preventDefault();

    };

    document.addEventListener('keydown', inputHandler, false);

    function getRoomData(callback) {
        console.debug('getting room data');
        $.get(base_url + 'blocks/coordinate/' + location.x + '/' + location.y + '.json', callback);
    }

    function getItemData(itemNum, callback) {
        $.get(base_url + 'items/' + itemNum + '.json', callback);
    }

    function loadContent(direction, itemNum) {
        if (itemNum > 1) {
            getItemData(itemNum, function (data) {
                $('.' + faceMap[direction] + ' .content').html('<div class="item"><img src="' + data.item.image_url + '"</div>');
            });
        } else {
            $('.' + faceMap[direction] + ' .content').html('');
        }
    }

    function hideWall(direction) {
        $('.' + faceMap[direction]).removeClass('wall');
    }

    function showWall(direction) {
        $('.' + faceMap[direction]).addClass('wall');
    }

    function drawWall(room, direction) {
        if (room[direction] > 0) {
            showWall(direction);
            loadContent(direction, room[direction]);
        } else {
            loadContent(direction, '');
            hideWall(direction);
        }
    }

    function drawRoom(room) {
        console.debug('drawing room', room);
        drawWall(room, 'north');
        drawWall(room, 'south');
        drawWall(room, 'east');
        drawWall(room, 'west');
    }

    function refreshRoom() {
        console.debug('refreshRoom');
        getRoomData(drawRoom);
    }

    $('.deleteWall').click(function () {
        $.get(base_url + 'blocks/coordinate/' + location.x + '/' + location.y + '/' + direction + '/0.json', refreshRoom);
    });

    $('.face').click(function () {
        var content = $('.content', this).html();


        console.debug(location.x, location.y, direction);

        if ($(this).hasClass('three')) {
            
            
            if (!$(this).hasClass('wall')) {
                if (direction === 'north') {
                    location.y++;
                } else if (direction === 'east') {
                    location.x++;
                } else if (direction === 'south') {
                    location.y--;
                } else if (direction === 'west') {
                    location.x--;
                }
            } else {
                console.debug('wall has content, cannot go forwards');
            }
            
            
        } else if ($(this).hasClass('two')) {
            console.debug('turn right 90 deg');
            if (direction === 'north') {
                direction = 'east';
                faceMap = {
                    north: 'five',
                    south: 'two',
                    east: 'three',
                    west: 'one'
                };
            } else if (direction === 'east') {
                direction = 'south';
                faceMap = {
                    north: 'one',
                    south: 'three',
                    east: 'five',
                    west: 'two'
                };
            } else if (direction === 'south') {
                direction = 'west';
                faceMap = {
                    north: 'two',
                    south: 'five',
                    east: 'one',
                    west: 'three'
                };
            } else if (direction === 'west') {
                direction = 'north';
                faceMap = {
                    north: 'three',
                    south: 'one',
                    east: 'two',
                    west: 'five'
                };
            }            
        } else if ($(this).hasClass('five')) {
            console.debug('turn left 90 deg');
            if (direction === 'north') {
                direction = 'west';
                faceMap = {
                    north: 'two',
                    south: 'five',
                    east: 'one',
                    west: 'three'
                };
            } else if (direction === 'east') {
                direction = 'north';
                faceMap = {
                    north: 'three',
                    south: 'one',
                    east: 'two',
                    west: 'five'
                };
            } else if (direction === 'south') {
                direction = 'east';
                faceMap = {
                    north: 'five',
                    south: 'two',
                    east: 'three',
                    west: 'one'
                };
            } else if (direction === 'west') {
                direction = 'south';
                faceMap = {
                    north: 'one',
                    south: 'three',
                    east: 'five',
                    west: 'two'
                };
            }            
        } else {
            //  do nothing
        }
        
        getRoomData(drawRoom);

    });

    // INIT
    getRoomData(drawRoom);

    return {
        drawRoom: drawRoom,
        location: location,
        direction: direction,
        getRoomData: getRoomData
    };

}());

// if face has no content move and change direction
// if face has content click to add content
// item click handler brings up lightbox
