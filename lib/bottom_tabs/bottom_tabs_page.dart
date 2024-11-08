import 'package:flutter/material.dart';

import 'package:thirst_tea/sign_in/sign_in_page.dart';
import 'package:thirst_tea/home/home_page.dart';


class HomePage extends StatefulWidget {



  HomePage({Key? key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages for each tab
  final List<Widget> _pages;

  _HomePageState() : _pages = [
    HomePage1(),

    Center(child: Text('Page 2')),
  ];

  @override
  void initState() {
    super.initState();

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'ThirsTea',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      endDrawer: _selectedIndex == 1
          ? Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // You can add a background color if needed
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/target_logo1.jpg', // Path to your logo image
                        fit: BoxFit.contain, // This will ensure the logo fits within the space

                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.blueAccent),
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  // );
                },
              ),

              ListTile(
                leading: Icon(Icons.info, color: Colors.blueAccent),
                title: Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AboutUsPage()),
                  // );
                },
              ),
              ListTile(
                leading: Icon(Icons.feedback, color: Colors.blueAccent),
                title: Text(
                  'Feedback',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => FeedbackPage()),
                  // );
                },
              ),
              // Divider to separate logout from other options
              Divider(
                height: 40, // Space above the divider
                thickness: 1, // Thickness of the divider
                color: Colors.grey, // Color of the divider
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
              ),
            ],
          ),
        ),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
