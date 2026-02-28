package routes;

import utilities.FSR.PageModel;

class Page implements PageModel {
  @:action
  public function login(username: String, password: String) {
    trace('login u: $username; p: $password');
  }

  public function load() {
    var meow = ":3";

    return {
      meow: meow
    };
  }

  public function new() {
    trace("loaded Page.hx");
  }
}