import 'dart:convert';

import '../../../../../../core/enums/user_type_enum.dart';

class RegisterModel {
  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
    this.phone,
    this.photoUrl,
    this.street,
    this.neighborhood,
    this.numberHouse,
    this.complement,
    this.zipCode,
    this.city,
    this.state,
    this.organizationName,
    this.cnpj,
    this.responsibleName,
    this.missionStatement,
    this.website,
    this.facebook,
    this.instagram,
    this.twitter,
  });

  final String name;
  final String email;
  final String password;
  final UserType userType;
  final String? phone;
  final String? photoUrl;

  // Campos de endereço
  final String? street;
  final String? neighborhood;
  final String? numberHouse;
  final String? complement;
  final String? zipCode;
  final String? city;
  final String? state;

  // Campos específicos para organizações
  final String? organizationName;
  final String? cnpj;
  final String? responsibleName;
  final String? missionStatement;
  final String? website;
  final String? facebook;
  final String? instagram;
  final String? twitter;

  Map<String, dynamic> toMap() {
    final baseMap = <String, dynamic>{
      'email': email,
      'password': password,
    };

    if (userType == UserType.individual) {
      baseMap.addAll({
        'name': name,
        if (phone != null) 'phone': phone,
        if (photoUrl != null) 'photo_url': photoUrl,
        if (_hasAddress) 'address': _addressMap,
      });
    } else {
      baseMap.addAll({
        'email': email,
        'password': password,
        'user_type': 'organization',
        'organization_name': organizationName ?? name,
        if (cnpj != null) 'cnpj': cnpj,
        if (responsibleName != null) 'responsible_name': responsibleName,
        if (phone != null) 'phone': phone,
        if (missionStatement != null) 'mission_statement': missionStatement,
        if (website != null) 'website': website,
        if (_hasSocialMedia) 'social_media': _socialMediaMap,
        if (_hasAddress) 'address': _addressMap,
      });
    }

    return baseMap;
  }

  bool get _hasAddress =>
      street != null ||
      neighborhood != null ||
      numberHouse != null ||
      zipCode != null ||
      city != null ||
      state != null;

  Map<String, dynamic> get _addressMap => {
        if (street != null) 'street': street,
        if (neighborhood != null) 'neighborhood': neighborhood,
        if (numberHouse != null) 'number_house': int.tryParse(numberHouse!) ?? 0,
        if (complement != null) 'complement': complement,
        if (zipCode != null) 'zip_code': zipCode,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
      };

  bool get _hasSocialMedia =>
      facebook != null || instagram != null || twitter != null;

  Map<String, dynamic> get _socialMediaMap => {
        if (facebook != null) 'facebook': facebook,
        if (instagram != null) 'instagram': instagram,
        if (twitter != null) 'twitter': twitter,
      };

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      name: map['name'] ?? map['organization_name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userType: map['user_type'] == 'organization'
          ? UserType.organization
          : UserType.individual,
      phone: map['phone'],
      photoUrl: map['photo_url'],
      street: map['address']?['street'],
      neighborhood: map['address']?['neighborhood'],
      numberHouse: map['address']?['number_house']?.toString(),
      complement: map['address']?['complement'],
      zipCode: map['address']?['zip_code'],
      city: map['address']?['city'],
      state: map['address']?['state'],
      organizationName: map['organization_name'],
      cnpj: map['cnpj'],
      responsibleName: map['responsible_name'],
      missionStatement: map['mission_statement'],
      website: map['website'],
      facebook: map['social_media']?['facebook'],
      instagram: map['social_media']?['instagram'],
      twitter: map['social_media']?['twitter'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterModel.fromJson(String source) =>
      RegisterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
