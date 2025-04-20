part of 'profile_cubit.dart';

@immutable
final class ProfileState extends Equatable {
  final String username;

  const ProfileState({this.username = ''});

  ProfileState copyWith({
    String? username,
  }) {
    return ProfileState(
      username: username ?? this.username,
    );
  }

  @override
  List<Object> get props => [username];
}
