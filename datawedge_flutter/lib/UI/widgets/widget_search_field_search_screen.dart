import 'package:datawedgeflutter/model/constants.dart';
import 'package:datawedgeflutter/model/palette.dart';
import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _textController = new TextEditingController();
    return Container(
      // width: 250,
      height: 32,
      // margin: EdgeInsets.all(8.0),
      // padding: EdgeInsets.all(5.0),
      //decoration: BoxDecoration(
      //color: Colors.deepPurple[200],
      // borderRadius: BorderRadius.circular(8.0)),

      child: Container(
        margin: const EdgeInsets.only(right: 12),
        // padding: const EdgeInsets.all(23.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.indigo)),
        child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.up,
            children: [
              Expanded(
                  child: TextField(
                controller: _textController,
                style: TextStyle(color: Colors.white),

                cursorColor: Colors.pinkAccent,
                // maxLength: 100,
                // keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      _textController.clear();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey.withOpacity(0.5),
                      size: 19,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 0.0,
                  ),
                  fillColor: Colors.indigo,
                  filled: true,
                  hintText: 'Поиск по наименованию и штрихкоду...',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Palette.textColor1.withOpacity(0.5),
                      fontStyle: FontStyle.italic),
                  //    hasFloatingPlaceholder: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(width: 0.0, style: BorderStyle.none),
                  ),
                ),
                //*** */
                // decoration: InputDecoration(
                //     //   // prefixIcon: Icon(
                //     //   //   Icons.qr_code_sharp,
                //     //   //   color: Palette.iconColor,
                //     //   // ),
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Colors.white10),
                //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Colors.white10),
                //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //     ),
                //     contentPadding: EdgeInsets.only(left: 15),
                //     hintText: "Поиск по наименованию и штрихкоду...",
                //     hintStyle: TextStyle(
                //         fontSize: 14,
                //         color: Palette.textColor1.withOpacity(0.5),
                //         fontStyle: FontStyle.italic),
                //     // suffixIconConstraints: BoxConstraints(
                //     //   minWidth: 25,
                //     //   minHeight: 32,
                //     // ),
                //     prefixIcon: Padding(
                //       padding: const EdgeInsetsDirectional.only(bottom: 12.0),
                //       child: IconButton(
                //         // onPressed: _controllerID.clear(),
                //         onPressed: () => searchingGoods(enteredSearchString),
                //         icon: Icon(Icons.search_outlined, color: Colors.white10),
                //       ), // myIcon is a 48px-wide widget.
                //     )),
                //     //*** */
                onChanged: (String str) {
                  {
                    try {
                      enteredSearchString = str;
                    } catch (e) {
                      enteredSearchString = "";
                    }
                  }
                  ;
                },
                onSubmitted: (text) {
                  searchingGoods(text);
                },
              )),
              //   IconButton(
              //     // onPressed: _controllerID.clear(),
              //     onPressed: () => searchingGoods(enteredSearchString),
              //     icon: Icon(
              //       Icons.search,
              //       color: Colors.black26,
              //     ),
              //   ),
            ]),
      ),
    );
  }
}

void searchingGoods(String text) {
  print(selectedProducts2);
}
