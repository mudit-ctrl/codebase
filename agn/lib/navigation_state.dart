import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final List<String> history; // Stack of visited URLs
  final int currentIndex; // Current index in the history

  NavigationState({
    required this.history,
    required this.currentIndex,
  });

  // Method to navigate to a new page
  NavigationState navigateTo(String url) {
    List<String> newHistory = history;

    if (currentIndex < history.length - 1) {
      // Clear forward history if we're navigating to a new page
      newHistory = history.sublist(0, currentIndex + 1);
    }
    newHistory.add(url);
    return NavigationState(
        history: newHistory, currentIndex: newHistory.length - 1);
  }

  // Method to go back in history
  String? goBack() {
    if (currentIndex > 0) {
      return history[currentIndex - 1];
    }
    return null; // No previous page
  }

  // Method to go forward in history
  String? goForward() {
    if (currentIndex < history.length - 1) {
      return history[currentIndex + 1];
    }
    return null; // No next page
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState(history: [], currentIndex: -1));

  void navigateTo(String url) {
    state = state.navigateTo(url);
  }

  void goBack() {
    if (state.currentIndex > 0) {
      String? previousUrl = state.goBack();
      if (previousUrl != null) {
        // Update the state to reflect the back navigation
        state = NavigationState(
          history: state.history,
          currentIndex: state.currentIndex - 1,
        );
      }
    }
  }

  void goForward() {
    if (state.currentIndex < state.history.length - 1) {
      String? nextUrl = state.goForward();
      if (nextUrl != null) {
        // Update the state to reflect the forward navigation
        state = NavigationState(
          history: state.history,
          currentIndex: state.currentIndex + 1,
        );
      }
    }
  }
}

// Create a provider for the navigation notifier
final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});
