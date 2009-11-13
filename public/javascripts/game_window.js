var x = 150;
var y = 150;

var ctx;
var WIDTH;
var HEIGHT;

var tile_w = 32;
var tile_h = 32;


function rect(x,y,w,h) {
  ctx.beginPath();
  ctx.rect(x,y,w,h);
  ctx.closePath();
  ctx.fill();
}

function line(x,y,x2,y2) {
  ctx.beginPath();
  ctx.moveTo(x,y);
  ctx.lineTo(x2,y2);
  ctx.closePath();
  ctx.stroke();
}

function clear() {
  ctx.clearRect(0, 0, WIDTH, HEIGHT);
}

//Login stuff here
function init() {
  ctx = $('#game_window')[0].getContext("2d");
  WIDTH = $("#game_window").width()
  HEIGHT = $("#game_window").height()
  clear();
  draw_map();
  setup_map();
}

function draw_tile(x,y,tile) {
  x = x * tile_w;
  y = y * tile_h;
  switch (tile) {
    case '|': line(x+16,y, x+16,y+tile_h);break;
    case '-': line(x,y+16, x+tile_w,y+16);break;
    case '+': line(x,y+16, x+tile_w,y+16); line(x+16,y, x+16,y+tile_h); break;
  }
}

function draw_player(id, x, y, avatar) {
  var player = $('#player_' + id);
  if (!player.length) {
    player = $('#blank_player').clone();
    player[0].id = 'player_' + id;
    player.css('background', avatar)
    $('#game').append(player);
  }
  player.css('top', (y * tile_h)+'px');
  player.css('left', (x * tile_w)+'px');
}

function remove_player(id) {
  $('#player_' + id).remove();
}

function clear_tile(x, y) {
  ctx.clearRect(x * tile_w, y * tile_h, tile_w, tile_h);
}

$(document).keydown(function(evt) {
  console.log(evt.keyCode);
  switch (evt.keyCode) {
    case 38: $.post('/game/move', {direction: 'north'});break;
    case 40: $.post('/game/move', {direction: 'south'});break;
    case 37: $.post('/game/move', {direction: 'west'});break;
    case 39: $.post('/game/move', {direction: 'east'});break;
  }
});


init();
