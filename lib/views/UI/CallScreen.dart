import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/call_viewmodel.dart';

class CallScreen extends StatelessWidget {
  final String channelId;

  const CallScreen({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final callViewModel = Provider.of<CallViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Call Details")),
      body: Center(
        child: callViewModel.isLoading
            ? CircularProgressIndicator()
            : callViewModel.currentCall != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Call Type: ${callViewModel.currentCall!.callType}"),
            Text("Caller: ${callViewModel.currentCall!.callerName}"),
            Text("Doctor: ${callViewModel.currentCall!.doctorName}"),
            Text("Duration: ${callViewModel.currentCall!.duration} sec"),
            Text("Status: ${callViewModel.currentCall!.status}"),
          ],
        )
            : Text("Call not found"),
      ),
    );
  }
}
