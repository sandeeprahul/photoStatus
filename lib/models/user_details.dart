class UserDetails {
  final String uid;
  final String phoneNumber;
  final String displayName;

  UserDetails({
    required this.uid,
    required this.phoneNumber,
    required this.displayName,
  });
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'phoneNumber': phoneNumber,
    'displayName': displayName,
  };
}