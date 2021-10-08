import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/user.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: //Column(
          //   children: [
          //     Container(
          //       height: (MediaQuery.of(context).size.height -
          //               MediaQuery.of(context).padding.top) *
          //           0.5,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.only(
          //           bottomLeft: Radius.elliptical(100, 40),
          //           bottomRight: Radius.elliptical(100, 40),
          //         ),
          //         image: DecorationImage(
          //           image: AssetImage('assets/images/register.jpg'),
          //           fit: BoxFit.fill,
          //         ),
          //       ),
          //       child: Positioned(
          //         child: Container(
          //           margin: EdgeInsets.only(),
          //           child: Center(
          //             child: Text(
          //               'Login',
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 50,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),

          SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  // ..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.yellow,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    'Umeed',
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline6.color,
                      fontSize: 50,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: AuthCard(),
              ),
            ],
          ),
        ),
      ),
    );
    //   Padding(
    //     padding: EdgeInsets.all(30.0),
    //     child: Column(
    //       children: [
    //         Container(
    //           padding: EdgeInsets.all(5.0),
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(10),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Color.fromRGBO(100, 100, 100, 0.3),
    //                 blurRadius: 20.0,
    //                 offset: Offset(0, 10),
    //               ),
    //             ],
    //           ),
    //           child: Column(
    //             children: <Widget>[
    //               Container(
    //                 padding: EdgeInsets.all(8.0),
    //                 decoration: BoxDecoration(
    //                   border: Border(
    //                     bottom: BorderSide(color: Colors.grey[300]),
    //                   ),
    //                 ),
    //                 child: TextField(
    //                   decoration: InputDecoration(
    //                       hintText: "Email",
    //                       border: InputBorder.none,
    //                       hintStyle: TextStyle(color: Colors.grey[400])),
    //                 ),
    //               ),
    //               Container(
    //                 padding: EdgeInsets.all(8.0),
    //                 child: TextField(
    //                   obscureText: true,
    //                   decoration: InputDecoration(
    //                       hintText: "Password",
    //                       border: InputBorder.none,
    //                       hintStyle: TextStyle(color: Colors.grey[400])),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const SizedBox(height: 30),
    //         TextButton(
    //           onPressed: () {},
    //           child: Container(
    //             height: 50,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10),
    //               gradient: LinearGradient(
    //                 colors: [
    //                   Color.fromRGBO(100, 100, 100, 1),
    //                   Color.fromRGBO(255, 255, 255, 1),
    //                 ],
    //               ),
    //             ),
    //             child: Center(
    //               child: Text(
    //                 'Login',
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         const SizedBox(height: 70),
    //         Text(
    //           'Forgot Password ?',
    //           style: TextStyle(color: Colors.grey),
    //         )
    //       ],
    //     ),
    //   ),
    // ],
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  User user;
  Position currentLocation;
  String currentAddress;
  String currentCity;
  String currentState;

  final _passwordController = TextEditingController();

  @override
  void initState() {
    // implement initState
    super.initState();
    user = Users.getUser();
    _determinePosition();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentLocation = position;
        currentAddress = '${place.locality}';
        currentCity = '${place.subAdministrativeArea}';
        currentState = '${place.administrativeArea}';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 450 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                    onChanged: (name) => user = user.copy(name: name),
                  ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value.isEmpty || !value.contains('@')
                      ? 'Invalid email!'
                      : null,
                  onSaved: (value) {
                    _authData['email'] = value;
                    user = user.copy(email: value);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) => value.isEmpty || value.length < 5
                      ? 'Password is too short!'
                      : null,
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) => value != _passwordController.text
                            ? 'Passwords do not match!'
                            : null
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: () {
                      _submit();
                      user = user.copy(address: currentAddress);
                      user = user.copy(city: currentCity);
                      user = user.copy(state: currentState);
                      Users.setUser(user);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onPrimary:
                          Theme.of(context).primaryTextTheme.button.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    ),
                  ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} '),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    primary: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
