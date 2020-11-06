import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserState.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      decoration: InputDecoration(labelText: 'Email'),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
    );
    final passwordField = TextField(
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
      controller: _passwordController,
    );
    UserState userState = context.watch<UserState>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Welcome to Startup Names Generator, please log in below'),
                SizedBox(height: 10),
                emailField,
                SizedBox(
                  height: 10,
                ),
                passwordField,
                SizedBox(height: 10),
                userState.isAuthenticating()
                    ? Center(child: CircularProgressIndicator())
                    : _getLogInButton(context, userState)
              ],
            ),
          ),
        ));
  }

  ElevatedButton _getLogInButton(BuildContext context, userState) {
    return ElevatedButton(
        onPressed: () async {
          if (await userState.singIn(
              _emailController.text, _passwordController.text)) {
            Navigator.pop(context);
          } else {
            final snackBar = SnackBar(content: Text('There was an error logging into the app'));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        child: Text('Log in'),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.red[900])));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
