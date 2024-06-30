class Menu {
  final int idMenu; // Unique identifier for the menu item
  final String menuName; // Name of the menu item
  final String descMenu; // Description of the menu item
  final int menuPrice; // Price of the menu item
  final String kategori; // Category of the menu item
  final String imageUrl; // URL to the image of the menu item

  // Constructor for Menu class
  Menu({
    required this.idMenu,
    required this.menuName,
    required this.descMenu,
    required this.menuPrice,
    required this.kategori,
    required this.imageUrl,
  });

  // Factory method to create Menu object from JSON data
  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        idMenu: json['id_menu']
            as int, // Retrieve id_menu from JSON and cast to int
        menuName: json['nama_menu']
            as String, // Retrieve nama_menu from JSON as String
        descMenu: json['desc_menu']
            as String, // Retrieve desc_menu from JSON as String
        menuPrice: json['harga_menu']
            as int, // Retrieve harga_menu from JSON and cast to int
        kategori:
            json['kategori'] as String, // Retrieve kategori from JSON as String
        imageUrl: json['img']
            as String, // Retrieve img (image URL) from JSON as String
      );

  // Method to convert Menu object to JSON format
  Map<String, dynamic> toJson() => {
        'id_menu': idMenu, // Convert idMenu to JSON
        'nama_menu': menuName, // Convert menuName to JSON
        'desc_menu': descMenu, // Convert descMenu to JSON
        'harga_menu': menuPrice, // Convert menuPrice to JSON
        'kategori': kategori, // Convert kategori to JSON
        'img': imageUrl, // Convert imageUrl to JSON
      };
}
