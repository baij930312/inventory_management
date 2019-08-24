import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management/common/utils.dart';
import 'package:inventory_management/memo/memo_edit_page/ocr_list_page/ocr_label_component/state.dart';
import 'package:inventory_management/route/router.dart';
import 'action.dart';
import 'state.dart';

Effect<OcrListState> buildEffect() {
  return combineEffects(<Object, Effect<OcrListState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _dispose,
    OcrListAction.onSubmit: _onSubmit,
  });
}

void _onInit(Action action, Context<OcrListState> ctx) async {
  var image = await ImagePicker.pickImage(source: ImageSource.camera);
  if (image == null) {
    return;
  }
  final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
  var visionText = await ctx.state.textDetector.processImage(visionImage);
  ctx.state.currentTextLabels.clear();
  List<OcrLabelState> labels =
      List.generate(visionText.blocks.length, (int index) {
    return OcrLabelState(
        id: Utils.currentTimeMillisAccumulation(index).toString(),
        text: visionText.blocks[index].text);
  }).toList();
  ctx.dispatch(OcrListActionCreator.init(labels));
}

void _onSubmit(Action action, Context<OcrListState> ctx) async {
  List<String> strList = ctx.state.currentTextLabels.map((OcrLabelState state) {
    return state.selected ? state.text : '';
  }).toList();
  appRouter.popScreen(ctx.context, strList.join());
}

void _dispose(Action action, Context<OcrListState> ctx) async {
   ctx.state.textDetector.close(); 
}
