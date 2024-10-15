import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final Future<dynamic> Function() loadData;
  final Widget Function(dynamic data) buildPage;

  const SkeletonLoader({
    super.key,
    required this.loadData,
    required this.buildPage,
  });

  @override
  _SkeletonLoaderState createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> {
  bool _loading = true;
  dynamic _loadedData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await widget.loadData();
      setState(() {
        _loadedData = data;
        _loading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      // Handle error here if needed
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildSkeleton();
    } else {
      return widget.buildPage(_loadedData);
    }
  }

  Widget _buildSkeleton() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        // children: List.generate(
        //   3,
        //   (index) => Container(
        //     width: 300,
        //     height: 20,
        //     margin: const EdgeInsets.symmetric(vertical: 10),
        //     decoration: BoxDecoration(
        //       color: Colors.grey[300],
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
