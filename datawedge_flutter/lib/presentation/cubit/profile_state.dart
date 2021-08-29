part of 'profile_cubit.dart';

class ProfileState {
  User selectedUser; //= users[0];
  Market selectedMarket; //= markets[0];
  DocumentType selectedDocumentType; //= documentTypes[0];
  Profile selectedProfile; //= profiles[0];
  bool usingZebra = false;
  bool isAuthorized = false;
  ProfileState(
      {required this.selectedUser,
      required this.selectedMarket,
      required this.selectedDocumentType,
      required this.selectedProfile,
      required this.usingZebra,
      required this.isAuthorized});
  // ProfileState({
  //   required this.selectedUser,
  // });
}
