class CameraEventState{
  final bool goToCurrentPosition;
  final bool goToDestinationPosition;
  final bool setZoomBoundsForDirection;

  CameraEventState(
      {required this.goToCurrentPosition,
      required this.goToDestinationPosition,
      required this.setZoomBoundsForDirection});

  CameraEventState copy({
     bool? goToCurrentPosition,
     bool? goToDestinationPosition,
     bool? setZoomBoundsForDirection,
  }){
    return CameraEventState(
        goToCurrentPosition: goToCurrentPosition ?? this.goToCurrentPosition,
        goToDestinationPosition: goToDestinationPosition ?? this.goToDestinationPosition,
        setZoomBoundsForDirection: setZoomBoundsForDirection ?? this.setZoomBoundsForDirection
    );
  }
}