package utilities;

import tink.http.Header.HeaderField;
import tink.core.Promise;
import tink.web.routing.Context;
import tink.http.Request;
import haxe.io.Path;
import tink.http.Response;

using StringTools;

enum EMacroRoute {
  TPageModel(file_path: String, import_path: String);
  TPageView(file_path: String, data: String);
  TPageStyle(file_path: String, data: String);
  
  TServer(file_path: String, import_path: String);
}

typedef TMacroRouteMap = Map<String, Array<EMacroRoute>>;


typedef TRoute = {
  var ?model: PageModel;
  var ?view: String;
  var ?style: String;
}

typedef TRouteMap = Map<String, TRoute>;

interface PageModel {
  public function load(): Any; 
}

interface Parser {
  public function parse(data: String): String;
}

class FSR {
  public var routes: TRouteMap = new Map();

  public var parsers = {
    view: new Map<String, Parser>(),
    style: new Map<String, Parser>()
  };

  public function new(macro_routes: TMacroRouteMap) {
    for(route_path => route_enums in macro_routes) {
      var route_data: TRoute = {};

			for(route_enum in route_enums) switch route_enum {
				case TPageModel(file_path, import_path):
					var ass = Type.resolveClass(import_path);
          
          var inst = Type.createInstance(ass, []);

          route_data.model = inst;
				case TPageStyle(file_path, data):
          var ext = Path.extension(file_path);
          
          route_data.style = data;
				case TPageView(file_path, data):
          var ext = Path.extension(file_path);
          
          route_data.view = data;
				case _:
					continue;
			}

      routes.set(route_path, route_data);
		}
  }

  public function route(i: Context): Promise<OutgoingResponse> {
    
    var path = i.getPath();
    
    var route = routes.get(path);
    
    trace(path, route, routes);
    if(route != null) {
      var header = new ResponseHeader(200, 'ok', [
        new HeaderField("content-type", "text/html")
      ]);
      return new OutgoingResponse(header, route.view);
    } else {
      var header = new ResponseHeader(404, 'not found');
      return new OutgoingResponse(header, 'The requested URL was not found');
    }
  }
}