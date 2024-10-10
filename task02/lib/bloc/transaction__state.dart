part of 'transaction__bloc.dart';

abstract class TransactionState extends TransactionBloc {
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionUpdated extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);

  @override
  List<Object> get props => [message];
}