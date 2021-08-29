import 'package:bloc/bloc.dart';
import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/dataloader.dart';
//import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileState(
            selectedUser: users[0],
            selectedMarket: markets[0],
            selectedDocumentType: documentTypes[0],
            selectedProfile: profiles[0],
            usingZebra: false,
            isAuthorized: false));
  void updateProfileState(_selectedUser, _selectedMarket, _selectedDocumentType,
          _selectedProfile, _usingZebra, _isAuthorized) =>
      emit(ProfileState(
          selectedUser: _selectedUser,
          selectedMarket: _selectedMarket,
          selectedDocumentType: _selectedDocumentType,
          selectedProfile: _selectedProfile,
          usingZebra: _usingZebra,
          isAuthorized: _isAuthorized));
}
