class AdvertModel {
  // ! added null safety behaviors
  AdvertModel({
    this.id,
    this.title,
    this.description,
    this.url,
    this.format,
    this.imageUrl,
    this.spaceId,
    this.createdAt,
    this.updatedAt,
    this.expireAt,
  });

  int? id;
  String? title;
  String? description;
  dynamic url;
  String? format;
  String? imageUrl;
  int? spaceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? expireAt;

  AdvertModel copyWith({
    int? id,
    String? title,
    String? description,
    dynamic url,
    String? format,
    String? imageUrl,
    int? spaceId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expireAt,
  }) =>
      AdvertModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        url: url ?? this.url,
        format: format ?? this.format,
        imageUrl: imageUrl ?? this.imageUrl,
        spaceId: spaceId ?? this.spaceId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        expireAt: expireAt ?? this.expireAt,
      );

  factory AdvertModel.fromJson(Map<String, dynamic> json) => AdvertModel(
        id: json["id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        url: json["url"],
        format: json["format"] == null ? null : json["format"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        spaceId: json["space_id"] == null ? null : json["space_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        expireAt: json["expire_at"] == null
            ? null
            : DateTime.parse(json["expire_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "url": url,
        "format": format == null ? null : format,
        "image_url": imageUrl == null ? null : imageUrl,
        "space_id": spaceId == null ? null : spaceId,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "expire_at": expireAt == null ? null : expireAt!.toIso8601String(),
      };
}
