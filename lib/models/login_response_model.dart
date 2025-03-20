import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool? status;
  String? message;
  User? user;
  String? token;

  LoginResponse({
    this.status,
    this.message,
    this.user,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    message: json["message"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  int? id;
  String? username;
  dynamic firstname;
  dynamic lastname;
  String? email;
  dynamic mobileNo;
  dynamic address;
  int? role;
  dynamic city;
  int? isActive;
  int? isVerify;
  int? isAdmin;
  dynamic token;
  dynamic passwordResetCode;
  dynamic lastIp;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic institute;
  dynamic branch;
  dynamic areaId;

  User({
    this.id,
    this.username,
    this.firstname,
    this.lastname,
    this.email,
    this.mobileNo,
    this.address,
    this.role,
    this.city,
    this.isActive,
    this.isVerify,
    this.isAdmin,
    this.token,
    this.passwordResetCode,
    this.lastIp,
    this.createdAt,
    this.updatedAt,
    this.institute,
    this.branch,
    this.areaId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    address: json["address"],
    role: json["role"],
    city: json["city"],
    isActive: json["is_active"],
    isVerify: json["is_verify"],
    isAdmin: json["is_admin"],
    token: json["token"],
    passwordResetCode: json["password_reset_code"],
    lastIp: json["last_ip"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    institute: json["institute"],
    branch: json["branch"],
    areaId: json["area_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "mobile_no": mobileNo,
    "address": address,
    "role": role,
    "city": city,
    "is_active": isActive,
    "is_verify": isVerify,
    "is_admin": isAdmin,
    "token": token,
    "password_reset_code": passwordResetCode,
    "last_ip": lastIp,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "institute": institute,
    "branch": branch,
    "area_id": areaId,
  };
}
