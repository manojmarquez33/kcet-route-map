import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({Key? key, required className}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              if (await controller.canGoBack()) {
                // Check if WebView can go back
                controller.goBack();
                return false; // Prevent default back button behavior
              }
              return true; // Allow default back button behavior
            },
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: 'https://map-viewer.situm.com/?apikey=1acaf949bfe26eee639edd9733c8a4a2fdcb043dd1af83eb720bdb6a163cd1e7&domain=&lng=en-IN&buildingid=15488&floorid=49886&navigation_to=540169&navigation_from=540121',
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onPageFinished: (String url) {
                controller
                    .evaluateJavascript("javascript:(function() { " +
                    "var head = document.getElementsByTagName('header')[0];" +
                    "head.parentNode.removeChild(head);" +
                    "var footer = document.getElementsByTagName('footer')[0];" +
                    "footer.parentNode.removeChild(footer);" +
                    "})()")
                    .then((value) =>
                    debugPrint('Page finished loading Javascript'))
                    .catchError((onError) => debugPrint('$onError'));

                setState(() {
                  isLoading =
                  false; // Set isLoading to false when the page finishes loading
                });
              },
            ),
          ),
          if (isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80.0),
                  Padding(
                    padding: EdgeInsets.only(left: 56.0),
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
