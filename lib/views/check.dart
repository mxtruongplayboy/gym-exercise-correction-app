import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_excercise_correction/views/upload.dart';
import 'package:gym_excercise_correction/widgets/history_check.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> with TickerProviderStateMixin {
  late TabController _tabController;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          overlayColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
          tabs: const [
            Tab(text: 'Check'),
            Tab(text: 'Histories'),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1 content
                UploadVideoPage(title: widget.title,),
                // Tab 2 content
                HistoryCheck(
                  title: widget.title,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
