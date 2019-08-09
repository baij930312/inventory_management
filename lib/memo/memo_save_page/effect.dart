import 'package:fish_redux/fish_redux.dart';
import 'package:inventory_management/agent/api.dart';
import 'package:inventory_management/agent/api_model.dart';
import 'package:inventory_management/memo/memo_edit_page/memo_image_component/state.dart';
import 'package:inventory_management/memo/memo_list_page/memo_list_tile_component/state.dart';
import 'package:inventory_management/route/router.dart';
import 'action.dart';
import 'state.dart';

Effect<MemoSaveState> buildEffect() {
  return combineEffects(<Object, Effect<MemoSaveState>>{
    Lifecycle.initState: _init,
    Lifecycle.dispose: _dispose,
    MemoSaveAction.onSave: _onSave,
  });
}

void _init(Action action, Context<MemoSaveState> ctx) async {
  // ApiModel result = await api.noteCategories();

  // if (result.isError()) {
  //   return;
  // }
  // List<CategoriesModel> activities = [];
  // for (var item in result.data['data']) {
  //   activities.add(CategoriesModel.fromJson(item));
  // }
  for (MemoImageState image in ctx.state.images) {
    if (image.asset != null) {
      await image.asset.requestThumbnail(300, 300, quality: 50);
    }
  }
}

void _dispose(Action action, Context<MemoSaveState> ctx) async {
  for (MemoImageState image in ctx.state.images) {
    if (image.asset != null) {
      image.asset.release();
    }
  }
}

void _onSave(Action action, Context<MemoSaveState> ctx) async {
  if (ctx.state.loading) {
    return;
  }
  ctx.dispatch(MemoSaveActionCreator.changeLoading(true));
  List<MemoImageState> images = ctx.state.images;
  if (images.length > 0) {
    //本地没有上传的图片
    List<MemoImageState> assets = images.where((image) {
      if (image.asset != null) {
        return true;
      }
      return false;
    }).toList();

    ApiModel result;
    List rowFiles = [];
    if (assets.length > 0) {
      //上传
      result = await api.fileUpload(assets.map((item) => item.asset).toList());
      if (result.isError()) {
        ctx.dispatch(MemoSaveActionCreator.changeLoading(false));
        return;
      }
      rowFiles = result.data['data'] ?? [];
    }
//移除已经上传的本地照片数据
    images.removeWhere((image) {
      if (image.asset != null) {
        return true;
      }
      return false;
    });
    //把上传后的数据添加到images中
    images.addAll(rowFiles.map<MemoImageState>((json) {
      return MemoImageState.fromJson(json);
    }).toList());
  }
  ApiModel addedResult;
  //拼接数据
  MemoListTileState state = ctx.state.listTileState.clone();
  state.keyword = ctx.state.keywordController.text;
  state.category = ctx.state.activity;
  state.notes = ctx.state.notes;
  state.email = ctx.state.sendEmail ? 1 : 0;
  state.files = images;
  if (ctx.state.listTileState.id == null) {
    addedResult = await api.addNote(state.toJson());
  } else {
    Map jsonMap = state.toJson();
    jsonMap['id'] = jsonMap['_id'];
    jsonMap.remove('_id');
    addedResult = await api.updateNote(jsonMap);
  }
  ctx.dispatch(MemoSaveActionCreator.changeLoading(false));
  if (!addedResult.isError()) {
    appRouter.popNum(ctx.context, 2);
  }
}
