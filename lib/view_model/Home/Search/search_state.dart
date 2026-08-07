part of 'search_cubit.dart';

@immutable
sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {
  const SearchInitial();
}

final class SearchLoadInProgress extends SearchState {
  const SearchLoadInProgress();
}

final class SearchLoadSuccess extends SearchState {
  const SearchLoadSuccess({required this.results});

  final List<ProductModel> results;

  @override
  List<Object> get props => [results];
}

final class SearchLoadFailure extends SearchState {
  const SearchLoadFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

final class SearchHistoryLoaded extends SearchState {
  const SearchHistoryLoaded(this.history);

  final List<String> history;

  @override
  List<Object> get props => [history];
}
