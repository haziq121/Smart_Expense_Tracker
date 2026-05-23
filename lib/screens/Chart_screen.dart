import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  final Map<int, double> expenseData;
  final Map<int, double> incomeData;

  const ChartScreen({
    super.key,
    required this.expenseData,
    required this.incomeData,
  });

  @override
  Widget build(BuildContext context) {
    double totalExpense =
        expenseData.values.fold(0, (a, b) => a + b);

    double totalIncome =
        incomeData.values.fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: const Color(0xff0f172a),

      appBar: AppBar(
        backgroundColor: const Color(0xff0f172a),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Analytics Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            // TOP CARDS
            Row(
              children: [
                Expanded(
                  child: buildCard(
                    title: "Income",
                    amount: totalIncome,
                    color: Colors.green,
                    icon: Icons.arrow_downward,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: buildCard(
                    title: "Expense",
                    amount: totalExpense,
                    color: Colors.red,
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // PIE CHART
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff1e293b),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  const Text(
                    "Income vs Expense",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 5,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            value: totalIncome,
                            color: Colors.green,
                            radius: 90,
                            title:
                                "${totalIncome.toStringAsFixed(0)}",
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          PieChartSectionData(
                            value: totalExpense,
                            color: Colors.red,
                            radius: 90,
                            title:
                                "${totalExpense.toStringAsFixed(0)}",
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      buildIndicator(
                        Colors.green,
                        "Income",
                      ),

                      const SizedBox(width: 20),

                      buildIndicator(
                        Colors.red,
                        "Expense",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BAR CHART
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff1e293b),
                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                children: [
                  const Text(
                    "Monthly Expenses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        borderData:
                            FlBorderData(show: false),

                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine:
                              (value) {
                            return FlLine(
                              color: Colors.white12,
                              strokeWidth: 1,
                            );
                          },
                        ),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget:
                                  (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white54,
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),

                          rightTitles:
                              const AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles: false,
                            ),
                          ),

                          topTitles:
                              const AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles: false,
                            ),
                          ),

                          bottomTitles:
                              AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles: true,
                              getTitlesWidget:
                                  (value, meta) {
                                List months = [
                                  "",
                                  "Jan",
                                  "Feb",
                                  "Mar",
                                  "Apr",
                                  "May",
                                  "Jun",
                                  "Jul",
                                  "Aug",
                                  "Sep",
                                  "Oct",
                                  "Nov",
                                  "Dec"
                                ];

                                return Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                          top: 8),
                                  child: Text(
                                    months[value
                                        .toInt()],
                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        barGroups:
                            expenseData.entries
                                .map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value,
                                width: 18,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            8),

                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Colors.orange,
                                    Colors.red,
                                  ],
                                  begin:
                                      Alignment
                                          .bottomCenter,
                                  end: Alignment
                                      .topCenter,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.7),
            color,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),

          const SizedBox(height: 15),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Rs ${amount.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator(
      Color color,
      String text,
      ) {
    return Row(
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
                BorderRadius.circular(100),
          ),
        ),

        const SizedBox(width: 8),

        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}