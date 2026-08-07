part of 'address_cubit.dart';

@immutable
sealed class AddressState extends Equatable{
const AddressState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}
// final class AddressCreated extends AddressState {}
// final class AddressUpdated extends AddressState {}
// final class AddressDeleted extends AddressState {}

class AddressLoaded extends AddressState{
  final List<AddressModel> addresses ;
  const AddressLoaded(this.addresses);
  @override
  List<Object?> get props => [addresses];
}

// final class AddressDefaultChanged extends AddressState {
//   final AddressModel defaultAddress;
//   const AddressDefaultChanged(this.defaultAddress);
//   @override
//   List<Object?> get props => [defaultAddress];
// }

class AddressError extends AddressState{
  final String message;
  const  AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
