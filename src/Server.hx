import tink.http.containers.*;
import tink.http.Response;
import tink.web.routing.*;

import utilities.FSR;
import macros.FSRMacro;

class Server {
	static var fsr_routes = FSRMacro.read("./routes/");

	public static function main() {
		var container = new NodeContainer(8080);

		var router = new FSR(fsr_routes);

    // var router = new Router<routes.Root>(new routes.Root());
		
    final instance = container.run((req) -> {
			var ctx = Context.ofRequest(req);

			return router.route(ctx)
				.recover(OutgoingResponse.reportError);
		});
		
		instance.handle((result) -> switch result {
			case Running(_):
				trace('Running');
				
			case Failed(error):
				trace(error);

			case Shutdown:
				trace('Shutdown');
		});
	}
}