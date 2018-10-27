import 'dart:io';

import 'package:lessons_schedule_pnu/data/network/pageload.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/data/service.dart';
import 'package:lessons_schedule_pnu/page/selection/state.dart';
import 'package:lessons_schedule_pnu/page/selection/view.dart';
import 'package:lessons_schedule_pnu/util/support.dart';
import 'package:redux/redux.dart';

class SearchInteractor extends BaseSearchInteractor {
  final prefWrapper = SharedPrefWrapper();
  ScheduleType searchType = ScheduleType.GROUP;

  SearchInteractor({this.searchType});

  @override
  ApiSearchService apiSearchService(String query) => _typeIsGroup() ?
      GroupsSuggestionSearch(query) : TeacherSuggestionSearch(query);

  void changeSearchType() {
    searchType = _newSearchType();
    clearText();
    _store.dispatch(ChangeSearchTypeAction(searchType));
    _animateAppBar();
  }

  void _animateAppBar() {
    _view.appBarSearchTypeInfo.animationController().reset();
    _view.appBarSearchTypeInfo.animationController().forward();
  }

  void clearText() {
    _view.textController.text = '';
    _store.dispatch(SearchResponseAction('', [], null));
  }

  void selectItem(ListItem selectedItem) async {
    _store.dispatch(ProgressAction.SHOW);
    prefWrapper
        .select(searchType, selectedItem.title)
        .whenComplete(() => _store.dispatch(ProgressAction.HIDE))
        .then((b) => _view.showHomePage(SelectedData(searchType, selectedItem.title), 'Збережено: ${selectedItem.title}'));
  }

  void tapOnItem(ListItem item) {
    _store.dispatch(SelectItemAction(item.position, item.title));
  }

  ScheduleType _newSearchType() => _typeIsGroup() ? ScheduleType.TEACHER : ScheduleType.GROUP;

  bool _typeIsGroup() => searchType == ScheduleType.GROUP;
}

abstract class BaseSearchInteractor {
  final DebounceAction debounceAction = DebounceAction();
  SelectionPageState _view;
  Store<SearchState> _store;

  void attach(SelectionPageState page, Store<SearchState> store) {
    this._view = page;
    this._store = store;
  }

  void search(String query)  {
    _doDebounce(() {
      if (query.isEmpty)
        _store.dispatch(SearchResponseAction(query, [], null));
      else
        _apiCall(query);
    });
  }

  void _apiCall(String query) {
    _store.dispatch(ProgressAction.SHOW);
    final ApiSearchService searchService = apiSearchService(query);
    searchService.fetchALl()
        .timeout(Duration(seconds: 120))
        .then((items) => _handleSuccess(query, items))
        .catchError((error) => _handleError(query, error));
  }

  void _handleSuccess(String query, List<String> items) {
    _store.dispatch(SearchResponseAction(query, items, null));
    _view.hideMessage();
  }

    void _handleError(String query, error) {
      _store.dispatch(SearchResponseAction(query, null, error.toString()));
      _view.showMessage(_errorMessage(error));
    }

    String _errorMessage(error) {
      if (error is SocketException) return 'Немає інтернет з\'єднання';
      if (error is NetworkException) return 'Return code: ${error.errorCode}';
      if (error is FormatException
          && error.message.contains('Unexpected character')
          && error.toString().contains('"suggestions": ]')) return 'Нічого не знайдено';
      return error.toString();
    }

    void _doDebounce(Function fun) {
      debounceAction.create(Duration(milliseconds: 500), fun);
    }

    ApiSearchService apiSearchService(String query);
}