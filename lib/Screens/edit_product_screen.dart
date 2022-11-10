import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Providers/product_provider.dart';
import '../Providers/product.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-Screen';
  const EditProduct({Key key}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var _isloading = false;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrl = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>(); // Global argument to access Form data
  var _edittedProduct = Product(
    // creating a skeleton for product initially
    id: null,
    title: "",
    description: "",
    price: 0,
  );
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrl.dispose();
    super.dispose();
    _imageFocusNode.dispose();
  }

  var isinit = true;
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageOnloseFocus); //passing a pointer
    super.initState();
  }

//ModelRoute can't be used in initstate
//thus we use didChangeDependencies
  @override
  void didChangeDependencies() {
    if (isinit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _edittedProduct = Provider.of<Products>(context).findById(productId);
        initValues = {
          'title': _edittedProduct.title,
          'description': _edittedProduct.description,
          'price': _edittedProduct.price.toString(),
          'imageUrl': '' //For image is different
        };
        _imageUrl.text = _edittedProduct.imageUrl;
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  void _updateImageOnloseFocus() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageUrl.text.startsWith("http") &&
              !_imageUrl.text.startsWith("https")) ||
          (!_imageUrl.text.endsWith(".png") &&
              !_imageUrl.text.endsWith(".jpg") &&
              !_imageUrl.text.endsWith(".jpeg"))) return;
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return; // don't retun anything and the rest of the code will not execute
    }
    _form.currentState.save(); //save is a method provided by FormState
    setState(() {
      _isloading = true;
    });
    if (_edittedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_edittedProduct.id, _edittedProduct)
          .then((_) {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      //since it has no Id
      Provider.of<Products>(context, listen: false)
          .addProduct(_edittedProduct)
          .catchError((err) {
        //catchError is a method provided by Future it receives the future error and handles it
        return showDialog<Null>(
            //it returns a Future which is passed to then method
            context: context,
            builder: ((ctx) {
              return AlertDialog(
                  title: Text("An error occured"),
                  content: Text("Something went wrong"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okay')),
                  ]);
            }));
      }).then((_) {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form, //connecting the form to the global key
                //Form helps to manage all the inputs without text editting comtroller
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction
                          .next, // displaying next on the softt keyboard
                      onFieldSubmitted: (ctx) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (value) {
                        _edittedProduct = Product(
                          title: value,
                          description: _edittedProduct.description,
                          price: _edittedProduct.price,
                          imageUrl: _edittedProduct.imageUrl,
                          id: _edittedProduct.id,
                          isFavourite: _edittedProduct.isFavourite,
                        );
                      },
                      //When we want to use our own caustom validator instead of relaying the form validator
                      validator: (value) {
                        //it takes a string and return the String For error messages
                        if (value.isEmpty) {
                          return "Please Enter The Product Title";
                        } else {
                          return null; //if no error occured
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (ctx) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (value) {
                        _edittedProduct = Product(
                            title: _edittedProduct.title,
                            price: double.parse(value),
                            description: _edittedProduct.description,
                            imageUrl: _edittedProduct.imageUrl,
                            id: _edittedProduct.id,
                            isFavourite: _edittedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter a Price";
                        }
                        if (double.tryParse(value) == null) {
                          //return null if th parse failed
                          return "Please Enter a valid number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please Enter a number greater than zero";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3, // Makes the text input larger
                      keyboardType: TextInputType
                          .multiline, //makes the soft keyboard on pressing enter to move to the next line in the text input
                      focusNode: _descriptionFocusNode,
                      validator: (descrip) {
                        if (descrip.isEmpty) {
                          return 'Please Enter a Description';
                        }
                        if (descrip.length < 10) {
                          return "Please enter atleast 10 characters for description";
                        }
                      },
                      onSaved: (val) {
                        _edittedProduct = Product(
                          title: _edittedProduct.title,
                          price: _edittedProduct.price,
                          description: val,
                          imageUrl: _edittedProduct.imageUrl,
                          id: _edittedProduct.id,
                          isFavourite: _edittedProduct.isFavourite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrl.text.isEmpty
                              ? Text("Enter an Image Url")
                              : FittedBox(
                                  child: Image.network(_imageUrl.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: initValues['imageUrl'], Thus we can't set the inital values of imageUrl while we are using a controller
                            //it takes as much width it can get
                            decoration: InputDecoration(
                                labelText: 'Enter the Product\'s Image'),
                            textInputAction: TextInputAction.done,
                            keyboardType:
                                TextInputType.url, //  soft keyboard for URl
                            controller:
                                _imageUrl, // when we want to manage the input before submitting the data in the form
                            focusNode:
                                _imageFocusNode, //adding custom Focus Listener on lossing focus
                            onEditingComplete: () {
                              //change set state once you've loose focus on the text input field
                              setState(() {});
                            },
                            validator: (img) {
                              if (img.isEmpty) {
                                return "Please Enter an image URL";
                              }
                              if (!img.startsWith("http") &&
                                  !img.startsWith("https")) {
                                return "Please Enter a Valid URL";
                              }
                              if (!img.endsWith(".png") &&
                                  !img.endsWith(".jpg") &&
                                  !img.endsWith(".jpeg")) {
                                return "Please Enter a Valid Image URL";
                              }
                              return null;
                            },
                            onSaved: (valuee) {
                              _edittedProduct = Product(
                                title: _edittedProduct.title,
                                price: _edittedProduct.price,
                                description: _edittedProduct.description,
                                imageUrl: valuee,
                                id: _edittedProduct.id,
                                isFavourite: _edittedProduct.isFavourite,
                              );
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
