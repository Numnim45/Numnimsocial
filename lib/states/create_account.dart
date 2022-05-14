import 'package:flutter/material.dart';
import 'package:numnimsocial/utility/my_constant.dart';
import 'package:numnimsocial/utility/my_dialog.dart';
import 'package:numnimsocial/widgets/show_button.dart';
import 'package:numnimsocial/widgets/show_form.dart';
import 'package:numnimsocial/widgets/show_icon_button.dart';
import 'package:numnimsocial/widgets/show_image.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Account'),
        backgroundColor: MyConstant.primary,
      ),
      body: ListView(
        children: [
          newWidget(widget: newAvatar(context: context)),
          newWidget(
              widget: ShowForm(label: 'Name :', iconData: Icons.fingerprint)),
          newWidget(
              widget:
                  ShowForm(label: 'Email :', iconData: Icons.email_outlined)),
          newWidget(
              widget:
                  ShowForm(label: 'Password :', iconData: Icons.lock_outline)),
          newWidget(
              widget:
                  ShowBotton(label: 'Create New Account', pressFunc: () {})),
        ],
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
          const ShowImage(
            path: 'images/avatar.png',
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ShowIconButton(
              iconData: Icons.add_a_photo,
              pressFunc: () {
                MyDialog(context: context).twoWayAction(
                    pressFunc2: () {
                      Navigator.pop(context);
                    },
                    label2: 'Gallery',
                    pressFunc1: () {
                      Navigator.pop(context);
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
}
