import 'package:inventory_management/bloc/bloc_provider.dart';
import 'package:inventory_management/agent/api.dart';
import 'package:inventory_management/material/model/material_model.dart';
import 'package:rxdart/rxdart.dart';

class MaterialBloc extends BlocBase {
  MaterialBloc() {
    Observable.merge([_suggestChangedStream, _loadMoreSubject.stream])
        .pipe(_searchSource);
  }

  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>();
  final BehaviorSubject<List<MaterialModel>> _searchSource =
      BehaviorSubject<List<MaterialModel>>();
  final BehaviorSubject<List<MaterialModel>> _loadMoreSubject =
      BehaviorSubject<List<MaterialModel>>();

  //接受搜索文字
  Function(String) get handelSearchTextChanged => _searchSubject.sink.add;

  Future<Null> handelLoadMore(text) async {
    ApiModel result = await api.materialList(
        keyword: text, current: _searchSource.value.length);
    if (result.error != 0) {
      return;
    }
    List<MaterialModel> res = [];
    for (Map item in result.data['data']) {
      res.add(MaterialModel.fromJson(item));
    }
    List<MaterialModel> list = List.from(_searchSource.value);
    list.addAll(res);
    _loadMoreSubject.add(list);
  }

//向外报漏的数据源
  Stream<List<MaterialModel>> get source => _searchSource.stream;

  Stream<List<MaterialModel>> get _suggestChangedStream => _searchSubject.stream
          .debounce(Duration(milliseconds: 1000))
          .asyncMap((text) {
        return api.materialList(keyword: text);
      }).map((ApiModel result) {
        if (result.error != 0) {
          return [];
        }
        List<MaterialModel> res = [];
        for (Map item in result.data['data']) {
          res.add(MaterialModel.fromJson(item));
        }
        return res;
      });

  @override
  void dispose() async {
    await _searchSource.drain();
    _searchSubject.close();
    _searchSource.close();
    _loadMoreSubject.close();
  }
}
