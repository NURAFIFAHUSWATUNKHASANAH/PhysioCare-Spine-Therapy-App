class User {
  final String id;
  final String nama;
  final String email;
  final String foto;
  final String createdAt;

  User({required this.id, required this.nama, required this.email, required this.foto, required this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      nama: json['nama'],
      email: json['email'],
      foto: json['foto'],
      createdAt: json['created_at'],
    );
  }
}
