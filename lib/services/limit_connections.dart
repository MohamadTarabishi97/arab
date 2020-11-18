import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
        ..maxConnectionsPerHost = 20;
  }
}