import 'package:flutter/material.dart';

import '../../../../../core/enums/user_type_enum.dart';
import '../../data/models/request/register_model.dart';

class RegisterParams extends ChangeNotifier {
  String name;
  String email;
  String password;
  String confirmPassword;
  UserType userType;
  String? phone;
  String? photoUrl;

  // Campos de endereço
  String? street;
  String? neighborhood;
  String? numberHouse;
  String? complement;
  String? zipCode;
  String? city;
  String? state;

  // Campos específicos para organizações
  String? organizationName;
  String? cnpj;
  String? responsibleName;
  String? missionStatement;
  String? website;
  String? facebook;
  String? instagram;
  String? twitter;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
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

  factory RegisterParams.empty() => RegisterParams(
        name: '',
        email: '',
        password: '',
        confirmPassword: '',
        userType: UserType.individual,
      );

  setEmail(String value) {
    email = value;
    notifyListeners();
  }

  setPassword(String value) {
    password = value;
    notifyListeners();
  }

  setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  setName(String value) {
    name = value;
    notifyListeners();
  }

  setUserType(UserType value) {
    userType = value;
    notifyListeners();
  }

  setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  setPhotoUrl(String value) {
    photoUrl = value;
    notifyListeners();
  }

  // Address setters
  setStreet(String value) {
    street = value;
    notifyListeners();
  }

  setNeighborhood(String value) {
    neighborhood = value;
    notifyListeners();
  }

  setNumberHouse(String value) {
    numberHouse = value;
    notifyListeners();
  }

  setComplement(String value) {
    complement = value;
    notifyListeners();
  }

  setZipCode(String value) {
    zipCode = value;
    notifyListeners();
  }

  setCity(String value) {
    city = value;
    notifyListeners();
  }

  setState(String value) {
    state = value;
    notifyListeners();
  }

  // Organization setters
  setOrganizationName(String value) {
    organizationName = value;
    notifyListeners();
  }

  setCnpj(String value) {
    cnpj = value;
    notifyListeners();
  }

  setResponsibleName(String value) {
    responsibleName = value;
    notifyListeners();
  }

  setMissionStatement(String value) {
    missionStatement = value;
    notifyListeners();
  }

  setWebsite(String value) {
    website = value;
    notifyListeners();
  }

  setFacebook(String value) {
    facebook = value;
    notifyListeners();
  }

  setInstagram(String value) {
    instagram = value;
    notifyListeners();
  }

  setTwitter(String value) {
    twitter = value;
    notifyListeners();
  }

  bool get isIndividual => userType == UserType.individual;
  bool get isOrganization => userType == UserType.organization;

  toModel() {
    return RegisterModel(
      name: name,
      email: email,
      password: password,
      userType: userType,
      phone: phone,
      photoUrl: photoUrl,
      street: street,
      neighborhood: neighborhood,
      numberHouse: numberHouse,
      complement: complement,
      zipCode: zipCode,
      city: city,
      state: state,
      organizationName: organizationName,
      cnpj: cnpj,
      responsibleName: responsibleName,
      missionStatement: missionStatement,
      website: website,
      facebook: facebook,
      instagram: instagram,
      twitter: twitter,
    );
  }
}
