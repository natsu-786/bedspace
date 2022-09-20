import 'dart:io';
import 'package:bedspace/providers/product.dart';
import 'package:bedspace/providers/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class add_product extends StatefulWidget {
  const add_product({Key? key}) : super(key: key);
  static const routename = "/add_product";

  @override
  State<add_product> createState() => _add_productState();
}

class _add_productState extends State<add_product> {
  final _key = GlobalKey<FormState>();
  double url = 0;
  final uid2 = FirebaseAuth.instance.currentUser!.uid;
  final ImagePicker _picker = ImagePicker();

  List<XFile> imageFileList = [];
  List<String> allurl = [];

  void selectImages() async {
    imageFileList = [];
    final List<XFile>? imgs = await _picker.pickMultiImage(imageQuality: 70);
    if (imgs!.isNotEmpty) {
      imageFileList.addAll(imgs);
      print(imageFileList);
    }
    setState(() {});
  }

  Future<void> uploadall(List<XFile> _images) async {
    for (int i = 0; i < _images.length; i++) {
      var imgurl = uploadFile(_images[i]);
      allurl.add(imgurl.toString());
    }
  }

  Future<String> uploadFile(XFile _imag) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(uid2)
        .child(DateTime.now().toString());
    UploadTask uploadtassk = ref.putFile(File(_imag.path));
    await uploadtassk.whenComplete(() {
      print(ref.getDownloadURL());
    });
    return await ref.getDownloadURL();
  }

  var initialdata =
      product(uid: '', title: '', description: '', price: '', location: '');
  var updateddata =
      product(uid: '', title: '', description: '', price: '', location: '');

  showSnackbar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          const TextButton(
              onPressed: null,
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    backgroundColor: Colors.blueGrey),
              ))
        ],
        title: const Center(child: Text('Add Post')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 13,
            ),
            GestureDetector(
              onTap: () {
                selectImages();
              },
              child: Card(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo),
                      SizedBox(width: 15),
                      Text('Add Photos'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: initialdata.title,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.title),
                          hintText: 'Write any title',
                          labelText: 'Title *',
                        ),
                        onSaved: (value) {
                          updateddata = product(
                              uid: updateddata.uid,
                              title: value,
                              description: updateddata.description,
                              price: updateddata.price,
                              location: updateddata.location);
                        },
                        validator: (String? value) {
                          return (value != null && value.contains('@'))
                              ? 'Do not use the @ char.'
                              : null;
                        },
                      ),
                      TextFormField(
                        initialValue: initialdata.location,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.location_on),
                          hintText: 'Where is it located',
                          labelText: 'Location *',
                        ),
                        onSaved: (value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                          updateddata = product(
                              uid: updateddata.uid,
                              title: updateddata.title,
                              description: updateddata.description,
                              price: updateddata.price,
                              location: value);
                        },
                        validator: (value) {
                          return (value != null && value.contains('@'))
                              ? 'Do not use the @ char.'
                              : null;
                        },
                      ),
                      TextFormField(
                        initialValue: initialdata.price,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.money),
                          hintText: 'Rent',
                          labelText: 'Rent *',
                        ),
                        onSaved: (value) {
                          updateddata = product(
                              uid: updateddata.uid,
                              title: updateddata.title,
                              description: updateddata.description,
                              price: value,
                              location: updateddata.location);
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
                        initialValue: initialdata.description,
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        decoration: InputDecoration(
                          icon: Icon(Icons.description),
                          hintText: uid2,
                          labelText: 'Description *',
                        ),
                        onSaved: (value) {
                          updateddata = product(
                              uid: updateddata.uid,
                              title: updateddata.title,
                              description: value,
                              price: updateddata.price,
                              location: updateddata.location);
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          return (value != null && value.contains('@'))
                              ? 'Do not use the @ char.'
                              : null;
                        },
                      ),
                    ],
                  )),
            ),
            GestureDetector(
              onTap: () {
                _key.currentState!.validate();
                _key.currentState!.save();
                uploadall(imageFileList).then((value) => {Provider.of<products>(context,listen: false).addProduact(uid2,updateddata)});
              },
              child: Card(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.post_add),
                      SizedBox(width: 15),
                      Text('Post'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
