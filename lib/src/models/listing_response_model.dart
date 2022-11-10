// To parse this JSON data, do
//
//     final listingResponse = listingResponseFromMap(jsonString);

import 'dart:convert';

class ListingResponse {
  ListingResponse({
    this.kind,
    this.data,
  });

  String? kind;
  ListingResponseData? data;

  factory ListingResponse.fromJson(String str) => ListingResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListingResponse.fromMap(Map<String, dynamic> json) => ListingResponse(
        kind: json["kind"],
        data: json["data"] == null ? null : ListingResponseData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "data": data?.toMap(),
      };
}

class ListingResponseData {
  ListingResponseData({
    this.after,
    this.dist,
    this.modhash,
    this.geoFilter,
    this.children,
    this.before,
  });

  String? after;
  num? dist;
  String? modhash;
  String? geoFilter;
  List<LinkResponse>? children;
  String? before;

  factory ListingResponseData.fromJson(String str) => ListingResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListingResponseData.fromMap(Map<String, dynamic> json) => ListingResponseData(
        after: json["after"],
        dist: json["dist"],
        modhash: json["modhash"],
        geoFilter: json["geo_filter"],
        children: json["children"] == null
            ? null
            : List<LinkResponse>.from(json["children"].map((x) => LinkResponse.fromMap(x))),
        before: json["before"],
      );

  Map<String, dynamic> toMap() => {
        "after": after,
        "dist": dist,
        "modhash": modhash,
        "geo_filter": geoFilter,
        "children": children == null ? null : List<dynamic>.from(children!.map((x) => x.toMap())),
        "before": before,
      };
}

class LinkResponse {
  LinkResponse({
    this.kind,
    this.data,
  });

  String? kind;
  LinkData? data;

  factory LinkResponse.fromJson(String str) => LinkResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LinkResponse.fromMap(Map<String, dynamic> json) => LinkResponse(
        kind: json["kind"],
        data: json["data"] == null ? null : LinkData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "data": data?.toMap(),
      };
}

class LinkData {
  LinkData({
    this.approvedAtUtc,
    this.subreddit,
    this.selftext,
    this.authorFullname,
    this.saved,
    this.modReasonTitle,
    this.gilded,
    this.clicked,
    this.title,
    this.linkFlairRichtext,
    this.subredditNamePrefixed,
    this.hidden,
    this.pwls,
    this.linkFlairCssClass,
    this.downs,
    this.thumbnailHeight,
    this.topAwardedType,
    this.hideScore,
    this.name,
    this.quarantine,
    this.linkFlairTextColor,
    this.upvoteRatio,
    this.authorFlairBackgroundColor,
    this.subredditType,
    this.ups,
    this.totalAwardsReceived,
    this.mediaEmbed,
    this.thumbnailWidth,
    this.authorFlairTemplateId,
    this.isOriginalContent,
    this.userReports,
    this.secureMedia,
    this.isRedditMediaDomain,
    this.isMeta,
    this.category,
    this.secureMediaEmbed,
    this.linkFlairText,
    this.canModPost,
    this.score,
    this.approvedBy,
    this.isCreatedFromAdsUi,
    this.authorPremium,
    this.thumbnail,
    this.edited,
    this.authorFlairCssClass,
    this.authorFlairRichtext,
    this.gildings,
    this.contentCategories,
    this.isSelf,
    this.modNote,
    this.created,
    this.linkFlairType,
    this.wls,
    this.removedByCategory,
    this.bannedBy,
    this.authorFlairType,
    this.domain,
    this.allowLiveComments,
    this.selftextHtml,
    this.likes,
    this.suggestedSort,
    this.bannedAtUtc,
    this.viewCount,
    this.archived,
    this.noFollow,
    this.isCrosspostable,
    this.pinned,
    this.over18,
    this.allAwardings,
    this.awarders,
    this.mediaOnly,
    this.canGild,
    this.spoiler,
    this.locked,
    this.authorFlairText,
    this.treatmentTags,
    this.visited,
    this.removedBy,
    this.numReports,
    this.distinguished,
    this.subredditId,
    this.authorIsBlocked,
    this.modReasonBy,
    this.removalReason,
    this.linkFlairBackgroundColor,
    this.id,
    this.isRobotIndexable,
    this.reportReasons,
    this.author,
    this.discussionType,
    this.numComments,
    this.sendReplies,
    this.whitelistStatus,
    this.contestMode,
    this.modReports,
    this.authorPatreonFlair,
    this.authorFlairTextColor,
    this.permalink,
    this.parentWhitelistStatus,
    this.stickied,
    this.url,
    this.subredditSubscribers,
    this.createdUtc,
    this.numCrossposts,
    this.media,
    this.isVideo,
    this.postHint,
    this.urlOverriddenByDest,
    this.preview,
    this.linkFlairTemplateId,
    this.isGallery,
    this.mediaMetadata,
    this.galleryData,
  });

  num? approvedAtUtc;
  String? subreddit;
  String? selftext;
  String? authorFullname;
  bool? saved;
  String? modReasonTitle;
  num? gilded;
  bool? clicked;
  String? title;
  List<dynamic>? linkFlairRichtext;
  String? subredditNamePrefixed;
  bool? hidden;
  num? pwls;
  String? linkFlairCssClass;
  num? downs;
  num? thumbnailHeight;
  dynamic topAwardedType;
  bool? hideScore;
  String? name;
  bool? quarantine;
  String? linkFlairTextColor;
  double? upvoteRatio;
  String? authorFlairBackgroundColor;
  String? subredditType;
  num? ups;
  num? totalAwardsReceived;
  Gildings? mediaEmbed;
  num? thumbnailWidth;
  String? authorFlairTemplateId;
  bool? isOriginalContent;
  List<dynamic>? userReports;
  Media? secureMedia;
  bool? isRedditMediaDomain;
  bool? isMeta;
  dynamic category;
  Gildings? secureMediaEmbed;
  String? linkFlairText;
  bool? canModPost;
  num? score;
  dynamic approvedBy;
  bool? isCreatedFromAdsUi;
  bool? authorPremium;
  String? thumbnail;
  bool? edited;
  dynamic authorFlairCssClass;
  List<dynamic>? authorFlairRichtext;
  Gildings? gildings;
  dynamic contentCategories;
  bool? isSelf;
  dynamic modNote;
  num? created;
  String? linkFlairType;
  num? wls;
  dynamic removedByCategory;
  dynamic bannedBy;
  String? authorFlairType;
  String? domain;
  bool? allowLiveComments;
  String? selftextHtml;
  dynamic likes;
  dynamic suggestedSort;
  dynamic bannedAtUtc;
  dynamic viewCount;
  bool? archived;
  bool? noFollow;
  bool? isCrosspostable;
  bool? pinned;
  bool? over18;
  List<AllAwarding>? allAwardings;
  List<dynamic>? awarders;
  bool? mediaOnly;
  bool? canGild;
  bool? spoiler;
  bool? locked;
  String? authorFlairText;
  List<dynamic>? treatmentTags;
  bool? visited;
  dynamic removedBy;
  dynamic numReports;
  String? distinguished;
  String? subredditId;
  bool? authorIsBlocked;
  dynamic modReasonBy;
  dynamic removalReason;
  String? linkFlairBackgroundColor;
  String? id;
  bool? isRobotIndexable;
  dynamic reportReasons;
  String? author;
  dynamic discussionType;
  num? numComments;
  bool? sendReplies;
  String? whitelistStatus;
  bool? contestMode;
  List<dynamic>? modReports;
  bool? authorPatreonFlair;
  String? authorFlairTextColor;
  String? permalink;
  String? parentWhitelistStatus;
  bool? stickied;
  String? url;
  num? subredditSubscribers;
  num? createdUtc;
  num? numCrossposts;
  Media? media;
  bool? isVideo;
  String? postHint;
  String? urlOverriddenByDest;
  Preview? preview;
  String? linkFlairTemplateId;
  bool? isGallery;
  Map<String, MediaMetadatum>? mediaMetadata;
  GalleryData? galleryData;

  factory LinkData.fromJson(String str) => LinkData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LinkData.fromMap(Map<String, dynamic> json) => LinkData(
        approvedAtUtc: json["approved_at_utc"],
        subreddit: json["subreddit"],
        selftext: json["selftext"],
        authorFullname: json["author_fullname"],
        saved: json["saved"],
        modReasonTitle: json["mod_reason_title"],
        gilded: json["gilded"],
        clicked: json["clicked"],
        title: json["title"],
        linkFlairRichtext:
            json["link_flair_richtext"] == null ? null : List<dynamic>.from(json["link_flair_richtext"].map((x) => x)),
        subredditNamePrefixed: json["subreddit_name_prefixed"],
        hidden: json["hidden"],
        pwls: json["pwls"],
        linkFlairCssClass: json["link_flair_css_class"],
        downs: json["downs"],
        thumbnailHeight: json["thumbnail_height"],
        topAwardedType: json["top_awarded_type"],
        hideScore: json["hide_score"],
        name: json["name"],
        quarantine: json["quarantine"],
        linkFlairTextColor: json["link_flair_text_color"],
        upvoteRatio: json["upvote_ratio"].toDouble(),
        authorFlairBackgroundColor: json["author_flair_background_color"],
        subredditType: json["subreddit_type"],
        ups: json["ups"],
        totalAwardsReceived: json["total_awards_received"],
        mediaEmbed: json["media_embed"] == null ? null : Gildings.fromMap(json["media_embed"]),
        thumbnailWidth: json["thumbnail_width"],
        authorFlairTemplateId: json["author_flair_template_id"],
        isOriginalContent: json["is_original_content"],
        userReports: json["user_reports"] == null ? null : List<dynamic>.from(json["user_reports"].map((x) => x)),
        secureMedia: json["secure_media"] == null ? null : Media.fromMap(json["secure_media"]),
        isRedditMediaDomain: json["is_reddit_media_domain"],
        isMeta: json["is_meta"],
        category: json["category"],
        secureMediaEmbed: json["secure_media_embed"] == null ? null : Gildings.fromMap(json["secure_media_embed"]),
        linkFlairText: json["link_flair_text"],
        canModPost: json["can_mod_post"],
        score: json["score"],
        approvedBy: json["approved_by"],
        isCreatedFromAdsUi: json["is_created_from_ads_ui"],
        authorPremium: json["author_premium"],
        thumbnail: json["thumbnail"],
        edited: json["edited"],
        authorFlairCssClass: json["author_flair_css_class"],
        authorFlairRichtext: json["author_flair_richtext"] == null
            ? null
            : List<dynamic>.from(json["author_flair_richtext"].map((x) => x)),
        gildings: json["gildings"] == null ? null : Gildings.fromMap(json["gildings"]),
        contentCategories: json["content_categories"],
        isSelf: json["is_self"],
        modNote: json["mod_note"],
        created: json["created"],
        linkFlairType: json["link_flair_type"],
        wls: json["wls"],
        removedByCategory: json["removed_by_category"],
        bannedBy: json["banned_by"],
        authorFlairType: json["author_flair_type"],
        domain: json["domain"],
        allowLiveComments: json["allow_live_comments"],
        selftextHtml: json["selftext_html"],
        likes: json["likes"],
        suggestedSort: json["suggested_sort"],
        bannedAtUtc: json["banned_at_utc"],
        viewCount: json["view_count"],
        archived: json["archived"],
        noFollow: json["no_follow"],
        isCrosspostable: json["is_crosspostable"],
        pinned: json["pinned"],
        over18: json["over_18"],
        allAwardings: json["all_awardings"] == null
            ? null
            : List<AllAwarding>.from(json["all_awardings"].map((x) => AllAwarding.fromMap(x))),
        awarders: json["awarders"] == null ? null : List<dynamic>.from(json["awarders"].map((x) => x)),
        mediaOnly: json["media_only"],
        canGild: json["can_gild"],
        spoiler: json["spoiler"],
        locked: json["locked"],
        authorFlairText: json["author_flair_text"],
        treatmentTags: json["treatment_tags"] == null ? null : List<dynamic>.from(json["treatment_tags"].map((x) => x)),
        visited: json["visited"],
        removedBy: json["removed_by"],
        numReports: json["num_reports"],
        distinguished: json["distinguished"],
        subredditId: json["subreddit_id"],
        authorIsBlocked: json["author_is_blocked"],
        modReasonBy: json["mod_reason_by"],
        removalReason: json["removal_reason"],
        linkFlairBackgroundColor: json["link_flair_background_color"],
        id: json["id"],
        isRobotIndexable: json["is_robot_indexable"],
        reportReasons: json["report_reasons"],
        author: json["author"],
        discussionType: json["discussion_type"],
        numComments: json["num_comments"],
        sendReplies: json["send_replies"],
        whitelistStatus: json["whitelist_status"],
        contestMode: json["contest_mode"],
        modReports: json["mod_reports"] == null ? null : List<dynamic>.from(json["mod_reports"].map((x) => x)),
        authorPatreonFlair: json["author_patreon_flair"],
        authorFlairTextColor: json["author_flair_text_color"],
        permalink: json["permalink"],
        parentWhitelistStatus: json["parent_whitelist_status"],
        stickied: json["stickied"],
        url: json["url"],
        subredditSubscribers: json["subreddit_subscribers"],
        createdUtc: json["created_utc"],
        numCrossposts: json["num_crossposts"],
        media: json["media"] == null ? null : Media.fromMap(json["media"]),
        isVideo: json["is_video"],
        postHint: json["post_hint"],
        urlOverriddenByDest: json["url_overridden_by_dest"],
        preview: json["preview"] == null ? null : Preview.fromMap(json["preview"]),
        linkFlairTemplateId: json["link_flair_template_id"],
        isGallery: json["is_gallery"],
        mediaMetadata: json["media_metadata"] == null
            ? null
            : Map.from(json["media_metadata"])
                .map((k, v) => MapEntry<String, MediaMetadatum>(k, MediaMetadatum.fromMap(v))),
        galleryData: json["gallery_data"] == null ? null : GalleryData.fromMap(json["gallery_data"]),
      );

  Map<String, dynamic> toMap() => {
        "approved_at_utc": approvedAtUtc,
        "subreddit": subreddit,
        "selftext": selftext,
        "author_fullname": authorFullname,
        "saved": saved,
        "mod_reason_title": modReasonTitle,
        "gilded": gilded,
        "clicked": clicked,
        "title": title,
        "link_flair_richtext": linkFlairRichtext == null ? null : List<dynamic>.from(linkFlairRichtext!.map((x) => x)),
        "subreddit_name_prefixed": subredditNamePrefixed,
        "hidden": hidden,
        "pwls": pwls,
        "link_flair_css_class": linkFlairCssClass,
        "downs": downs,
        "thumbnail_height": thumbnailHeight,
        "top_awarded_type": topAwardedType,
        "hide_score": hideScore,
        "name": name,
        "quarantine": quarantine,
        "link_flair_text_color": linkFlairTextColor,
        "upvote_ratio": upvoteRatio,
        "author_flair_background_color": authorFlairBackgroundColor,
        "subreddit_type": subredditType,
        "ups": ups,
        "total_awards_received": totalAwardsReceived,
        "media_embed": mediaEmbed?.toMap(),
        "thumbnail_width": thumbnailWidth,
        "author_flair_template_id": authorFlairTemplateId,
        "is_original_content": isOriginalContent,
        "user_reports": userReports == null ? null : List<dynamic>.from(userReports!.map((x) => x)),
        "secure_media": secureMedia?.toMap(),
        "is_reddit_media_domain": isRedditMediaDomain,
        "is_meta": isMeta,
        "category": category,
        "secure_media_embed": secureMediaEmbed?.toMap(),
        "link_flair_text": linkFlairText,
        "can_mod_post": canModPost,
        "score": score,
        "approved_by": approvedBy,
        "is_created_from_ads_ui": isCreatedFromAdsUi,
        "author_premium": authorPremium,
        "thumbnail": thumbnail,
        "edited": edited,
        "author_flair_css_class": authorFlairCssClass,
        "author_flair_richtext":
            authorFlairRichtext == null ? null : List<dynamic>.from(authorFlairRichtext!.map((x) => x)),
        "gildings": gildings?.toMap(),
        "content_categories": contentCategories,
        "is_self": isSelf,
        "mod_note": modNote,
        "created": created,
        "link_flair_type": linkFlairType,
        "wls": wls,
        "removed_by_category": removedByCategory,
        "banned_by": bannedBy,
        "author_flair_type": authorFlairType,
        "domain": domain,
        "allow_live_comments": allowLiveComments,
        "selftext_html": selftextHtml,
        "likes": likes,
        "suggested_sort": suggestedSort,
        "banned_at_utc": bannedAtUtc,
        "view_count": viewCount,
        "archived": archived,
        "no_follow": noFollow,
        "is_crosspostable": isCrosspostable,
        "pinned": pinned,
        "over_18": over18,
        "all_awardings": allAwardings == null ? null : List<dynamic>.from(allAwardings!.map((x) => x.toMap())),
        "awarders": awarders == null ? null : List<dynamic>.from(awarders!.map((x) => x)),
        "media_only": mediaOnly,
        "can_gild": canGild,
        "spoiler": spoiler,
        "locked": locked,
        "author_flair_text": authorFlairText,
        "treatment_tags": treatmentTags == null ? null : List<dynamic>.from(treatmentTags!.map((x) => x)),
        "visited": visited,
        "removed_by": removedBy,
        "num_reports": numReports,
        "distinguished": distinguished,
        "subreddit_id": subredditId,
        "author_is_blocked": authorIsBlocked,
        "mod_reason_by": modReasonBy,
        "removal_reason": removalReason,
        "link_flair_background_color": linkFlairBackgroundColor,
        "id": id,
        "is_robot_indexable": isRobotIndexable,
        "report_reasons": reportReasons,
        "author": author,
        "discussion_type": discussionType,
        "num_comments": numComments,
        "send_replies": sendReplies,
        "whitelist_status": whitelistStatus,
        "contest_mode": contestMode,
        "mod_reports": modReports == null ? null : List<dynamic>.from(modReports!.map((x) => x)),
        "author_patreon_flair": authorPatreonFlair,
        "author_flair_text_color": authorFlairTextColor,
        "permalink": permalink,
        "parent_whitelist_status": parentWhitelistStatus,
        "stickied": stickied,
        "url": url,
        "subreddit_subscribers": subredditSubscribers,
        "created_utc": createdUtc,
        "num_crossposts": numCrossposts,
        "media": media?.toMap(),
        "is_video": isVideo,
        "post_hint": postHint,
        "url_overridden_by_dest": urlOverriddenByDest,
        "preview": preview?.toMap(),
        "link_flair_template_id": linkFlairTemplateId,
        "is_gallery": isGallery,
        "media_metadata": mediaMetadata == null
            ? null
            : Map.from(mediaMetadata!).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "gallery_data": galleryData?.toMap(),
      };
}

class AllAwarding {
  AllAwarding({
    this.giverCoinReward,
    this.subredditId,
    this.isNew,
    this.daysOfDripExtension,
    this.coinPrice,
    this.id,
    this.pennyDonate,
    this.awardSubType,
    this.coinReward,
    this.iconUrl,
    this.daysOfPremium,
    this.tiersByRequiredAwardings,
    this.resizedIcons,
    this.iconWidth,
    this.staticIconWidth,
    this.startDate,
    this.isEnabled,
    this.awardingsRequiredToGrantBenefits,
    this.description,
    this.endDate,
    this.stickyDurationSeconds,
    this.subredditCoinReward,
    this.count,
    this.staticIconHeight,
    this.name,
    this.resizedStaticIcons,
    this.iconFormat,
    this.iconHeight,
    this.pennyPrice,
    this.awardType,
    this.staticIconUrl,
  });

  dynamic giverCoinReward;
  dynamic subredditId;
  bool? isNew;
  dynamic daysOfDripExtension;
  num? coinPrice;
  String? id;
  dynamic pennyDonate;
  String? awardSubType;
  num? coinReward;
  String? iconUrl;
  dynamic daysOfPremium;
  dynamic tiersByRequiredAwardings;
  List<ResizedIcon>? resizedIcons;
  num? iconWidth;
  num? staticIconWidth;
  dynamic startDate;
  bool? isEnabled;
  dynamic awardingsRequiredToGrantBenefits;
  String? description;
  dynamic endDate;
  dynamic stickyDurationSeconds;
  num? subredditCoinReward;
  num? count;
  num? staticIconHeight;
  String? name;
  List<ResizedIcon>? resizedStaticIcons;
  dynamic iconFormat;
  num? iconHeight;
  dynamic pennyPrice;
  String? awardType;
  String? staticIconUrl;

  factory AllAwarding.fromJson(String str) => AllAwarding.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AllAwarding.fromMap(Map<String, dynamic> json) => AllAwarding(
        giverCoinReward: json["giver_coin_reward"],
        subredditId: json["subreddit_id"],
        isNew: json["is_new"],
        daysOfDripExtension: json["days_of_drip_extension"],
        coinPrice: json["coin_price"],
        id: json["id"],
        pennyDonate: json["penny_donate"],
        awardSubType: json["award_sub_type"],
        coinReward: json["coin_reward"],
        iconUrl: json["icon_url"],
        daysOfPremium: json["days_of_premium"],
        tiersByRequiredAwardings: json["tiers_by_required_awardings"],
        resizedIcons: json["resized_icons"] == null
            ? null
            : List<ResizedIcon>.from(json["resized_icons"].map((x) => ResizedIcon.fromMap(x))),
        iconWidth: json["icon_width"],
        staticIconWidth: json["static_icon_width"],
        startDate: json["start_date"],
        isEnabled: json["is_enabled"],
        awardingsRequiredToGrantBenefits: json["awardings_required_to_grant_benefits"],
        description: json["description"],
        endDate: json["end_date"],
        stickyDurationSeconds: json["sticky_duration_seconds"],
        subredditCoinReward: json["subreddit_coin_reward"],
        count: json["count"],
        staticIconHeight: json["static_icon_height"],
        name: json["name"],
        resizedStaticIcons: json["resized_static_icons"] == null
            ? null
            : List<ResizedIcon>.from(json["resized_static_icons"].map((x) => ResizedIcon.fromMap(x))),
        iconFormat: json["icon_format"],
        iconHeight: json["icon_height"],
        pennyPrice: json["penny_price"],
        awardType: json["award_type"],
        staticIconUrl: json["static_icon_url"],
      );

  Map<String, dynamic> toMap() => {
        "giver_coin_reward": giverCoinReward,
        "subreddit_id": subredditId,
        "is_new": isNew,
        "days_of_drip_extension": daysOfDripExtension,
        "coin_price": coinPrice,
        "id": id,
        "penny_donate": pennyDonate,
        "award_sub_type": awardSubType,
        "coin_reward": coinReward,
        "icon_url": iconUrl,
        "days_of_premium": daysOfPremium,
        "tiers_by_required_awardings": tiersByRequiredAwardings,
        "resized_icons": resizedIcons == null ? null : List<dynamic>.from(resizedIcons!.map((x) => x.toMap())),
        "icon_width": iconWidth,
        "static_icon_width": staticIconWidth,
        "start_date": startDate,
        "is_enabled": isEnabled,
        "awardings_required_to_grant_benefits": awardingsRequiredToGrantBenefits,
        "description": description,
        "end_date": endDate,
        "sticky_duration_seconds": stickyDurationSeconds,
        "subreddit_coin_reward": subredditCoinReward,
        "count": count,
        "static_icon_height": staticIconHeight,
        "name": name,
        "resized_static_icons":
            resizedStaticIcons == null ? null : List<dynamic>.from(resizedStaticIcons!.map((x) => x.toMap())),
        "icon_format": iconFormat,
        "icon_height": iconHeight,
        "penny_price": pennyPrice,
        "award_type": awardType,
        "static_icon_url": staticIconUrl,
      };
}

class ResizedIcon {
  ResizedIcon({
    this.url,
    this.width,
    this.height,
  });

  String? url;
  num? width;
  num? height;

  factory ResizedIcon.fromJson(String str) => ResizedIcon.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResizedIcon.fromMap(Map<String, dynamic> json) => ResizedIcon(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "width": width,
        "height": height,
      };
}

class GalleryData {
  GalleryData({
    this.items,
  });

  List<Item>? items;

  factory GalleryData.fromJson(String str) => GalleryData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GalleryData.fromMap(Map<String, dynamic> json) => GalleryData(
        items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "items": items == null ? null : List<dynamic>.from(items!.map((x) => x.toMap())),
      };
}

class Item {
  Item({
    this.mediaId,
    this.id,
  });

  String? mediaId;
  num? id;

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        mediaId: json["media_id"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "media_id": mediaId,
        "id": id,
      };
}

class Gildings {
  Gildings();

  factory Gildings.fromJson(String str) => Gildings.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Gildings.fromMap(Map<String, dynamic> json) => Gildings();

  Map<String, dynamic> toMap() => {};
}

class Media {
  Media({
    this.redditVideo,
  });

  RedditVideo? redditVideo;

  factory Media.fromJson(String str) => Media.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Media.fromMap(Map<String, dynamic> json) => Media(
        redditVideo: json["reddit_video"] == null ? null : RedditVideo.fromMap(json["reddit_video"]),
      );

  Map<String, dynamic> toMap() => {
        "reddit_video": redditVideo?.toMap(),
      };
}

class RedditVideo {
  RedditVideo({
    this.bitrateKbps,
    this.fallbackUrl,
    this.height,
    this.width,
    this.scrubberMediaUrl,
    this.dashUrl,
    this.duration,
    this.hlsUrl,
    this.isGif,
    this.transcodingStatus,
  });

  num? bitrateKbps;
  String? fallbackUrl;
  num? height;
  num? width;
  String? scrubberMediaUrl;
  String? dashUrl;
  num? duration;
  String? hlsUrl;
  bool? isGif;
  String? transcodingStatus;

  factory RedditVideo.fromJson(String str) => RedditVideo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RedditVideo.fromMap(Map<String, dynamic> json) => RedditVideo(
        bitrateKbps: json["bitrate_kbps"],
        fallbackUrl: json["fallback_url"],
        height: json["height"],
        width: json["width"],
        scrubberMediaUrl: json["scrubber_media_url"],
        dashUrl: json["dash_url"],
        duration: json["duration"],
        hlsUrl: json["hls_url"],
        isGif: json["is_gif"],
        transcodingStatus: json["transcoding_status"],
      );

  Map<String, dynamic> toMap() => {
        "bitrate_kbps": bitrateKbps,
        "fallback_url": fallbackUrl,
        "height": height,
        "width": width,
        "scrubber_media_url": scrubberMediaUrl,
        "dash_url": dashUrl,
        "duration": duration,
        "hls_url": hlsUrl,
        "is_gif": isGif,
        "transcoding_status": transcodingStatus,
      };
}

class MediaMetadatum {
  MediaMetadatum({
    this.status,
    this.e,
    this.m,
    this.o,
    this.p,
    this.s,
    this.id,
  });

  String? status;
  String? e;
  String? m;
  List<S>? o;
  List<S>? p;
  S? s;
  String? id;

  factory MediaMetadatum.fromJson(String str) => MediaMetadatum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MediaMetadatum.fromMap(Map<String, dynamic> json) => MediaMetadatum(
        status: json["status"],
        e: json["e"],
        m: json["m"],
        o: json["o"] == null ? null : List<S>.from(json["o"].map((x) => S.fromMap(x))),
        p: json["p"] == null ? null : List<S>.from(json["p"].map((x) => S.fromMap(x))),
        s: json["s"] == null ? null : S.fromMap(json["s"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "e": e,
        "m": m,
        "o": o == null ? null : List<dynamic>.from(o!.map((x) => x.toMap())),
        "p": p == null ? null : List<dynamic>.from(p!.map((x) => x.toMap())),
        "s": s?.toMap(),
        "id": id,
      };
}

class S {
  S({
    this.y,
    this.x,
    this.u,
  });

  num? y;
  num? x;
  String? u;

  factory S.fromJson(String str) => S.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory S.fromMap(Map<String, dynamic> json) => S(
        y: json["y"],
        x: json["x"],
        u: json["u"],
      );

  Map<String, dynamic> toMap() => {
        "y": y,
        "x": x,
        "u": u,
      };
}

class Preview {
  Preview({
    this.images,
    this.enabled,
  });

  List<RedditImage>? images;
  bool? enabled;

  factory Preview.fromJson(String str) => Preview.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Preview.fromMap(Map<String, dynamic> json) => Preview(
        images:
            json["images"] == null ? null : List<RedditImage>.from(json["images"].map((x) => RedditImage.fromMap(x))),
        enabled: json["enabled"],
      );

  Map<String, dynamic> toMap() => {
        "images": images == null ? null : List<dynamic>.from(images!.map((x) => x.toMap())),
        "enabled": enabled,
      };
}

class RedditImage {
  RedditImage({
    this.source,
    this.resolutions,
    this.variants,
    this.id,
  });

  ResizedIcon? source;
  List<ResizedIcon>? resolutions;
  Variants? variants;
  String? id;

  factory RedditImage.fromJson(String str) => RedditImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RedditImage.fromMap(Map<String, dynamic> json) => RedditImage(
        source: json["source"] == null ? null : ResizedIcon.fromMap(json["source"]),
        resolutions: json["resolutions"] == null
            ? null
            : List<ResizedIcon>.from(json["resolutions"].map((x) => ResizedIcon.fromMap(x))),
        variants: json["variants"] == null ? null : Variants.fromMap(json["variants"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "source": source?.toMap(),
        "resolutions": resolutions == null ? null : List<dynamic>.from(resolutions!.map((x) => x.toMap())),
        "variants": variants?.toMap(),
        "id": id,
      };
}

class Variants {
  Variants({
    this.obfuscated,
    this.nsfw,
  });

  Nsfw? obfuscated;
  Nsfw? nsfw;

  factory Variants.fromJson(String str) => Variants.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Variants.fromMap(Map<String, dynamic> json) => Variants(
        obfuscated: json["obfuscated"] == null ? null : Nsfw.fromMap(json["obfuscated"]),
        nsfw: json["nsfw"] == null ? null : Nsfw.fromMap(json["nsfw"]),
      );

  Map<String, dynamic> toMap() => {
        "obfuscated": obfuscated?.toMap(),
        "nsfw": nsfw?.toMap(),
      };
}

class Nsfw {
  Nsfw({
    this.source,
    this.resolutions,
  });

  ResizedIcon? source;
  List<ResizedIcon>? resolutions;

  factory Nsfw.fromJson(String str) => Nsfw.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Nsfw.fromMap(Map<String, dynamic> json) => Nsfw(
        source: json["source"] == null ? null : ResizedIcon.fromMap(json["source"]),
        resolutions: json["resolutions"] == null
            ? null
            : List<ResizedIcon>.from(json["resolutions"].map((x) => ResizedIcon.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "source": source?.toMap(),
        "resolutions": resolutions == null ? null : List<dynamic>.from(resolutions!.map((x) => x.toMap())),
      };
}
