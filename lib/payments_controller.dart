import 'dart:async';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PaymentsController extends GetxController {
  static PaymentsController get to => Get.find();
  late StreamSubscription<List<PurchaseDetails>>
      _subscription; // ! added 'late' tag

  // ! from {InAppPurchase, purchaseUpdatedStream} to {InAppPurchase, purchaseStream}
  @override
  void onInit() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream; // ! from {Stream} to {Stream<List<PurchaseDetails>>}
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print(error);
      // handle error here.
    });
    super.onInit();
  }

  loadProductsForSale() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    print(available);
    const Set<String> _kIds = <String>{'premium_1'};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }
    List<ProductDetails> products = response.productDetails;
    print(products);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print(purchaseDetails);
      // if (purchaseDetails.status == PurchaseStatus.pending) {
      //   _showPendingUI();
      // } else {
      //   if (purchaseDetails.status == PurchaseStatus.error) {
      //     _handleError(purchaseDetails.error);
      //   } else if (purchaseDetails.status == PurchaseStatus.purchased) {
      //     bool valid = await _verifyPurchase(purchaseDetails);
      //     if (valid) {
      //       _deliverProduct(purchaseDetails);
      //     } else {
      //       _handleInvalidPurchase(purchaseDetails);
      //       return;
      //     }
      //   }
      //   if (purchaseDetails.pendingCompletePurchase) {
      //     await InAppPurchase.instance
      //         .completePurchase(purchaseDetails);
      //   }
      // }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
