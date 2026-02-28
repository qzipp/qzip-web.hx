package utilities;

import haxe.macro.Context;
import haxe.macro.Expr;

// i need a fat hotdawg in my mouth ~orbl
class ComponentMacro {
	static inline final IN_META:String = ':in';

	macro static public function build():Array<Field> {
		final fields = Context.getBuildFields();
		var mapEntries:Array<Expr> = [];

		for (field in fields) {
			// Now we're going to iterate through the classes fields to identify the @:in meta
			for (m in field.meta) {
				if (m.name == IN_META) {
					// Check whether the field is a variable decl (FVar)
					final name:String = field.name;
					mapEntries.push(macro this._template_data.set($v{name}, this.$name));
					break;
				}
			}
		}

		var constructor:Field = null;
		for (f in fields) {
			if (f.name == "new") {
				constructor = f;
			}
		}

		if (constructor != null) {
			// if a constructor exists, we're going to attempt to merge them..
			switch (constructor.kind) {
				case FFun(f):
					final prevExpr = f.expr; // i dunno anymore...
					f.expr = macro {
						super();
						$prevExpr;
						$b{mapEntries};
					};
				default:
			}
		} else {
			// if the constructor does not exist, we're going to create one
			fields.push({
				name: "new",
				access: [APublic],
				kind: FFun({
					args: [],
					ret: null,
					expr: macro {
						super();
						$b{mapEntries};
					}
				}),
				pos: Context.currentPos()
			});
		}
		return fields;
	}

	macro static public function toAnon(expr:Expr):Expr { // better do this reflect shit at compile time
		return macro {
			var anon:Dynamic = {};
			final map:Map<String, Any> = $expr;
			if (map != null) {
				for (k in map.keys()) {
					Reflect.setField(anon, k, map.get(k));
				}
			}
			anon;
		};
	}
}
