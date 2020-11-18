
import 'dart:convert';

import 'package:ArabDealProject/objects/category.dart';
import 'package:ArabDealProject/objects/user.dart';

Offer offerFromJson(String str) => Offer.fromJson(json.decode(str));

String offerToJson(Offer data) => json.encode(data.toJson());

class Offer {
    Offer({
        this.id,
        this.categoryId,
        this.offerTitleArabic,
        this.offerTitleGerman,
        this.offerShortDescriptionArabic,
        this.offerShortDescriptionGerman,
        this.offerDescriptionArabic,
        this.offerDescriptionGerman,
        this.offerUrl,
        this.imageUrl,
        this.videoUrl,
        this.vouchersCode,
        this.priceBefore,
        this.state,
        this.priceAfter,
        this.date,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.dateAr,
        this.percent,
        this.likeNumber,
        this.commentsNumber,
        this.category,
        this.offersLikes,
        this.offersComments,
        this.user,
        this.testDes
    });

    dynamic id;
    dynamic categoryId;
    String offerTitleArabic;
    String offerTitleGerman;
    String offerShortDescriptionArabic;
    String offerShortDescriptionGerman;
    String offerDescriptionArabic;
    String offerDescriptionGerman;
    String offerUrl;
    List<String> imageUrl;
    dynamic videoUrl;
    dynamic vouchersCode;
    dynamic priceBefore;
    dynamic state;
    dynamic priceAfter;
    String date;
    dynamic createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    String dateAr;
    dynamic percent;
    dynamic likeNumber;
    dynamic commentsNumber;
    Category category;
    List<dynamic> offersLikes;
    List<dynamic> offersComments;
    final String testDes;
    User user;

    factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        
        id: json["id"],
        categoryId: json["category_id"],
        testDes: json["offer_description_german"],
        offerTitleArabic: json["offer_title_arabic"],
        offerTitleGerman: json["offer_title_german"],
        offerShortDescriptionArabic: json["offer_short_description_arabic"],
        offerShortDescriptionGerman: json["offer_short_description_german"],
        offerDescriptionArabic: json["offer_description_arabic"] as String,
        offerDescriptionGerman: json["offer_description_german"] as String,
        offerUrl: json["offer_url"],
        imageUrl: List<String>.from(json["image_url"].map((x) => x)),
        videoUrl: json["video_url"],
        vouchersCode: json["vouchersCode"],
        priceBefore: json["price_before"],
        state: json["state"],
        priceAfter: json["price_after"],
        date: json["date"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
       updatedAt: DateTime.parse(json["updated_at"]),
        dateAr: json["date_ar"],
        percent: json["percent"],
        likeNumber: json["like_number"],
        commentsNumber: json["comments_number"],
       category: Category.fromJson(json["category"]),
        //offersLikes: List<dynamic>.from(json["offers_likes"].map((x) => x)),
        //offersComments: List<dynamic>.from(json["offers_comments"].map((x) => x)),
        user: (json['user']!=null)?User.fromJson(json["user"]):null,
    );

    Map<String, dynamic> toJson() => {
      //  "id": id,
        "category_id": categoryId.toString(),
        "offer_title_arabic": offerTitleArabic.toString(),
        "offer_title_german": offerTitleGerman.toString(),
        "offer_short_description_arabic": offerShortDescriptionArabic.toString(),
        "offer_short_description_german": offerShortDescriptionGerman.toString(),
        "offer_description_arabic": offerDescriptionArabic.toString(),
        "offer_description_german": offerDescriptionGerman.toString(),
        "offer_url": offerUrl.toString(),
       "image_url": List<String>.from(imageUrl.map((x) => x)),
        "video_url": videoUrl.toString(),
        "vouchersCode": vouchersCode.toString(),
        "price_before": priceBefore,
      //  "state": state,
        "price_after": priceAfter,
      //  "date": date,
        "created_by": createdBy.toString(),
       // "created_at": createdAt.toIso8601String(),
       // "updated_at": updatedAt.toIso8601String(),
       // "date_ar": dateAr,
       // "percent": percent,
       // "like_number": likeNumber,
       // "comments_number": commentsNumber,
       // "category": category.toJson(),
       // "offers_likes": List<dynamic>.from(offersLikes.map((x) => x)),
        //"offers_comments": List<dynamic>.from(offersComments.map((x) => x)),
       // "user": user.toJson(),
    };
}