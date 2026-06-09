class User {

  String firstName;
  String lastName;
  String email;
  String picture;

  User(this.firstName, this.lastName, this.email, this.picture);

  Map<String, dynamic> toJson() {
    return {
      "firstName" : firstName,
      "lastName"  : lastName,
      "email"     : email,
      "picture"   : picture
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['firstName'] as String,
      json['lastName'] as String,
      json['email'] as String,
      json['picture'] as String,
    );
  }
}