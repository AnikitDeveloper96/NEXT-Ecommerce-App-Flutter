// // Bloc
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:upi_india/upi_india.dart';
// import '../bloc_event/upi_payment_event.dart';
// import '../bloc_state/upi_payment_state.dart';

// class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
//   final UpiIndia _upiIndia = UpiIndia();

//   PaymentBloc() : super(PaymentInitialState()) {
//     on<PaymentInitiatedEvent>((event, emit) async {
//       emit(PaymentLoadingState()); // Show loading state

//       try {
//         final result = await _upiIndia.startTransaction(
//           app: UpiApp.allBank, // Optional
//           receiverUpiId: "YOUR_UPI_ID",
//           receiverName: "Payee Name",
//           amount: 1.00, // Must be a string
//           transactionNote: "Transaction Note",
//           transactionRefId: "",

//         );

//         if (result.status == UpiPaymentStatus.SUCCESS) {
//           emit(PaymentSuccessfulState(result));
//         } else {
//           emit(PaymentFailedState(result.status??"Failed")); // Or a more specific error message
//         }
//       } catch (e) {
//         emit(PaymentFailedState(e.toString()));
//       }
//     });
//   }
// }
