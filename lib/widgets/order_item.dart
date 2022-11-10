// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import '../Providers/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderItems orders;
  OrderItem(this.orders);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        //make the card expandable
        children: [
          ListTile(
            title: Text("\$${widget.orders.amount}"),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orders.dateTime),
            ),
            trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          if (_expanded) //in list if statement
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: min(widget.orders.productOrder.length * 20.0 + 10.0, 100),
              child: ListView(
                children: widget.orders.productOrder
                    .map(
                      (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${e.quantity}x\$${e.price}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            )
                          ]),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
