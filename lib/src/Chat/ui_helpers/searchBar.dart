import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Searchbar extends StatelessWidget {
  final controller;
  final onChange;
  const Searchbar({Key? key, this.controller, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, -1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor)
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0),
              child: TextField(
                style: const TextStyle(height: 1, fontSize: 14,),
                controller: controller,
                onChanged: onChange,

                decoration: const InputDecoration(
                    hintStyle:TextStyle(height: 1, fontSize: 14,color: Colors.grey),
                    hintText: 'search',
                    border: InputBorder.none
                ),
              ),
            ),
          ),

            const Padding(
              padding: EdgeInsets.only(right:8.0),
              child:  Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
