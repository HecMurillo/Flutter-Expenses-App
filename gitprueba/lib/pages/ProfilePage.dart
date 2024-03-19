import 'package:flutter/material.dart';
import 'package:gitprueba/components/textfieldprofile.dart';
import 'package:gitprueba/components/profile_button.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final int userId;

  ProfilePage(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.userId})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.userEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/Users/Update'),
      body: {
        'id': widget.userId.toString(),
        'name': _nameController.text,
        'email': _emailController.text,
      },
    );

    if (response.statusCode == 200) {
      print('User updated successfully.');
    } else {
      print('Failed to update user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 60,
                    child: Text(
                      'Name: ',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: MyTextFieldPro(
                      controller: _nameController,
                      hintText: 'update Name',
                      obscureText: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 60,
                    child: Text(
                      'Email: ',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: MyTextFieldPro(
                      controller: _emailController,
                      hintText: 'update Email',
                      obscureText: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ProfileButton(
              onTap: _updateUser,
            ),
          ],
        ),
      ),
    );
  }
}
