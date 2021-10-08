import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    cid: null,
    item: '',
    quantity: '0',
    location: '',
    // imageUrl: '',
  );
  var _initValues = {
    'item': '',
    'location': '',
    'quantity': '',
    // 'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'item': _editedProduct.item,
          'location': _editedProduct.location,
          'quantity': _editedProduct.quantity.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.cid != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.cid, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  String dropDownValue = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    // TextFormField(
                    //   initialValue: _initValues['item'],
                    //   decoration: InputDecoration(labelText: 'Title'),
                    //   textInputAction: TextInputAction.next,
                    //   onFieldSubmitted: (_) {
                    //     FocusScope.of(context).requestFocus(_priceFocusNode);
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please provide a value.';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _editedProduct = Product(
                    //         item: value,
                    //         quantity: _editedProduct.quantity,
                    //         location: _editedProduct.location,
                    //         imageUrl: _editedProduct.imageUrl,
                    //         id: _editedProduct.id,
                    //         isDonate: _editedProduct.isDonate);
                    //   },
                    // ),
                    DropdownButton(
                      value: dropDownValue,
                      items: <String>[
                        'None',
                        'Besan',
                        'Bhujia',
                        'Chickpeas',
                        'Cumin',
                        'Ghee',
                        'Maida',
                        'Mask',
                        'Milk',
                        'Pulses',
                        'RefinedOil',
                        'Rice',
                        'Salt',
                        'Sanitizer',
                        'Soyabean',
                        'Sugar',
                        'Tea',
                        'Wheat',
                      ]
                          .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                    child: Text(value),
                                    value: value,
                                  ))
                          .toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropDownValue = newValue;
                          _editedProduct = Product(
                            cid: _editedProduct.cid,
                            item: dropDownValue,
                            location: _editedProduct.location,
                            quantity: _editedProduct.quantity,
                            // imageUrl: _editedProduct.imageUrl,
                          );
                          _imageUrlController.text = dropDownValue != 'None'
                              ? "assets/products/$dropDownValue.jpg"
                              : null;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['quantity'],
                      decoration: InputDecoration(labelText: 'Amount'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a quantity.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          item: _editedProduct.item,
                          quantity: value,
                          location: _editedProduct.location,
                          // imageUrl: _imageUrlController.text,
                          cid: _editedProduct.cid,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['location'],
                      decoration: InputDecoration(labelText: 'Location'),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a location.';
                        }
                        // if (value.length < 10) {
                        //   return 'Should be at least 10 characters long.';
                        // }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          item: _editedProduct.item,
                          quantity: _editedProduct.quantity,
                          location: value,
                          // imageUrl: _editedProduct.imageUrl,
                          cid: _editedProduct.cid,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('No Image')
                              : FittedBox(
                                  child: Image(
                                    image: AssetImage(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        // Expanded(
                        //   child: TextFormField(
                        //     decoration: InputDecoration(labelText: 'Image URL'),
                        //     keyboardType: TextInputType.url,
                        //     textInputAction: TextInputAction.done,
                        //     controller: _imageUrlController,
                        //     focusNode: _imageUrlFocusNode,
                        //     onFieldSubmitted: (_) {
                        //       _saveForm();
                        //     },
                        //     validator: (value) {
                        //       if (value.isEmpty) {
                        //         return 'Please enter an image URL.';
                        //       }
                        //       // if (!value.startsWith('http') &&
                        //       //     !value.startsWith('https')) {
                        //       //   return 'Please enter a valid URL.';
                        //       // }
                        //       if (!value.endsWith('.png') &&
                        //           !value.endsWith('.jpg') &&
                        //           !value.endsWith('.jpeg')) {
                        //         return 'Please enter a valid image URL.';
                        //       }
                        //       return null;
                        //     },
                        //     onSaved: (value) {
                        //       _editedProduct = Product(
                        //         item: _editedProduct.item,
                        //         quantity: _editedProduct.quantity,
                        //         location: _editedProduct.location,
                        //         imageUrl: value,
                        //         id: _editedProduct.id,
                        //         isDonate: _editedProduct.isDonate,
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
