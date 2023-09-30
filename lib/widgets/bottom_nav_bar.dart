import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHorizontalScrollingButtons(),
        _buildFixedButtons(),
      ],
    );
  }

  Widget _buildHorizontalScrollingButtons() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {},
            child: Text('ボタン $index'),
          ),
        ),
      ),
    );
  }

  Widget _buildFixedButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton('ボタン 1'),
        _buildButton('ボタン 2'),
        _buildButton('ボタン 3'),
      ],
    );
  }

  Widget _buildButton(String label) {
    return ElevatedButton(onPressed: () {}, child: Text(label));
  }
}
