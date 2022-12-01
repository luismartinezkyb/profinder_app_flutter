class UserModel {
  final String name;
  final String username;
  final String level;
  final int role;
  final String image;
  final String email;
  final String description;
  final String number;

  const UserModel({
    required this.name,
    required this.username,
    required this.level,
    required this.role,
    required this.image,
    required this.email,
    required this.description,
    required this.number,
  });

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        username: json['username'],
        level: json['level'],
        role: json['role'],
        image: json['image'],
        email: json['email'],
        description: json['description'],
        number: json['number'],
      );
}


//CREATING A CLASSES OBJECT
