var x = 150;
var y = 150;

var ctx;
var WIDTH;
var HEIGHT;

var tile_w = 32;
var tile_h = 32;

var dead_player_img = new Image();
dead_player_img.src = '/images/skeleton.png';

var wall = new Image();
wall.src = '/images/brick_wall.png';

var progress_bar_val = 0;


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
  ctx.fillStyle = '#000000';
  ctx.clearRect(0, 0, WIDTH, HEIGHT);
  rect(0, 0, WIDTH, HEIGHT);
  ctx.fill();
}

function get_player(id) {
  return $('#player_'+id)
}

//Login stuff here
function init() {
  ctx = $('#game_window')[0].getContext("2d");
  WIDTH = $("#game_window").width();
  HEIGHT = $("#game_window").height();
  clear();
  $('#pick_player').hide();
  //$('#login input[type=submit]').click(login);
  $('#pick_player input[type=submit]').click(join);
  $('#welcome').hide();
  $('#login').dialog('open');
}

function login() {
  action('login', {"name": $('#username').val(), "password": $('#password').val()});
  $('#login').hide();
}

function join() {
  var name = $('#player_list').val();
  action('join', {"name": name});
  $(document).keypress(key_handler);
  $('#pick_player').hide();
}

function draw_tile(x,y,tile) {
  x = x * tile_w;
  y = y * tile_h;
  switch (tile) {
    case '|':
    case '-':
    case '+':ctx.drawImage(wall, x, y);
      
    //case '|': line(x+16,y, x+16,y+tile_h);break;
    //case '-': line(x,y+16, x+tile_w,y+16);break;
    //case '+': line(x,y+16, x+tile_w,y+16); line(x+16,y, x+16,y+tile_h); break;
  }
}

function draw_player(data) {
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

function set_map(map) {
  $(map).each(function(r) {
    $(this).each(function(c) {
      draw_tile(c,r, this[0]);
    });
  });
}

function player_list(players) {
  var select = $('#player_list');
  $(players).each(function(){
    select.append($("<option></option>").text(this.name));
  });
}

function i_am(data) {
  $('#player_name').text(data.name);
  $('#player_icon').addClass(data.avatar);
  $('#player_data_x').attr('id', 'player_data_'+data.id); 
}

function key_handler(evt) {
  command = 'move';
  if (evt.shiftKey) {command = 'attack'};
  switch (evt.keyCode) {
    case 38: action(command, {direction: 'north'});break;
    case 40: action(command, {direction: 'south'});break;
    case 37: action(command, {direction: 'west'});break;
    case 39: action(command, {direction: 'east'});break;
    default: return;
  }
  return false;
}

function api_handler(cmds) {
  if (cmds == null) return;
  $(cmds).each(function(){
    command_handler(this['command'], this['data']);
  });
}

function action(command, data) {
  //$.post('/game/'+command, data, api_handler, 'json');
  juggernaut.sendData(Juggernaut.toJSON({"command": command, "data": data}));
}

Juggernaut.fn.receiveData = function(msg) {
  msg = Juggernaut.parseJSON(unescape(msg.toString()));
  console.log(msg);
  api_handler(msg);
}

function command_handler(command, data) {
  switch (command) {
    case 'draw_player': draw_player(data);break;
    case 'activity': activity(data);break;
    case 'player_dead': player_dead(data);break;
    case 'remove_player': remove_player(data);break;
    case 'map': set_map(data);break;
    case 'player_list': player_list(data);break;
    case 'you_are': i_am(data);break;
    default: activity('Unknown command: ' + command);
  }
}

$(document).bind('juggernaut:connected', init);
