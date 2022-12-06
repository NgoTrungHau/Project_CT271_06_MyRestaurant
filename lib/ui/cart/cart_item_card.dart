import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import '../../ui/cart/cart_manager.dart';
import '../shared/dialog_utils.dart';

class CartItemCard extends StatefulWidget {
  final String dishId;
  final CartItem cartItem;

  const CartItemCard({
    required this.dishId,
    required this.cartItem,
    super.key,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  CartItem? cartItem;

  @override
  void initState() {
    cartItem = widget.cartItem;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showConfirmDialog(
          context,
          'Do you want to remove the item from the cart?',
        );
      },
      onDismissed: (direction) {
        context.read<CartManager>().removeItem(widget.dishId);
      },
      child: buildItemCard(context),
    );
  }

  Widget buildItemCard(BuildContext context) {
    final cart = context.read<CartManager>();
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.cartItem.imageUrl),
          ),
          title: Text(widget.cartItem.title),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Price: \$${cartItem?.price}'),
                Text(
                    'Total: \$${cart.totalAmountItem(widget.dishId).toStringAsFixed(2)}'),
              ]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
              icon: const Icon(Icons.remove, size: 30),
              color: Colors.orangeAccent,
              onPressed: (() {
                cart.minusQuantity(context, widget.dishId, widget.cartItem);
                setState(() {
                  cartItem = cart.getCartItem(widget.dishId);
                  print(cartItem?.quantity);
                });
              }),
            ),
            SizedBox(
              width: 20.0,
              height: 24.0,
              child: Center(
                child: Text(
                  '${cartItem?.quantity}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              color: Colors.orangeAccent,
              icon: const Icon(Icons.add, size: 30),
              onPressed: (() {
                cart.plusQuantity(widget.dishId, widget.cartItem);
                setState(() {
                  cartItem = cart.getCartItem(widget.dishId);
                  print(cartItem?.quantity);
                });
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
