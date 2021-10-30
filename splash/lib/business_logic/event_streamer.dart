import 'package:base/models/trip_data.dart';

class EventStreamer{
  final TripData? assignedTrip;
  final bool isLoggedIn;
  final String error;
  final bool done;

  EventStreamer({
    required this.assignedTrip,
    required this.isLoggedIn,
    required this.error,
    required this.done
  });

  EventStreamer copy({
    TripData? assignedTrip,
    bool? isLoggedIn,
    String? error,
    bool? done
  }){
    return EventStreamer(
        assignedTrip: assignedTrip ?? this.assignedTrip,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        error: error ?? this.error,
        done: done ?? this.done
    );
  }
}