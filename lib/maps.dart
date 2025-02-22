import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  // Launch Google Maps with a search query
  static Future<void> launchMapWithSearch(String searchQuery) async {
    // Encode the search query for URL
    final encodedQuery = Uri.encodeComponent(searchQuery);

    // Create the Google Maps search URL
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedQuery');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      debugPrint('Error launching map: $e');
      // You might want to show a snackbar or dialog here to inform the user
      rethrow;
    }
  }

  // Launch Google Maps with specific coordinates
  static Future<void> launchMapWithCoordinates(
      double latitude, double longitude) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      debugPrint('Error launching map: $e');
      rethrow;
    }
  }

  // Launch Google Maps with navigation to a specific address
  static Future<void> launchMapWithNavigation(String destination) async {
    final encodedDestination = Uri.encodeComponent(destination);
    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$encodedDestination');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      debugPrint('Error launching map: $e');
      rethrow;
    }
  }
}
