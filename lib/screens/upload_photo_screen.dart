import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/colores.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import '../Models/user_model.dart';
import '../utils/utils.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  Uint8List? _file;
  final TextEditingController _discriptionController = TextEditingController();
  bool _isLoading = false;

  String img =
      'https://imgs.search.brave.com/Y_wMHn-VdDevaRJD8VfqqnoOHVRNjeyhaCLIgqmsB50/rs:fit:1200:1200:1/g:ce/aHR0cDovL3d3dy5s/aW9ubGVhZi5jb20v/d3AtY29udGVudC91/cGxvYWRzLzIwMTQv/MTEvMTQxNTI3NV8y/MjgyMTgyMS5qcGc';

  void postImage(String uid, String profilePic, String username) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FirebaseMethods().uploadPost(
        _file!,
        uid,
        _discriptionController.text,
        username,
        profilePic,
      );

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnakBar('Posted!!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnakBar(res, context);
      }
    } catch (err) {
      showSnakBar(err.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Select Photo Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _discriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(CupertinoIcons.arrow_up_circle),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(CupertinoIcons.back),
                onPressed: () => clearImage(),
              ),
              title: const Text('Upload'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    _user.uid!,
                    _user.photoUrl!,
                    _user.username!,
                  ),
                  child: const Text(
                    'POST',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isLoading ? const LinearProgressIndicator() : const SizedBox(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_user.photoUrl ?? img),
                    ),
                    SizedBox(
                      width: 160,
                      child: TextField(
                        controller: _discriptionController,
                        decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Divider()
              ],
            ),
          );
  }
}
