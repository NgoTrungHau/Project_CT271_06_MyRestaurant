import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/table.dart';
import '../shared/dialog_utils.dart';

import 'reservations_manager.dart';

class EditTableScreen extends StatefulWidget {
  static const routeName = '/edit-table';

  EditTableScreen(
    TableB? table, {
      super.key,
    }) {
      if (table == null) {
        this.table = TableB(
          id: null,
          title: '',
          status: 0,
        );
      } else {
        this.table = table;
      }
    }

    late final TableB table;

    @override
    State<EditTableScreen> createState() => _EditTableScreenState();
}

class _EditTableScreenState extends State<EditTableScreen>{
  final _editForm = GlobalKey<FormState>();
  late TableB _editedTable;
  var _isLoading = false;


  @override
  void initState() {
    _editedTable = widget.table;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();
    
    setState(() {
      _isLoading = true;
    });

    try {
      final reservationsManager = context.read<ReservationsManager>();
      if (_editedTable.id != null) {
        await reservationsManager.updateTable(_editedTable);
      } else {
        await reservationsManager.addTable(_editedTable);
      }
    } catch (error) {
      await showErrorDialog(context, 'Something went wrong.');
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a table',
          style: TextStyle(color: Colors.white)
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 237, 205),
      body: _isLoading
          ? const Center(
            child: CircularProgressIndicator()
          )
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _editForm,
              child: ListView(
                children: <Widget>[
                  buildNameField(),
                  buildStatusField(),
                ]
              )
            )
          )
    );
  }
  
  TextFormField buildNameField() {
    return TextFormField(
      initialValue: _editedTable.title,
      decoration: const InputDecoration(labelText: 'Name',),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedTable = _editedTable.copyWith(title: value);
      },
    );
  }
  
  TextFormField buildStatusField() {
    return TextFormField(
      initialValue: _editedTable.status.toString(),
      decoration: const InputDecoration(labelText: 'Status'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator:(value) {
        if(value!.isEmpty) {
          return 'Please enter a number.';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter an integer number.';
        }
        if (int.parse(value) < 0 || int.parse(value) > 2) {
          return 'Please enter a number from zero to two.';
        }
        return null;
      },
      onSaved: (value) {
        _editedTable = _editedTable.copyWith(status: int.parse(value!));
      }
    );
  }

}

