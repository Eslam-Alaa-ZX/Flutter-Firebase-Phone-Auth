class UserModel {
  final String email;
  final String name;
  final String bio;
  final String profileImg;
  final String createdAt;
  final String phone;
  final String userId;

  UserModel(
      {required this.email,
      required this.name,
      required this.bio,
      required this.profileImg,
      required this.createdAt,
      required this.phone,
      required this.userId});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map["email"] ?? "",
      name: map["name"] ?? "",
      bio: map["bio"] ?? "",
      profileImg: map["profileImg"] ?? "",
      createdAt: map["createdAt"] ?? "",
      phone: map["phone"] ?? "",
      userId: map["userId"] ?? "",
    );
  }

  Map<String, dynamic> tpMap(){
    return{
      "userId":userId,
      "phone":phone,
      "createdAt":createdAt,
      "profileImg":profileImg,
      "bio":bio,
      "name":name,
      "email":email
    };
  }
}
