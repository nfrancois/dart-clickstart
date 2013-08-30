import 'dart:io';
import 'package:path/path.dart' as path;

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
  final String filePath= request.uri.path == '/' ? 'index.html' : request.uri.path.substring(1);
  String fileFullPath = path.joinAll(['web', filePath]);
  final File file = new File(fileFullPath);
  file.exists().then((bool found) {
    if (found) {
      file.openRead().pipe(response);
    } else {
      _send404(request, fileFullPath);
    }
  });
}

_send404(HttpRequest request, [String filePath = ""]) {
  print("404 - ${request.uri} - $filePath");
  request.response..statusCode = HttpStatus.NOT_FOUND
                  ..close();
}