import 'package:flutter/material.dart';

class MyForm extends StatelessWidget {
  final GlobalKey formKey;
  final Iterable children;

  const MyForm({
    Key? key,
    required this.formKey,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Form(
            key: formKey,
                child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                    child: Column(
                        children: [
                          ...children//spreading the form elements 
                        ]
                    )
                ) 
        )
      )
    );
  } 
}
