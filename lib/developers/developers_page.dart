import 'package:flutter/material.dart';
import 'package:thirst_tea/profile/profile_page.dart';
import 'package:thirst_tea/home/home_page.dart';

class DeveloperPage extends StatelessWidget {
  final String email;


  const DeveloperPage({Key? key,required this.email}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDEBDF), Color(0xFFF5E6D8)], // Soft gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
            'Developers',
            style: TextStyle(fontSize: screenWidth * 0.06),
          ),
        leading: Builder(
          builder: (context) => IconButton(  // Wrap the IconButton with Builder
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Now this context has Scaffold
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Column(
                  children: [
                    // Expanded(
                    //   child: Image.asset(
                    //     'https://via.placeholder.com/25', // Your logo
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: Colors.brown),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(email: email)), // Navigate to SignInPage
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.home, color: Colors.brown),
                title: Text(
                  'Home',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage1(email: email)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.help, color: Colors.brown),
                title: Text(
                  'About Us',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.code, color: Colors.brown),
                title: Text(
                  'Developers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DeveloperPage(email: email,)), // Navigate to SignInPage
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFDEBDF), Color(0xFFF5E6D8)], // Soft gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.all(20.0),
            children: [
              _buildDeveloperCard(
                'Gwen Aldrey Santos',
                'assets/gwen_image.jpeg',
                '09307259609',
                'sdsd',
              ),
              SizedBox(height: 20),
              _buildDeveloperCard(
                'Lovely Candelario',
                'assets/lovely_image.jpeg',
                '09629050755',
                ' ',
              ),
              SizedBox(height: 20),
              _buildDeveloperCard(
                'Franz Andrei Carlos',
                'assets/franz_image.jpeg',
                '09451690537',
                '',
              ),
              SizedBox(height: 20),
              _buildDeveloperCard(
                'Regel Peller',
                'assets/regel_image.jpge',
                '09451690537',
                '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard(
      String name,
      String imagePath,
      String phoneNumber,
      String email,
      ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Contact: $phoneNumber',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Email: $email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
