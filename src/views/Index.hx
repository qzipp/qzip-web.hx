package views;

import utilities.Component;

// class Main extends Component {
//   @:in public var meow = "mrrp";
//   @:in public var purr = {
//     test: "nya"
//   };

//   public function new() {
//     super();
//   }

//   @:in function wawa(n: Int) {
//     return 2 + n;
//   }

// 	override function template() {
//     return '<!DOCTYPE html>
// <html lang="en">
// <head>
//   <meta charset="utf-8" />
//   <title>:3</title>
//   <link rel="stylesheet" href="/assets/css/main.css" />
// </head>
// <body>
//   <main>
//     <components.Meow />
//     <Meow>stupid</Meow>
//     <h1>purrr ::meow::</h1>
//     <div>::purr::; ::purr.test::</div>
//     <div>2 + 2 = ::wawa::</div>
//     <img src="https://gif.fxtwitter.com/tweet_video/HBoRgTTX0AAtxn4.gif" alt="sibuxiang and tuye"/>
//   </main>
//   <script src="/assets/js/client.js"></script>
// </body>
// </html>';
//   }
// }

class Index {
  public var meow = "prrr";
  public var wawa = "<h1>prrr</h1>";
  public var purr = {
    test: "nya"
  };

  public function new() {
    // super();
  }
  
  public var style = macros.File.load_file("./Index.css");

  @:template("Index.html") public function render();
}