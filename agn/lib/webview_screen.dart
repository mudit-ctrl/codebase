import 'package:agn/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebViewScreen extends ConsumerStatefulWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true; // Loading state for the WebView
  String? errorMessage; // Store error message

  @override
  void initState() {
    super.initState();
    WebView.platform = SurfaceAndroidWebView(); // Required for Android

    // Schedule the initial URL navigation after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navigationProvider.notifier).navigateTo(widget.url);
      _checkInternetAndLoad(widget.url); // Check internet and load the URL
    });
  }

  // Method to check internet connectivity
  Future<void> _checkInternetAndLoad(String url) async {
    try {
      // Perform a simple GET request to check internet connectivity
      final response = await http.get(Uri.parse('https://www.google.com'));

      if (response.statusCode == 200) {
        _loadWebPage(url); // Load the URL if internet is available
      } else {
        _showNoInternetDialog(); // Show dialog if internet is not available
      }
    } catch (e) {
      // Catch any errors (e.g., timeout, no internet)
      _showNoInternetDialog(); // Show dialog if there's an error
    }
  }

  // Method to load the web page
  Future<void> _loadWebPage(String url) async {
    // Load the URL
    controller.loadUrl(url);
  }

  // Method to refresh the WebView
  Future<void> _refresh() async {
    // Check internet connectivity before refreshing
    await _checkInternetAndLoad(widget.url);
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = ref.watch(navigationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game WebView'),
        backgroundColor: Colors.yellow[700], // Yellow AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Refresh button icon
            onPressed: _refresh, // Call refresh method
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(navigationProvider.notifier).goBack();
              final previousUrl = navigationState.goBack();
              if (previousUrl != null) {
                controller.loadUrl(previousUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              ref.read(navigationProvider.notifier).goForward();
              final nextUrl = navigationState.goForward();
              if (nextUrl != null) {
                controller.loadUrl(nextUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history')),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.yellow[50], // Light yellow background
            child: WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                controller = webViewController;
              },
              onPageFinished: (String url) {
                setState(() {
                  isLoading =
                      false; // Hide loading spinner when page finishes loading
                  errorMessage =
                      null; // Clear any error message when the page loads successfully
                });
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  isLoading = false; // Hide loading spinner
                  errorMessage =
                      "Failed to load page: ${error.description}"; // Set error message
                });
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('http')) {
                  return NavigationDecision.navigate;
                }
                return NavigationDecision.prevent;
              },
            ),
          ),
          if (isLoading) // Show loading spinner if loading
            const Center(child: CircularProgressIndicator()),
          if (errorMessage != null) // Show error message if exists
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
