var world = (function () {

  var zAxis    = 0,
      yAngle   = 0,
      xAngle   = 0,
      zAxisInc = 400,
      pos      = 0,
      maxPos   = 5,
      yAngInt  = 90,

  reset = function () {
    zAxis    = 0;
    yAngle   = 0;
    xAngle   = 0;
    zAxisInc = 400;
    pos      = 0;
    maxPos   = 5;
    yAngInt  = 90;
  },
  
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

      case 32: // space
        toggleShape();
        break;

      case 37: // left
        yAngle -= yAngInt;
        break;

      case 38: // up
        xAngle += 90;
        break;

      case 39: // right
        yAngle += yAngInt;
        break;

      case 40: // down
        xAngle -= 90;
        break;

      case 189: // minus
        if (pos > 0) {
          zAxis -= zAxisInc;
          pos -= 1;
          $('.rack .face > div')[pos].style.opacity = "1";
        }
        break;

      case 187: // plus
        if (pos < maxPos) {          
          zAxis += zAxisInc;
          pos += 1;
          $('.rack .face > div')[pos-1].style.opacity = "0";
        }
        break;

      }

    transformation = "translateZ(" + zAxis + "px)" +
      " rotateX(" + xAngle + "deg)" +
      " rotateY(" + yAngle + "deg)";

    $('.shape')[0].style.webkitTransform = transformation;

    e.preventDefault();

  };

  document.addEventListener('keydown', inputHandler, false);

  function loadContent(face, content) {
      $('.' + face + ' .content').html(content);
  }
  
  function hideWall(face) {
      $('.' + face).hide();
  }
  
  function showWall(face) {
      $('.' + face).show();
  }

  // TODO: put stuff on different walls based on direction you're facing in
  function drawRoom(room) {
      if (room.left) {
          showWall('five');
          loadContent('five', room.left);
      } else {
          loadContent('five', '');
          hideWall('five')
      }

      if (room.right) {
          showWall('two');
          loadContent('two', room.right);
      } else {
          loadContent('two', '');
          hideWall('two');
      }

      if (room.front) {
          showWall('three');
          loadContent('three', room.front);
      } else {
          loadContent('three', '');
          hideWall('three');
      }

  }

  $('.face').mouseover(function() {
    // why?
  });

  $('.face').click(function() {
    // why?
  });

  function deleteWall() {
      console.debug('delete');
  }

  function addItem() {
      console.debug('addItem');
  }

  function getRoomData(pos) {
      $.get();
  }

  function moveTo(pos) {
      // getRoomData
        // callback to drawRoom
  }
  
  return {
      drawRoom: drawRoom
  }

})();

var pos = {x: 0, y:0, d:'n'};

// getRoom()

// drawRoom()

// if face has no content move and change direction

// if face has content click to add content

// item click handler brings up lightbox

world.drawRoom({
    front: 'FRONT FRONT FRONT',
    // left: 'LEFT LEFT LEFT LEFT',
    right: 'right right right'
});