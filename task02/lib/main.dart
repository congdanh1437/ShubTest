import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction__bloc.dart';

import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => TransactionBloc(),
        child: const TransactionForm(),
      ),
    );
  }
}

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập Giao Dịch'),
        actions: [
          ElevatedButton(style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
          ),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                FocusScope.of(context).unfocus();
                var formData = _formKey.currentState!.value;

                // Dispatch the update event
                context.read<TransactionBloc>().add(UpdateTransaction(
                  time: formData['time'],
                  quantity: formData['quantity'],
                  reference: formData['reference'],
                  revenue: formData['revenue'],
                  unitPrice: formData['unitPrice'],
                ));

                Fluttertoast.showToast(
                  msg: "Cập nhật thành công.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                FocusScope.of(context).unfocus();
                Fluttertoast.showToast(
                  msg: "Cập nhật thất bại.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            child: const Text('Cập nhật'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderDateTimePicker(
                  name: 'time',
                  inputType: InputType.both,
                  decoration: const InputDecoration(
                    labelText: 'Thời gian',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: FormBuilderValidators.compose([
                        (val) {
                      if (val == null) {
                        return 'Vui lòng nhập ngày và giờ';
                      }
                      DateTime date = val as DateTime;
                      if (date.isAfter(DateTime.now())) {
                        return 'Vui lòng chọn ngày hợp lệ';
                      }
                      return null;
                    }
                  ]),
                  lastDate: DateTime.now(),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'quantity',
                  decoration: const InputDecoration(
                    labelText: 'Số Lượng',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Vui lòng nhập số lượng',
                    ),
                    FormBuilderValidators.numeric(
                      errorText: 'Vui lòng nhập số hợp lệ',
                    ),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                FormBuilderDropdown(
                  name: 'reference',
                  decoration: const InputDecoration(
                    labelText: 'Trụ',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'option1',
                      child: Text('Option 1'),
                    ),
                    DropdownMenuItem(
                      value: 'option2',
                      child: Text('Option 2'),
                    ),
                    DropdownMenuItem(
                      value: 'option3',
                      child: Text('Option 3'),
                    ),
                  ],
                  validator: FormBuilderValidators.required(
                    errorText: 'Vui lòng chọn số Trụ',
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'revenue',
                  decoration: const InputDecoration(
                    labelText: 'Doanh Thu',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Vui lòng nhập Doanh Thu',
                    ),
                    FormBuilderValidators.numeric(),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'unitPrice',
                  decoration: const InputDecoration(
                    labelText: 'Đơn Giá',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Vui lòng nhập Đơn Giá',
                    ),
                    FormBuilderValidators.numeric(),
                  ]),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
