import 'dart:convert';

class SliderModel {
  List<Sliders>? sliders;

  SliderModel({
    this.sliders,
  });

  factory SliderModel.fromRawJson(String str) =>
      SliderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        sliders: json["sliders"] == null
            ? []
            : List<Sliders>.from(
                json["sliders"]!.map((x) => Sliders.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sliders": sliders == null
            ? []
            : List<dynamic>.from(sliders!.map((x) => x.toJson())),
      };
}

class Sliders {
  int? id;
  dynamic subtitleText;
  String? subtitleTextAr;
  dynamic subtitleSize;
  dynamic subtitleColor;
  dynamic subtitleAnime;
  dynamic titleText;
  String? titleTextAr;
  dynamic titleSize;
  dynamic titleColor;
  dynamic titleAnime;
  dynamic detailsText;
  String? detailsTextAr;
  dynamic detailsSize;
  dynamic detailsColor;
  dynamic detailsAnime;
  String? photo;
  dynamic position;
  String? link;
  int? mobileSetting;
  int? linked;
  int? linkId;
  dynamic btnText;
  dynamic btnTextAr;
  dynamic firstSidePhoto;
  dynamic secondSidePhoto;
  String? type;
  String? title;
  String? titleAr;

  Sliders({
    this.id,
    this.subtitleText,
    this.subtitleTextAr,
    this.subtitleSize,
    this.subtitleColor,
    this.subtitleAnime,
    this.titleText,
    this.titleTextAr,
    this.titleSize,
    this.titleColor,
    this.titleAnime,
    this.detailsText,
    this.detailsTextAr,
    this.detailsSize,
    this.detailsColor,
    this.detailsAnime,
    this.photo,
    this.position,
    this.link,
    this.mobileSetting,
    this.linked,
    this.linkId,
    this.btnText,
    this.btnTextAr,
    this.firstSidePhoto,
    this.secondSidePhoto,
    this.type,
    this.title,
    this.titleAr,
  });

  factory Sliders.fromRawJson(String str) => Sliders.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sliders.fromJson(Map<String, dynamic> json) => Sliders(
        id: json["id"],
        subtitleText: json["subtitle_text"],
        subtitleTextAr: json["subtitle_text_ar"],
        subtitleSize: json["subtitle_size"],
        subtitleColor: json["subtitle_color"],
        subtitleAnime: json["subtitle_anime"],
        titleText: json["title_text"],
        titleTextAr: json["title_text_ar"],
        titleSize: json["title_size"],
        titleColor: json["title_color"],
        titleAnime: json["title_anime"],
        detailsText: json["details_text"],
        detailsTextAr: json["details_text_ar"],
        detailsSize: json["details_size"],
        detailsColor: json["details_color"],
        detailsAnime: json["details_anime"],
        photo: json["photo"],
        position: json["position"],
        link: json["link"],
        mobileSetting: json["mobile_setting"],
        linked: json["linked"],
        linkId: json["link_id"],
        btnText: json["btn_text"],
        btnTextAr: json["btn_text_ar"],
        firstSidePhoto: json["first_side_photo"],
        secondSidePhoto: json["second_side_photo"],
        type: json["type"],
        title: json["title"],
        titleAr: json["title_ar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subtitle_text": subtitleText,
        "subtitle_text_ar": subtitleTextAr,
        "subtitle_size": subtitleSize,
        "subtitle_color": subtitleColor,
        "subtitle_anime": subtitleAnime,
        "title_text": titleText,
        "title_text_ar": titleTextAr,
        "title_size": titleSize,
        "title_color": titleColor,
        "title_anime": titleAnime,
        "details_text": detailsText,
        "details_text_ar": detailsTextAr,
        "details_size": detailsSize,
        "details_color": detailsColor,
        "details_anime": detailsAnime,
        "photo": photo,
        "position": position,
        "link": link,
        "mobile_setting": mobileSetting,
        "linked": linked,
        "link_id": linkId,
        "btn_text": btnText,
        "btn_text_ar": btnTextAr,
        "first_side_photo": firstSidePhoto,
        "second_side_photo": secondSidePhoto,
        "type": type,
        "title": title,
        "title_ar": titleAr,
      };
}
