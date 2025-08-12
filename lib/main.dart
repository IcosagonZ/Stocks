// Import libraries
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import "apis.dart";

// Main app
void main()
{
  runApp(const MyApp());
}

// Struct to hold stock data
class StockData
{
  int id;
  String symbol;
  String current;
  String high;
  String low;
  int update_status;
  StockData(this.id, this.symbol, this.current, this.high, this.low, this.update_status);
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
  // Sample data
  List<StockData> data_stocks =
  [
    StockData(0, "GOOG", "N/A", "N/A", "N/A", 0),
    StockData(0, "SPOT", "N/A", "N/A", "N/A", 0),
    StockData(0, "AAPL", "N/A", "N/A", "N/A", 0),
  ];

  // Finnhub API key
  String stock_api_key = finhubb_api_key;

  // Display small info
  void ui_snackbar(BuildContext context, String text)
  {
    ScaffoldMessenger.of(context).showSnackBar
    (
      SnackBar(content: Text(text)),
    );
  }

  // Display info in dialog
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

  // Fetch data using API
  Future<StockData> stocks_fetch(BuildContext context, String symbol, String apikey) async
  {
    final url = Uri.parse("https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apikey");

    final response = await http.get(url);

    StockData stock_return = StockData(0, symbol, "N/A", "N/A", "N/A", 0);

    if(response.statusCode==200)
    {
      final data = json.decode(response.body);
      stock_return.current = data["c"].toString();
      stock_return.high = data["h"].toString();
      stock_return.low = data["l"].toString();
      stock_return.update_status = response.statusCode;

      print("[STOCK] Fetched for ${symbol} current ${stock_return.current}");
    }
    else
    {
      stock_return.update_status = response.statusCode;
      ui_snackbar(context, "Error code: ${response.statusCode}");
      print("[ERROR] Fetch error ${response.statusCode}");
    }

    return stock_return;
  }

  // Refresh data
  Future<void> ui_refresh (BuildContext context) async
  {
    print("[APP] Refresh requested");

    List<StockData> data_stocks_new = [];
    StockData stock_temp;

    for(int i=0; i<data_stocks.length; i++)
    {
      stock_temp = await stocks_fetch(context, data_stocks[i].symbol, stock_api_key);
      data_stocks_new.add(stock_temp);
    }

    setState(()
    {
      data_stocks = data_stocks_new;
    }
    );
  }

  // Remove stock item
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

  // Add stock item
  final TextEditingController ui_controller_symbol_add = TextEditingController();

  void ui_add(BuildContext context)
  {
    print("[APP] Add requested");

    final String symbol = ui_controller_symbol_add.text;
    if(symbol!=null)
    {
      setState(()
      {
        data_stocks.add(StockData(0, symbol, "N/A", "N/A", "N/A", 0));
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

  // Main app UI
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
