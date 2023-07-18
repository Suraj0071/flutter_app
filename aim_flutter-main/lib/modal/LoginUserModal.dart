class LoginUserRes {
  final String res;

  const LoginUserRes({required this.res});

  factory LoginUserRes.fromJson(Map<String, dynamic> json) {
    return LoginUserRes(res: json['status']);
  }
}
