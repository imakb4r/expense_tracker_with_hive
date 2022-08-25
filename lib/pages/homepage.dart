import 'package:expense_tracer_using_hive/controllers/db_helper.dart';
import 'package:expense_tracer_using_hive/modals/transection_modal.dart';
import 'package:expense_tracer_using_hive/pages/add_transection.dart';
import 'package:expense_tracer_using_hive/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracer_using_hive/static.dart' as Static;
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  DateTime today = DateTime.now();
  late SharedPreferences preferences;
  late Box box;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;

  List<String> months = [
    'Jan',
    'Feb',
    'March',
    'Apr',
    'May',
    'June',
    'Jul',
    'Aug',
    'Sept',
    'Oct'
        'Nov',
    'Dec'
  ];

  getTotalBalance(List<TransactionModal> entireData) {
    totalBalance = 0;
    totalExpense = 0;
    totalIncome = 0;
    // entireData.forEach((key, value) {
    //   if (value['type'] == 'Income') {
    //     totalBalance += (value['amount'] as int);
    //     totalIncome += (value['amount'] as int);
    //   } else {
    //     totalBalance -= (value['amount'] as int);
    //     totalExpense += (value['amount'] as int);
    //   }
    // });
    for (TransactionModal data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == 'Income') {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense += data.amount;
        }
      }
    }
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModal>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModal> items = [];
      box.toMap().values.forEach((element) {
        items.add(TransactionModal(
            amount: element['amount'] as int,
            date: element['date'] as DateTime,
            note: element['note'] as String,
            type: element['type'] as String));
      });
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: Color(0xffe2e7ef),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => AddTranssection(),
          ),
        )
            .whenComplete(() {
          setState(() {});
        }),
        backgroundColor: Static.PrimaryColor,
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      body: FutureBuilder<List<TransactionModal>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Unexpected Error'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data provided'),
              );
            }
            getTotalBalance(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            //padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white70),
                            width: 64.0,
                            child: Image.asset('assets/face.png'),
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Text(
                            'Hello ${preferences.getString('Name')}',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: Static.PrimaryMaterialColor[800],
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white70),
                        child: Icon(
                          Icons.settings,
                          size: 32.0,
                          color: Color(0xff3e454c),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  // color: Colors.amber,
                  margin: EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Static.PrimaryColor,
                          Colors.blueAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4.0, -4.0),
                          blurRadius: 15.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Balance",
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹$totalBalance",
                          style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IncomeCard(totalIncome.toString()),
                              ExpenseCard(totalExpense.toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  reverse: true,
                  itemCount: (snapshot.data!.length),
                  itemBuilder: (context, index) {
                    TransactionModal dataAtIndex = snapshot.data![index];
                    return (dataAtIndex.type == 'Income')
                        ? newIncomeCard(dataAtIndex.amount, dataAtIndex.note,
                            dataAtIndex.date, index)
                        : expenseCard(dataAtIndex.amount, dataAtIndex.note,
                            dataAtIndex.date, index);
                  },
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            );
          } else {
            return Center(
              child: Text('Unexpected Error'),
            );
          }
        },
      ),
    );
  }

  Widget IncomeCard(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.green,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget ExpenseCard(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.red,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget expenseCard(int value, String note, DateTime date, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            InkWell(
              onLongPress: () async {
                bool? response = await showConfirmDialog(context, 'WARNING',
                    'Do you want to delete this transaction?');
                if (response != null && response) {
                  dbHelper.deleteData(index);
                  setState(() {});
                } else {}
              },
              child: Container(
                height: 70,
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 32, color: Colors.black45, spreadRadius: -8)
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/icon.png',
                        height: 35,
                        width: 55,
                      ),
                      Text(
                        note,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "- ₹$value",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'On ${date.day} ${months[date.month - 1]} ${date.year}',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 132,
              height: 24,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 16),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(36),
              ),
              child: Text(
                "Expense",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newIncomeCard(int value, String note, DateTime date, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            InkWell(
              onLongPress: () async {
                bool? response = await showConfirmDialog(context, 'WARNING',
                    'Do you want to delete this transaction?');
                if (response != null && response) {
                  dbHelper.deleteData(index);
                  setState(() {});
                } else {}
              },
              child: Container(
                height: 70,
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 32, color: Colors.black45, spreadRadius: -8)
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon.png',
                        height: 35,
                        width: 55,
                      ),
                      Text(
                        note,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                "+ ₹$value",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'On ${date.day} ${months[date.month - 1]} ${date.year}',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      //SizedBox(width: 1.0),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 132,
              height: 24,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 16),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(36),
              ),
              child: Text(
                "Income",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
