// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final linkCommentResponse = linkCommentResponseFromMap(jsonString);

import 'dart:convert';

import 'package:reddit_app/src/models/listing_response_model.dart';

class LinkDetailResponse {
  final ListingResponse? linkData;
  final LinkCommentResponse? commentData;
  LinkDetailResponse({this.commentData, this.linkData});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'linkData': linkData?.toMap(), 'commentData': commentData?.toMap()};
  }

  factory LinkDetailResponse.fromMap(dynamic map) {
    return LinkDetailResponse(
      linkData: map[0] == null ? null : ListingResponse.fromMap(map[0]),
      commentData: map[1] == null ? null : LinkCommentResponse.fromMap(map[1]),
    );
  }

  String toJson() => json.encode(toMap());

  factory LinkDetailResponse.fromJson(String source) => LinkDetailResponse.fromMap(json.decode(source));
}

class LinkCommentResponse {
  LinkCommentResponse({
    this.kind,
    this.data,
  });

  final String? kind;
  final LinkCommentResponseData? data;

  factory LinkCommentResponse.fromJson(String str) => LinkCommentResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LinkCommentResponse.fromMap(Map<String, dynamic> json) => LinkCommentResponse(
        kind: json["kind"],
        data: json["data"] == null ? null : LinkCommentResponseData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "data": data?.toMap(),
      };
}

class LinkCommentResponseData {
  LinkCommentResponseData({
    this.after,
    this.dist,
    this.modhash,
    this.geoFilter,
    this.children,
    this.before,
  });

  final dynamic after;
  final dynamic dist;
  final String? modhash;
  final String? geoFilter;
  final List<CommentData>? children;
  final dynamic before;

  factory LinkCommentResponseData.fromJson(String str) => LinkCommentResponseData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LinkCommentResponseData.fromMap(Map<String, dynamic> json) => LinkCommentResponseData(
        after: json["after"],
        dist: json["dist"],
        modhash: json["modhash"],
        geoFilter: json["geo_filter"],
        children: json["children"] == null
            ? []
            : List<CommentData>.from(json["children"]!.map((x) => CommentData.fromMap(x))),
        before: json["before"],
      );

  Map<String, dynamic> toMap() => {
        "after": after,
        "dist": dist,
        "modhash": modhash,
        "geo_filter": geoFilter,
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toMap())),
        "before": before,
      };
}

class CommentData {
  CommentData({
    this.kind,
    this.data,
  });

  final String? kind;
  final Comment? data;

  factory CommentData.fromJson(String str) => CommentData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommentData.fromMap(Map<String, dynamic> json) => CommentData(
        kind: json["kind"],
        data: json["data"] == null ? null : Comment.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "data": data?.toMap(),
      };
}

class Comment {
  Comment({
    this.subredditId,
    this.approvedAtUtc,
    this.authorIsBlocked,
    this.commentType,
    this.awarders,
    this.modReasonBy,
    this.bannedBy,
    this.authorFlairType,
    this.totalAwardsReceived,
    this.subreddit,
    this.authorFlairTemplateId,
    this.likes,
    this.replies,
    this.userReports,
    this.saved,
    this.id,
    this.bannedAtUtc,
    this.modReasonTitle,
    this.gilded,
    this.archived,
    this.collapsedReasonCode,
    this.noFollow,
    this.author,
    this.canModPost,
    this.createdUtc,
    this.sendReplies,
    this.parentId,
    this.score,
    this.authorFullname,
    this.approvedBy,
    this.modNote,
    this.allAwardings,
    this.collapsed,
    this.body,
    this.edited,
    this.topAwardedType,
    this.authorFlairCssClass,
    this.name,
    this.isSubmitter,
    this.downs,
    this.authorFlairRichtext,
    this.authorPatreonFlair,
    this.bodyHtml,
    this.removalReason,
    this.collapsedReason,
    this.distinguished,
    this.associatedAward,
    this.stickied,
    this.authorPremium,
    this.canGild,
    this.gildings,
    this.unrepliableReason,
    this.authorFlairTextColor,
    this.scoreHidden,
    this.permalink,
    this.subredditType,
    this.locked,
    this.reportReasons,
    this.created,
    this.authorFlairText,
    this.treatmentTags,
    this.linkId,
    this.subredditNamePrefixed,
    this.controversiality,
    this.depth,
    this.authorFlairBackgroundColor,
    this.collapsedBecauseCrowdControl,
    this.modReports,
    this.numReports,
    this.ups,
    this.count,
    this.children,
  });

  final String? subredditId;
  final dynamic approvedAtUtc;
  final bool? authorIsBlocked;
  final dynamic commentType;
  final List<dynamic>? awarders;
  final dynamic modReasonBy;
  final dynamic bannedBy;
  final String? authorFlairType;
  final num? totalAwardsReceived;
  final String? subreddit;
  final dynamic authorFlairTemplateId;
  final dynamic likes;
  final LinkCommentResponseData? replies;
  final List<dynamic>? userReports;
  final bool? saved;
  final String? id;
  final dynamic bannedAtUtc;
  final dynamic modReasonTitle;
  final num? gilded;
  final bool? archived;
  final String? collapsedReasonCode;
  final bool? noFollow;
  final String? author;
  final bool? canModPost;
  final num? createdUtc;
  final bool? sendReplies;
  final String? parentId;
  final num? score;
  final String? authorFullname;
  final dynamic approvedBy;
  final dynamic modNote;
  final List<AllAwarding>? allAwardings;
  final bool? collapsed;
  final String? body;
  final dynamic edited;
  final dynamic topAwardedType;
  final dynamic authorFlairCssClass;
  final String? name;
  final bool? isSubmitter;
  final num? downs;
  final List<dynamic>? authorFlairRichtext;
  final bool? authorPatreonFlair;
  final String? bodyHtml;
  final dynamic removalReason;
  final dynamic collapsedReason;
  final dynamic distinguished;
  final dynamic associatedAward;
  final bool? stickied;
  final bool? authorPremium;
  final bool? canGild;
  final Gildings? gildings;
  final dynamic unrepliableReason;
  final String? authorFlairTextColor;
  final bool? scoreHidden;
  final String? permalink;
  final String? subredditType;
  final bool? locked;
  final dynamic reportReasons;
  final num? created;
  final dynamic authorFlairText;
  final List<String>? treatmentTags;
  final String? linkId;
  final String? subredditNamePrefixed;
  final num? controversiality;
  final num? depth;
  final String? authorFlairBackgroundColor;
  final dynamic collapsedBecauseCrowdControl;
  final List<dynamic>? modReports;
  final dynamic numReports;
  final num? ups;
  final num? count;
  final List<String>? children;

  factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        subredditId: json["subreddit_id"],
        approvedAtUtc: json["approved_at_utc"],
        authorIsBlocked: json["author_is_blocked"],
        commentType: json["comment_type"],
        awarders: json["awarders"] == null ? [] : List<dynamic>.from(json["awarders"]!.map((x) => x)),
        modReasonBy: json["mod_reason_by"],
        bannedBy: json["banned_by"],
        authorFlairType: json["author_flair_type"],
        totalAwardsReceived: json["total_awards_received"],
        subreddit: json["subreddit"],
        authorFlairTemplateId: json["author_flair_template_id"],
        likes: json["likes"],
        replies:
            json["replies"] == null || json["replies"] == "" ? null : LinkCommentResponseData.fromMap(json["replies"]),
        userReports: json["user_reports"] == null ? [] : List<dynamic>.from(json["user_reports"]!.map((x) => x)),
        saved: json["saved"],
        id: json["id"],
        bannedAtUtc: json["banned_at_utc"],
        modReasonTitle: json["mod_reason_title"],
        gilded: json["gilded"],
        archived: json["archived"],
        collapsedReasonCode: json["collapsed_reason_code"],
        noFollow: json["no_follow"],
        author: json["author"],
        canModPost: json["can_mod_post"],
        createdUtc: json["created_utc"],
        sendReplies: json["send_replies"],
        parentId: json["parent_id"],
        score: json["score"],
        authorFullname: json["author_fullname"],
        approvedBy: json["approved_by"],
        modNote: json["mod_note"],
        allAwardings: json["all_awardings"] == null
            ? []
            : List<AllAwarding>.from(json["all_awardings"]!.map((x) => AllAwarding.fromMap(x))),
        collapsed: json["collapsed"],
        body: json["body"],
        edited: json["edited"],
        topAwardedType: json["top_awarded_type"],
        authorFlairCssClass: json["author_flair_css_class"],
        name: json["name"],
        isSubmitter: json["is_submitter"],
        downs: json["downs"],
        authorFlairRichtext: json["author_flair_richtext"] == null
            ? []
            : List<dynamic>.from(json["author_flair_richtext"]!.map((x) => x)),
        authorPatreonFlair: json["author_patreon_flair"],
        bodyHtml: json["body_html"],
        removalReason: json["removal_reason"],
        collapsedReason: json["collapsed_reason"],
        distinguished: json["distinguished"],
        associatedAward: json["associated_award"],
        stickied: json["stickied"],
        authorPremium: json["author_premium"],
        canGild: json["can_gild"],
        gildings: json["gildings"] == null ? null : Gildings.fromMap(json["gildings"]),
        unrepliableReason: json["unrepliable_reason"],
        authorFlairTextColor: json["author_flair_text_color"],
        scoreHidden: json["score_hidden"],
        permalink: json["permalink"],
        subredditType: json["subreddit_type"],
        locked: json["locked"],
        reportReasons: json["report_reasons"],
        created: json["created"],
        authorFlairText: json["author_flair_text"],
        treatmentTags: json["treatment_tags"] == null ? [] : List<String>.from(json["treatment_tags"]!.map((x) => x)),
        linkId: json["link_id"],
        subredditNamePrefixed: json["subreddit_name_prefixed"],
        controversiality: json["controversiality"],
        depth: json["depth"],
        authorFlairBackgroundColor: json["author_flair_background_color"],
        collapsedBecauseCrowdControl: json["collapsed_because_crowd_control"],
        modReports: json["mod_reports"] == null ? [] : List<dynamic>.from(json["mod_reports"]!.map((x) => x)),
        numReports: json["num_reports"],
        ups: json["ups"],
        count: json["count"],
        children: json["children"] == null ? [] : List<String>.from(json["children"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "subreddit_id": subredditId,
        "approved_at_utc": approvedAtUtc,
        "author_is_blocked": authorIsBlocked,
        "comment_type": commentType,
        "awarders": awarders == null ? [] : List<dynamic>.from(awarders!.map((x) => x)),
        "mod_reason_by": modReasonBy,
        "banned_by": bannedBy,
        "author_flair_type": authorFlairType,
        "total_awards_received": totalAwardsReceived,
        "subreddit": subreddit,
        "author_flair_template_id": authorFlairTemplateId,
        "likes": likes,
        "replies": replies?.toMap(),
        "user_reports": userReports == null ? [] : List<dynamic>.from(userReports!.map((x) => x)),
        "saved": saved,
        "id": id,
        "banned_at_utc": bannedAtUtc,
        "mod_reason_title": modReasonTitle,
        "gilded": gilded,
        "archived": archived,
        "collapsed_reason_code": collapsedReasonCode,
        "no_follow": noFollow,
        "author": author,
        "can_mod_post": canModPost,
        "created_utc": createdUtc,
        "send_replies": sendReplies,
        "parent_id": parentId,
        "score": score,
        "author_fullname": authorFullname,
        "approved_by": approvedBy,
        "mod_note": modNote,
        "all_awardings": allAwardings == null ? [] : List<dynamic>.from(allAwardings!.map((x) => x.toMap())),
        "collapsed": collapsed,
        "body": body,
        "edited": edited,
        "top_awarded_type": topAwardedType,
        "author_flair_css_class": authorFlairCssClass,
        "name": name,
        "is_submitter": isSubmitter,
        "downs": downs,
        "author_flair_richtext":
            authorFlairRichtext == null ? [] : List<dynamic>.from(authorFlairRichtext!.map((x) => x)),
        "author_patreon_flair": authorPatreonFlair,
        "body_html": bodyHtml,
        "removal_reason": removalReason,
        "collapsed_reason": collapsedReason,
        "distinguished": distinguished,
        "associated_award": associatedAward,
        "stickied": stickied,
        "author_premium": authorPremium,
        "can_gild": canGild,
        "gildings": gildings?.toMap(),
        "unrepliable_reason": unrepliableReason,
        "author_flair_text_color": authorFlairTextColor,
        "score_hidden": scoreHidden,
        "permalink": permalink,
        "subreddit_type": subredditType,
        "locked": locked,
        "report_reasons": reportReasons,
        "created": created,
        "author_flair_text": authorFlairText,
        "treatment_tags": treatmentTags == null ? [] : List<dynamic>.from(treatmentTags!.map((x) => x)),
        "link_id": linkId,
        "subreddit_name_prefixed": subredditNamePrefixed,
        "controversiality": controversiality,
        "depth": depth,
        "author_flair_background_color": authorFlairBackgroundColor,
        "collapsed_because_crowd_control": collapsedBecauseCrowdControl,
        "mod_reports": modReports == null ? [] : List<dynamic>.from(modReports!.map((x) => x)),
        "num_reports": numReports,
        "ups": ups,
        "count": count,
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x)),
      };
}
