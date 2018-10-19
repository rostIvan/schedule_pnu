import 'package:lessons_schedule_pnu/page/selection/interactor.dart';
import 'package:lessons_schedule_pnu/page/selection/state.dart';
import 'package:lessons_schedule_pnu/util/support.dart';
import 'package:redux/redux.dart';

Store<SearchState> searchStore(ScheduleType scheduleType) => Store<SearchState>(
    searchReducer,
    initialState: SearchState(scheduleType, null, false, null, null, null),
    distinct: true,
    middleware: [ middle ]
);

SearchInteractor searchInteractor({ScheduleType type}) => SearchInteractor(searchType: type);
