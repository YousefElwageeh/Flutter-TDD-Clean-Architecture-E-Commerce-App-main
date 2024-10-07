import 'package:eshop/features/order/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/images.dart';
import '../bloc/order_fetch/order_fetch_cubit.dart';
import '../../../../config/util/widgets/order_info_card.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: BlocBuilder<OrderFetchCubit, OrderFetchState>(
        builder: (context, state) {
          if (state is OrderFetchFail) {
            return RefreshIndicator.adaptive(
              onRefresh: () {
                context.read<OrderFetchCubit>().getOrders();
                return Future<void>.value();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(kOrderDelivery),
                    const Text("Orders are Empty!"),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    )
                  ],
                ),
              ),
            );
          }
          if (state is OrderFetchSuccess) {
            return RefreshIndicator.adaptive(
              onRefresh: () {
                context.read<OrderFetchCubit>().getOrders();
                return Future<void>.value();
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.orders.orders?.length ?? 0,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: (10 + MediaQuery.of(context).padding.bottom),
                  top: 10,
                ),
                itemBuilder: (context, index) => OrderInfoCard(
                  orderDetails: state.orders.orders?[index] ?? Order(),
                ),
              ),
            );
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 6,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: (10 + MediaQuery.of(context).padding.bottom),
                top: 10,
              ),
              itemBuilder: (context, index) => const OrderInfoCard(),
            );
          }
        },
      ),
    );
  }
}
