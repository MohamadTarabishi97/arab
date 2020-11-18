
class User {
  dynamic id;
  String firstName;
  String lastName;
  String username;
  String email;
  String userType;
  String imageUrl;
  String password;
  dynamic wantEmail;
  String phoneNumber;
  dynamic rememberToken;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic termsOfUse;
  String tokens;
  Map<String,dynamic> admin;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.userType,
    this.imageUrl,
    this.password,
    this.wantEmail,
    this.phoneNumber,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.tokens,
    this.admin,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        userType: json["user_type"],
        imageUrl: json["image_url"],
        username: json['user_name'],
        password: json["password"],
        wantEmail: json["wantEmail"],
        phoneNumber: json["phone_number"],
        rememberToken: json["remember_token"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        tokens: json["tokens"],
        admin: (json["admin"]!=null)?new Map.from(json["admin"])
            .map((k, v) => new MapEntry<String,dynamic>(k, v == null ? null : v)):null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "user_type": userType,
        "image_url": imageUrl,
        "password": password,
        "wantEmail": wantEmail,
        "phone_number": phoneNumber,
        "remember_token": rememberToken,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "tokens": tokens,
        "admin": new Map.from(admin).map(
            (k, v) => new MapEntry<String, dynamic>(k, v == null ? null : v)),
      };
}



 
        