import 'package:flutter/material.dart';
import 'package:house_prediction/src/screen/detail/detail_screen.dart';
import 'package:house_prediction/src/screen/home/home_service.dart';
import 'package:house_prediction/src/widgets/multi_field_code_dialog.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService homeService = HomeService();
  final ScrollController scrollController = ScrollController();

  List<String> locations = []; // To store the fetched data
  List<String> filteredData = []; // For filtered results
  bool isLoaded = false; // To track if locations are already fetched

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final result = await homeService.getLocations();
      setState(() {
        locations = result;
        filteredData = result;
        isLoaded = true;
      });
    } catch (e) {
      setState(() {
        isLoaded = true;
      });

      _showDialog();
      print('Error fetching locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text("HomeValueAI"),
    );
  }

  _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.maxFinite,
      child: Column(
        children: [
          SearchAnchor(
            builder: (context, controller) {
              return SearchBar(
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                },
                onChanged: (text) {
                  setState(() {
                    filteredData = locations
                        .where((item) =>
                            item.toLowerCase().contains(text.toLowerCase()))
                        .toList();
                  });
                },
                hintText: "Search location",
                trailing: const [
                  Icon(Icons.search),
                  SizedBox(
                    width: 10,
                  )
                ],
              );
            },
            suggestionsBuilder: (context, controller) {
              if (filteredData.isEmpty) {
                return [
                  ListTile(
                    title: Text('No results found'),
                  ),
                ];
              }
              return filteredData
                  .map((item) => Card(
                        child: ListTile(
                          title: Text(item),
                          onTap: () {
                            print('Selected: $item');
                            controller.closeView(
                                "CLose"); // Close suggestions dropdown
                          },
                        ),
                      ))
                  .toList();
            },
          ),
          SizedBox(height: 10),
          _buildLocationList(),
        ],
      ),
    );
  }

  _buildLocationList() {
    if (!isLoaded) {
      return Center(child: CircularProgressIndicator());
    }

    if (locations.isEmpty) {
      return Center(child: Text("No locations found."));
    }

    return filteredData.length == 0
        ? Center(child: Text("No locations found."))
        : Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: filteredData.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  print('Tapped on: ${filteredData[index]}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PropertyForm(filteredData[index])));
                },
                child: Card(
                  child: ListTile(
                    title: Text(filteredData[index]),
                  ),
                ),
              ),
            ),
          );
  }

  void _showDialog() async {
    final code = await showDialog(
      context: context,
      builder: (context) => MultiFieldCodeDialog(),
    );
    if (code != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Code Entered: $code")),
      );
      homeService.updateNgrokBase(code: code);
      await _fetchLocations();
    }
  }
}
