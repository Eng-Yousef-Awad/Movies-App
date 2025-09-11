import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_data.dart';

class FirebaseManager {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ------------------ Auth  ------------------

  static Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    String avatar = "",
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        final userdata = Userdata(
          id: user.uid,
          name: name,
          email: email,
          phone: phone,
          avatar: avatar,
          watchLater: [],
          history: [],
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userdata.toJson());
        onSuccess();
      } else {
        onError("User creation failed.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        onError("This email is already registered.");
      } else if (e.code == 'invalid-email') {
        onError("Invalid email address.");
      } else {
        onError(e.message ?? "Unknown error.");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<void> login({
    required String email,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        onSuccess();
      } else {
        onError("User not found");
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          onError("No user found with this email.");
          break;
        case "wrong-password":
          onError("Wrong password.");
          break;
        case "invalid-email":
          onError("Invalid email format.");
          break;
        case "user-disabled":
          onError("This account has been disabled.");
          break;
        default:
          onError("Something went wrong. Please try again.");
      }
    } catch (e) {
      onError("Error: $e");
    }
  }

  static Future<void> signInWithGoogle({
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        onError("Google sign in cancelled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          final userdata = Userdata(
            id: user.uid,
            name: user.displayName ?? "",
            email: user.email ?? "",
            phone: user.phoneNumber ?? "",
            avatar: user.photoURL ?? "",
            watchLater: [],
            history: [],
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userdata.toJson());
        }
        onSuccess();
      } else {
        onError("Google sign in failed.");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<void> resetPassword({
    required String email,
    required Function(String) onError,
    required Function onSuccess,
  }) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        onError("No user found for that email.");
        return;
      }

      await _auth.sendPasswordResetEmail(email: email);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        onError("The email address is not valid.");
      } else {
        onError("Something went wrong. Try again.");
      }
    } catch (e) {
      onError("Error: $e");
    }
  }

  static User? get currentUser => _auth.currentUser;

  static Future<Userdata?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return Userdata.fromJson(doc.data()!);
    }
    return null;
  }

  static Stream<Userdata?> userDataStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }
    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (doc.exists) {
        return Userdata.fromJson(doc.data()!);
      }
      return null;
    });
  }

  static Future<void> updateProfileData({
    required String name,
    required String phone,
    String? avatar,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      onError("No logged in user.");
      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).update({
        "name": name,
        "phone": phone,
        if (avatar != null) "avatar": avatar,
      });
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<void> updateUserData(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update(data);
  }

  // ------------------ Watch Later ------------------

  static Future<void> addToWatchLater(int movieId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      "watchLater": FieldValue.arrayUnion([movieId]),
    });
  }

  static Future<void> removeFromWatchLater(int movieId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      "watchLater": FieldValue.arrayRemove([movieId]),
    });
  }

  static Future<bool> isInWatchLater(int movieId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return false;

    final data = doc.data();
    final List<dynamic>? watchLater = data?['watchLater'] as List<dynamic>?;
    if (watchLater == null) return false;

    return watchLater.contains(movieId);
  }

  // ------------------ History ------------------

  static Future<void> addToHistory(int movieId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      "history": FieldValue.arrayUnion([movieId]),
    });
  }

  static Future<void> removeFromHistory(int movieId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      "history": FieldValue.arrayRemove([movieId]),
    });
  }
}
