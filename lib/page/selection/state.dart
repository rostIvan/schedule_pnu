import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/page/selection/interactor.dart';

@immutable
class SearchState {
  final SearchType searchType;
  final String query;
  final bool isSearching;
  final List<String> results;
  final String error;
  final SelectedItem selectedItem;
  SearchState(this.searchType, this.query, this.isSearching, this.results, this.error, this.selectedItem);
}

@immutable
class SelectedItem {
  final int position;
  final String title;
  SelectedItem(this.position, this.title);
}

SearchState searchReducer(SearchState prev, dynamic action) {
  switch(action) {
    case ProgressAction.HIDE: return SearchState(prev.searchType, prev.query, false, [], null, null); break;
    case ProgressAction.SHOW: return SearchState(prev.searchType, prev.query, true, [], null, null); break;
  }
  if (action is SearchResponseAction) {
    return SearchState(prev.searchType, action.query, false, action.items, action.error, null);
  }
  else if (action is ChangeSearchTypeAction) {
    return SearchState(action.newSearchType, '', false, [], null, null);
  }
  else if(action is SelectItemAction) {
    return SearchState(prev.searchType, prev.query, false, prev.results, prev.error, SelectedItem(action.itemIndex, action.itemTitle));
  }
  return prev;
}

class SelectItemAction {
  final int itemIndex;
  final String itemTitle;
  SelectItemAction(this.itemIndex, this.itemTitle);
}

class ChangeSearchTypeAction {
  final SearchType newSearchType;
  ChangeSearchTypeAction(this.newSearchType);
}

class SearchResponseAction {
  final String query;
  final List<String> items;
  final String error;
  SearchResponseAction(this.query, this.items, this.error);
}

enum ProgressAction {
  SHOW,
  HIDE
}