import 'package:flutter/material.dart';

void main()
{
  runApp(const MyApp());
}

class StockData
{
  final int id;
  final String symbol;
  final String current;
  final String high;
  final String low;
  final String update_time;
  StockData(this.id, this.symbol, this.current, this.high, this.low, this.update_time);
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Stocks',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const Page_Home(title: 'Stocks'),
    );
  }
}

class Page_Home extends StatefulWidget
{
  const Page_Home({super.key, required this.title});

  final String title;

  @override
  State<Page_Home> createState() => _Page_HomeState();
}

class _Page_HomeState extends State<Page_Home>
{
  List<StockData> data_stocks =
  [
    StockData(1, "MSFT", "420", "450", "321", "N/A"),
    StockData(2, "SPOT", "424", "551", "420", "N/A"),
    StockData(3, "APPL", "415", "463", "322", "N/A"),
    StockData(4, "TSLA", "460", "481", "333", "N/A"),
  ];

  void ui_snackbar(BuildContext contex, String text)
  {
    ScaffoldMessenger.of(context).showSnackBar
    (
      SnackBar(content: Text(text)),
    );
  }

  void ui_dialog_info(BuildContext context, String title, String text)
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog
        (
          title: Text(title),
          content: Text(text),
          actions:
          [
            TextButton
            (
              child: Text("Close"),
              onPressed: (){Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }

  void ui_refresh(BuildContext context)
  {
    print("[APP] Refresh requested");
  }

  final TextEditingController ui_controller_symbol_remove = TextEditingController();

  void ui_remove(BuildContext context)
  {
    print("[APP] Remove requested");

    final String symbol = ui_controller_symbol_remove.text;

    if(symbol!=null)
    {
      setState(()
      {
        data_stocks.removeWhere((stock) => stock.symbol==symbol);
        ui_controller_symbol_remove.clear();
      }
      );
    }
    else
    {
      ui_snackbar(context, "Invalid symbol");
    }
  }

  void ui_dialog_remove(BuildContext context)
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog
        (
          title: Text("Remove item"),
          content:TextField
          (
            controller: ui_controller_symbol_remove,
            decoration: InputDecoration(labelText: "Symbol"),
          ),
          actions:
          [
            TextButton
            (
              child: Text("Remove"),
              onPressed: ()
              {
                ui_remove(context);
                Navigator.of(context).pop();
              },
            ),
            TextButton
            (
              child: Text("Cancel"),
              onPressed: (){Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }

  final TextEditingController ui_controller_symbol_add = TextEditingController();

  void ui_add(BuildContext context)
  {
    print("[APP] Add requested");

    final String symbol = ui_controller_symbol_add.text;
    if(symbol!=null)
    {
      setState(()
      {
        data_stocks.add(StockData(0, symbol, "N/A", "N/A", "N/A", "N/A"));
        ui_controller_symbol_add.clear();
      }
      );
    }
    else
    {
      ui_snackbar(context, "Invalid symbol");
    }
  }

  void ui_dialog_add(BuildContext context)
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog
        (
          title: Text("Add item"),
          content:TextField
          (
            controller: ui_controller_symbol_add,
            decoration: InputDecoration(labelText: "Symbol"),
          ),
          actions:
          [
            TextButton
            (
              child: Text("Add"),
              onPressed: ()
              {
                Navigator.of(context).pop();
                ui_add(context);
              },
            ),
            TextButton
            (
              child: Text("Cancel"),
              onPressed: (){Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text(widget.title),
        actions:
        [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: ()
            {
              ui_dialog_info(context, "Info", "Hello");
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: ()
            {
              ui_dialog_remove(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: ()
            {
              ui_dialog_add(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: ()
            {
              ui_refresh(context);
            },
          ),
        ],
      ),
      body: SizedBox.expand
      (
        child: DataTable
        (
          columns: const <DataColumn>
          [
            DataColumn
            (
              label: Expanded(child: Text("Symbol")),
            ),
            DataColumn
            (
              label: Expanded(child: Text("Now")),
            ),
            DataColumn
            (
              label: Expanded(child: Text("High")),
            ),
            DataColumn
            (
              label: Expanded(child: Text("Low")),
            ),
          ],

          rows: data_stocks.map((stock)
          {
            return DataRow(cells:
              [
                DataCell(Text(stock.symbol)),
                DataCell(Text(stock.current)),
                DataCell(Text(stock.high)),
                DataCell(Text(stock.low)),
              ]
            );
          }).toList(),
        ),
       ),
    );
  }
}
