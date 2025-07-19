import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Layout/app_header.dart';

class HistoryRecordsPage extends StatefulWidget {
  const HistoryRecordsPage({super.key});

  @override
  State<HistoryRecordsPage> createState() => _HistoryRecordsPageState();
}

class _HistoryRecordsPageState extends State<HistoryRecordsPage> {
  String selectedFilter = 'All';
  bool selectionMode = false;
  bool showTrashIcon = false;
  bool isAllSelected = false;

  List<String> filterOptions = ['All', '1 Day Ago', '1 Month Ago', '3 Months Ago'];

  Map<String, List<Map<String, dynamic>>> recordsByDate = {
    '2025-07-11': [
      {
        'image': 'C:/Users/ASUS/Desktop/fyp_app/assets/Image/sample.jfif',
        'name': 'Plastic Bottle',
        'source': 'Recognition',
        'category': 'Recyclable',
        'selected': false,
      },
      {
        'image': 'C:/Users/ASUS/Desktop/fyp_app/assets/Image/sample.jfif',
        'name': 'Apple Core',
        'source': 'Search',
        'category': 'Organic',
        'selected': false,
      },
    ],
    '2025-07-10': [
      {
        'image': 'C:/Users/ASUS/Desktop/fyp_app/assets/Image/sample.jfif',
        'name': 'Glass Cup',
        'source': 'Recognition',
        'category': 'Recyclable',
        'selected': false,
      },
    ],
  };

  bool isInFilterRange(String dateStr) {
    final now = DateTime.now();
    final recordDate = DateTime.parse(dateStr);
    switch (selectedFilter) {
      case '1 Day Ago':
        return now.difference(recordDate).inDays <= 1;
      case '1 Month Ago':
        return now.difference(recordDate).inDays <= 30;
      case '3 Months Ago':
        return now.difference(recordDate).inDays <= 90;
      default:
        return true;
    }
  }

  void toggleSelectAllAcrossAll() {
    final filteredDates = recordsByDate.keys.where((d) => isInFilterRange(d)).toList();
    setState(() {
      isAllSelected = !isAllSelected;
      for (var date in filteredDates) {
        for (var record in recordsByDate[date]!) {
          record['selected'] = isAllSelected;
        }
      }
    });
  }

  void deleteSelected() {
    int totalToDelete = 0;
    recordsByDate.forEach((date, list) {
      totalToDelete += list.where((e) => e['selected']).length;
    });

    if (totalToDelete == 0) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text("Do you want to delete $totalToDelete records?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(
            onPressed: () {
              setState(() {
                recordsByDate.removeWhere((key, list) {
                  list.removeWhere((e) => e['selected']);
                  return list.isEmpty;
                });
                selectionMode = false;
                showTrashIcon = false;
              });
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  bool get hasSelected => recordsByDate.values.expand((e) => e).any((e) => e['selected']);

  @override
  Widget build(BuildContext context) {
    final filteredDates = recordsByDate.keys.where((d) => isInFilterRange(d)).toList();
    final hasRecords = filteredDates.isNotEmpty &&
        recordsByDate.entries.any((entry) => isInFilterRange(entry.key) && entry.value.isNotEmpty);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Color(0xFF425855)),
                label: const Text("Back", style: TextStyle(color: Color(0xFF425855))),
              ),
              Center(
                child: Text("History Records",
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Filter by Date:", style: TextStyle(fontSize: 14.sp)),
                      SizedBox(width: 8.w),
                      DropdownButton<String>(
                        value: selectedFilter,
                        underline: const SizedBox(),
                        items: filterOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      selectionMode ? Icons.delete : Icons.more_vert,
                      color: selectionMode ? (hasSelected ? Colors.red : Colors.grey) : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        if (!selectionMode) {
                          selectionMode = true;
                          showTrashIcon = true;
                        } else {
                          if (hasSelected) {
                            deleteSelected();
                          }
                        }
                      });
                    },
                  )
                ],
              ),
              if (selectionMode && hasRecords)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectionMode = false;
                          showTrashIcon = false;
                          isAllSelected = false;
                          for (var date in filteredDates) {
                            for (var record in recordsByDate[date]!) {
                              record['selected'] = false;
                            }
                          }
                        });
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: toggleSelectAllAcrossAll,
                      child: Text(isAllSelected ? "Unselect All" : "Select All"),
                    ),
                  ],
                ),
              SizedBox(height: 12.h),
              Expanded(
                child: hasRecords
                    ? ListView(
                  children: filteredDates.map((date) {
                    final records = recordsByDate[date]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(date,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.h),
                        ...records.map((record) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2)),
                              ],
                            ),
                            child: Row(
                              children: [
                                if (selectionMode)
                                  Checkbox(
                                    value: record['selected'],
                                    onChanged: (val) {
                                      setState(() => record['selected'] = val);
                                    },
                                  ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    File(record['image']),
                                    width: 60.w,
                                    height: 60.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                          width: 60.w,
                                          height: 60.w,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image),
                                        ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(record['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp)),
                                      SizedBox(height: 4.h),
                                      Text("Source: ${record['source']}",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 13.sp)),
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 50.h, color: Colors.grey),
                                SizedBox(width: 8.w),
                                Text(record['category'],
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                )
                    : Center(
                  child: Text("No Records Found",
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
