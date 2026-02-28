package src.routes;

class Root {
	public function new() {}

  @:header("content-type", "text/html; charset=utf8")
  @:get('/')
  public var main = new views.Index().render();

  @:get('/assets/js/client.js')
  public var client_js = macros.File.load_file("./export/js/Client.js");
}