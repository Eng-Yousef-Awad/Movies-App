import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/firebase/firebasemanger.dart';
import 'package:movies_app/screens/Auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/RegisterScreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int selectedAvatar = 0;
  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;
  bool isLoading = false;

  final avatars = [
    "assets/images/avatar1.png",
    "assets/images/avatar2.png",
    "assets/images/avatar3.png",
    "assets/images/avatar4.png",
    "assets/images/avatar5.png",
    "assets/images/avatar6.png",
    "assets/images/avatar7.png",
    "assets/images/avatar8.png",
    "assets/images/avatar9.png",
  ];

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          _buildRegisterForm(context),
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Register"),
      leading: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAvatarCarousel(),
                SizedBox(height: 24.h),
                _buildNameField(),
                SizedBox(height: 24.h),
                _buildEmailField(),
                SizedBox(height: 24.h),
                _buildPasswordField(),
                SizedBox(height: 24.h),
                _buildConfirmPasswordField(),
                SizedBox(height: 24.h),
                _buildPhoneField(),
                SizedBox(height: 24.h),
                _buildRegisterButton(context),
                SizedBox(height: 24.h),
                _buildLoginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarCarousel() {
    return CarouselSlider.builder(
      itemCount: avatars.length,
      itemBuilder: (context, index, realIndex) {
        final isSelected = index == selectedAvatar;
        return AnimatedScale(
          scale: isSelected ? 1.2 : 0.8,
          duration: const Duration(milliseconds: 300),
          child: ClipOval(
            child: Image.asset(
              avatars[index],
              fit: BoxFit.contain,
              width: isSelected ? 120 : 100,
              height: isSelected ? 120 : 100,
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 150,
        enlargeCenterPage: true,
        viewportFraction: 0.4,
        onPageChanged: (index, reason) {
          setState(() {
            selectedAvatar = index;
          });
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Name is required';
        return null;
      },
      decoration: InputDecoration(
        hintText: "Name",
        prefixIcon: Icon(Icons.person, size: 30.sp),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required';
        final emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(value.trim());
        if (!emailValid) return 'Please enter a valid email';
        return null;
      },
      decoration: InputDecoration(
        hintText: "Email",
        prefixIcon: Icon(Icons.email, size: 30.sp),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: !isPasswordVisible,
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: Icon(Icons.lock, size: 30.sp),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            size: 30.sp,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      obscureText: !isRePasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value != passwordController.text) return 'Password Not match';
        return null;
      },
      decoration: InputDecoration(
        hintText: "Confirm Password",
        prefixIcon: Icon(Icons.lock, size: 30.sp),
        suffixIcon: IconButton(
          icon: Icon(
            isRePasswordVisible ? Icons.visibility_off : Icons.visibility,
            size: 30.sp,
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

  Widget _buildPhoneField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Phone is required';
        if (value.length != 11) return 'Please enter a valid phone number';
        return null;
      },
      decoration: InputDecoration(
        hintText: "Phone Number",
        prefixIcon: Icon(Icons.call, size: 30.sp),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleRegistration(context),
      child: Text("Create Account"),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "Already Have Account ? ",
          style: Theme.of(context).textTheme.displayMedium,
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => _navigateToLogin(),
              text: "Login",
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

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  void _navigateToLogin() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 200));
    setState(() => isLoading = false);
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  void _handleRegistration(BuildContext context) async {
    if (!formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await FirebaseManager.signUp(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      avatar: avatars[selectedAvatar],
      onError: (value) {
        setState(() => isLoading = false);
        _showErrorDialog(context, value);
      },
      onSuccess: () {
        setState(() => isLoading = false);
        _showSuccessDialog(context);
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
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }

  void _showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: "Account Created Successfully",
      btnOkOnPress: () => Navigator.pushNamed(context, LoginScreen.routeName),
      btnCancelOnPress: () => Navigator.pushNamed(context, LoginScreen.routeName),
    ).show();
  }
}