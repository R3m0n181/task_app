import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoDashboard(),
    );
  }
}

class VideoDashboard extends StatefulWidget {
  @override
  _VideoDashboardState createState() => _VideoDashboardState();
}

class _VideoDashboardState extends State<VideoDashboard> {
  List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  void _fetchVideos() async {
    final response = await http.get(
        'https://hajjmanagment.online/api/external/atab/m360ict/get/video/app/test'
            as Uri);

    if (response.statusCode == 200) {
      setState(() {
        _videos = (json.decode(response.body) as List)
            .map((video) => Video.fromJson(video))
            .toList();
      });
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: Container(
        child: _videos.length > 0
            ? ListView.builder(
                itemCount: _videos.length,
                itemBuilder: (BuildContext context, int index) {
                  final video = _videos[index];
                  return VideoCard(video: video);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              video.caption,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              video.time,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Add logic to play video here
              },
              child: Text('Play Video'),
            ),
          ],
        ),
      ),
    );
  }
}

class Video {
  final String caption;
  final String time;
  final String url;

  Video({required this.caption, required this.time, required this.url});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      caption: json['caption'],
      time: json['time'],
      url: json['url'],
    );
  }
}
