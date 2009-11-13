var x = 150;
var y = 150;

var ctx;
var WIDTH;
var HEIGHT;


function rect(x,y,w,h) {
  ctx.beginPath();
  ctx.rect(x,y,w,h);
  ctx.closePath();
  ctx.fill();
}

function clear() {
  ctx.clearRect(0, 0, WIDTH, HEIGHT);
}

//Login stuff here
function init() {
  ctx = $('#game_window')[0].getContext("2d");
  WIDTH = $("#game_window").width()
  HEIGHT = $("#game_window").height()
  return setInterval(draw, 10);
}

//Main draw function
function draw() {
  clear();
  rect(10, 10, 10, 15);
}

init();
