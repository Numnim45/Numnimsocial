import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numnimsocial/models/user_model.dart';
import 'package:numnimsocial/utility/my_constant.dart';
import 'package:numnimsocial/utility/my_dialog.dart';
import 'package:numnimsocial/widgets/show_button.dart';
import 'package:numnimsocial/widgets/show_form.dart';
import 'package:numnimsocial/widgets/show_icon_button.dart';
import 'package:numnimsocial/widgets/show_image.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  File? file;
  String? name, email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Account'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: ListView(
          children: [
            newWidget(widget: newAvatar(context: context)),
            newWidget(
                widget: ShowForm(
              label: 'Name :',
              iconData: Icons.fingerprint,
              changeFunc: (String string) {
                name = string.trim();
              },
            )),
            newWidget(
                widget: ShowForm(
              label: 'Email :',
              iconData: Icons.email_outlined,
              changeFunc: (String string) {
                email = string.trim();
              },
            )),
            newWidget(
                widget: ShowForm(
              label: 'Password :',
              iconData: Icons.lock_outline,
              changeFunc: (String string) {
                password = string.trim();
              },
            )),
            newWidget(
              widget: ShowBotton(
                label: 'Create New Account',
                pressFunc: () {
                  if (file == null) {
                    MyDialog(context: context).twoWayAction(
                        title: 'No Avatar ?', subTitle: 'Please Take Photo');
                  } else if ((name?.isEmpty ?? true) ||
                      (email?.isEmpty ?? true) ||
                      (password?.isEmpty ?? true)) {
                    MyDialog(context: context).twoWayAction(
                        title: 'Have Space ?',
                        subTitle:
                            'Please Fill Every Blank \nกรุณากรอกทุกช่อง ด้วย ค่ะ');
                  } else {
                    processRegister();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row newWidget({required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: widget,
        ),
      ],
    );
  }

  Container newAvatar({required BuildContext context}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32),
      width: 250,
      height: 250,
      child: Stack(
        children: [
          file == null
              ? const ShowImage(
                  path: 'images/avatar.png',
                )
              : Image.file(file!),
          Positioned(
            bottom: 0,
            right: 0,
            child: ShowIconButton(
              iconData: Icons.add_a_photo,
              pressFunc: () {
                MyDialog(context: context).twoWayAction(
                    pressFunc2: () {
                      Navigator.pop(context);
                      processTakePhoto(imageSource: ImageSource.gallery);
                    },
                    label2: 'Gallery',
                    pressFunc1: () {
                      Navigator.pop(context);
                      processTakePhoto(imageSource: ImageSource.camera);
                    },
                    label1: 'camera',
                    title: 'Require Photo',
                    subTitle: 'Please Tap Camera or Gallery');
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processTakePhoto({required ImageSource imageSource}) async {
    var result = await ImagePicker().pickImage(
      source: imageSource,
      maxWidth: 800,
      maxHeight: 800,
    );
    file = File(result!.path);
    setState(() {});
  }

  Future<void> processRegister() async {
    // Precess Create Now Account Firedase
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      String uid = value.user!.uid;
      print('Regis Success uid = $uid');

      // precess Uplond Image to Storage
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference reference = firebaseStorage.ref().child('avatar/$uid.jpg');
      UploadTask uploadTask = reference.putFile(file!);
      await uploadTask.whenComplete(() async {
        print('Uplond Success');

        // Find url Image Uplond
        await reference.getDownloadURL().then((value) async {
          String urlAvatar = value;
          print('urlAvatar = $urlAvatar');

          UserModel userModel = UserModel(
              email: email!,
              name: name!,
              password: password!,
              urlAvatar: urlAvatar);

          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .set(userModel.toMap())
              .then((value) {
            MyDialog(context: context).twoWayAction(
                title: 'create account Success',
                subTitle: 'Welcome to My App You Can Login by Click Authen',
                label1: 'Authen',
                pressFunc1: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
          });
        });
      });
    }).catchError((value) {
      MyDialog(context: context)
          .twoWayAction(title: value.code, subTitle: value.message);
    });
  }
}
