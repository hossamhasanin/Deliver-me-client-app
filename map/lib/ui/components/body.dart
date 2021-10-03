import 'dart:async';

import 'package:base/base.dart';
import 'package:base/configs.dart';
import 'package:base/models/location.dart';
import 'package:base/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:base/models/destination_result.dart';
import 'package:map/business_logic/data/driver_data.dart';
import 'package:map/business_logic/map_controller.dart';
import 'package:map/business_logic/payment_methods.dart';
import 'package:map/ui/components/pay_online.dart';
import 'package:map/ui/components/payment_method.dart';
import 'package:map/ui/components/pick_destination.dart';
import 'package:map/ui/components/show_car_types.dart';

import 'assign_car.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Completer<GoogleMapController> _mainMapCompleter = Completer();
  GoogleMapController? _googleMapController;

  final MapController _controller = Get.find();

  final PageController _pageController = PageController();

  final PolylineId polylineTripId = const PolylineId("tripRoute");
  final MarkerId pickUpMarkerId = const MarkerId("pickUpMarker");
  final MarkerId dropOffMarkerId = const MarkerId("dropOffMarker");


  late Polyline polyline;
  late Marker pickUpMarker;
  late Marker dropOffMarker;
  late Marker driverMarker;
  late Circle pickUpCircle;
  late Circle dropOffCircle;
  List<LatLng> coordinates = [];


  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    polyline = Polyline(
        polylineId: polylineTripId,
        color: Colors.red,
        jointType: JointType.round,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true
    );

    pickUpMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      markerId: pickUpMarkerId,
    );

    dropOffMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      markerId: dropOffMarkerId,
    );

    driverMarker = const Marker(
      markerId: MarkerId("driverId"),
    );

    BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 10), "assets/images/automobile.png")
        .then((value) {
        driverMarker = driverMarker.copyWith(iconParam: value);
    });

    pickUpCircle = const Circle(
        circleId: CircleId("pickUp"),
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.red,
        fillColor: Colors.red
    );

    dropOffCircle = const Circle(
        circleId: CircleId("dropOff"),
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blue,
        fillColor: Colors.blue
    );



    ever(_controller.viewState, (_) {
      if (_pageController.page != _controller.viewState.value.page){
        _pageController.animateToPage(_controller.viewState.value.page, duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
      }
    });

    ever(_controller.destinationResult , (_){
      if (_controller.destinationResult.value != null){
        LatLngBounds latLngBounds;

        if (_controller.destinationResult.value!.pickUpLatitude > _controller.destinationResult.value!.dropOffLatitude &&
            _controller.destinationResult.value!.pickUpLongitude > _controller.destinationResult.value!.dropOffLongitude){
          latLngBounds = LatLngBounds(southwest: LatLng(_controller.destinationResult.value!.dropOffLatitude, _controller.destinationResult.value!.dropOffLongitude), northeast: LatLng(_controller.destinationResult.value!.pickUpLatitude, _controller.destinationResult.value!.pickUpLongitude));
        } else if (_controller.destinationResult.value!.pickUpLongitude > _controller.destinationResult.value!.dropOffLongitude){
          latLngBounds = LatLngBounds(southwest: LatLng(_controller.destinationResult.value!.pickUpLatitude , _controller.destinationResult.value!.dropOffLongitude), northeast: LatLng(_controller.destinationResult.value!.dropOffLatitude , _controller.destinationResult.value!.pickUpLongitude));
        } else if (_controller.destinationResult.value!.pickUpLatitude > _controller.destinationResult.value!.dropOffLatitude){
          latLngBounds = LatLngBounds(southwest: LatLng(_controller.destinationResult.value!.dropOffLatitude, _controller.destinationResult.value!.pickUpLongitude), northeast: LatLng(_controller.destinationResult.value!.pickUpLatitude , _controller.destinationResult.value!.dropOffLongitude));
        } else {
          latLngBounds = LatLngBounds(southwest: LatLng(_controller.destinationResult.value!.pickUpLatitude, _controller.destinationResult.value!.pickUpLongitude), northeast: LatLng(_controller.destinationResult.value!.dropOffLatitude, _controller.destinationResult.value!.dropOffLongitude));
        }

        _googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx((){

          if (_controller.destinationResult.value != null){
            pickUpMarker = pickUpMarker.copyWith(
                positionParam: LatLng(_controller.destinationResult.value!.pickUpLatitude, _controller.destinationResult.value!.pickUpLongitude),
                infoWindowParam: InfoWindow(title: _controller.destinationResult.value!.pickUpAddress.name , snippet: "My location"));
            dropOffMarker = dropOffMarker.copyWith(
                positionParam: LatLng(_controller.destinationResult.value!.dropOffLatitude, _controller.destinationResult.value!.dropOffLongitude),
                infoWindowParam: InfoWindow(title: _controller.destinationResult.value!.dropOffAddress.name , snippet: "Drop off location"));
            polyline = polyline.copyWith(pointsParam: _controller.destinationResult.value!.polyLinePoints as List<LatLng>);
            pickUpCircle = pickUpCircle.copyWith(centerParam: LatLng(_controller.destinationResult.value!.pickUpLatitude, _controller.destinationResult.value!.pickUpLongitude));
            dropOffCircle = dropOffCircle.copyWith(centerParam: LatLng(_controller.destinationResult.value!.dropOffLatitude, _controller.destinationResult.value!.dropOffLongitude));

            markers.addAll([pickUpMarker , dropOffMarker]);
          }

          if (_controller.driverData.value.location != null){
            driverMarker = driverMarker.copyWith(
                positionParam: LatLng(_controller.driverData.value.location!.latitude!, _controller.driverData.value.location!.longitude!),
                infoWindowParam: InfoWindow(title: "The driver" , snippet: _controller.driverData.value.driverPersonalData!.name));
            markers.add(driverMarker);
          }

          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            polylines: _controller.destinationResult.value != null ? {polyline} : {},
            markers: markers,
            circles: _controller.destinationResult.value != null ? {pickUpCircle , dropOffCircle} : {},
            onMapCreated: (GoogleMapController mapController){
              _mainMapCompleter.complete(mapController);
              _googleMapController = mapController;
            },
          );
        }),

        Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 300.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, -3.0),
                      blurRadius: 5.0
                  )
                ]
              ),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PickDestination(
                    pickDestination: () async {
                      var result = await Get.toNamed(SET_DESTINATION_SCREEN);
                      if (result != null){
                        _controller.setDestination(result as DestinationResult);
                        await _controller.getCarTypes();
                      }
                      print(result.runtimeType);
                      // await _controller.getCarTypes();

                    },
                  ),
                  GetX<MapController>(builder: (_){
                    return ShowCarTypes(
                      loading: _controller.viewState.value.loading,
                      error: _controller.viewState.value.error,
                      carTypes: _controller.viewState.value.carTypes,
                      selectedCarType: _controller.dataCarrier.value.selectedCarType,
                      nextButtonAction: (){
                        if (_controller.dataCarrier.value.selectedCarType != null){
                          _controller.getToPaymentMethod();
                        }
                      },
                      selectCarType: (carType){
                        _controller.selectCarType(carType);
                      },
                    );
                  }),
                  GetX<MapController>(builder: (_){
                    return PaymentMethod(
                        selectedPayment: _controller.dataCarrier.value.paymentMethod,
                        nextButtonAction: (){
                          if (_controller.dataCarrier.value.paymentMethod == PaymentMethods.creditCard){
                            showModalBottomSheet(context: context, builder: (context){
                              return PayOnline(
                                payAction: (){
                                  Navigator.pop(context);
                                  _controller.goToDriverAssigning();
                                },
                              );
                            });
                          } else if (_controller.dataCarrier.value.paymentMethod == PaymentMethods.cash){
                            _controller.goToDriverAssigning();
                          }
                        },
                        selectPaymentMethod: (paymentMethod){
                          _controller.selectPayment(paymentMethod);
                        }
                    );
                  },),
                  GetX<MapController>(
                    builder: (_){
                      return AssignCar(driverData: _controller.driverData.value,durationTillDriverCome: "1 mill",);
                    },
                  )
                  // AssignCar(driverData: DriverData(
                  //   location: Location(latitude: 0.0, longitude: 0.0),
                  //   driverPersonalData: User(
                  //     id: "",
                  //     name: "koko",
                  //     email: "koko",
                  //     phone: "koko",
                  //     img: "koko"
                  //   ),
                  // ),
                  // durationTillDriverCome: "1 mil",
                  // )
                ],
              ),
            )
        )
      ],
    );
  }
}
