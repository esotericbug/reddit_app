// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromMap(jsonString);

import 'dart:convert';

class ErrorResponse {
  ErrorResponse({
    this.reason,
    this.message,
    this.error,
  });

  String? reason;
  String? message;
  num? error;

  factory ErrorResponse.fromJson(String str) => ErrorResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ErrorResponse.fromMap(Map<String, dynamic> json) => ErrorResponse(
        reason: json["reason"],
        message: json["message"],
        error: json["error"],
      );

  Map<String, dynamic> toMap() => {
        "reason": reason,
        "message": message,
        "error": error,
      };
}
