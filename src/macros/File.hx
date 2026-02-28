package macros;

import haxe.macro.Context;
import haxe.macro.Expr;

import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

class File {
	public static macro function load_file(path: String): Expr {
		var pos = Context.currentPos();

		try {
			var base = Path.directory(Context.getPosInfos(pos).file);
			
			var caller_relative_path = Path.join([base, path]);

			// first try relative to caller's path, fallback to relative/absolute 
			final content = FileSystem.exists(caller_relative_path)
				? sys.io.File.getContent(caller_relative_path)
				: sys.io.File.getContent(path);

			return Context.makeExpr(content, pos);
		} catch (e: Dynamic) {
			return Context.error("shit don't work :< " + path, pos);
		}
	}
}
