import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numnimsocial/models/post_model.dart';
import 'package:numnimsocial/models/user_model.dart';
import 'package:numnimsocial/states/authen.dart';
import 'package:numnimsocial/utility/my_constant.dart';
import 'package:numnimsocial/utility/my_dialog.dart';
import 'package:numnimsocial/widgets/show_form.dart';
import 'package:numnimsocial/widgets/show_icon_button.dart';
import 'package:numnimsocial/widgets/show_text.dart';

class MyService extends StatefulWidget {
  const MyService({Key? key}) : super(key: key);

  @override
  State<MyService> createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  String? post;
  var user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  TextEditingController textEditingController = TextEditingController();
  var postModels = <PostModel>[];
  bool load = true;

  @override
  void initState() {
    super.initState();
    findUserModel();
    readAllPost();
  }

  Future<void> readAllPost() async {
    await FirebaseFirestore.instance
        .collection('post').orderBy('timePost', descending: true)
        .snapshots()
        .listen((event) {
      if (postModels.isNotEmpty) {
        postModels.clear();
      }

      for (var element in event.docs) {
        PostModel postModel = PostModel.fromMap(element.data());
        postModels.add(postModel);
      }
      load = false;
      setState(() {});
    });
  }

  Future<void> findUserModel() async {
    print('## uid == ${user!.uid}');
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data()!);
      print('## userModel == ${userModel!.toMap()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Social'),
        backgroundColor: MyConstant.primary,
        actions: [
          ShowIconButton(
            iconData: Icons.exit_to_app,
            pressFunc: () {
              MyDialog(context: context).twoWayAction(
                title: 'Signout ?',
                subTitle: 'Please Signout for Signout',
                label1: 'Signout',
                pressFunc1: () {
                  processSignOut(context: context);
                },
              );
            },
            colorIcon: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          load ? const Center(child: CircularProgressIndicator()) : listPost(),
          addPost(),
        ],
      ),
    );
  }

  Widget listPost() => Padding(
    padding: const EdgeInsets.only(bottom: 80),
    child: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: postModels.length,
          itemBuilder: (context, index) => Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(postModels[index].urlAvatar),
                        ),
                        ShowText(label: postModels[index].namePost),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowText(
                          label: postModels[index].postBody,
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowText(
                            label: findTimePost(
                                timePost: postModels[index].timePost))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  );

  Column addPost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShowForm(
                  controller: textEditingController,
                  label: 'New Post :',
                  iconData: Icons.post_add,
                  changeFunc: (String string) {
                    post = string.trim();
                  }),
              ShowIconButton(
                  iconData: Icons.send,
                  pressFunc: () {
                    if (post?.isEmpty ?? true) {
                      MyDialog(context: context).twoWayAction(
                          title: 'No Post ?', subTitle: 'Post Fill Post');
                    } else {
                      processAddpost();
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> processSignOut({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Authen(),
          ),
          (route) => false);
    });
  }

  Future<void> processAddpost() async {
    Timestamp timePost = Timestamp.fromDate(DateTime.now());

    print('## timePost == $timePost');

    PostModel postModel = PostModel(
        namePost: userModel!.name,
        postBody: post!,
        timePost: timePost,
        uidPost: user!.uid,
        urlAvatar: userModel!.urlAvatar);

    print('## postModel ==> $postModel');

    await FirebaseFirestore.instance
        .collection('post')
        .doc()
        .set(postModel.toMap())
        .then((value) {
      print('## Add Post Success');
      textEditingController.text = '';
    });
  }

  String findTimePost({required Timestamp timePost}) {
    DateTime dateTime = timePost.toDate();
    DateFormat dateFormat = DateFormat('dd MMMM yyyy HH:mm');
    String result = dateFormat.format(dateTime);
    return result;
  }
}
