import 'package:flutter/material.dart';

/// 搜索框
class SearchBox extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String value)? onChange;
  final void Function(String value)? onSearch;
  final bool allowClear;

  const SearchBox({
    Key? key,
    this.controller,
    this.onSearch,
    this.onChange,
    this.allowClear = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(160, 160, 160, 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (onChange != null) {
            onChange!(value);
          }
        },
        onSubmitted: (value) {
          if (onSearch != null) {
            onSearch!(value);
          }
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isDense: true,
          hintText: "搜索",
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          suffixIcon: allowClear
              ? GestureDetector(
                  onTap: () {
                    controller?.clear();
                    if(onChange != null) {
                      onChange!("");
                    }
                    if (onSearch != null) {
                      onSearch!("");
                    }
                  },
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0x44999999),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Opacity(
                            opacity: 0.5,
                            child: Icon(
                              Icons.clear,
                              size: 10,
                            ),
                          ),
                        ),
                      )),
                )
              : null,
        ),
      ),
    );
  }
}
