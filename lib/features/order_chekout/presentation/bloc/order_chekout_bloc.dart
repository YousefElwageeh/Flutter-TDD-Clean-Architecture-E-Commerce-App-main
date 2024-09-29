import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_chekout_event.dart';
part 'order_chekout_state.dart';

class OrderChekoutBloc extends Bloc<OrderChekoutEvent, OrderChekoutState> {
  OrderChekoutBloc() : super(OrderChekoutInitial()) {
    on<OrderChekoutEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
