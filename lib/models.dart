class Movie {
  final String title;
  final int year;
  final String mediumCoverImage;
  final int id;

  Movie({
    required this.title,
    required this.year,
    required this.mediumCoverImage,
    required this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      year: json['year'],
      mediumCoverImage: json['medium_cover_image'],
      id: json['id'],
    );
  }
}