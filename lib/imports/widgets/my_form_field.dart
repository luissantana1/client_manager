import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText; //optional 
  final FormFieldValidator<String> validator;
  final Icon? prefixIcon;

  const MyFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false, //default value
    required this.validator,
    this.prefixIcon
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: TextFormField(
            controller: controller, 
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: prefixIcon,
                  border: OutlineInputBorder(
                      borderRadius: 
                        BorderRadius.circular(30.0)
                  ),
            ),
            obscureText: obscureText,
            //onChanged: (value) => onChanged(),
            validator: validator,
        )
    ); 
  }
}
