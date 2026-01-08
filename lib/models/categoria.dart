class Categoria {
  final int id;
  final String titulo;
  final String name;

  Categoria({
    required this.id,
    required this.titulo,
    required this.name,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'name': name,
    };
  }
}