import 'package:flutter/material.dart';

void main()
{
  runApp(const MyApp());
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

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text(widget.title),
      ),
      body: DataTable
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

        rows: const <DataRow>
        [
          DataRow
          (
            cells: const <DataCell>
            [
              DataCell(Text("SPOT")),
              DataCell(Text("420")),
              DataCell(Text("500")),
              DataCell(Text("400")),
            ],
          ),
          DataRow
          (
            cells: const <DataCell>
            [
              DataCell(Text("TSLA")),
              DataCell(Text("420")),
              DataCell(Text("500")),
              DataCell(Text("400")),
            ],
          ),
          DataRow
          (
            cells: const <DataCell>
            [
              DataCell(Text("MSFT")),
              DataCell(Text("420")),
              DataCell(Text("500")),
              DataCell(Text("400")),
            ],
          ),
        ],
      ),
    );
  }
}
