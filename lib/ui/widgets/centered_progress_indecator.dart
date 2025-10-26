import 'package:flutter/material.dart';

class CenteredProgressIndecator extends StatelessWidget {
  const CenteredProgressIndecator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
