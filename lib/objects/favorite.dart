class Favorite {
  String word;
  int id;
  Favorite({this.word, this.id});
  factory Favorite.fromJson(Map<String, dynamic> json) =>
      Favorite(id: json["id"], word: json["word"]);
}
