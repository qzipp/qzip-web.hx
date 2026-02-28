package macros;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;

import utilities.FSR;

using StringTools;

class FSRMacro {
  static function force_load_class_file(file_path: String): Null<String> {
    #if macro
    final import_path = {
      file_path = Path.normalize(file_path);
      
      if(!file_path.endsWith(".hx")) null;         
      file_path = ~/(\/)/g.replace(file_path, ".");
      file_path = ~/(.*)(\.hx)/g.replace(file_path, "$1");

      file_path;
    };

    // hack to force load a class
    Context.getType(import_path);

    return import_path;
    #else
    return null;
    #end
  }

  static function relative_to(path: String, dir: String) {
    path = Path.normalize(path);
    dir = Path.normalize(dir);
    
    if(path.startsWith(dir))
      return path.replace(Path.addTrailingSlash(dir), "");

    return path;
  } 


	static function get_route_path(file_path: String, dir: String): Null<String> {
    #if macro
    var route_path = relative_to(file_path, dir);
		route_path = Path.directory(route_path);

		if(route_path == "")
			route_path = "/";

		return route_path;
    #else
    return null;
    #end
	}

  static function get_local_path(): Null<String> {
    #if macro
    final path_ereg = ~/#pos\((.+?):(.+?)\)/gm; 
    final pos = '${Context.getLocalClass().get().pos}';

    if(path_ereg.match(pos)) 
      return path_ereg.matched(1);
    else 
      return null;
    #else 
    return null;
    #end
  }

  // dont worry i hate this too
  static function read_routes(rel_routes_path: String): TMacroRouteMap {
    #if macro
    final local_file_path = get_local_path();
    if(local_file_path == null) throw "bradar wat is this";
    final local_path = Path.directory(local_file_path);

    final routes_path = Path.join([local_path, rel_routes_path]);

    final file_list = FileSystem.readDirectory(routes_path);

    final routes: TMacroRouteMap = new Map();


    for(file_name in file_list) {
      final rel_file_path = './' + Path.join([rel_routes_path, file_name]);
      final file_path = Path.join([routes_path, file_name]);
      
      final route_path = get_route_path(file_path, routes_path);
      
      if(FileSystem.isDirectory(file_path)) {
        final file_list = read_routes(rel_file_path);
        
        for(route_path => route in file_list) {
          routes.set('/' + Path.join([file_name, route_path]), route);
        }
      } else {
        if(!routes.exists(route_path)) 
          routes.set(route_path, []);
       
        var route = routes.get(route_path);
        final file_name_ext = Path.withoutDirectory(file_path);
        // final file_name = Path.withoutExtension(file_name_ext);

  			switch(file_name_ext) {
	  			case "Page.hx":
            final import_path = force_load_class_file(rel_file_path);

            route.push(TPageModel(file_path, import_path));
				  case "Page.html":
            final data = File.getContent(file_path);

  					route.push(TPageView(file_path, data));
	  			case "Page.css":
            final data = File.getContent(file_path);

		  			route.push(TPageStyle(file_path, data));


	  			case "Server.hx":
            final import_path = force_load_class_file(rel_file_path);

		  			route.push(TServer(file_path, import_path));
			  	case _:
            continue;
        }
      }
    }

    return routes;
    #else
    return new Map();
    #end
  }
  
  macro public static function read(e: Expr): Expr {
    final path: String = switch e.expr {
      case EConst(CString(path)): path;
      default: throw "explode.";
    }

    final routes = read_routes(path);
    final arr_map = [];

    for(route_path => route in routes) {
      arr_map.push(macro $v{route_path} => $v{route});
    }

    return macro $a{arr_map};
  }
}