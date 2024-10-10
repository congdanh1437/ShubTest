import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaction__event.dart';
part 'transaction__state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is UpdateTransaction) {
      // Logic to handle the update can be added here
      yield TransactionUpdated();
    }
  }
}