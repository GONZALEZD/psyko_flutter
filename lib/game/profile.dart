class UserProfile {
  final String name;
  final String email;
  final String id;

  const UserProfile({required this.name, required this.email, required this.id});

  @override
  String toString() {
    final props = {'name': name, 'email': email, 'id':id};
    return "$runtimeType($props)";
  }

  static const UserProfile anonymous = UserProfile(name: "", email: "", id: "");
}
