import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../profile/profile_sections/profile_app_bar.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool isloading = false;
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..runJavaScript(
        "document.getElementsByTagName('body')[0].style.display='none';")
    ..loadRequest(Uri.parse("https://apniseva.com/Privacy_Policy"));
  // ..setNavigationDelegate(NavigationDelegate(
  //   onProgress: (int progress) {
  //     CircularProgressIndicator();
  //     // Update loading bar.
  //   },
  //   onPageStarted: (String url) {
  //       if (url.contains('https://getmobie.de/')) {
  //            //Added delayed future method for wait for the website to load fully before calling javascript
  //             Future.delayed(Duration(milliseconds: 900), () {
  //               _controller.runJavascriptReturningResult(
  //                     "document.getElementsByClassName('elementor elementor-7715 elementor-location-header')[0].style.display='none';"
  //                     "document.getElementsByClassName('elementor elementor-2727 elementor-location-footer')[0].style.display='none';"
  //               );
  //             });
  //   },
  // onPageFinished: (String url) {
  //   print(url);

  // _controller.runJavascript("document.getElementsByTagName('header')[0].style.display='none'");
  // onPageFinished: (url) async {
  // _controller.runJavascript("document.getElementsByTagName('header')[0].style.display='none'");
  // },
  //  },
  //   onWebResourceError: (WebResourceError error) {},
  //   // onNavigationRequest: (NavigationRequest request) {
  //   //   if (request.url.startsWith('https://www.youtube.com/')) {
  //   //     return NavigationDecision.prevent;
  //   //   }
  //   //   return NavigationDecision.navigate;
  //   // },
  //));

  // static get section => null;
  // ..runJavaScript(
  //     "document.getElementsByTagName('footer')[0].style.display='none'");
  // ..runJavaScript(
  //     "document.getElementsByTagName('header')[0].style.display='none'")

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (url) {
        isloading = true;
        setState(() {});
      },
      // onPageStarted: (url) {
      //   print("Page is started with documents");
      //   // isloading = false;
      //   setState(() {});
      // },
      onPageFinished: (url) async {
        isloading = false;
        _controller.runJavaScript(
            "document.getElementById('navbar').style.display='none';"
            "document.getElementsByClassName('uk-background-cover')[0].style.display='none';"
            "document.getElementsByTagName('footer')[0].style.display='none'");
        setState(() {}); //uk-background-cover
      },
    ));
    //     .setNavigationDelegate(NavigationDelegate(onProgress: (int progress) {
    //   CircularProgressIndicator();
    //   // Update loading bar.
    // }, onPageStarted: (String url) {
    //   if (url.contains('https://getmobie.de/')) {
    //     //Added delayed future method for wait for the website to load fully before calling javascript
    //     Future.delayed(Duration(milliseconds: 900), () {
    //       _controller.runJavaScriptReturningResult(
    //           "document.getElementsByClassName('elementor elementor-7715 elementor-location-header')[0].style.display='none';"
    //           "document.getElementsByClassName('elementor elementor-2727 elementor-location-footer')[0].style.display='none';");
    //     });
    //   }
    //   // onPageFinished: (String url) {
    //   //   print(url);
    //   // },
    //   // onWebResourceError: (WebResourceError error) {},
    //   // onNavigationRequest: (NavigationRequest request) {
    //   //   if (request.url.startsWith('https://www.youtube.com/')) {
    //   //     return NavigationDecision.prevent;
    //   //   }
    //   //   return NavigationDecision.navigate;
    //   // },
    // }));

    // _controller.runJavaScript(
    //     "document.getElementsByClassName('uk-container')[0].style.display");//navbar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimaryAppBar(
          title: "Privacy Policy",
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.red,
              ))
            : SafeArea(child: WebViewWidget(controller: _controller)));
  }
}
