import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'add_person_widget.dart' show AddPersonWidget;
import 'package:flutter/material.dart';

class AddPersonModel extends FlutterFlowModel<AddPersonWidget> {
  
  final formKey = GlobalKey<FormState>();
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
  // Stores action output result for [Validate Form] action in addButton widget.

  String? errorMessage;

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
