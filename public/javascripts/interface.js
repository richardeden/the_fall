function load_login_interface() {
  $("#login").dialog({
    bgiframe: true, autoOpen: false, height: 290, modal: true,
    buttons:{
      Login: function() {
        login();
      }
    }
  });

  $("#pick_player").dialog({
    bgiframe: true, autoOpen: false, height: 200, modal: true,
    buttons:{
      Select: function() {
        join();
      }
    }
  });
  
  $("#stats").dialog({
    bgiframe: true, autoOpen: false, height: 350, modal: true
  });
}
