import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/empty_bag.dart';
import '../../../models/order.dart';
import '../../../providers/order_provider.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  bool isEmptyOrders = false;

  @override
  Widget build(BuildContext context) {
    // Accessing the OrdersProvider
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(
          label: 'Placed orders',
        ),
      ),
      body: FutureBuilder<List<OrdersModelAdvanced>>(
        // Fetching the list of orders
        future: ordersProvider.fetchOrder(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Displaying a loading indicator while waiting for data
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Displaying an error message if an error occurs
            return Center(
              child: SelectableText(
                  "An error has been occurred ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || ordersProvider.getOrders.isEmpty) {
            // Displaying an empty bag widget if there are no orders
            return EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              title: "No orders have been placed yet",
              subtitle: "",
              buttonText: "Shop now",
            );
          }

          // Displaying the list of orders using a ListView
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: OrdersWidgetFree(
                  ordersModelAdvanced: ordersProvider.getOrders[index],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              // Adding a divider between orders
              return const Divider();
            },
          );
        }),
      ),
    );
  }
}
