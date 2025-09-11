import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TorrentButton extends StatelessWidget {
  final String torrentUrl;

  TorrentButton({super.key, required this.torrentUrl});

  Future<void> _launchTorrent(BuildContext context) async {
    final Uri url = Uri.parse(torrentUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("can't launch torrent ⚠️")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _launchTorrent(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        side: BorderSide.none,
      ),
      child: Column(
        children: [
          Icon(
            Icons.download_rounded,
            size: 30.sp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
