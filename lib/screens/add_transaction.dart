import 'package:flutter/material.dart';

List<String> expenseCategories = [
  "Food",
  "Travel",
  "Bills",
  "Shopping",
  "Entertainment",
  "Health",
];

List<String> incomeCategories = [
  "Salary",
  "Freelance",
  "Business",
  "Gift",
  "Bonus",
];

String selectedCategory = "Food";
class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() {
    return _AddTransaction();
  }
}

class _AddTransaction extends State<AddTransaction> {
  final _amountContrller = TextEditingController();

  final _noteController = TextEditingController();
  bool isIncome = false;
  void _submitData() {
    final enteredAmount = _amountContrller.text;

    if (enteredAmount.isEmpty) {
      return;
    }

    final newdata = {
      "amount": enteredAmount,
      "category": selectedCategory,
      "note": _noteController.text,
      "type": isIncome ? "Income" : "Expense",
      "date":DateTime.now().toString(),
      
    };
    Navigator.pop(context, newdata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _amountContrller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
            ),
          DropdownButtonFormField(
  value: selectedCategory,

  items: (isIncome
          ? incomeCategories
          : expenseCategories)
      .map((cat) {
    return DropdownMenuItem(
      value: cat,
      child: Text(cat),
    );
  }).toList(),

  onChanged: (value) {
    setState(() {
      selectedCategory = value!;
    });
  },

  decoration: const InputDecoration(
    labelText: "Category",
  ),
),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: "Note"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Expense"),
                Switch(
                  value: isIncome,
                 onChanged: (val) {
  setState(() {
    isIncome = val;

    selectedCategory = isIncome
        ? incomeCategories[0]
        : expenseCategories[0];
  });
},
                ),
                Text("Income"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
