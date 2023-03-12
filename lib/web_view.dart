import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewX extends StatefulWidget {
  const WebViewX({super.key});

  @override
  State<WebViewX> createState() => _WebViewXState();
}




class _WebViewXState extends State<WebViewX> {
  double _progress = 0.0;

  late InAppWebViewController _webViewController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "SHAKIB SIR",
          style: TextStyle(color: Colors.black),

        ),
        actions: [
          // action button

          Container(
            padding: EdgeInsets.all(3), // Border width
            decoration: BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(25), // Image radius
                child: Image.network('https://axismathematics.com/portal/shakib_sir.jpg',fit: BoxFit.cover),
              ),
            ),
          )

        ],


        /*

         decoration: BoxDecoration(
	shape: BoxShape.circle,
	image: DecorationImage(
	  image: NetworkImage('https://axismathematics.com/portal/shakib_sir.jpg'),
	  fit: BoxFit.fill
	),
  ),



         */
        // leading: IconButton(
        //   icon: Image.asset('assets/logo.png'),
        //   onPressed: () { },
        // ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse("https://axismathematics.com/portal"),
             // navigationeDlegate: _interceptNavigation,
            ),

            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(

                  useOnDownloadStart: true,
                  useShouldOverrideUrlLoading: true
              ),
            ),

            shouldOverrideUrlLoading: (controller, request) async {
              var url = request.url;
              var uri = Uri.parse(url);

              if (!["http", "https", "file",
                "chrome", "data", "javascript",
                "about"].contains(uri.scheme)) {
                if (await canLaunch(url)) {
                  // Launch the App
                  await launch(
                    url,
                  );
                  // and cancel the request
                  return ShouldOverrideUrlLoadingAction.CANCEL;
                }
              }

              return ShouldOverrideUrlLoadingAction.ALLOW;
            },

            onDownloadStart: (controller, url,) async {
              // print("onDownloadStart $url");
              final String _url_files = "$url";
              void _launchURL_files() async =>
                  await canLaunch(_url_files) ? await launch(_url_files) : throw 'Could not launch $_url_files';
              _launchURL_files();
            },


            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;

            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
          _progress < 1.0
              ? LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 50, 64, 75)))
              : Container(),
        ],
      ),
    );
  }
}



NavigationDecision _interceptNavigation(NavigationRequest request) {
  if (request.url.contains("mailto:")) {
    launchUrlString('mailto:specify email address here');
    return NavigationDecision.prevent;
  } else if (request.url.contains("tel:")) {
    launchUrlString('tel:specify telephone number here');
    return NavigationDecision.prevent;
  }
  return NavigationDecision.navigate;
}

