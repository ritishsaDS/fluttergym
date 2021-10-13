import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl({
  required String url,
}) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

Future<void> downloadFile(
  BuildContext context, {
  required String uri,
}) async {
  var appDirectory = await getApplicationDocumentsDirectory();
  if (['png', 'jpg', 'pdf'].any((element) => uri.endsWith(element))) {
    await FlutterDownloader.enqueue(
      url: uri,
      savedDir: appDirectory.path,
    );
  }
}
