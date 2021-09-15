class EventState{
  final bool goToCurrentPosition;
  final bool goToDestinationPosition;
  final bool setZoomBoundsForDirection;

  EventState(
      {required this.goToCurrentPosition,
      required this.goToDestinationPosition,
      required this.setZoomBoundsForDirection});

  EventState copy({
     bool? goToCurrentPosition,
     bool? goToDestinationPosition,
     bool? setZoomBoundsForDirection,
  }){
    return EventState(
        goToCurrentPosition: goToCurrentPosition ?? this.goToCurrentPosition,
        goToDestinationPosition: goToDestinationPosition ?? this.goToDestinationPosition,
        setZoomBoundsForDirection: setZoomBoundsForDirection ?? this.setZoomBoundsForDirection
    );
  }
}