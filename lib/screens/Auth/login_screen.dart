import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/firebase/firebasemanger.dart';
import 'package:movies_app/screens/Auth/forget_password_screen.dart';
import 'package:movies_app/screens/Auth/register_screen.dart';
import 'package:movies_app/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isRePasswordVisible = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildLoginForm(context),
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(19.0),
      child: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              _buildLogo(),
              SizedBox(height: 50.h),
              _buildEmailField(),
              SizedBox(height: 25.h),
              _buildPasswordField(),
              SizedBox(height: 25.h),
              _buildForgotPassword(context),
              SizedBox(height: 25.h),
              _buildLoginButton(context),
              SizedBox(height: 25.h),
              _buildRegisterLink(context),
              SizedBox(height: 25.h),
              _buildDividerWithText(context),
              SizedBox(height: 25),
              _buildGoogleLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      "assets/images/logo_login.png",
      fit: BoxFit.contain,
      width: 121.w,
      height: 118.h,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required';
        return null;
      },
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintText: "Email",
        prefixIcon: Icon(Icons.email, size: 30),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !isRePasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        return null;
      },
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintText: "Password",
        prefixIcon: Icon(Icons.lock, size: 30),
        suffixIcon: IconButton(
          icon: Icon(
            isRePasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              isRePasswordVisible = !isRePasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => _navigateToForgotPassword(),
        child: Text(
          "Forget Password ?",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleLogin(context),
      child: Text("Login"),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "Don't Have Account ? ",
          style: GoogleFonts.roboto(
            textStyle: Theme.of(context).textTheme.displayMedium,
          ),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => _navigateToRegister(),
              text: "Create One",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerWithText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
              endIndent: 20.w,
            ),
          ),
          Center(
            child: Text(
              "OR",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              indent: 20.w,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleGoogleLogin(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/icon _google_.png",
            width: 30.w,
            height: 30.h,
          ),
          SizedBox(width: 10.w),
          Text("Login with Google"),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  void _navigateToForgotPassword() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => isLoading = false);
    Navigator.pushNamed(context, ForgetPasswordScreen.routeName);
  }

  void _navigateToRegister() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => isLoading = false);
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }

  void _handleLogin(BuildContext context) async {
    if (!formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await FirebaseManager.login(
      email: emailController.text,
      password: passwordController.text,
      onSuccess: () {
        setState(() => isLoading = false);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
              (route) => false,
        );
      },
      onError: (message) {
        setState(() => isLoading = false);
        _showErrorDialog(context, message);
      },
    );
  }

  void _handleGoogleLogin(BuildContext context) async {
    setState(() => isLoading = true);

    await FirebaseManager.signInWithGoogle(
      onSuccess: () {
        setState(() => isLoading = false);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
              (_) => false,
        );
      },
      onError: (message) {
        setState(() => isLoading = false);
        _showErrorDialog(context, message);
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: message,
      descTextStyle: GoogleFonts.inter(
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }
}