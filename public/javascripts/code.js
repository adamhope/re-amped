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

    function loadContent(face, content) {
        console.debug(face, content);
        $('.' + faceMap[direction] + ' .content').html(content);
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
        console.debug(room);
        drawWall(room, 'north');
        drawWall(room, 'south');
        drawWall(room, 'east');
        drawWall(room, 'west');
    }

    $('.item').mouseover(function () {
        // show remove link
    });

    // $('.face').click(function() {
    //     console.debug(this);
    //     $('.selected').removeClass('.selected');
    //     $(this).addClass('selected');
    //     
    //     // update message bar
    //     // if no wall option to add
    //     // if wall
    //       // remove wall option
    //       // if item
    //           // remove item
    //       // else add item
    //     
    // });
    $('.face').click(function () {
        var content = $('.content', this).html();
        if (!content) {
            // switch based on current direction
            // sets new coords
            // sets new direction
            // get block at new coords
            // draw room
            console.debug('get room data for ...', 'draw room');
        } else {
            console.debug('invalid move');
        }
    });

    function deleteWall() {
        console.debug('delete');
    }

    function addItem() {
        console.debug('addItem');
    }

    function getRoomData(loc, callback) {
        $.get(base_url + 'blocks/coordinate/' + loc.x + '/' + loc.y + '.json', callback);
    }

    function moveTo(pos) {
        // getRoomData
        // callback to drawRoom
    }

    // INIT
    getRoomData(location, drawRoom);

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
