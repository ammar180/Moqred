import 'package:flutter/material.dart';
import '/flutter_flow/flutterflow_ui.dart';

import 'person_details_widget.dart' show PersonDetailsPageWidget;

class PersonDetailsPageModel extends FlutterFlowModel<PersonDetailsPageWidget> {
  static const pageSize = 5;
  final formKey = GlobalKey<FormState>();
  String? errorMessage;
  // State field(s) for personName widget.
  FocusNode? personNameFocusNode;
  TextEditingController? personNameTextController;
  String? Function(BuildContext, String?)? personNameTextControllerValidator;
  String? _personNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'الاسم أساسي';
    }

    return null;
  }

  // State field(s) for personPhone widget.
  FocusNode? personPhoneFocusNode;
  TextEditingController? personPhoneTextController;
  String? Function(BuildContext, String?)? personPhoneTextControllerValidator;
  // State field(s) for personRelatedTo widget.
  String? personRelatedToValue;
  FormFieldController<String>? personRelatedToValueController;
  // State field(s) for personBio widget.
  FocusNode? personBioFocusNode;
  TextEditingController? personBioTextController;
  String? Function(BuildContext, String?)? personBioTextControllerValidator;
  @override
  void initState(BuildContext context) {
    personNameTextControllerValidator = _personNameTextControllerValidator;
  }

  @override
  void dispose() {
    personNameFocusNode?.dispose();
    personNameTextController?.dispose();

    personPhoneFocusNode?.dispose();
    personPhoneTextController?.dispose();

    personBioFocusNode?.dispose();
    personBioTextController?.dispose();
  }
}


