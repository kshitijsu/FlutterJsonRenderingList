import 'package:json_annotation/json_annotation.dart';
import "address.dart";
import "company.dart";
part 'user.g.dart';

@JsonSerializable()
class User {
    User();

    num id;
    String name;
    String username;
    String email;
    Address address;
    String phone;
    String website;
    Company company;
    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
