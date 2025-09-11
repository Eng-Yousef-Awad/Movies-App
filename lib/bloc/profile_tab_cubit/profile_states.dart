abstract class ProfileState {
  final String name;
  final String phone;
  final String avatar;
  final List<int> watchLater;
  final List<int> history;

  const ProfileState({
    required this.name,
    required this.phone,
    required this.avatar,
    required this.watchLater,
    required this.history,
  });

  ProfileState copyWith({
    String? name,
    String? phone,
    String? avatar,
    List<int>? watchLater,
    List<int>? history,
  });
}

class ProfileInitial extends ProfileState {
  const ProfileInitial({
    required super.name,
    required super.phone,
    required super.avatar,
    required super.watchLater,
    required super.history,
  });

  @override
  ProfileState copyWith({
    String? name,
    String? phone,
    String? avatar,
    List<int>? watchLater,
    List<int>? history,
  }) {
    return ProfileInitial(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      watchLater: watchLater ?? this.watchLater,
      history: history ?? this.history,
    );
  }
}

class ProfileLoading extends ProfileState {
  const ProfileLoading({
    required super.name,
    required super.phone,
    required super.avatar,
    required super.watchLater,
    required super.history,
  });

  @override
  ProfileState copyWith({
    String? name,
    String? phone,
    String? avatar,
    List<int>? watchLater,
    List<int>? history,
  }) {
    return ProfileLoading(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      watchLater: watchLater ?? this.watchLater,
      history: history ?? this.history,
    );
  }
}

class ProfileUpdated extends ProfileState {
  const ProfileUpdated({
    required super.name,
    required super.phone,
    required super.avatar,
    required super.watchLater,
    required super.history,
  });

  @override
  ProfileState copyWith({
    String? name,
    String? phone,
    String? avatar,
    List<int>? watchLater,
    List<int>? history,
  }) {
    return ProfileUpdated(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      watchLater: watchLater ?? this.watchLater,
      history: history ?? this.history,
    );
  }
}

class ProfileDeleted extends ProfileState {
  const ProfileDeleted()
    : super(
        name: "",
        phone: "",
        avatar: "",
        watchLater: const [],
        history: const [],
      );

  @override
  ProfileState copyWith({
    String? name,
    String? phone,
    String? avatar,
    List<int>? watchLater,
    List<int>? history,
  }) {
    return const ProfileDeleted();
  }
}

class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut()
    : super(
        name: "",
        phone: "",
        avatar: "",
        watchLater: const [],
        history: const [],
      );

  @override
  ProfileState copyWith({
    String? name,
    String? phone,
    String? avatar,
    List<int>? watchLater,
    List<int>? history,
  }) {
    return const ProfileLoggedOut();
  }
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(
    this.message, {
    required super.name,
    required super.phone,
    required super.avatar,
    required super.watchLater,
    required super.history,
  });

  @override
  ProfileState copyWith({
    String? name,
    String? phone,
    String? avatar,
    List<int>? watchLater,
    List<int>? history,
  }) {
    return ProfileError(
      message,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      watchLater: watchLater ?? this.watchLater,
      history: history ?? this.history,
    );
  }
}
