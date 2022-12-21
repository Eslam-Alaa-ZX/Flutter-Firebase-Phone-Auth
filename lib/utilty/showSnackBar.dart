import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImg(BuildContext context) async {
  File? img;
  try{
    final selectedImg=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(selectedImg !=null){
      img=File(selectedImg.path);
    }
  }catch(e){
    showSnackBar(context, e.toString());
  }
  return img;
}
