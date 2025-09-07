import 'package:moqred/flutter_flow/form_field_controller.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'new_transaction_widget.dart' show NewTransactionWidget;
import 'package:flutter/material.dart';

class NewTransactionModel extends FlutterFlowModel<NewTransactionWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for transactionAmount widget.
  FocusNode? transactionAmountFocusNode;
  TextEditingController? transactionAmountTextController;
  String? Function(BuildContext, String?)?
      transactionAmountTextControllerValidator;
  String? _transactionAmountTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'يجب ادخال المبلغ';
    }

    return null;
  }

  // State field(s) for transactionType widget.
  String? transactionTypeValue;
  FormFieldController<String>? transactionTypeValueController;
  // State field(s) for transactionPerson widget.
  String? transactionPersonValue;
  FormFieldController<String>? transactionPersonValueController;
  // State field(s) for transactionPersonNotes widget.
  FocusNode? transactionPersonNotesFocusNode;
  TextEditingController? transactionPersonNotesTextController;
  String? Function(BuildContext, String?)?
      transactionPersonNotesTextControllerValidator;

  @override
  void initState(BuildContext context) {
    transactionAmountTextControllerValidator =
        _transactionAmountTextControllerValidator;
  }

  @override
  void dispose() {
    transactionAmountFocusNode?.dispose();
    transactionAmountTextController?.dispose();

    transactionPersonNotesFocusNode?.dispose();
    transactionPersonNotesTextController?.dispose();
  }
}
