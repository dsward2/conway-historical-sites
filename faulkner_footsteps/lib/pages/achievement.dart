import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:faulkner_footsteps/app_state.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementsPage extends StatefulWidget {
  AchievementsPage({super.key, required this.displaySites});
  List displaySites;
  @override
  AchievementsPageState createState() {
    return AchievementsPageState();
  }
}

class AchievementsPageState extends State<AchievementsPage> {
  // To track visited places - only called from map view
  void visitPlace(BuildContext context, String place) async {
    // If the place is visited for the first time, a popup will appear and update the state
    final appState = Provider.of<ApplicationState>(context, listen: false);

    if (!appState.hasVisited(place)) {
      await appState.saveAchievement(place);

      if (!mounted) return;

      // Show achievement popup dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          title: const Text(
            "Achievement Unlocked!",
            style: TextStyle(
              color: Color.fromARGB(255, 72, 52, 52),
            ),
          ),
          content: Text(
            "You have visited $place.",
            style: const TextStyle(
              color: Color.fromARGB(255, 72, 52, 52),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Color.fromARGB(255, 72, 52, 52),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // New method to show information popup when achievement is tapped
  void showAchievementInfo(
      BuildContext context, String placeName, bool isVisited) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 8,
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 238, 214, 196),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: const Color.fromARGB(255, 107, 79, 79),
              width: 3.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  placeName,
                  style: GoogleFonts.ultra(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 72, 52, 52),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Achievement Status
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: isVisited
                      ? Colors.green[100]
                      : const Color.fromARGB(255, 255, 243, 228),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isVisited
                        ? Colors.green
                        : const Color.fromARGB(255, 107, 79, 79),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVisited ? Icons.emoji_events : Icons.place,
                      size: 24,
                      color: isVisited
                          ? Colors.green
                          : const Color.fromARGB(255, 143, 6, 6),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isVisited ? "Completed!" : "Not Visited",
                      style: GoogleFonts.rakkas(
                        textStyle: TextStyle(
                          color: isVisited
                              ? Colors.green[800]
                              : const Color.fromARGB(255, 72, 52, 52),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Information content
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Text(
                  isVisited
                      ? "You've already discovered this historical site. Great job!"
                      : "To unlock this achievement, you need to visit this historical site in person. Use the map to find and navigate to this location.",
                  style: GoogleFonts.rakkas(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 107, 79, 79),
                      fontSize: 16,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Close button
              Padding(
                padding: const EdgeInsets.only(bottom: 24, top: 8),
                child: Container(
                  width: 120,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color.fromARGB(255, 107, 79, 79),
                      width: 2.0,
                    ),
                    color: const Color.fromARGB(255, 255, 243, 228),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Text(
                          "Close",
                          style: GoogleFonts.rakkas(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 79, 79),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 160, // Increased height further
              ),
              itemCount: widget.displaySites.length,
              itemBuilder: (context, index) {
                final place = widget.displaySites[index];
                final isVisited = appState.hasVisited(place.name);

                // Calculate font size based on text length
                final fontSize = place.name.length > 20 ? 14.0 : 16.0;

                return GestureDetector(
                  onTap: () =>
                      showAchievementInfo(context, place.name, isVisited),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isVisited
                          ? Colors.green[100]
                          : const Color.fromARGB(255, 255, 243, 228),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isVisited
                            ? Colors.green
                            : const Color.fromARGB(255, 107, 79, 79),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Top section with icon
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Icon(
                            isVisited ? Icons.emoji_events : Icons.place,
                            size: 40,
                            color: isVisited
                                ? Colors.green
                                : const Color.fromARGB(255, 143, 6, 6),
                          ),
                        ),

                        // Middle section with name
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Center(
                              child: Text(
                                place.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize, // Adaptive font size
                                  color: Color.fromARGB(255, 72, 52, 52),
                                ),
                                maxLines: 3, // Increased max lines
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),

                        // Bottom section with "Done!" label
                        Container(
                          height: 24,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: isVisited
                              ? const Text(
                                  "Done!",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const SizedBox(), // Empty placeholder
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
