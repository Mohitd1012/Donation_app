import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/user.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/widgets/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditUserDetail extends StatefulWidget {
  // const EditUserDetail({ Key? key }) : super(key: key);
  static const routeName = "/edit-user-detail";
  @override
  _EditUserDetailState createState() => _EditUserDetailState();
}

class _EditUserDetailState extends State<EditUserDetail> {
  User user;

  @override
  void initState() {
    // implement initState
    super.initState();
    user = Users.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Edit'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 10,
          ),
          ProfileWidget(
            imagePath: user.imagePath,
            isEdit: true,
            onClicked: () async {
              final image =
                  await ImagePicker().getImage(source: ImageSource.gallery);
              if (image == null) return;
              final directory = await getApplicationDocumentsDirectory();
              final name = basename(image.path);
              final imageFile = File('${directory.path}/$name');
              final newImage = await File(image.path).copy(imageFile.path);

              setState(() => user = user.copy(imagePath: newImage.path));
            },
          ),
          const SizedBox(height: 18),
          TextFieldWidget(
            label: "Full Name",
            text: user.name,
            onChanged: (name) => user = user.copy(name: name),
          ),
          const SizedBox(height: 18),
          TextFieldWidget(
            label: "Email",
            text: user.email,
            onChanged: (email) => user = user.copy(email: email),
          ),
          const SizedBox(height: 18),
          TextFieldWidget(
            label: "Address",
            text: '${user.address},${user.city},${user.state}',
            onChanged: (address) => user = user.copy(address: address),
          ),
          const SizedBox(height: 18),
          TextFieldWidget(
            label: "About",
            maxLines: 5,
            text: user.about,
            onChanged: (about) => user = user.copy(about: about),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              Users.setUser(user);
              Navigator.of(context).maybePop();
            },
            child: Text('Save'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatefulWidget {
  // const TextFieldWidget({ Key? key }) : super(key: key);
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    this.maxLines = 1,
    @required this.label,
    @required this.text,
    @required this.onChanged,
  });

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  TextEditingController controller;

  @override
  void initState() {
    // implement initState
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    // implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextField(
          controller: controller,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
