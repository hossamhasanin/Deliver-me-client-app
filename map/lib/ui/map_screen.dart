import 'package:flutter/material.dart';
import 'package:map/ui/components/app_drawer.dart';

import 'components/body.dart';

class MapScreen extends StatelessWidget {


  const MapScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: AppDrawer(),
      body: Body(),
    );
  }
}
