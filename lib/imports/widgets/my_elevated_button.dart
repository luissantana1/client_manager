import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget { 
  final String hintText;
  final VoidCallback onPressed;
  final Color color;

  const MyElevatedButton({
    Key? key,
    required this.hintText,
    required this.onPressed,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: ElevatedButton(            
            style: ElevatedButton.styleFrom(
                primary: color, 
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 20),
            ),
            child: Text(hintText),
            //widget.onPressed must be called as a function()
            onPressed: () => onPressed()
        )
    );
  }
}
