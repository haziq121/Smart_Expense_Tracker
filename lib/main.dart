import 'package:expense_tracker/screens/Chart_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'screens/add_transaction.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("transactionsBox");
  runApp(MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  double getTotalIncome() {
    double total = 0;
    for (int i = 0; i < box.length; i++) {
      var tx = box.getAt(i);
      if (tx["type"] == "Income") {
        total += double.tryParse(tx["amount"]) ?? 0;
      }
    }
    return total;
  }

  double getTotalExpense() {
    double total = 0;
    for (int i = 0; i < box.length; i++) {
      var tx = box.getAt(i);
      if (tx["type"] == "Expense") {
        total += double.tryParse(tx["amount"]) ?? 0;
      }
    }
    return total;
  }

  var box = Hive.box("transactionsBox");
  void deleteTransactions(int index) {
    setState(() {
      box.deleteAt(index);
    });
  }

  Map<int, double> monthlyExpense = {};
  Map<int, double> monthlyIncome = {};

  void calculateMonthlyData() {
    monthlyExpense.clear();
    monthlyIncome.clear();

    for (int i = 0; i < box.length; i++) {
      var tx = box.getAt(i);

      DateTime dt = DateTime.parse(tx["date"]);
      int month = dt.month;

      double amount = double.tryParse(tx["amount"]) ?? 0;

      if (tx["type"] == "Expense") {
        monthlyExpense[month] = (monthlyExpense[month] ?? 0) + amount;
      } else {
        monthlyIncome[month] = (monthlyIncome[month] ?? 0) + amount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f172a),

      appBar: AppBar(
        backgroundColor: const Color(0xff0f172a),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Expense Tracker",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                calculateMonthlyData();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartScreen(
                      expenseData: monthlyExpense,
                      incomeData: monthlyIncome,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.bar_chart_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TOP BALANCE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),

                gradient: const LinearGradient(
                  colors: [Color(0xff6366f1), Color(0xff8b5cf6)],
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Rs ${(getTotalIncome() - getTotalExpense()).toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // INCOME
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Income",
                                style: TextStyle(color: Colors.white70),
                              ),

                              Text(
                                "Rs ${getTotalIncome().toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // EXPENSE
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Expense",
                                style: TextStyle(color: Colors.white70),
                              ),

                              Text(
                                "Rs ${getTotalExpense().toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // LIST
            Expanded(
              child: box.isEmpty
                  ? const Center(
                      child: Text(
                        "No Transactions Yet",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: box.length,

                      itemBuilder: (context, index) {
                        final tx = box.getAt(index);

                        bool isIncome = tx["type"] == "Income";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: const Color(0xff1e293b),
                            borderRadius: BorderRadius.circular(22),
                          ),

                          child: Row(
                            children: [
                              // ICON
                              Container(
                                padding: const EdgeInsets.all(14),

                                decoration: BoxDecoration(
                                  color: isIncome
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),

                                  borderRadius: BorderRadius.circular(18),
                                ),

                                child: Icon(
                                  isIncome
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: isIncome ? Colors.green : Colors.red,
                                ),
                              ),

                              const SizedBox(width: 15),

                              // TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      tx["category"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      tx["note"],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      tx["date"].toString().substring(0, 10),

                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // AMOUNT + DELETE
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Text(
                                    "${isIncome ? "+" : "-"} Rs ${tx["amount"]}",
                                    style: TextStyle(
                                      color: isIncome
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      deleteTransactions(index);
                                    },

                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff8b5cf6),

        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransaction()),
          );

          if (result != null) {
            setState(() {
              box.add(result);
            });
          }
        },

        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
