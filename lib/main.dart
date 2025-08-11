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

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text(widget.title),
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
