import 'package:flutter/material.dart';
import '../models/call.dart';
import '../repository/call_repository.dart';

class CallViewModel extends ChangeNotifier {
  final CallRepository _repository = CallRepository();
  CallModel? _currentCall;
  bool _isLoading = false;

  CallModel? get currentCall => _currentCall;
  bool get isLoading => _isLoading;

  // Start a new call
  Future<void> startCall(CallModel call) async {
    try {
      await _repository.startCall(call);
      _currentCall = call;
      notifyListeners();
    } catch (e) {
      print("Error starting call: $e");
    }
  }

  // Update call status
  Future<void> updateCallStatus(String channelId, Map<String, dynamic> updates) async {
    try {
      await _repository.updateCallStatus(channelId, updates);
      fetchCall(channelId);
    } catch (e) {
      print("Error updating call: $e");
    }
  }

  // Fetch call details
  Future<void> fetchCall(String channelId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentCall = await _repository.getCall(channelId);
    } catch (e) {
      print("Error fetching call: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
