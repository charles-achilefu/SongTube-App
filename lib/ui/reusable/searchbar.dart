// Flutter
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBar extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final Color containerColor;
  final Color textfieldColor;
  final TextEditingController controller;
  final Function onTextChanged;
  final Function onSearchPressed;
  final double indicatorValue;
  final bool enablePasteButton;
  final String hintText;
  final Icon prefixIcon;
  SearchBar({
    this.padding = const EdgeInsets.only(left: 8, right: 8, bottom: 8),
    @required this.containerColor,
    @required this.textfieldColor,
    @required this.controller,
    this.onTextChanged,
    this.enablePasteButton: true,
    @required this.onSearchPressed,
    this.indicatorValue,
    @required this.hintText,
    this.prefixIcon
  });
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: widget.padding,
    child: Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: widget.containerColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            offset: Offset(0.0, 1.5), //(x,y)
            blurRadius: 10.0,
            spreadRadius: 0.1
          ),
        ],
      ),
      child: Container(
        height: kToolbarHeight*1.1,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // URL Input
                    Expanded(
                      child: Theme(
                        data: Theme.of(context)
                          .copyWith(accentColor: Theme.of(context).accentColor),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          cursorColor: Theme.of(context).accentColor,
                          controller: widget.controller,
                          decoration: InputDecoration(
                            contentPadding: widget.prefixIcon != null
                              ? EdgeInsets.only(top: 15)
                              : EdgeInsets.only(top: 15, left: 16),
                            prefixIcon: widget.prefixIcon != null ? widget.prefixIcon : null,
                            filled: true,
                            fillColor: widget.textfieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 0, 
                                style: BorderStyle.none,
                              ),
                            ),
                            hintText: widget.hintText,
                            suffixIcon: AnimatedOpacity (
                              duration: Duration(milliseconds: 200),
                              opacity: widget.controller.text == "" ? 0.0 : 1.0,
                              child: IconButton(
                                icon: Icon(Icons.clear,
                                color: Theme.of(context).iconTheme.color),
                                onPressed: () => widget.controller.clear(),
                              )
                            ),
                          ),
                          onChanged: widget.onTextChanged,
                          onEditingComplete: widget.onSearchPressed,
                          
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                      ),
                    ),
                    // ClipBoard Paste Button
                    widget.enablePasteButton
                      ? Center(
                        child: IconButton(
                          icon: Icon(Icons.content_paste),
                          onPressed: () async {
                            ClipboardData data = await Clipboard.getData('text/plain');
                            if (data == null) return;
                            setState(() => widget.controller.text = data.text);
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      )
                      : Container(),
                    // Start Searching Button
                    Center(
                      child: IconButton(
                        icon: Icon(EvaIcons.searchOutline),
                        onPressed: widget.onSearchPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Search indicator Bar
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  height: 2,
                  width: MediaQuery.of(context).size.width*0.9,
                  child: LinearProgressIndicator(
                    value: widget.indicatorValue,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                  ),
                ),
              ),
            ),
            ],
          )
        ),
    ),
    );
  }
}