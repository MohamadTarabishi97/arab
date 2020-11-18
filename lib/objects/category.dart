import 'dart:convert';

Category offerFromJson(String str) => Category.fromJson(json.decode(str));

String offerToJson(Category data) => json.encode(data.toJson());
class Category {
    Category({
        this.id,
        this.nameArabic,
        this.nameGerman,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String nameArabic;
    String nameGerman;
    dynamic createdAt;
    dynamic updatedAt;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        nameArabic: json["name_arabic"],
        nameGerman: json["name_german"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name_arabic": nameArabic,
        "name_german": nameGerman,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

