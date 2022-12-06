import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dish.dart';
import '../shared/dialog_utils.dart';

import 'dishes_manager.dart';

class EditDishScreen extends StatefulWidget {
  static const routeName = '/edit-dish';

  EditDishScreen(
    Dish? dish, {
      super.key,
    }) {
      if (dish == null) {
        this.dish = Dish(
          id: null,
          title: '',
          price: 0,
          description: '',
          imageURL: '',
        );
      } else {
        this.dish = dish;
      }
    }

    late final Dish dish;

    @override
    State<EditDishScreen> createState() => _EditDishScreenState();
}

class _EditDishScreenState extends State<EditDishScreen>{
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Dish _editedDish;
  var _isLoading = false;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https')) && (value.endsWith('.png') || value.endsWith('.jpg') || value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        setState(() {});
      }
    });
    _editedDish = widget.dish;
    _imageUrlController.text = _editedDish.imageURL;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
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
      final dishesManager = context.read<DishesManager>();
      if (_editedDish.id != null) {
        await dishesManager.updateDish(_editedDish);
      } else {
        await dishesManager.addDish(_editedDish);
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
        title: const Text('Edit Dish'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
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
                  buildTitleField(),
                  buildPriceField(),
                  buildDescriptionField(),
                  buildDishPreview(),
                  buildImageURLField(),
                ]
              )
            )
          )
    );
  }
  
  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: _editedDish.title,
      decoration: const InputDecoration(labelText: 'Title',),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        
        _editedDish = _editedDish.copyWith(title: value);
        print(_editedDish.title);
      },
    );
  }
  
  TextFormField buildPriceField() {
    return TextFormField(
      initialValue: _editedDish.price.toString(),
      decoration: const InputDecoration(labelText: 'Price'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator:(value) {
        if(value!.isEmpty) {
          return 'Please enter a price.';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a number greater than zero.';
        }
        if (double.parse(value) <= 0) {
          return 'Please enter a number greater than zero.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDish = _editedDish.copyWith(price: double.parse(value!));
      }
    );
  }
  
  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedDish.description,
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDish = _editedDish.copyWith(description: value);
      }
    );
  }
  
  Widget buildDishPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 180,
          height: 100,
          margin: const EdgeInsets.only(
            top: 8,
            right: 0,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0,
              color: const Color.fromARGB(255, 255, 237, 205),
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? const Text('Enter a URL')
              : FittedBox(
                child: Image.network(
                  _imageUrlController.text,
                  fit: BoxFit.cover,
                )
              )
        ),
      ],
    );
  }
  
  TextFormField buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Image URL'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an image URL.';
        }
        if (!_isValidImageUrl(value)) {
          return 'Please enter a valid image URL.';
        }
        return null;
      },
      onSaved: (value) {
        _editedDish = _editedDish.copyWith(imageURL: value);
      }
    );
  }

}

