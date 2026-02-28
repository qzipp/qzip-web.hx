package utilities;

import haxe.rtti.Meta;
import haxe.Template;

@:autoBuild(ComponentMacro.build())
abstract class Component {
  var _template_data:Map<String, Any> = [];

  final _template: Template;
  public function new() {
    final template_raw = this.template();
    
    this._template = new Template(template_raw);
  }
  
  public function render() {
    final context = ComponentMacro.toAnon(_template_data);
    final output = this._template.execute(context);
    
    return output;
  }
  
	public function template(): String {
    throw haxe.exceptions.NotImplementedException;
  }
}