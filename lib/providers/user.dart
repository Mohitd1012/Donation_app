class User {
  final String imagePath;
  final String name;
  final String email;
  final String address;
  final String city;
  final String state;
  final String about;

  const User({
    this.imagePath =
        'https://thumbs.dreamstime.com/b/businessman-icon-vector-male-avatar-profile-image-profile-businessman-icon-vector-male-avatar-profile-image-182095609.jpg',
    this.name,
    this.email,
    this.address,
    this.city,
    this.state,
    this.about,
  });

  User copy({
    String imagePath,
    String name,
    String email,
    String address,
    String city,
    String state,
    String about,
  }) =>
      User(
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        email: email ?? this.email,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        about: about ?? this.about,
      );

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'about': about,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        imagePath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        address: json['address'],
        city: json['city'],
        state: json['state'],
        about: json['about'],
      );
}
