import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier{
   int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }

}