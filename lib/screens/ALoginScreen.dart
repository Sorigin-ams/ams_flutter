import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/screens/AForgetPasswordScreen.dart';
import 'package:sk_ams/screens/ADashboardScreen.dart';
import 'package:sk_ams/utils/utils/AColors.dart';
import 'package:sk_ams/main.dart';
// Import for encoding and decoding JSON
// Import the HTTP package for API calls

class ALoginScreen extends StatefulWidget {
  const ALoginScreen({super.key});

  @override
  _ALoginScreenState createState() => _ALoginScreenState();
}

class _ALoginScreenState extends State<ALoginScreen> {
  var viewPassword = true;
  GlobalKey<FormState> mykey = GlobalKey<FormState>();

  // Add controllers to manage the text input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Mock data array with login credentials for testing purposes
  final List<Map<String, String>> mockLoginData = [
    {
      'email': 'user@example.com',
      'password': 'password123',
    },
    {
      'email': 'admin@example.com',
      'password': 'adminpass',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials on start
  }

  // Function to load saved credentials
  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('savedEmail');
    String? savedPassword = prefs.getString('savedPassword');

    if (savedEmail != null) {
      _emailController.text = savedEmail;
    }

    if (savedPassword != null) {
      _passwordController.text = savedPassword;
    }
  }

  // Handle login action
  Future<void> handleLogin() async {
    if (mykey.currentState!.validate()) {
      String username = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Uncomment the below section to enable API-based login

      /*
      final response = await http.post(
        Uri.parse('https://your-api-url.com/login'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);

        // Check if login was successful
        if (data['success']) {
          await _saveCredentials(username, password);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ADashboardScreen()),
          );
        } else {
          _showErrorDialog("Invalid username or password.");
        }
      } else {
        _showErrorDialog("Login failed. Please try again.");
      }
      */

      // Temporary local login logic using mock data for testing
      bool loginSuccess = mockLoginData.any((credentials) =>
      credentials['email'] == username &&
          credentials['password'] == password);

      if (loginSuccess) {
        await _saveCredentials(username, password);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ADashboardScreen()),
        );
      } else {
        _showErrorDialog("Invalid username or password.");
      }
    }
  }

  // Function to save credentials
  Future<void> _saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedEmail', email);
    await prefs.setString('savedPassword', password);
  }

  // Function to clear credentials
  Future<void> _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedEmail');
    await prefs.remove('savedPassword');
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Failed"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: appStore.isDarkModeOn
                        ? context.cardColor
                        : appetitAppContainerColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: 50,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    child: const Icon(Icons.arrow_back_ios_outlined,
                        color: appetitBrownColor),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Text('Login',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            const Text('Login using credentials',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
            Form(
              key: mykey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          labelText: 'Enter E-mail',
                          hintText: 'Enter your E-mail',
                          filled: true,
                          fillColor: appStore.isDarkModeOn
                              ? context.cardColor
                              : appetitAppContainerColor,
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter valid e-mail';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: viewPassword,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          labelText: 'Enter Password',
                          hintText: 'Enter your Password',
                          filled: true,
                          fillColor: appStore.isDarkModeOn
                              ? context.cardColor
                              : appetitAppContainerColor,
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => viewPassword = !viewPassword),
                            icon: viewPassword
                                ? const Icon(Icons.visibility_off,
                                color: Colors.grey)
                                : const Icon(Icons.visibility,
                                color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter valid Password';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const AForgetPasswordScreen())),
                        child: const Text('Forget password?',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                onPressed: handleLogin, // Call the handleLogin method
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Text('Login',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
