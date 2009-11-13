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

function get_player(id) {
  return $('#player_'+id)
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

function draw_player(data) {
  data = data['player'];
  var id = data['id'];
  var player = get_player(id);
  if (!player.length) {
    player = $('#blank_player').clone();
    player[0].id = 'player_' + id;
    player.addClass(data['avatar'])
    $('#game').append(player);
  }
  player.css('top', (data['y'] * tile_h)+'px');
  player.css('left', (data['x'] * tile_w)+'px');
  $('#player_data_'+id+' .stats').each(function(){
    $(this).text(data[$(this).attr('id')]);
  });
}

var dead_player_img = new Image();
dead_player_img.src = '/images/skeleton.png';

function player_dead(player_id) {
  player_pos = get_player(player_id).position();
  ctx.drawImage(dead_player_img, player_pos.left, player_pos.top);
  remove_player(player_id);
  $('#player_data_'+player_id+' #health').text('DEAD!');
}

function remove_player(id) {
  $('#player_' + id).remove();
}

function activity(text) {
  $('#activity').prepend('<p>'+text+'</p>')
}

function clear_tile(x, y) {
  ctx.clearRect(x * tile_w, y * tile_h, tile_w, tile_h);
}

$(document).keypress(function(evt) {
  command = 'move';
  if (evt.shiftKey) {command = 'attack'};
  switch (evt.keyCode) {
    case 38: $.post('/game/'+command, {direction: 'north'});break;
    case 40: $.post('/game/'+command, {direction: 'south'});break;
    case 37: $.post('/game/'+command, {direction: 'west'});break;
    case 39: $.post('/game/'+command, {direction: 'east'});break;
  }
});


init();
