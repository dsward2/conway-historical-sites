// import 'package:faulkner_footsteps/app_state.dart';
// import 'package:faulkner_footsteps/objects/hist_site.dart';
// import 'package:faulkner_footsteps/objects/site_filter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating/flutter_rating.dart';
// import 'package:google_fonts/google_fonts.dart';

// // enum siteFilter { Monument, Park, Hall, Other }

// class FilterDialog extends StatefulWidget {
//   const FilterDialog(
//       {super.key, required this.activeFilters, required this.onFiltersChanged});

//   final List<SiteFilter> activeFilters;

//   final Function onFiltersChanged;

//   @override
//   _FilterDialogState createState() => _FilterDialogState();
// }

// class _FilterDialogState extends State<FilterDialog> {
//   List<SiteFilter> filters = [];

//   void initState() {
//     super.initState();

//     filters.addAll(widget.activeFilters);
//   }

//   @override
//   Widget build(BuildContext build) {
//     return AlertDialog(
//       alignment: Alignment.topCenter,
//       backgroundColor: const Color.fromARGB(255, 168, 124, 124),
//       title: Text(
//         'Select your filters',
//         style: GoogleFonts.rakkas(
//             textStyle: const TextStyle(
//                 color: Color.fromARGB(255, 62, 50, 50), fontSize: 20.0)),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//               child: Wrap(
//             children: siteFilter.values.map((siteFilter site) {
//               return FilterChip(
//                 label: Text(site.name),
//                 selected: filters.contains(site),
//                 onSelected: (bool selected) {
//                   setState(() {
//                     if (selected) {
//                       filters.add(site);
//                     } else {
//                       filters.remove(site);
//                     }
//                   });
//                 },
//               );
//             }).toList(),
//           ))
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text(
//             "Cancel",
//             style: GoogleFonts.rakkas(
//                 textStyle: const TextStyle(
//                     color: Color.fromARGB(255, 62, 50, 50), fontSize: 20.0)),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             widget.onFiltersChanged(filters);
//             Navigator.of(context).pop();
//           },
//           child: Text(
//             "Submit",
//             style: GoogleFonts.rakkas(
//                 textStyle: const TextStyle(
//                     color: Color.fromARGB(255, 62, 50, 50), fontSize: 20.0)),
//           ),
//         ),
//       ],
//     );
//   }
// }
