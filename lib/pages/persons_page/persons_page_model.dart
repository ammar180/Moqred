import 'package:flutter/material.dart';
import 'persons_page_widget.dart' show PersonsPageWidget;
import '/flutter_flow/flutter_flow_util.dart';
import '/components/mobile_nav/mobile_nav_widget.dart';

class PersonsPageModel extends FlutterFlowModel<PersonsPageWidget> {
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
