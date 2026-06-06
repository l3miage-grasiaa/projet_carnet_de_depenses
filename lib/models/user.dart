class User {

  String firstName;
  String lastName;
  String picture;

  User(this.firstName, this.lastName, this.picture);

  Map<String, dynamic> toJson() {
    return {
      "firstName" : firstName,
      "lastName"  : lastName,
      "picture"   : picture
    };
  }

  User.fromJson(json) :
    firstName = json['firstName'],
    lastName = json['lastName'],
    picture = json['picture'];

}