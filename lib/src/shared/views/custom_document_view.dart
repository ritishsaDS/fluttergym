import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomDocumentView extends StatelessWidget {
  const CustomDocumentView({
    required this.title,
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String title;

  final String uri;

  static const routeName = '/document';

  static Route<void> route({
    required String title,
    required String uri,
  }) {
    return MaterialPageRoute(
      builder: (context) {
        return CustomDocumentView(
          title: title,
          uri: uri,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (uri.endsWith('.md')) {
      return _MarkdownView(title: title, uri: uri);
    } else if (uri.endsWith('.pdf')) {
      return _PdfView(title: title, uri: uri);
    } else if (uri.startsWith('http')) {
      return _WebView(title: title, uri: uri);
    }

    return const SizedBox.shrink();
  }
}

class _MarkdownView extends StatefulWidget {
  const _MarkdownView({
    required this.title,
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String title;

  final String uri;

  @override
  State<_MarkdownView> createState() => _MarkdownViewState();
}

class _MarkdownViewState extends State<_MarkdownView> {
  late AssetBundle _bundle;

  @override
  void initState() {
    super.initState();
    if (widget.uri.startsWith('assets')) {
      _bundle = DefaultAssetBundle.of(context);
    } else {
      _bundle = NetworkAssetBundle(Uri.parse(widget.uri));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DefaultAssetBundle(
        bundle: _bundle,
        child: FutureBuilder<String>(
          future: DefaultAssetBundle.of(context).loadString(widget.uri),
          builder: (context, snapshot) {
            return Markdown(
              data: snapshot.data ?? '',
              styleSheet: MarkdownStyleSheet(
                h2: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 30,
                ),
                textAlign: WrapAlignment.spaceBetween,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PdfView extends StatelessWidget {
  const _PdfView({
    required this.title,
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String title;

  final String uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return uri.startsWith('assets')
        ? SfPdfViewer.asset(uri)
        : SfPdfViewer.network(uri);
  }
}

class _WebView extends StatefulWidget {
  const _WebView({
    required this.title,
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String title;

  final String uri;

  @override
  State<_WebView> createState() => _WebViewState();
}

class _WebViewState extends State<_WebView> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canGoBack = await _controller?.canGoBack() ?? false;
        if (canGoBack) {
          await _controller?.goBack();
        }
        return Future.value(!canGoBack);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: WebView(
            gestureNavigationEnabled: true,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.uri,
          ),
        ),
      ),
    );
  }
}
