import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class add_product extends StatefulWidget {
  const add_product({Key? key}) : super(key: key);
  static const routename = "/add_product";

  @override
  State<add_product> createState() => _add_productState();
}

class _add_productState extends State<add_product> {
  final _key = GlobalKey<FormState>();
  File? _image;
  File? compresedimage;
  String url = '';
  final imagepicker = ImagePicker();

  showSnackbar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future imagePickerMethod() async {
    final pick = await imagepicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        compressImage(_image);
      } else {
        showSnackbar('No Image Selected', const Duration(microseconds: 400));
      }
    });
  }

  void compressImage(File? file) async {
    // Get file path
    // eg:- "Volume/VM/abcd.jpeg"
    final filePath = file?.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath?.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath?.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath?.substring(lastIndex!)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath!, outPath,
        quality: 70);
    compresedimage = compressedImage;
  }
  Future uploadImage(String username, String uid, String name) async {
    Reference ref =
    FirebaseStorage.instance.ref().child(username).child(uid).child(name);
    await ref.putFile(compresedimage!);
    url = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:<Widget>[const TextButton(onPressed: null, child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 18,backgroundColor: Colors.blueGrey),))],
        title: const Center(child: Text('Add Post')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 13,),
            GestureDetector(onTap: (){imagePickerMethod().then((value) => uploadImage('username', 'Uid', 'name')).then((value) =>{'add in storage'});},child: Card(color: Colors.black12,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_a_photo),
                  SizedBox(width: 15),
                  Text('Add Photos'),
                ],
              ),
            ),),),
            Form(
                key: _key,
                child:
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Write any title',
                    labelText: 'Title *',
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                )),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.location_on),
                hintText: 'Where is it located',
                labelText: 'Location *',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.money),
                hintText: 'Rent',
                labelText: 'Rent *',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
                maxLines: 7,
              decoration: const InputDecoration(
                icon: Icon(Icons.description),
                hintText: 'Description',
                labelText: 'Description *',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
            ),
            GestureDetector(onTap:(){ print('Added');},child: Card(color: Colors.black12,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.post_add),
                  SizedBox(width: 15),
                  Text('Post'),
                ],
              ),
            ),),),

          ],
        ),
      ),
    );
  }
}
