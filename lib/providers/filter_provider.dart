import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  FilterOption _filterOption = FilterOption.jobTitle;

  FilterOption get filterOption => _filterOption;

  void setFilter(FilterOption option) {
    _filterOption = option;
    notifyListeners();
  }
}

enum FilterOption {
  jobTitle,
  employee,
}