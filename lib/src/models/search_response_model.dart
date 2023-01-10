// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromMap(jsonString);

import 'dart:convert';

class SearchResponse {
  SearchResponse({
    this.kind,
    this.data,
  });

  final String? kind;
  final SearchResponseData? data;

  factory SearchResponse.fromJson(String str) => SearchResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchResponse.fromMap(Map<String, dynamic> json) => SearchResponse(
        kind: json["kind"],
        data: json["data"] == null ? null : SearchResponseData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "data": data?.toMap(),
      };
}

class SearchResponseData {
  SearchResponseData({
    this.after,
    this.dist,
    this.modhash,
    this.geoFilter,
    this.children,
    this.before,
  });

  final String? after;
  final num? dist;
  final String? modhash;
  final String? geoFilter;
  final List<SubredditResponse>? children;
  final dynamic before;

  factory SearchResponseData.fromJson(String str) => SearchResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchResponseData.fromMap(Map<String, dynamic> json) => SearchResponseData(
        after: json["after"],
        dist: json["dist"],
        modhash: json["modhash"],
        geoFilter: json["geo_filter"],
        children: json["children"] == null
            ? null
            : List<SubredditResponse>.from(json["children"].map((x) => SubredditResponse.fromMap(x))),
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

class SubredditResponse {
  SubredditResponse({
    this.kind,
    this.data,
  });

  final String? kind;
  final SubredditData? data;

  factory SubredditResponse.fromJson(String str) => SubredditResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubredditResponse.fromMap(Map<String, dynamic> json) => SubredditResponse(
        kind: json["kind"],
        data: json["data"] == null ? null : SubredditData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "data": data?.toMap(),
      };
}

class SubredditData {
  const SubredditData({
    this.userFlairBackgroundColor,
    this.submitTextHtml,
    this.restrictPosting,
    this.userIsBanned,
    this.freeFormReports,
    this.wikiEnabled,
    this.userIsMuted,
    this.userCanFlairInSr,
    this.displayName,
    this.headerImg,
    this.title,
    this.allowGalleries,
    this.iconSize,
    this.primaryColor,
    this.activeUserCount,
    this.iconImg,
    this.displayNamePrefixed,
    this.accountsActive,
    this.publicTraffic,
    this.subscribers,
    this.userFlairRichtext,
    this.videostreamLinksCount,
    this.name,
    this.quarantine,
    this.hideAds,
    this.predictionLeaderboardEntryType,
    this.emojisEnabled,
    this.advertiserCategory,
    this.publicDescription,
    this.commentScoreHideMins,
    this.allowPredictions,
    this.userHasFavorited,
    this.userFlairTemplateId,
    this.communityIcon,
    this.bannerBackgroundImage,
    this.originalContentTagEnabled,
    this.communityReviewed,
    this.submitText,
    this.descriptionHtml,
    this.spoilersEnabled,
    this.commentContributionSettings,
    this.allowTalks,
    this.headerSize,
    this.userFlairPosition,
    this.allOriginalContent,
    this.hasMenuWidget,
    this.isEnrolledInNewModmail,
    this.keyColor,
    this.canAssignUserFlair,
    this.created,
    this.wls,
    this.showMediaPreview,
    this.submissionType,
    this.userIsSubscriber,
    this.allowedMediaInComments,
    this.allowVideogifs,
    this.shouldArchivePosts,
    this.userFlairType,
    this.allowPolls,
    this.collapseDeletedComments,
    this.emojisCustomSize,
    this.publicDescriptionHtml,
    this.allowVideos,
    this.isCrosspostableSubreddit,
    this.notificationLevel,
    this.shouldShowMediaInCommentsSetting,
    this.canAssignLinkFlair,
    this.accountsActiveIsFuzzed,
    this.allowPredictionContributors,
    this.submitTextLabel,
    this.linkFlairPosition,
    this.userSrFlairEnabled,
    this.userFlairEnabledInSr,
    this.allowChatPostCreation,
    this.allowDiscovery,
    this.acceptFollowers,
    this.userSrThemeEnabled,
    this.linkFlairEnabled,
    this.disableContributorRequests,
    this.subredditType,
    this.suggestedCommentSort,
    this.bannerImg,
    this.userFlairText,
    this.bannerBackgroundColor,
    this.showMedia,
    this.id,
    this.userIsModerator,
    this.over18,
    this.headerTitle,
    this.description,
    this.isChatPostFeatureEnabled,
    this.submitLinkLabel,
    this.userFlairTextColor,
    this.restrictCommenting,
    this.userFlairCssClass,
    this.allowImages,
    this.lang,
    this.whitelistStatus,
    this.url,
    this.createdUtc,
    this.bannerSize,
    this.mobileBannerImage,
    this.userIsContributor,
    this.allowPredictionsTournament,
  });

  final String? userFlairBackgroundColor;
  final String? submitTextHtml;
  final bool? restrictPosting;
  final dynamic userIsBanned;
  final bool? freeFormReports;
  final bool? wikiEnabled;
  final dynamic userIsMuted;
  final dynamic userCanFlairInSr;
  final String? displayName;
  final dynamic headerImg;
  final String? title;
  final bool? allowGalleries;
  final dynamic iconSize;
  final String? primaryColor;
  final dynamic activeUserCount;
  final String? iconImg;
  final String? displayNamePrefixed;
  final dynamic accountsActive;
  final bool? publicTraffic;
  final num? subscribers;
  final List<dynamic>? userFlairRichtext;
  final num? videostreamLinksCount;
  final String? name;
  final bool? quarantine;
  final bool? hideAds;
  final String? predictionLeaderboardEntryType;
  final bool? emojisEnabled;
  final String? advertiserCategory;
  final String? publicDescription;
  final num? commentScoreHideMins;
  final bool? allowPredictions;
  final dynamic userHasFavorited;
  final dynamic userFlairTemplateId;
  final String? communityIcon;
  final String? bannerBackgroundImage;
  final bool? originalContentTagEnabled;
  final bool? communityReviewed;
  final String? submitText;
  final String? descriptionHtml;
  final bool? spoilersEnabled;
  final CommentContributionSettings? commentContributionSettings;
  final bool? allowTalks;
  final dynamic headerSize;
  final String? userFlairPosition;
  final bool? allOriginalContent;
  final bool? hasMenuWidget;
  final dynamic isEnrolledInNewModmail;
  final String? keyColor;
  final bool? canAssignUserFlair;
  final num? created;
  final num? wls;
  final bool? showMediaPreview;
  final String? submissionType;
  final dynamic userIsSubscriber;
  final List<dynamic>? allowedMediaInComments;
  final bool? allowVideogifs;
  final bool? shouldArchivePosts;
  final String? userFlairType;
  final bool? allowPolls;
  final bool? collapseDeletedComments;
  final dynamic emojisCustomSize;
  final String? publicDescriptionHtml;
  final bool? allowVideos;
  final bool? isCrosspostableSubreddit;
  final dynamic notificationLevel;
  final bool? shouldShowMediaInCommentsSetting;
  final bool? canAssignLinkFlair;
  final bool? accountsActiveIsFuzzed;
  final bool? allowPredictionContributors;
  final String? submitTextLabel;
  final String? linkFlairPosition;
  final dynamic userSrFlairEnabled;
  final bool? userFlairEnabledInSr;
  final bool? allowChatPostCreation;
  final bool? allowDiscovery;
  final bool? acceptFollowers;
  final bool? userSrThemeEnabled;
  final bool? linkFlairEnabled;
  final bool? disableContributorRequests;
  final String? subredditType;
  final dynamic suggestedCommentSort;
  final String? bannerImg;
  final dynamic userFlairText;
  final String? bannerBackgroundColor;
  final bool? showMedia;
  final String? id;
  final dynamic userIsModerator;
  final bool? over18;
  final String? headerTitle;
  final String? description;
  final bool? isChatPostFeatureEnabled;
  final String? submitLinkLabel;
  final dynamic userFlairTextColor;
  final bool? restrictCommenting;
  final dynamic userFlairCssClass;
  final bool? allowImages;
  final String? lang;
  final String? whitelistStatus;
  final String? url;
  final num? createdUtc;
  final dynamic bannerSize;
  final String? mobileBannerImage;
  final dynamic userIsContributor;
  final bool? allowPredictionsTournament;

  factory SubredditData.fromJson(String str) => SubredditData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubredditData.fromMap(Map<String, dynamic> json) => SubredditData(
        userFlairBackgroundColor: json["user_flair_background_color"],
        submitTextHtml: json["submit_text_html"],
        restrictPosting: json["restrict_posting"],
        userIsBanned: json["user_is_banned"],
        freeFormReports: json["free_form_reports"],
        wikiEnabled: json["wiki_enabled"],
        userIsMuted: json["user_is_muted"],
        userCanFlairInSr: json["user_can_flair_in_sr"],
        displayName: json["display_name"],
        headerImg: json["header_img"],
        title: json["title"],
        allowGalleries: json["allow_galleries"],
        iconSize: json["icon_size"],
        primaryColor: json["primary_color"],
        activeUserCount: json["active_user_count"],
        iconImg: json["icon_img"],
        displayNamePrefixed: json["display_name_prefixed"],
        accountsActive: json["accounts_active"],
        publicTraffic: json["public_traffic"],
        subscribers: json["subscribers"],
        userFlairRichtext:
            json["user_flair_richtext"] == null ? null : List<dynamic>.from(json["user_flair_richtext"].map((x) => x)),
        videostreamLinksCount: json["videostream_links_count"],
        name: json["name"],
        quarantine: json["quarantine"],
        hideAds: json["hide_ads"],
        predictionLeaderboardEntryType: json["prediction_leaderboard_entry_type"],
        emojisEnabled: json["emojis_enabled"],
        advertiserCategory: json["advertiser_category"],
        publicDescription: json["public_description"],
        commentScoreHideMins: json["comment_score_hide_mins"],
        allowPredictions: json["allow_predictions"],
        userHasFavorited: json["user_has_favorited"],
        userFlairTemplateId: json["user_flair_template_id"],
        communityIcon: json["community_icon"],
        bannerBackgroundImage: json["banner_background_image"],
        originalContentTagEnabled: json["original_content_tag_enabled"],
        communityReviewed: json["community_reviewed"],
        submitText: json["submit_text"],
        descriptionHtml: json["description_html"],
        spoilersEnabled: json["spoilers_enabled"],
        commentContributionSettings: json["comment_contribution_settings"] == null
            ? null
            : CommentContributionSettings.fromMap(json["comment_contribution_settings"]),
        allowTalks: json["allow_talks"],
        headerSize: json["header_size"],
        userFlairPosition: json["user_flair_position"],
        allOriginalContent: json["all_original_content"],
        hasMenuWidget: json["has_menu_widget"],
        isEnrolledInNewModmail: json["is_enrolled_in_new_modmail"],
        keyColor: json["key_color"],
        canAssignUserFlair: json["can_assign_user_flair"],
        created: json["created"],
        wls: json["wls"],
        showMediaPreview: json["show_media_preview"],
        submissionType: json["submission_type"],
        userIsSubscriber: json["user_is_subscriber"],
        allowedMediaInComments: json["allowed_media_in_comments"] == null
            ? null
            : List<dynamic>.from(json["allowed_media_in_comments"].map((x) => x)),
        allowVideogifs: json["allow_videogifs"],
        shouldArchivePosts: json["should_archive_posts"],
        userFlairType: json["user_flair_type"],
        allowPolls: json["allow_polls"],
        collapseDeletedComments: json["collapse_deleted_comments"],
        emojisCustomSize: json["emojis_custom_size"],
        publicDescriptionHtml: json["public_description_html"],
        allowVideos: json["allow_videos"],
        isCrosspostableSubreddit: json["is_crosspostable_subreddit"],
        notificationLevel: json["notification_level"],
        shouldShowMediaInCommentsSetting: json["should_show_media_in_comments_setting"],
        canAssignLinkFlair: json["can_assign_link_flair"],
        accountsActiveIsFuzzed: json["accounts_active_is_fuzzed"],
        allowPredictionContributors: json["allow_prediction_contributors"],
        submitTextLabel: json["submit_text_label"],
        linkFlairPosition: json["link_flair_position"],
        userSrFlairEnabled: json["user_sr_flair_enabled"],
        userFlairEnabledInSr: json["user_flair_enabled_in_sr"],
        allowChatPostCreation: json["allow_chat_post_creation"],
        allowDiscovery: json["allow_discovery"],
        acceptFollowers: json["accept_followers"],
        userSrThemeEnabled: json["user_sr_theme_enabled"],
        linkFlairEnabled: json["link_flair_enabled"],
        disableContributorRequests: json["disable_contributor_requests"],
        subredditType: json["subreddit_type"],
        suggestedCommentSort: json["suggested_comment_sort"],
        bannerImg: json["banner_img"],
        userFlairText: json["user_flair_text"],
        bannerBackgroundColor: json["banner_background_color"],
        showMedia: json["show_media"],
        id: json["id"],
        userIsModerator: json["user_is_moderator"],
        over18: json["over18"],
        headerTitle: json["header_title"],
        description: json["description"],
        isChatPostFeatureEnabled: json["is_chat_post_feature_enabled"],
        submitLinkLabel: json["submit_link_label"],
        userFlairTextColor: json["user_flair_text_color"],
        restrictCommenting: json["restrict_commenting"],
        userFlairCssClass: json["user_flair_css_class"],
        allowImages: json["allow_images"],
        lang: json["lang"],
        whitelistStatus: json["whitelist_status"],
        url: json["url"],
        createdUtc: json["created_utc"],
        bannerSize: json["banner_size"],
        mobileBannerImage: json["mobile_banner_image"],
        userIsContributor: json["user_is_contributor"],
        allowPredictionsTournament: json["allow_predictions_tournament"],
      );

  Map<String, dynamic> toMap() => {
        "user_flair_background_color": userFlairBackgroundColor,
        "submit_text_html": submitTextHtml,
        "restrict_posting": restrictPosting,
        "user_is_banned": userIsBanned,
        "free_form_reports": freeFormReports,
        "wiki_enabled": wikiEnabled,
        "user_is_muted": userIsMuted,
        "user_can_flair_in_sr": userCanFlairInSr,
        "display_name": displayName,
        "header_img": headerImg,
        "title": title,
        "allow_galleries": allowGalleries,
        "icon_size": iconSize,
        "primary_color": primaryColor,
        "active_user_count": activeUserCount,
        "icon_img": iconImg,
        "display_name_prefixed": displayNamePrefixed,
        "accounts_active": accountsActive,
        "public_traffic": publicTraffic,
        "subscribers": subscribers,
        "user_flair_richtext": userFlairRichtext == null ? null : List<dynamic>.from(userFlairRichtext!.map((x) => x)),
        "videostream_links_count": videostreamLinksCount,
        "name": name,
        "quarantine": quarantine,
        "hide_ads": hideAds,
        "prediction_leaderboard_entry_type": predictionLeaderboardEntryType,
        "emojis_enabled": emojisEnabled,
        "advertiser_category": advertiserCategory,
        "public_description": publicDescription,
        "comment_score_hide_mins": commentScoreHideMins,
        "allow_predictions": allowPredictions,
        "user_has_favorited": userHasFavorited,
        "user_flair_template_id": userFlairTemplateId,
        "community_icon": communityIcon,
        "banner_background_image": bannerBackgroundImage,
        "original_content_tag_enabled": originalContentTagEnabled,
        "community_reviewed": communityReviewed,
        "submit_text": submitText,
        "description_html": descriptionHtml,
        "spoilers_enabled": spoilersEnabled,
        "comment_contribution_settings": commentContributionSettings?.toMap(),
        "allow_talks": allowTalks,
        "header_size": headerSize,
        "user_flair_position": userFlairPosition,
        "all_original_content": allOriginalContent,
        "has_menu_widget": hasMenuWidget,
        "is_enrolled_in_new_modmail": isEnrolledInNewModmail,
        "key_color": keyColor,
        "can_assign_user_flair": canAssignUserFlair,
        "created": created,
        "wls": wls,
        "show_media_preview": showMediaPreview,
        "submission_type": submissionType,
        "user_is_subscriber": userIsSubscriber,
        "allowed_media_in_comments":
            allowedMediaInComments == null ? null : List<dynamic>.from(allowedMediaInComments!.map((x) => x)),
        "allow_videogifs": allowVideogifs,
        "should_archive_posts": shouldArchivePosts,
        "user_flair_type": userFlairType,
        "allow_polls": allowPolls,
        "collapse_deleted_comments": collapseDeletedComments,
        "emojis_custom_size": emojisCustomSize,
        "public_description_html": publicDescriptionHtml,
        "allow_videos": allowVideos,
        "is_crosspostable_subreddit": isCrosspostableSubreddit,
        "notification_level": notificationLevel,
        "should_show_media_in_comments_setting": shouldShowMediaInCommentsSetting,
        "can_assign_link_flair": canAssignLinkFlair,
        "accounts_active_is_fuzzed": accountsActiveIsFuzzed,
        "allow_prediction_contributors": allowPredictionContributors,
        "submit_text_label": submitTextLabel,
        "link_flair_position": linkFlairPosition,
        "user_sr_flair_enabled": userSrFlairEnabled,
        "user_flair_enabled_in_sr": userFlairEnabledInSr,
        "allow_chat_post_creation": allowChatPostCreation,
        "allow_discovery": allowDiscovery,
        "accept_followers": acceptFollowers,
        "user_sr_theme_enabled": userSrThemeEnabled,
        "link_flair_enabled": linkFlairEnabled,
        "disable_contributor_requests": disableContributorRequests,
        "subreddit_type": subredditType,
        "suggested_comment_sort": suggestedCommentSort,
        "banner_img": bannerImg,
        "user_flair_text": userFlairText,
        "banner_background_color": bannerBackgroundColor,
        "show_media": showMedia,
        "id": id,
        "user_is_moderator": userIsModerator,
        "over18": over18,
        "header_title": headerTitle,
        "description": description,
        "is_chat_post_feature_enabled": isChatPostFeatureEnabled,
        "submit_link_label": submitLinkLabel,
        "user_flair_text_color": userFlairTextColor,
        "restrict_commenting": restrictCommenting,
        "user_flair_css_class": userFlairCssClass,
        "allow_images": allowImages,
        "lang": lang,
        "whitelist_status": whitelistStatus,
        "url": url,
        "created_utc": createdUtc,
        "banner_size": bannerSize,
        "mobile_banner_image": mobileBannerImage,
        "user_is_contributor": userIsContributor,
        "allow_predictions_tournament": allowPredictionsTournament,
      };
}

class CommentContributionSettings {
  CommentContributionSettings({
    this.allowedMediaTypes,
  });

  final List<String>? allowedMediaTypes;

  factory CommentContributionSettings.fromJson(String str) => CommentContributionSettings.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommentContributionSettings.fromMap(Map<String, dynamic> json) => CommentContributionSettings(
        allowedMediaTypes:
            json["allowed_media_types"] == null ? null : List<String>.from(json["allowed_media_types"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "allowed_media_types": allowedMediaTypes == null ? null : List<dynamic>.from(allowedMediaTypes!.map((x) => x)),
      };
}
