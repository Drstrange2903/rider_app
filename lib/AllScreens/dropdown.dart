import 'package:flutter/material.dart';
import 'package:rider_app/main.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('select your location'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

// ===================

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String value = "";
  List<DropdownMenuItem<String>> menuitems = List();
  bool disabledropdown = true;

  final waittime = {
    "1": "1 hr",
    "2": "2 hr",
    "3": "3 hr",
  };

  // ignore: non_constant_identifier_names
  final DESTINATION = {
    "1": "NIIT",
    "2": "AIRPORT",
    "3": "RAILWAY STATION",
  };

  final Expectedtimeofdept = {
    "1": "12 am",
    "2": "1 am",
    "3": "2 am",
  };

  void populateweb() {
    for (String key in waittime.keys) {
      menuitems.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(waittime[key]),
        ),
        value: waittime[key],
      ));
    }
  }

  void populateapp() {
    for (String key in DESTINATION.keys) {
      menuitems.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(DESTINATION[key]),
        ),
        value: DESTINATION[key],
      ));
    }
  }

  void populatedesktop() {
    for (String key in Expectedtimeofdept.keys) {
      menuitems.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(Expectedtimeofdept[key]),
        ),
        value: Expectedtimeofdept[key],
      ));
    }
  }

  void selected(_value) {
    if (_value == "timewait") {
      menuitems = [];
      populateweb();
    } else if (_value == "DESTINATION") {
      menuitems = [];
      populateapp();
    } else if (_value == "Expectedtimeofdept") {
      menuitems = [];
      populatedesktop();
    }
    setState(() {
      value = _value;
      disabledropdown = false;
    });
  }

  void secondselected(_value) {
    setState(() {
      value = _value;
    });
  }

  List<MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    1: "NIIT",
    2: "AIRPORT",
    3: "RAILWAY STATION",
    4: "BUS STATION",
  };

  void populateMultiselect() {
    for (int v in valuestopopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    populateMultiselect();
    final items = multiItem;

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: [1, 2].toSet(),
        );
      },
    );

    print(selectedValues);
    getvaluefromkey(selectedValues);
  }

  void getvaluefromkey(Set selection) {
    if (selection != null) {
      for (int x in selection.toList()) {
        print(valuestopopulate[x]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BOOKNOW",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DropdownButton<String>(
              items: [
                DropdownMenuItem<String>(
                  value: "timewait",
                  child: Center(
                    child: Text("waittime"),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "DESTINATION",
                  child: Center(
                    child: Text("DESTINATION"),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "dept time",
                  child: Center(
                    child: Text("expectedtimeofdept"),
                  ),
                ),
              ],
              onChanged: (_value) => selected(_value),
              hint: Text(" WHAT TO DO"),
            ),
            DropdownButton<String>(
              items: menuitems,
              onChanged:
                  disabledropdown ? null : (_value) => secondselected(_value),
              hint: Text("Select AS FOLLOW"),
              disabledHint: Text("First Select Your Field"),
            ),
            Text(
              "$value",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            RaisedButton(
              child: Text("YOUR LOCATION"),
              onPressed: () => _showMultiSelect(context),
            ),
          ],
        ),
      ),
    );
  }
}
