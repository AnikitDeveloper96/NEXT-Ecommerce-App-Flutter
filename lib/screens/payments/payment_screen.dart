// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:next_ecommerce_app/blocs/bloc_event/upi_payment_event.dart';

// import '../../blocs/bloc_state/upi_payment_state.dart';
// import '../../blocs/blocs/upi_payment_bloc.dart';

// class UPIPaymentScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<PaymentBloc>( // Provide the Bloc
//       create: (context) => PaymentBloc(),
//       child: _UPIPaymentScreenContent(),
//     );
//   }
// }

// class _UPIPaymentScreenContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('UPI Payment'),
//       ),
//       body: Center(
//         child: BlocBuilder<PaymentBloc, PaymentState>( // Use BlocBuilder
//           builder: (context, state) {
//             if (state is PaymentInitialState) {
//               return ElevatedButton(
//                 onPressed: () {
//                   context.read<PaymentBloc>().add(PaymentInitiatedEvent()); // Dispatch event
//                 },
//                 child: Text('Pay Now'),
//               );
//             } else if (state is PaymentLoadingState) {
//               return CircularProgressIndicator(); // Show loading indicator
//             } else if (state is PaymentSuccessfulState) {
//               return Text('Payment Successful: ${state.response.status}');
//             } else if (state is PaymentFailedState) {
//               return Text('Payment Failed: ${state.error}');
//             } else {
//               return Container(); // Or handle other states
//             }
//           },
//         ),
//       ),
//     );
//   }
// }