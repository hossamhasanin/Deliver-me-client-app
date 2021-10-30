import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {

  const AppDrawer();

  final List _drawerMenu = const [
    {
      "icon": Icons.restore,
      "text": "My rides",
      "route": "",
    },
    {
      "icon": Icons.local_activity,
      "text": "Promotions",
      "route": ""
    },
    {
      "icon": Icons.star_border,
      "text": "My favourites",
      "route": ""
    },
    {
      "icon": Icons.credit_card,
      "text": "My payments",
      "route": "",
    },
    {
      "icon": Icons.notifications,
      "text": "Notification",
    },
    {
      "icon": Icons.chat,
      "text": "Support",
      "route": "",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width * 0.2),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              height: 170.0,
              color: _theme.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        "https://pbs.twimg.com/profile_images/1214214436283568128/KyumFmOO.jpg"),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Garuba OLayemii",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Text(
                    "444-509-980-103",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: ListView(
                  children: _drawerMenu.map((menu) {
                    return GestureDetector(
                      onTap: () {

                      },
                      child: ListTile(
                        leading: Icon(menu["icon"]),
                        title: Text(
                          menu["text"],
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}