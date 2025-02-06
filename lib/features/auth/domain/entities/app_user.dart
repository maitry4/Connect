class CAppUser {
  final String uid;
  final String email;
  final String name;

  CAppUser({
    required this.uid, 
    required this.email, 
    required this.name
  });

  //convert app user to => json
  Map<String, dynamic> toJson() {
    return {
      'uid':uid,
      'email':email,
      'name':name
    };
  }
  
  //convert json to => app user
  factory CAppUser.fromJson(Map<String, dynamic> jsonUser) {
    return CAppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name']
    );
  }
}
