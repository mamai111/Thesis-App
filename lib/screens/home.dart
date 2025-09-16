import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/app_drawer.dart';
import '../components/CustomBottomNavBar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> articles = [
    {
      "title": "Understanding Urine Color: What It Means",
      "content":
          "Urine color can indicate your hydration and health. Light yellow usually means well-hydrated, dark yellow can suggest dehydration, while red or cloudy urine may signal possible infection or other health issues.",
      "image": "assets/images/urine_color.jpg"
    },
    {
      "title": "UTI Symptoms You Shouldn't Ignore",
      "content":
          "Common UTI symptoms include frequent urination, burning sensation when peeing, cloudy urine, and lower abdominal pain. If symptoms persist, consult a doctor immediately.",
      "image": "assets/images/uti.png"
    },
    {
      "title": "Tips to Stay Hydrated Every Day",
      "content":
          "Drink at least 8 glasses of water daily. Include fruits and vegetables in your diet, and avoid excessive caffeine or alcohol which may cause dehydration.",
      "image": "assets/images/hydration.png"
    },
    {
      "title": "Early Detection of Dehydration in Children",
      "content":
          "Watch out for signs like dry mouth, no tears when crying, sunken eyes, and decreased urination. Early hydration is key to preventing serious complications.",
      "image": "assets/images/dehydration.png"
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/instructions');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/capture');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              "Health Articles",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 12),
            ...articles.map((article) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: ExpansionTile(
                  leading: const Icon(Icons.article, color: Colors.teal),
                  title: Text(article["title"]!, style: GoogleFonts.poppins()),
                  children: [
                    if (article["image"] != null) // 👈 SHOW IMAGE IF AVAILABLE
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            article["image"]!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        article["content"]!,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
