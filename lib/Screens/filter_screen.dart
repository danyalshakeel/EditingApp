import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Initial image path and list of filter paths
  String _selectedImage = "image/bg.jpg"; // Replace with your default image
  final List<String> _filterImages = [
    "image/bg.jpg", // Add paths to your filter images here
    "image/bg.jpg",
    "image/bg.jpg",
    "image/bg.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              // Handle the filter application logic here
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the selected image in the center
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 500,
            //  alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Circular cropping
              child: Image.asset(
                _selectedImage,
                fit: BoxFit.cover,
                width: 300,
                height: 400,
              ),
            ),
          ),
          Spacer(),
          // Filters ListView
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //   color: Colors.grey, // Light background color
            height: 120, // Height of the filter preview container
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filterImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImage = _filterImages[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(_filterImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
