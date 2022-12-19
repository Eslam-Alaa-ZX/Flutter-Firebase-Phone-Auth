import 'package:flutter/material.dart';

class CstBtn extends StatelessWidget {
  final String txt;
  final VoidCallback fun;

  const CstBtn({Key? key, required this.txt, required this.fun})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.purple),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      child: Text(
        txt,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
