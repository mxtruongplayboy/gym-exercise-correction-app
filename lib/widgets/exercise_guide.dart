import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/services/introduction_service.dart';
import 'package:gym_excercise_correction/widgets/video.dart';

class ExerciseGuide extends StatefulWidget {
  const ExerciseGuide({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<ExerciseGuide> createState() => _ExerciseGuideState();
}

class _ExerciseGuideState extends State<ExerciseGuide>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final IntroductionService introductionService = IntroductionService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: introductionService.getIntroductionByName(widget.title),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return buildContent(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          return const Center(child: Text("No data available"));
        });
  }

  Widget buildContent(QuerySnapshot data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            overlayColor:
                MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
            tabs: const [
              Tab(text: 'Animation'),
              Tab(text: 'Video'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200.0,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1 content
                  const Center(
                    child: Text('Tab 1 Content'),
                  ),
                  // Tab 2 content
                  VideoPlayerScreen(
                    url: data.docs.first.get('VideoUrl'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.docs.first.get('Instruction'),
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
