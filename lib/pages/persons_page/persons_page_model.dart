import 'package:flutter/material.dart';
import 'package:moqred/components/mobile_nav/mobile_nav_model.dart';
import 'package:moqred/flutter_flow/flutter_flow_model.dart';
import 'package:moqred/pages/persons_page/persons_page_widget.dart';

class PersonsModel extends FlutterFlowModel<PersonsPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for mobileNav component.
  late MobileNavModel mobileNavModel;

  @override
  void initState(BuildContext context) {
    mobileNavModel = createModel(context, () => MobileNavModel());
  }

  @override
  void dispose() {
    mobileNavModel.dispose();
  }
}
