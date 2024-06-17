import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_excercise_correction/services/histories_check_service.dart';
import 'package:gym_excercise_correction/widgets/video.dart';

class HistoryCheckDetail extends StatefulWidget {
  const HistoryCheckDetail({
    super.key,
    required this.title,
    required this.handledVideoUrl,
    required this.date,
    required this.id,
  });

  final String id;
  final String title;
  final String handledVideoUrl;
  final Timestamp date;

  @override
  State<HistoryCheckDetail> createState() => _HistoryCheckDetailState();
}

class _HistoryCheckDetailState extends State<HistoryCheckDetail> {
  late List<bool> _isOpen;
  bool _imageLoadingError = false;
  late List errorDetailsList;
  final HistoriesCheckService historiesCheckService = HistoriesCheckService();

  @override
  void initState() {
    super.initState();
    loadErrorDetails();
  }

  void loadErrorDetails() async {
    errorDetailsList = [];
    var details = await historiesCheckService.getErrorDetailsByID(widget.id);
    if (details != null) {
      setState(() {
        errorDetailsList = details.entries.toList();
        _isOpen = List.generate(errorDetailsList.length, (index) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title.toUpperCase())),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                    height: 200,
                    child: VideoPlayerScreen(url: widget.handledVideoUrl)),
              ),
              const ListTile(
                leading: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                ),
                title: Text(
                  'Error Details',
                  style: TextStyle(
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
                children: errorDetailsList.map<ExpansionPanel>((error) {
                  final index = errorDetailsList.indexOf(error);
                  return ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text(
                                error.key,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                              error.value.length.toString(),
                              style: TextStyle(
                                color: isExpanded ? Colors.red : Colors.grey,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_imageLoadingError)
                            const CircularProgressIndicator() // Hiển thị khi có lỗi tải ảnh
                          else
                            ...error.value.map<Widget>((errorDetail) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time: ${errorDetail['frame_in_seconds']} seconds',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image.network(
                                    errorDetail['url'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const CircularProgressIndicator(); // Hiển thị khi đang tải ảnh
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      setState(() {
                                        _imageLoadingError =
                                            true; // Cập nhật trạng thái lỗi
                                      });
                                      return Container(); // Hiển thị khi có lỗi tải ảnh
                                    },
                                  ),
                                ],
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
