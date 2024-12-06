import 'package:flutter/material.dart';

AppBar appBar() {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: const Text(
      "EgyWanders",
      style: TextStyle(
          color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    leading: const Icon(Icons.menu, color: Colors.black),
    actions: [
      Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          const Positioned(
            right: 10,
            top: 10,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.red,
              child: Text(
                '2',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          )
        ],
      )
    ],
  );
}

//temporary, will be changed
BottomNavigationBar bottomNavigationBar() {
  return BottomNavigationBar(
    backgroundColor: Colors.orange,
    selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
    unselectedItemColor: const Color.fromARGB(255, 231, 231, 231),
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_box),
        label: 'Account',
      ),
    ],
    type: BottomNavigationBarType.fixed,
  );
}
