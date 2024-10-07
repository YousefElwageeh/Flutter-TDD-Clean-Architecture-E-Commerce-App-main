package com.example.eshop.eshop

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ccavenue.dubaisdk.PaymentOptions
import com.ccavenue.dubaisdk.externalModel.*
import androidx.annotation.NonNull // Import the NonNull annotation

class MainActivity : FlutterActivity(), AvenuesTransactionCallBack.stateListener {
    private val CHANNEL = "plugin_ccavenue"

    companion object {
        private var flutterResult: MethodChannel.Result? = null
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "payCCAvenue") {
                MainActivity.flutterResult = result
                AvenuesTransactionCallBack.getInstance().setListener(this)

                // Create MerchantDetails object
                val merchantDetails = MerchantDetails().apply {
                    accessCode = call.argument<Any>("accessCode").toString()
                    merchantId = call.argument<Any>("mId").toString()
                    currency = call.argument<Any>("currency").toString()
                    amount = call.argument<Any>("amount").toString()
                    redirectUrl = call.argument<Any>("redirect_url").toString()
                    setCancel_url(call.argument<Any>("cancel_url").toString())
                    orderId = call.argument<Any>("order_id").toString()
                    customerId = call.argument<Any>("customer_id").toString()
                    trackingId = call.argument<Any>("tracking_id").toString()
                    requestHash = call.argument<Any>("request_hash").toString()
                    isShowAddr = call.argument<Any>("display_address")?.toString() == "Y"
                    isCCAvenuePromo = true
                    promoCode = call.argument<Any>("promo").toString()
                    add1 = call.argument<Any>("merchantParam1").toString()
                    add2 = call.argument<Any>("merchantParam2").toString()
                    add3 = call.argument<Any>("merchantParam3").toString()
                    add4 = call.argument<Any>("merchantParam4").toString()
                    add5 = call.argument<Any>("merchantParam5").toString()
                }

                // Create BillingAddress object
                val billingAddress = BillingAddress().apply {
                    name = call.argument<Any>("billing_name").toString()
                    address = call.argument<Any>("billing_address").toString()
                    country = call.argument<Any>("billing_country").toString()
                    state = call.argument<Any>("billing_state").toString()
                    city = call.argument<Any>("billing_city").toString()
                    telephone = call.argument<Any>("billing_telephone").toString()
                    email = call.argument<Any>("billing_email").toString()
                }

                // Create ShippingAddress object
                val shippingAddress = ShippingAddress().apply {
                    name = call.argument<Any>("shipping_name").toString()
                    address = call.argument<Any>("shipping_address").toString()
                    country = call.argument<Any>("shipping_country").toString()
                    state = call.argument<Any>("shipping_state").toString()
                    city = call.argument<Any>("shipping_city").toString()
                    telephone = call.argument<Any>("shipping_telephone").toString()
                }

                // Create StandardInstructions object
                val standardInstructions = StandardInstructions().apply {
                    si_type = call.argument<Any>("siType").toString()
                    si_mer_ref_no = call.argument<Any>("siRef").toString()
                    si_is_setup_amt = call.argument<Any>("siSetupAmount").toString()
                    si_amount = call.argument<Any>("siAmount").toString()
                    si_start_date = call.argument<Any>("siStartDate").toString()
                    si_frequency_type = call.argument<Any>("siFreqType").toString()
                    si_frequency = call.argument<Any>("siFreq").toString()
                    si_bill_cycle = call.argument<Any>("siBillCycle").toString()
                }

                // Start PaymentOptions activity
                val intent = Intent(this, PaymentOptions::class.java).apply {
                    putExtra("merchant", merchantDetails)
                    putExtra("billing", billingAddress)
                    putExtra("shipping", shippingAddress)
                    putExtra("standardInstructions", standardInstructions)
                }
                startActivity(intent)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onSuccess(p0: String?) {
        runOnUiThread {
            MainActivity.flutterResult?.success(p0)
        }
    }

    override fun onError(p0: String?) {
        runOnUiThread {
            MainActivity.flutterResult?.error("ERROR", p0, null)
        }
    }

    override fun onCancel(p0: String?) {
        runOnUiThread {
            MainActivity.flutterResult?.error("CANCEL", p0, null)
        }
    }
}
