import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryDetail extends StatefulWidget {
  const HistoryDetail(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.date,
      required this.duration,
      required this.errorTotalCount,
      required this.specificErrorFrames});

  final String title;
  final String imageUrl;
  final Timestamp date;
  final int duration;
  final int errorTotalCount;
  final List specificErrorFrames;

  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final List<bool> _isOpen = List.generate(100, (index) => false);
  bool _imageLoadingError = false;

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
              image: DecorationImage(
                image: AssetImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
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
              ListTile(
                leading: const Icon(
                  Icons.date_range_outlined,
                  color: Colors.green,
                ),
                title: Text(
                  widget.date.toDate().toString().substring(0, 19),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.timer_sharp,
                  color: Colors.blue,
                ),
                title: Text(
                  widget.duration.toString(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                title: Text(
                  '${widget.errorTotalCount} errors',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ExpansionPanelList(
                animationDuration: const Duration(milliseconds: 500),
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    _isOpen[panelIndex] = isExpanded;
                  });
                },
                children:
                    widget.specificErrorFrames.map<ExpansionPanel>((error) {
                  final index = widget.specificErrorFrames.indexOf(error);
                  return ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                error['ErrorType']!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.error_outline,
                              size: 14.0,
                              color: isExpanded ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              error['Count'].toString(),
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
                          if (_imageLoadingError)
                            const CircularProgressIndicator() // Placeholder when image loading fails
                          else
                            ...error['ImageUrl'].map<Widget>((url) {
                              return Image.network(
                                url,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const CircularProgressIndicator(); // Placeholder when image is loading
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  setState(() {
                                    _imageLoadingError =
                                        true; // Set error state
                                  });
                                  return Container(); // Placeholder when image loading fails
                                },
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                    isExpanded: _isOpen[index],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
