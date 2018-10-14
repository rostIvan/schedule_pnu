import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/page/selection/interactor.dart';
import 'package:lessons_schedule_pnu/page/selection/state.dart';
import 'package:redux/redux.dart';

class SelectPage extends StatelessWidget {
  final Store<SearchState> store = Store<SearchState>(
      searchReducer,
      initialState: SearchState(SearchType.GROUP, null, false, null, null, null),
      distinct: true
  );
  final SearchInteractor interactor = SearchInteractor();
  final TextEditingController textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SelectPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(key: _scaffoldKey, appBar: _buildAppBar(), body: _buildBody(), floatingActionButton: _buildFab());
    interactor.attach(this, store);
    return StoreProvider<SearchState>(store: store, child: scaffold);
  }

  AppBar _buildAppBar() => AppBar(
      title: StoreConnector<SearchState, String>(
          converter: (store) => store.state.searchType == SearchType.GROUP ? 'групи' : 'викладача',
          builder: (context, text) => Text('Пошук $text')),
    actions: <Widget>[
    StoreConnector<SearchState, SearchState>(
      converter: (store) => store.state,
      builder: (context, state) => state.selectedItem == null ? Container() :
      IconButton(icon: Icon(Icons.check, color: Colors.white), onPressed: () => interactor.selectItem(state.selectedItem))
    )],
  );

  Widget _buildBody() => Column(children: <Widget>[SizedBox(height: 4.0), _buildInput(),  _buildSearchArea()]);

  Widget _buildFab() => StoreConnector<SearchState, SearchType>(
      converter: (store) => store.state.searchType,
      builder: (context, searchType) => FloatingActionButton(
          onPressed: () => interactor.changeSearchType(), child: searchType == SearchType.GROUP ? Icon(Icons.person) : Icon(Icons.group)));

  Widget _buildInput() =>
      Container(child: SearchTextField(controller: textController, interactor: interactor), padding: EdgeInsets.only(left: 0.0, right: 0.0));

  Widget _buildSearchArea() => StoreConnector<SearchState, SearchState>(
      converter: (store) => store.state, builder: (context, state) => state.isSearching ? _progress() : _suggestions(state.results));

  Widget _progress() => Progress();

  Widget _suggestions(List<String> suggestions) => SuggestionListView(suggestions, interactor);

  showMessage(message) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(message)));
  }

  hideErrorMessage() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
  }
}

class SearchTextField extends StatelessWidget {
  final SearchInteractor interactor;
  final TextEditingController controller;

  SearchTextField({Key key, this.interactor, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<SearchState, SearchType>(
      converter: (store) => store.state.searchType,
      builder: (context, searchType) => TextField(
          controller: controller,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
          onChanged: (text) => interactor.search(text),
          autofocus: true,
          decoration: InputDecoration(
              hintText: _hint(searchType),
              suffix: CircleIconButton(onPressed: () => interactor.clearText()),
              contentPadding: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0))));

  String _hint(searchType) => 'Введіть назву ' + (searchType == SearchType.GROUP ? 'групи' : 'викладача');
}

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Expanded(flex: 3, child: Center(child: CircularProgressIndicator()));
}

class SuggestionListView extends StatelessWidget {
  final List<String> suggestions;
  final SearchInteractor interactor;
  SuggestionListView(this.suggestions, this.interactor);

  @override
  Widget build(BuildContext context) => Expanded(child: _buildListView());

  ListView _buildListView() {
    List<Widget> list = suggestions == null ? [] : suggestions.asMap()
        .map((index, title) => MapEntry(index, _buildItem(index, title)))
        .values
        .map((suggestionItem) => Column(children: <Widget>[ suggestionItem, Divider(height: 1.0, color: Colors.grey[300]) ]))
        .toList();
    return ListView(children: list);
  }

  Widget _buildItem(int index, String title) => StoreConnector<SearchState, SelectedItem>(
      converter: (store) => store.state.selectedItem,
      builder: (context, selectedItem) => _buildSuggestion(selectedItem, index, title)
  );

  SuggestionItem _buildSuggestion(SelectedItem selectedItem, int index, String title) => selectedItem == null
      || selectedItem.position == null
      || selectedItem.position != index ?
    SuggestionItem(index, title, onClick: (index, text) => interactor.tapOnItem(index, text)) :
    SuggestionItem(index, title, onClick: (index, text) => interactor.tapOnItem(index, text), backgroundColor: Colors.blue, textColor: Colors.white);
}

typedef void OnClick(int index, String text);
class SuggestionItem extends StatelessWidget {
  final int index;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final OnClick onClick;

  const SuggestionItem(this.index, this.text, {this.onClick, this.textColor, this.backgroundColor, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(child: Container(
    child: ListTile(title: Text(text, style: TextStyle(color: textColor)), onTap: () { onClick(index, text); }),
    decoration: BoxDecoration(color: backgroundColor),
  ), padding: EdgeInsets.only(left: 0.0, right: 0.0));
}

class CircleIconButton extends StatelessWidget {
  final double size;
  final Function onPressed;
  final IconData icon;

  CircleIconButton({this.size = 24.0, this.icon = Icons.clear, this.onPressed});

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: this.onPressed,
      child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment(0.0, 0.0), // all centered
            children: <Widget>[
              Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle)),
              Icon(icon, size: size * 0.8, color: Theme.of(context).accentColor) // 60% width for icon
            ],
          )));
}
