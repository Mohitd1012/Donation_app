import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/user.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/screens/edit_user_detail_screen.dart';
import '../widgets/profile.dart';

class UserDetailScreen extends StatefulWidget {
  // const UserDetailScreen({ Key? key }) : super(key: key);
  static const routeName = "/user-detail";

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Users.getUser();
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text("Your Details"),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 10,
            ),
            ProfileWidget(
              imagePath: user.imagePath,
              isEdit: false,
              onClicked: () async {
                await Navigator.of(context).pushNamed(EditUserDetail.routeName);
                setState(() {});
              },
            ),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(
              height: 24,
            ),
            buildAbout(user),
          ],
        ));
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user.email,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 38,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.address,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'City',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.city,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'State',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.state,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
}
