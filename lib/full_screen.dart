import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class FullScreen extends StatefulWidget {
  final String imageurl;

  const FullScreen({super.key, required this.imageurl});
  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> downloadWallpaper() async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Storage permission denied')));
        return;
      }

      var file = await DefaultCacheManager().getSingleFile(widget.imageurl);

      Directory? directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }

      String newPath =
          '${directory?.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await file.copy(newPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wallpaper downloaded to: $newPath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Preview", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              widget.imageurl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          GestureDetector(
            child: InkWell(
              onTap: () {
                downloadWallpaper();
              },
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Download Wallpaper',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 