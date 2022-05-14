import 'package:flutter/material.dart';
import 'package:numnimsocial/states/create_account.dart';
import 'package:numnimsocial/utility/my_constant.dart';
import 'package:numnimsocial/widgets/show_button.dart';
import 'package:numnimsocial/widgets/show_form.dart';
import 'package:numnimsocial/widgets/show_image.dart';
import 'package:numnimsocial/widgets/show_text.dart';
import 'package:numnimsocial/widgets/show_text_button.dart';

class Authen extends StatelessWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Container(
          decoration: MyConstant().planBox(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                newImage(),
                newText(),
                newEmail(),
                newPassword(),
                newLoginButton(),
                newCreateAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row newCreateAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowText(
          label: 'Non Account ?',
          textStyle: MyConstant().h2Style(),
        ),
        ShowTextButton(
          label: 'Create Account',
          pressFunc: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAccount(),
                ));
          },
        ),
      ],
    );
  }

  ShowBotton newLoginButton() => ShowBotton(
        label: 'login',
        pressFunc: () {},
      );

  ShowForm newPassword() {
    return ShowForm(
      obscue: true,
      label: 'Password',
      iconData: Icons.lock_open_outlined, changeFunc: (String string ) {  },
    );
  }

  ShowForm newEmail() {
    return ShowForm(
      label: 'Email :',
      iconData: Icons.contact_mail_outlined, changeFunc: (String string ) {  },
    );
  }

  ShowText newText() {
    return ShowText(
      label: 'Login :',
      textStyle: MyConstant().h1Style(),
    );
  }

  SizedBox newImage() {
    return const SizedBox(
      width: 100,
      child: ShowImage(),
    );
  }
}
