class AppIcons {
  String googleIcon = 'assets/svgs/google_logo.svg';
  String githubIcon = 'assets/svgs/github.svg';
  String documentLogo = 'assets/svgs/document_logo.svg';
  String guestLogo = 'assets/svgs/guest.svg';
}

String emulatorUrl = "10.0.2.2";
String samsungDebug = "192.168.29.73";
String localhost = "localhost";
String baseUrl = "http://$localhost:5000";

class ApiRoutes {
  String signupRoute = "$baseUrl/api/signup";
  String getUserRoute = "$baseUrl/";
  String createDocumentRoute = "$baseUrl/doc/create";
  String getDocumentsRoute = "$baseUrl/doc/my";
}
