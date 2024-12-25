import 'dart:developer';

import 'package:eshop/core/router/app_router.dart';
import 'package:eshop/features/order/presentation/bloc/order_fetch/order_fetch_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  String webViewUrl;
  PaymentWebView({
    super.key,
    required this.webViewUrl,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..enableZoom(true)
    ..addJavaScriptChannel(
      'reciveCallBack',
      onMessageReceived: (p0) {
        log('CAll Back');

        log(p0.message.toString());

        log(p0.hashCode.toString());
      },
    )
    ..getUserAgent().then((value) {
      log("getUserAgent");

      log(value ?? "");
    });

  @override
  void initState() {
    super.initState();

    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          controller.getTitle().then((value) {
            log("getTitle");
            if (value == 'Success') {
              context.read<OrderFetchCubit>().getOrders();
              Navigator.of(context).pushReplacementNamed(AppRouter.orders);
              EasyLoading.showSuccess("Order Placed Successfully");
            } else if (value == 'Failure') {
              Navigator.pop(context);
              EasyLoading.showError("Order Placed Failed");
            } else if (value == 'Aborted') {
              Navigator.pop(context);
              EasyLoading.showError("Order Canceled");
            } else if (value!
                .contains('https://nffpm-demo.ecom.mm4web.net/en/checkout')) {
              Navigator.pop(context);
              EasyLoading.showError("Order Canceled");
            }

            log(value ?? "");
          });
        },
        onHttpError: (HttpResponseError error) {
          log(error.toString());
          log(error.response?.statusCode.toString() ?? "");
          log(error.response?.toString() ?? "");
        },
        onWebResourceError: (WebResourceError error) {},
        onHttpAuthRequest: (request) {
          log(request.toString());
        },
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controller.loadHtmlString(widget.webViewUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
