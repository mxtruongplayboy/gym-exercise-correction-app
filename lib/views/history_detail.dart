import 'package:flutter/material.dart';

class HistoryDetail extends StatefulWidget {
  const HistoryDetail({super.key});

  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final List<Map<String, String>> errorList = [
    {'title': 'Error 1', 'details': 'Details about Error 1...'},
    {'title': 'Error 2', 'details': 'Details about Error 2...'},
    {'title': 'Error 3', 'details': 'Details about Error 3...'},
    // Add more errors as needed
  ];

  List<bool> _isOpen =
      List.generate(3, (index) => false); // Track the open state of each panel

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 140.0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            elevation: 0,
            flexibleSpace: Container(
              width: MediaQuery.of(context).size.width,
              height: 140.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: AssetImage('./assets/images/plank.webp'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PLANK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(
                    Icons.date_range_outlined,
                    color: Colors.green,
                  ),
                  title: Text(
                    'April 16, 2024 at 4:07:36 PM',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.timer_sharp,
                    color: Colors.blue,
                  ),
                  title: Text(
                    '2 minutes',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  title: Text(
                    '2 errors',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ExpansionPanelList(
                  animationDuration: const Duration(
                    milliseconds: 500,
                  ),
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      _isOpen[panelIndex] = isExpanded;
                    });
                  },
                  children: errorList.map<ExpansionPanel>((error) {
                    final index = errorList.indexOf(error);
                    return ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Text(
                                error['title']!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.error_outline,
                                size: 14.0,
                                color: isExpanded ? Colors.red : Colors.grey,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '2 errors',
                                style: TextStyle(
                                  color: isExpanded ? Colors.red : Colors.grey,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      body: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                './assets/images/plank.webp',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ],
                          )),
                      isExpanded: _isOpen[index],
                    );
                  }).toList(),
                ),
              ],
            ),
          )),
    );
  }
}
