import 'package:fish_redux/fish_redux.dart';
import 'package:inventory_management/inventory_page/state.dart';

enum InventoryAction { add, subtract, onScan, scaned, init, onSave, clean }

class InventoryActionCreator {
  static Action init(InventoryState state) {
    return Action(InventoryAction.init, payload: state);
  }

  static Action clean() {
    return Action(InventoryAction.clean);
  }

  static Action add() {
    return const Action(InventoryAction.add);
  }

  static Action subtract() {
    return const Action(InventoryAction.subtract);
  }

  static Action onScan() {
    return const Action(InventoryAction.onScan);
  }

  static Action scaned(Map<String, String> data) {
    return Action(InventoryAction.scaned, payload: data);
  }

  static Action save(Map<String, dynamic> data) {
    return Action(InventoryAction.onSave, payload: data);
  }
}
