import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
    : super(
        const ProfileLoading(
          name: "",
          phone: "",
          avatar: "",
          watchLater: [],
          history: [],
        ),
      ) {
    _subscribeToUserData();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSub;

  void _subscribeToUserData() {
    final user = _auth.currentUser;
    if (user == null) {
      emit(const ProfileLoggedOut());
      return;
    }

    _userSub = _firestore
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.exists) {
              final data = snapshot.data()!;
              emit(
                ProfileInitial(
                  name: data["name"] ?? "",
                  phone: data["phone"] ?? "",
                  avatar: data["avatar"] ?? "assets/images/avatar1.png",
                  watchLater: (data["watchLater"] as List<dynamic>? ?? [])
                      .map((e) => int.tryParse(e.toString()) ?? 0)
                      .toList(),
                  history: (data["history"] as List<dynamic>? ?? [])
                      .map((e) => int.tryParse(e.toString()) ?? 0)
                      .toList(),
                ),
              );
            } else {
              emit(
                const ProfileError(
                  "No user data found",
                  name: "",
                  phone: "",
                  avatar: "",
                  watchLater: [],
                  history: [],
                ),
              );
            }
          },
          onError: (e) {
            emit(
              ProfileError(
                e.toString(),
                name: state.name,
                phone: state.phone,
                avatar: state.avatar,
                watchLater: state.watchLater,
                history: state.history,
              ),
            );
          },
        );
  }

  Future<void> loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(const ProfileLoggedOut());
        return;
      }

      final snapshot = await _firestore.collection("users").doc(user.uid).get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        emit(
          ProfileInitial(
            name: data["name"] ?? "",
            phone: data["phone"] ?? "",
            avatar: data["avatar"] ?? "assets/images/avatar1.png",
            watchLater: (data["watchLater"] as List<dynamic>? ?? [])
                .map((e) => int.tryParse(e.toString()) ?? 0)
                .toList(),
            history: (data["history"] as List<dynamic>? ?? [])
                .map((e) => int.tryParse(e.toString()) ?? 0)
                .toList(),
          ),
        );
      }
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
          name: state.name,
          phone: state.phone,
          avatar: state.avatar,
          watchLater: state.watchLater,
          history: state.history,
        ),
      );
    }
  }

  Future<void> updateProfile(String name, String phone, String avatar) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection("users").doc(user.uid).update({
        "name": name,
        "phone": phone,
        "avatar": avatar,
      });

      emit(
        ProfileUpdated(
          name: name,
          phone: phone,
          avatar: avatar,
          watchLater: state.watchLater,
          history: state.history,
        ),
      );
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
          name: state.name,
          phone: state.phone,
          avatar: state.avatar,
          watchLater: state.watchLater,
          history: state.history,
        ),
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    emit(const ProfileLoggedOut());
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection("users").doc(user.uid).delete();
      await user.delete();

      emit(const ProfileDeleted());
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
          name: state.name,
          phone: state.phone,
          avatar: state.avatar,
          watchLater: state.watchLater,
          history: state.history,
        ),
      );
    }
  }

  Future<void> addToWatchLater(int movieId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection("users").doc(user.uid).update({
        "watchLater": FieldValue.arrayUnion([movieId]),
      });
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
          name: state.name,
          phone: state.phone,
          avatar: state.avatar,
          watchLater: state.watchLater,
          history: state.history,
        ),
      );
    }
  }

  Future<void> removeFromWatchLater(int movieId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection("users").doc(user.uid).update({
        "watchLater": FieldValue.arrayRemove([movieId]),
      });
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
          name: state.name,
          phone: state.phone,
          avatar: state.avatar,
          watchLater: state.watchLater,
          history: state.history,
        ),
      );
    }
  }

  Future<void> addToHistory(int movieId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection("users").doc(user.uid).update({
        "history": FieldValue.arrayUnion([movieId]),
      });
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
          name: state.name,
          phone: state.phone,
          avatar: state.avatar,
          watchLater: state.watchLater,
          history: state.history,
        ),
      );
    }
  }

  Future<void> removeFromHistory(int movieId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection("users").doc(user.uid).update({
        "history": FieldValue.arrayRemove([movieId]),
      });
    } catch (e) {
      emit(
        ProfileError(
          e.toString(),
          name: state.name,
          phone: state.phone,
          avatar: state.avatar,
          watchLater: state.watchLater,
          history: state.history,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    return super.close();
  }
}
