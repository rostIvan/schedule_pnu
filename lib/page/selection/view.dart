import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/page/home/view.dart';
import 'package:lessons_schedule_pnu/page/selection/interactor.dart';
import 'package:lessons_schedule_pnu/page/selection/state.dart';
import 'package:lessons_schedule_pnu/util/support.dart';
import 'package:redux/redux.dart';

class SelectionPage extends StatefulWidget {
  final Store<SearchState> store;
  final SearchInteractor interactor;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SelectionPage(this.store, this.interactor, {Key key}) : super(key: key);

  @override
  SelectionPageState createState() =>
      SelectionPageState(store, interactor, _scaffoldKey);
}

class SelectionPageState extends State<SelectionPage> {
  final Store<SearchState> store;
  final SearchInteractor interactor;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  final textController = TextEditingController();
  final appBarSearchTypeInfo = SearchTypeInfo();

  SelectionPageState(this.store, this.interactor, this._scaffoldKey);

  @override
  void initState() {
    interactor.attach(this, store);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFab());
    return StoreProvider<SearchState>(store: store, child: scaffold);
  }

  AppBar _buildAppBar() => AppBar(
        title: _appBarTitle(),
        actions: <Widget>[_selectButton()],
      );

  Widget _appBarTitle() =>
      Row(children: <Widget>[Text('Пошук '), appBarSearchTypeInfo]);

  Widget _selectButton() => StoreConnector<SearchState, SearchState>(
      converter: (store) => store.state,
      builder: (context, state) => state.selectedItem == null
          ? Container()
          : IconButton(
              icon: Icon(Icons.check, color: Colors.white),
              onPressed: () => interactor.selectItem(state.selectedItem)));

  Widget _buildBody() => Column(children: <Widget>[
        SizedBox(height: 4.0),
        _buildInput(),
        _buildSearchArea()
      ]);

  Widget _buildFab() => StoreConnector<SearchState, ScheduleType>(
      converter: (store) => store.state.searchType,
      builder: (context, searchType) => FloatingActionButton(
          onPressed: () => interactor.changeSearchType(),
          child: searchType == ScheduleType.GROUP
              ? Icon(Icons.person)
              : Icon(Icons.group)));

  Widget _buildInput() =>
      SearchTextField(controller: textController, interactor: interactor);

  Widget _buildSearchArea() => StoreConnector<SearchState, SearchState>(
      converter: (store) => store.state,
      builder: (context, state) =>
          state.isSearching ? _progress() : _suggestions(state.results));

  Widget _progress() => Progress();

  Widget _suggestions(List<String> suggestions) =>
      SuggestionListView(suggestions, interactor);

  void showMessage(message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void hideMessage() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
  }

  void showHomePage(SelectedData data, String message) {
    Navigator.of(_scaffoldKey.currentContext).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(data: data, startMessage: message)));
  }
}

class SearchTextField extends StatelessWidget {
  final SearchInteractor interactor;
  final TextEditingController controller;

  SearchTextField({Key key, this.interactor, this.controller});

  @override
  Widget build(BuildContext context) =>
      StoreConnector<SearchState, ScheduleType>(
          converter: (store) => store.state.searchType,
          builder: (context, searchType) => TextField(
              controller: controller,
              onChanged: (text) => interactor.search(text),
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              autofocus: true,
              decoration: InputDecoration(
                  hintText: _hint(searchType),
                  suffix:
                      CircleIconButton(onPressed: () => interactor.clearText()),
                  contentPadding: EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 8.0, bottom: 8.0))));

  String _hint(searchType) =>
      'Введіть назву ' +
      (searchType == ScheduleType.GROUP ? 'групи' : 'викладача');
}

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Expanded(flex: 3, child: Center(child: CircularProgressIndicator()));
}

class SuggestionListView extends StatelessWidget {
  final List<String> suggestions;
  final SearchInteractor interactor;

  SuggestionListView(this.suggestions, this.interactor);

  @override
  Widget build(BuildContext context) => Expanded(child: _buildListView());

  ListView _buildListView() {
    List<Widget> list = suggestions == null
        ? []
        : suggestions
            .asMap()
            .map((index, title) => MapEntry(index, _buildItem(index, title)))
            .values
            .map((suggestionItem) => Column(children: <Widget>[
                  suggestionItem,
                  Divider(height: 1.0, color: Colors.grey[300])
                ]))
            .toList();
    return ListView(children: list);
  }

  Widget _buildItem(int index, String title) =>
      StoreConnector<SearchState, ListItem>(
          converter: (store) => store.state.selectedItem,
          builder: (context, selectedItem) =>
              _buildSuggestion(selectedItem, index, title));

  SuggestionItem _buildSuggestion(
          ListItem selectedItem, int index, String title) =>
      selectedItem == null ||
              selectedItem.position == null ||
              selectedItem.position != index
          ? SuggestionItem(index, title,
              onClick: (index, text) =>
                  interactor.tapOnItem(ListItem(index, text)))
          : SuggestionItem(index, title,
              onClick: (index, text) =>
                  interactor.tapOnItem(ListItem(index, text)),
              backgroundColor: Colors.blue,
              textColor: Colors.white);
}

typedef void OnClick(int index, String text);

class SuggestionItem extends StatelessWidget {
  final int index;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final OnClick onClick;

  const SuggestionItem(this.index, this.text,
      {this.onClick, this.textColor, this.backgroundColor, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        child: ListTile(
            title: Text(text, style: TextStyle(color: textColor)),
            onTap: () {
              onClick(index, text);
            }),
        decoration: BoxDecoration(color: backgroundColor),
      );
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
            alignment: Alignment(1.0, 1.0), // all centered
            children: <Widget>[
              Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(shape: BoxShape.circle)),
              Icon(icon,
                  size: size * 0.8,
                  color: Theme.of(context).accentColor) // 60% width for icon
            ],
          )));
}

class SearchTypeInfo extends StatefulWidget {
  final searchType = SearchTypeState();

  @override
  SearchTypeState createState() => searchType;

  AnimationController animationController() => searchType.translationController;
}

class SearchTypeState extends State<SearchTypeInfo>
    with SingleTickerProviderStateMixin {
  Animation<double> translationAnimation;
  AnimationController translationController;

  @override
  void initState() {
    super.initState();
    _initAnim();
  }

  void _initAnim() {
    translationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    translationAnimation =
        Tween(begin: -0.1, end: 0.0).animate(translationController)
          ..addListener(() {
            setState(() {});
          });
    translationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var animatedBuilder = AnimatedBuilder(
        animation: translationController,
        builder: (BuildContext context, Widget child) => Transform(
            transform: Matrix4.translationValues(
                0.0, translationAnimation.value * height, 0.0),
            child: StoreConnector<SearchState, String>(
                converter: (store) =>
                    store.state.searchType == ScheduleType.GROUP
                        ? 'групи'
                        : 'викладача',
                builder: (context, text) => AnimatedOpacity(
                    opacity: translationAnimation.value > -0.03 ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 150),
                    child: Text(text)))));
    return animatedBuilder;
  }

  @override
  void dispose() {
    translationController.dispose();
    super.dispose();
  }
}
