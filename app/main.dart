import 'dart:io';
import 'dart:json' as JSON;

final Path staticFiles = new Path("web/out");

main() {
  var env = Platform.environment;  
  var port = env['PORT'] == null ? 7000 : int.parse(env['PORT']);
  HttpServer.bind('0.0.0.0', port).then((HttpServer server) {
    print('Server started on port: ${port}');
    server.listen(_staticFileHandler,
                  onError: (error) => print("Failed to start server: $error"));
  });
}


void _staticFileHandler(HttpRequest request) {
  HttpResponse response = request.response;
  final String file= request.uri.path == '/' ? '/index.html' : request.uri.path;
  
  String filePath = staticFiles.append(file).canonicalize().toNativePath();
  print(filePath);
  if(!filePath.startsWith(staticFiles.toNativePath())){
    _send404(request, filePath);
  } else {
    final File file = new File(filePath);
    file.exists().then((bool found) {
      if (found) {
        print("200 - ${request.uri.path} - $filePath");
        file.openRead().pipe(response);
      } else {
        _send404(request, filePath);
      }
    });
  }
}

_send404(HttpRequest request, [String filePath = ""]) {
  print("404 - ${request.uri} - $filePath");
  request.response.statusCode = HttpStatus.NOT_FOUND;
  request.response.close();
}