import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:provider/provider.dart';


class AddImagePage extends StatefulWidget {
  // need user data to process
  const AddImagePage({Key? key}) : super(key: key);

  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  final ImagePicker _picker = ImagePicker();
  final _productNameTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  XFile? image;

  final String placeholder_img = 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_272x92dp.png';
  final String handong_img = "https://handong.edu/site/handong/res/img/logo.png";

  String image_url_to_upload = '';
  String image_name_to_upload = '';

  bool uploading = false;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    // final simpleAppState = Provider.of<ApplicationState>(context, listen: false);
    // _productNameTextController.text = "hi";
    Future<void> addDataToFirebase() async {
      var imageURL;
      if(image != null) {
        // 1. Upload image to storage and get the image public url
        // this requires path_provider package

        // final appDocDir = await getApplicationDocumentsDirectory();
        // log("appDocDir is " + appDocDir.toString());
        // final filePath = "${appDocDir.absolute}/path/to/mountains.jpg";
        // final file = File(filePath);

        //  to upload image to cloud storage,
        log("image is ${image!.path}");
        log("image name is ${image!.name}");
        log("iamge hash code is ${image!.hashCode}");
        final file = File(image!.path);

        // Create the file metadata
        final metadata = SettableMetadata(contentType: "image/jpeg");

        // Create a reference to the Firebase Storage bucket
        final storageRef = FirebaseStorage.instance.ref();

        // Upload file and metadata to the path 'images/mountains.jpg'
        final uploadTask = await storageRef
            .child("images/$uid/${image!.name}")
            .putFile(file, metadata);

        // Get public url of the uploaded image
        imageURL = (await uploadTask.ref.getDownloadURL()).toString();
        log("image URL is $imageURL");

        image_url_to_upload = imageURL;
        image_name_to_upload = image!.name;
      }
      else {
        log("Image is null - use the default image");
        image_url_to_upload = handong_img;
        image_name_to_upload = 'default';
      }

      // 2. Add document to product collection
      //  product name
      //  creation date
      //  modified date (same as modified date when adding)
      //  price
      //  description
      //  creator
      //
      //  likes [] - likes in an array form
      //    likes array will contain user uid
      //    length of the array will be used to display the number of likes
      //  wishlist [] - wishlist array containing user uid
      //    can be queried like:
      //      final a_user's_wishlist =
      //        product_collection.where("wishlist", arrayContains: <uid>);
      //    this will return all document where wishlist field contains uid
      // create document of random name
      FirebaseFirestore.instance
          .collection('User').doc(uid).collection("Gallery")
          .add(<String, dynamic>{
            'imageUrl': "$imageURL",
            'memo': "",
            'timeCreated': FieldValue.serverTimestamp(),
            'timeModified': FieldValue.serverTimestamp(),
          });
    }

    return Scaffold(
        appBar: AppBar(
          leading: TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            onPressed: () =>
            {
              debugPrint("Cancel Add"),
              Navigator.of(context).pop()
            },
          ),
          title: const Center(child: Text("Add")),
          actions: [
            TextButton(
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                setState(() {
                  uploading = true;
                });
                // add data to firebase
                log("Beginning Add data to firebase!");
                // 0. Check if user added custom image
                await addDataToFirebase();
                log("done uploading!");

                if (!mounted) return;
                uploading = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            children: [

              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.none,
                    image: NetworkImage(placeholder_img),
                    opacity: (image==null)?1:0,
                  ),
                ),
                child: (image==null)?
                const SizedBox.shrink():
                Image(image: XFileImage(image!),)


              ),

              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.photo_camera),
                  onPressed: () async {
                    // do nothing if uploading is in progress
                    if(uploading) return;

                    // add data to firebase
                    // when add button is pressed,
                    // image should be uploaded to the Storage
                    // then public link that can be used to access the image should be fetched
                    // this link will be stored in the firestore product databsae
                    try {
                      final imageFile = await _picker.pickImage(
                          source: ImageSource.gallery);
                      setState(() {
                        image = imageFile;
                      });
                    }
                    catch(e) {
                      log("Exception occured getting image");
                      log(e.toString());
                    }
                    // log(image.toString());
                  },
                ),
              ),
              // need to surround with Form widget ???
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 35),
                child: Column(
                  children: [
                    TextFormField(
                      enabled: !uploading,
                      controller: _productNameTextController,
                      decoration: const InputDecoration(hintText: 'Product Name'),
                    ),
                    TextFormField(
                      enabled: !uploading,
                      controller: _priceTextController,
                      decoration: const InputDecoration(hintText: 'Price'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      enabled: !uploading,
                      controller: _descriptionTextController,
                      decoration: const InputDecoration(hintText: 'Description'),
                      maxLines: 5,
                      minLines: 1,
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}