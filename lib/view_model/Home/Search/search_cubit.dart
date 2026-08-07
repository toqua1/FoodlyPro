import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final Future<List<ProductModel>> Function(String query) searchFunction;
  final _searchSubject = BehaviorSubject<String>();
  static const _searchHistoryKey = 'search_history';

  SearchCubit(this.searchFunction) : super(const SearchInitial()) {
    _searchSubject.debounceTime(const Duration(milliseconds: 300)).listen((query) async {
      if (query.isEmpty) {
        final history = await _getSearchHistory();
        emit(SearchHistoryLoaded(history));
        return;
      }
      try {
        emit(const SearchLoadInProgress());
        final results = await searchFunction(query);
        // _saveSearchQuery(query); // Save the query on success
        emit(SearchLoadSuccess(results: results));
      } catch (e) {
        emit(SearchLoadFailure(e.toString()));
      }
    });
  }

  void queryChanged(String query) {
    _searchSubject.add(query);
  }

  Future<List<String>> _getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> saveSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_searchHistoryKey) ?? [];

    // Remove if already exists to move it to the front
    history.remove(query);
    history.insert(0, query);

    if (history.length > 5) {
      history = history.sublist(0, 5);
    }

    await prefs.setStringList(_searchHistoryKey, history);
  }

  void loadRecentSearches() async {
    final history = await _getSearchHistory();
    emit(SearchHistoryLoaded(history));
  }

  @override
  Future<void> close() {
    _searchSubject.close();
    return super.close();
  }
}
