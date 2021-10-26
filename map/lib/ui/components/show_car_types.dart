import 'package:flutter/material.dart';
import 'package:base/models/car_type.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:map/business_logic/map_controller.dart';
import 'package:map/business_logic/pages_state.dart';

class ShowCarTypes extends StatelessWidget {

  final bool loading;
  final String error;
  final List<CarType> carTypes;
  final CarType? selectedCarType;
  final Function() nextButtonAction;
  final Function(CarType) selectCarType;

  const ShowCarTypes({
    Key? key ,
    required this.selectCarType ,
    required this.loading ,
    required this.error ,
    required this.carTypes ,
    required this.selectedCarType ,
    required this.nextButtonAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading ? const Center(child: CircularProgressIndicator(),) :
    error.isNotEmpty ? Center(child: Text(error),):
    Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                  "Select type of car",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: carTypes.length,
                itemBuilder: (context , index){
                  return GestureDetector(
                    onTap: (){
                      selectCarType(carTypes[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(left: 10.0 , right: 10.0 , top: 5.0),
                      decoration: BoxDecoration(
                          border: carTypes[index] == selectedCarType ?  Border.all(color: Colors.orange):
                              Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Row(
                        children: [
                          Image(image: NetworkImage(carTypes[index].icon , scale: 10.0),),
                          const SizedBox(width: 20.0,),
                          Text(carTypes[index].name)
                        ],
                      ),
                    ),
                  );
                }),
          ),

          ElevatedButton(
              onPressed: (){
                nextButtonAction();
              },
              child: const Text("Next")
          )
        ]
    );

  }
}
