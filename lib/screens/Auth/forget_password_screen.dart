import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/firebase/firebasemanger.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String routeName = '/ForgetPassword';

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: "Warning",
        desc: "Please enter your email address.",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    await FirebaseManager.resetPassword(
      email: email,
      onSuccess: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Success",
          desc: "Password reset link has been sent to your email.",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
          btnCancelOnPress: () {},
        ).show();
      },
      onError: (errorMsg) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: " Error",
          desc: errorMsg,
          btnOkOnPress: () {},

          btnCancelOnPress: () {},
        ).show();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/forgot password.png"),
              SizedBox(height: 24),
              TextFormField(
                controller: _emailController,

                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: "Email",
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.white, size: 30),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _resetPassword,

                child: Text(
                  "Verify Email",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
