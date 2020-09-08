import 'dart:async';
import 'dart:io'; // fro file management
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // add this tool to the pubspec.yaml dependencies as image_picker
import 'package:firebase_storage/firebase_storage.dart'; // pubspec.yaml dependencies code : firebase_storage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File sampleVideo;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  Future getVideo() async {
    try {
      final tempVideo =
          await ImagePicker.pickVideo(source: ImageSource.gallery);

      setState(() {
        sampleVideo = tempVideo;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
       
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Upload'),
      ),
      body: Center(
        child: sampleVideo == null
            ? Text('select a video')
            : enableUpload(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getVideo,
        tooltip: 'Add Video',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget enableUpload(BuildContext context) {
     final List<Widget> children = <Widget>[];
    _tasks.forEach((StorageUploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
        //onDownload: () => downloadFile(task.lastSnapshot.ref),
      );
      children.add(tile);
    });
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(
            sampleVideo,
            height: 300.0,
            width: 300.0,
          ),
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () {
              final DateTime now = DateTime.now();
              final int millSeconds = now.millisecondsSinceEpoch;
              final String month = now.month.toString();
              final String date = now.day.toString();
              final String storageId = (millSeconds.toString());
              final String today = ('$month-$date');
              final StorageReference firebaseStorageRef = FirebaseStorage
                  .instance
                  .ref()
                  .child('video')
                  .child(today)
                  .child(storageId);
              final StorageUploadTask uploadTask = firebaseStorageRef.putFile(
                  sampleVideo, StorageMetadata(contentType: 'video/mp4'));
              uploaded(context);
            },
          )
        ],
      ),
    );
  }

  void uploaded(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text('Video Uploaded'),
      content: Text('Video Uploaded'),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
