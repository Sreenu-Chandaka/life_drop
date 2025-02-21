import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  // Launch Google Maps with a search query
  static Future<void> launchMapWithSearch(String searchQuery) async {
    // Encode the search query for URL
    final encodedQuery = Uri.encodeComponent(searchQuery);
    
    // Create the Google Maps search URL
    final url = 'https://www.google.com/maps/search/?api=1&query=$encodedQuery';
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  // Launch Google Maps with specific coordinates
  static Future<void> launchMapWithCoordinates(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  // Launch Google Maps with navigation to a specific address
  static Future<void> launchMapWithNavigation(String destination) async {
    final encodedDestination = Uri.encodeComponent(destination);
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$encodedDestination';
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}

// Example usage in a Flutter widget
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Navigation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                MapLauncher.launchMapWithSearch('restaurants near me');
              },
              child: Text('Search Nearby Restaurants'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                MapLauncher.launchMapWithCoordinates(37.7749, -122.4194);
              },
              child: Text('Show San Francisco'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                MapLauncher.launchMapWithNavigation('1600 Amphitheatre Parkway, Mountain View, CA');
              },
              child: Text('Navigate to Google HQ'),
            ),
          ],
        ),
      ),
    );
  }
}
