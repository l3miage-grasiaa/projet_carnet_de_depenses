import 'package:flutter/material.dart';
import 'package:projet_carnet_de_depenses/pages/profile.dart';

import '../models/user.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("TP2"),
        actions: [
          IconButton(
            onPressed: () async {
              var result = await Navigator
                  .of(context)
                  .push(MaterialPageRoute(builder:
                  (context) => ProfilePage(user:
                    User("Shinnosuke", "Nohara", "assets/shinchan_profil_image.jpeg")
                  ),
              ));
              print(result);
            },
            icon: Icon(
              Icons.account_circle,
              size: 40,
            )
          )
        ],
      )
    );
  }
}
