import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sk_ams/screens/AForgetPasswordScreen.dart';
import 'package:sk_ams/screens/ADashboardScreen.dart';
import 'package:sk_ams/main.dart';

class ALoginScreen extends StatefulWidget {
  const ALoginScreen({super.key});

  @override
  _ALoginScreenState createState() => _ALoginScreenState();
}

class _ALoginScreenState extends State<ALoginScreen> {
  var viewPassword = true;
  GlobalKey<FormState> mykey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    _loadSavedCredentials();
  }

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

  Future<void> _saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> handleLogin() async {
    if (mykey.currentState!.validate()) {
      String username = _emailController.text.trim();
      String password = _passwordController.text.trim();

      bool loginSuccess = mockLoginData.any((credentials) =>
      credentials['email'] == username &&
          credentials['password'] == password);

      if (loginSuccess) {
        await _saveCredentials(username, password);
        await _saveLoginStatus();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ADashboardScreen()),
        );
      } else {
        _showErrorDialog("Invalid username or password.");
      }
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedEmail', email);
    await prefs.setString('savedPassword', password);
  }

  Future<void> _clearCredentialsAndStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedEmail');
    await prefs.remove('savedPassword');
    await prefs.remove('isLoggedIn');
  }

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
    // Adjust colors dynamically based on dark mode
    final isDarkMode = appStore.isDarkModeOn;
    final backgroundColor = Theme
        .of(context)
        .scaffoldBackgroundColor;
    final textColor = Theme
        .of(context)
        .colorScheme
        .onSurface;
    final hintTextColor = isDarkMode ? Colors.white70 : Colors.grey;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery
                .of(context)
                .viewPadding
                .top),
            const SizedBox(height: 60),
            Text('Login',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                  color: textColor, // Use text color from theme
                )),
            const SizedBox(height: 16),
            Text('Login using credentials',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: hintTextColor,
                )),
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
                          labelStyle: TextStyle(color: hintTextColor),
                          border: InputBorder.none,
                          labelText: 'Enter E-mail',
                          hintText: 'Enter your E-mail',
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          // Dynamic fill color
                          hintStyle: TextStyle(color: hintTextColor),
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
                          labelStyle: TextStyle(color: hintTextColor),
                          border: InputBorder.none,
                          labelText: 'Enter Password',
                          hintText: 'Enter your Password',
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          // Dynamic fill color
                          hintStyle: TextStyle(color: hintTextColor),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => viewPassword = !viewPassword),
                            icon: viewPassword
                                ? const Icon(Icons.visibility_off,
                                color: Colors.grey)
                                : const Icon(
                                Icons.visibility, color: Colors.grey),
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
                        onTap: () =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const AForgetPasswordScreen())),
                        child: Text('Forget password?',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: hintTextColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 60,
              child: ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
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
  }}




//API BELOW

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:sk_ams/screens/AForgetPasswordScreen.dart';
// import 'package:sk_ams/screens/ADashboardScreen.dart';
// import 'package:sk_ams/utils/utils/AColors.dart';
// import 'package:sk_ams/main.dart';
// import 'package:http/http.dart' as http;
//
// class ALoginScreen extends StatefulWidget {
//   const ALoginScreen({super.key});
//
//   @override
//   _ALoginScreenState createState() => _ALoginScreenState();
// }
//
// class _ALoginScreenState extends State<ALoginScreen> {
//   // Control visibility of password
//   var viewPassword = true;
//
//   // Form key for form validation
//   GlobalKey<FormState> mykey = GlobalKey<FormState>();
//
//   // Text controllers for email and password fields
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   bool  loginSuccess=false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCredentials(); // Load saved credentials on initialization
//   }
//
//   // Load saved credentials (email and password) from SharedPreferences
//   Future<void> _loadSavedCredentials() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedEmail = prefs.getString('savedEmail');
//     String? savedPassword = prefs.getString('savedPassword');
//
//     if (savedEmail != null) {
//       _emailController.text = savedEmail;
//     }
//
//     if (savedPassword != null) {
//       _passwordController.text = savedPassword;
//     }
//   }
//
//   // Save login status after successful login
//   Future<void> _saveLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', true);
//   }
//
//   // Handle login process, call the API, and navigate based on the response
//   Future<void> handleLogin() async {
//     if (mykey.currentState!.validate()) {
//       String email = _emailController.text.trim();
//       String password = _passwordController.text.trim();
//
//       // Define API endpoint URL
//       var url = Uri.parse('https://webigosolutions.in/api3.php'); // Replace with your API endpoint
//
//       // Log the request payload
//       print('Sending data to API: email=$email');
//
//       try {
//         // Send a POST request with email and password to the server
//         var response = await http.post(
//           url,
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({'email': email, 'password': password}),
//         );
//
//         // Log the response status code and body
//         print('Response status: ${response.statusCode}');
//         print('Response body: ${response.body}');
//
//         // Check if the response status is OK (200)
//         if (response.statusCode == 200) {
//           var responseData = jsonDecode(response.body);
//
//           // Safely check if 'success' key exists and is a boolean
//           //bool loginSuccess = responseData['success'] ?? false;
//           if(responseData['status']=='success'){
//            loginSuccess=true;
//
//           }
//           // If login is successful, save credentials and navigate to Dashboard
//           if (loginSuccess) {
//             await _saveCredentials(email, password);
//             await _saveLoginStatus();
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const ADashboardScreen()),
//             );
//           } else {
//             // If login fails, show error dialog with message from API response
//             _showErrorDialog(responseData['message'] ?? "Invalid credentials.");
//           }
//         } else {
//           // Show error dialog if the server response is not OK
//           _showErrorDialog("Failed to login. Please try again.");
//         }
//       } catch (e) {
//         print('Error sending data to API: $e');
//         _showErrorDialog("An error occurred. Please try again.");
//       }
//     }
//   }
//
//   // Save user credentials (email and password) in SharedPreferences
//   Future<void> _saveCredentials(String email, String password) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('savedEmail', email);
//     await prefs.setString('savedPassword', password);
//   }
//
//   // Clear saved credentials and login status
//   Future<void> _clearCredentialsAndStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('savedEmail');
//     await prefs.remove('savedPassword');
//     await prefs.remove('isLoggedIn');
//   }
//
//   // Show an error dialog with a custom message
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Login Failed"),
//           content: Text(message),
//           actions: [
//             TextButton(
//               child: const Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Adjust colors dynamically based on dark mode
//     final isDarkMode = appStore.isDarkModeOn;
//     final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
//     final textColor = Theme.of(context).colorScheme.onBackground;
//     final hintTextColor = isDarkMode ? Colors.white70 : Colors.grey;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: MediaQuery.of(context).viewPadding.top),
//             const SizedBox(height: 60),
//             Text('Login',
//                 style: TextStyle(
//                   fontSize: 45,
//                   fontWeight: FontWeight.w500,
//                   color: textColor, // Use text color from theme
//                 )),
//             const SizedBox(height: 16),
//             Text('Login using credentials',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w300,
//                   color: hintTextColor,
//                 )),
//             Form(
//               key: mykey,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child: TextFormField(
//                         controller: _emailController,
//                         textInputAction: TextInputAction.next,
//                         decoration: InputDecoration(
//                           labelStyle: TextStyle(color: hintTextColor),
//                           border: InputBorder.none,
//                           labelText: 'Enter E-mail',
//                           hintText: 'Enter your E-mail',
//                           filled: true,
//                           fillColor: isDarkMode
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade200,
//                           hintStyle: TextStyle(color: hintTextColor),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Enter valid e-mail';
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child: TextFormField(
//                         controller: _passwordController,
//                         obscureText: viewPassword,
//                         decoration: InputDecoration(
//                           labelStyle: TextStyle(color: hintTextColor),
//                           border: InputBorder.none,
//                           labelText: 'Enter Password',
//                           hintText: 'Enter your Password',
//                           filled: true,
//                           fillColor: isDarkMode
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade200,
//                           hintStyle: TextStyle(color: hintTextColor),
//                           suffixIcon: IconButton(
//                             onPressed: () =>
//                                 setState(() => viewPassword = !viewPassword),
//                             icon: viewPassword
//                                 ? const Icon(Icons.visibility_off,
//                                 color: Colors.grey)
//                                 : const Icon(
//                                 Icons.visibility, color: Colors.grey),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Enter valid Password';
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                         onTap: () =>
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                     const AForgetPasswordScreen())),
//                         child: Text('Forget password?',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 color: hintTextColor)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: 60,
//               child: ElevatedButton(
//                 onPressed: handleLogin,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade600,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15)),
//                 ),
//                 child: const Text('Login',
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white)),
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
