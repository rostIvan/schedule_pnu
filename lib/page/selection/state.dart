import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/util/support.dart';
import 'package:redux/redux.dart';

@immutable
class SearchState {
  final ScheduleType searchType;
  final String query;
  final bool isSearching;
  final List<String> results;
  final String error;
  final ListItem selectedItem;
  SearchState(this.searchType, this.query, this.isSearching, this.results, this.error, this.selectedItem);
}

@immutable
class ListItem {
  final int position;
  final String title;
  ListItem(this.position, this.title);
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
    return SearchState(prev.searchType, prev.query, false, prev.results, prev.error, ListItem(action.itemIndex, action.itemTitle));
  }
  return prev;
}

void middle(Store store, action, NextDispatcher next) async {
  print('called action: ${action.toString()}');
  next(action);
}

class SelectItemAction {
  final int itemIndex;
  final String itemTitle;
  SelectItemAction(this.itemIndex, this.itemTitle);
  @override
  String toString() => "SelectItemAction[index=$itemIndex, title=$itemTitle]";
}

class ChangeSearchTypeAction {
  final ScheduleType newSearchType;
  ChangeSearchTypeAction(this.newSearchType);
  @override
  String toString() => "ChangeSearchTypeAction[newSearchType=$newSearchType]";
}

class SearchResponseAction {
  final String query;
  final List<String> items;
  final String error;
  SearchResponseAction(this.query, this.items, this.error);
  @override
  String toString() => "SearchResponseAction[query=$query, items=$items, error=$error]";
}

enum ProgressAction {
  SHOW,
  HIDE
}