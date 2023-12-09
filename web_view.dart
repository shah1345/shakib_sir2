import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';
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


    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),

                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),

              ],
            ),
      ) ?? false; //if showDialouge had returned null, then return false
    }



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
            decoration: const BoxDecoration(
                color: Colors.blueGrey, shape: BoxShape.circle),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(25), // Image radius
                child: Image.network(
                    'https://axismathematics.com/portal/shakib_sir.jpg',
                    fit: BoxFit.cover),
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
          WillPopScope(
            onWillPop:showExitPopup,



            child: InAppWebView(



                initialUrlRequest: URLRequest(
                  url: Uri.parse("https://axismathematics.com/portal"),
                  //navigationeDlegate: _interceptNavigation,
                ),

                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(

                      useOnDownloadStart: true,
                      useShouldOverrideUrlLoading: true
                  ),
                ),


                shouldOverrideUrlLoading: (controller, request) async {
                  var url = request.request.url;
                  var uri = Uri.parse(url.toString());
                  // _interceptNavigation;
                  print("URL Data $url");
                  if (!["http", "https", "file",
                    "chrome", "data", "javascript",
                    "about"].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                      // Launch the App
                      await launchUrl(
                        uri,
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
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


                onDownloadStartRequest: (controller,
                    downloadStartRequest) async {
                  _launchInBrowser(downloadStartRequest.url);


                  //   await downloadFile(downloadStartRequest.url.toString(),
                  //      // downloadStartRequest.suggestedFilename);
                  // };
                  // onDownloadStartRequest: (controller, url,) async {
                  //   // print("onDownloadStart $url");
                  //   //
                  //   // await launchUrl(Uri.parse(url.url.toString()));
                  //   // // final taskId = await FlutterDownloader.enqueue(
                  //   // //   url: url.toString(),
                  //   // //
                  //   // //   headers: {}, // optional: header send with url (auth token etc)
                  //   // //   savedDir: 'Download',
                  //   // //   showNotification: true, // show download progress in status bar (for Android)
                  //   // //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                  //   // // );
                  //
                  //
                  //
                  //
                  //
                  //    print("onDownloadStart $url");
                  //   final String urlFiles = "$url";
                  //    var uri = Uri.parse(url.url.toString());
                  //   void launchURL_files() async =>
                  //       await canLaunchUrl(uri) ? await launchUrl(uri) : throw 'Could not launch $urlFiles';
                  //    launchURL_files();
                  // },
                }),
          ),


          _progress < 1.0
              ? LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 50, 64, 75)))
              : Container(),
        ],

      ),

    );
  }


//   Future<void> downloadFile(String url, [String? filename]) async {
//     var hasStoragePermission = await Permission.storage.isGranted;
//     if (!hasStoragePermission) {
//       final status = await Permission.storage.request();
//       hasStoragePermission = status.isGranted;
//     }
//     if (hasStoragePermission) {
//       final taskId = await FlutterDownloader.enqueue(
//           url: url,
//           headers: {},
//           // optional: header send with url (auth token etc)
//           savedDir: (await getDownloadsDirectory())!.path,
//           saveInPublicStorage: true,
//           fileName: filename);
//       print(taskId);
//     }
//   }
// }


// NavigationDecision _interceptNavigation(NavigationRequest request) {
//   if (request.url.contains("mailto:")) {
//     launchUrlString('mailto:specify email address here');
//     return NavigationDecision.prevent;
//   } else if (request.url.contains("tel:")) {
//     launchUrlString('tel:specify telephone number here');
//     return NavigationDecision.prevent;
//   }
//   return NavigationDecision.navigate;
// }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}