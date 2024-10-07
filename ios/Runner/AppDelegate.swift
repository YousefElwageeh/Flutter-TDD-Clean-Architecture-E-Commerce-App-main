import UIKit
import Flutter
import CCAvenueUaeVertical

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CCMainViewControllerDelegate {
    var paymentController: CCMainViewController?
    var navigationController: UINavigationController?
    var flutterResult: FlutterResult?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      GMSServices.provideAPIKey("AIzaSyBXTd4c3IVvMXsRM-EZrnMS8nfJ6se22UQ")
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        // Set navigation controller over Flutter view controller
        navigationController = UINavigationController(rootViewController: controller)
        navigationController?.setNavigationBarHidden(true, animated: false)

        // Set navigation controller as a root view controller
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()

        // Create method channel object for communication with Flutter
        let ccAvenueChannel = FlutterMethodChannel(name: "plugin_ccavenue", binaryMessenger: controller.binaryMessenger)
        
        ccAvenueChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            let arguments = call.arguments as? NSDictionary
            if call.method.elementsEqual("payCCAvenue") {
                self.openPaymentViewController(result: result, arguments: arguments!)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func openPaymentViewController(result: @escaping FlutterResult, arguments: NSDictionary) {
        self.flutterResult = result
        let requestDict = getRequest(arguments: arguments)
        self.paymentController = CCMainViewController(request: requestDict)
        self.paymentController?.delegate = self
        self.paymentController?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(self.paymentController!, animated: false)
    }
    
    func getRequest(arguments: NSDictionary?) -> [String: Any] {
        return [
            "customer_id": arguments!["customer_id"] as! String,
            "access_code": arguments!["accessCode"] as! String,
            "amount": arguments!["amount"] as! String,
            "currency": arguments!["currency"] as! String,
            "merchant_id": Int(arguments!["mId"] as! String)!,
            "order_id": arguments!["order_id"] as! String,
            "tracking_id": Int(arguments!["tracking_id"] as! String)!,
            "request_hash": arguments!["request_hash"] as! String,
            "promotion": arguments!["promo"] as! String,
            "billing_name": arguments!["billing_name"] as! String,
            "billing_address": arguments!["billing_address"] as! String,
            "billing_city": arguments!["billing_city"] as! String,
            "billing_country": arguments!["billing_country"] as! String,
            "billing_state": arguments!["billing_state"] as! String,
            "billing_tel": arguments!["billing_telephone"] as! String,
            "billing_email": arguments!["billing_email"] as! String,
            "shipping_name": arguments!["shipping_name"] as! String,
            "shipping_address": arguments!["shipping_address"] as! String,
            "shipping_city": arguments!["shipping_city"] as! String,
            "shipping_country": arguments!["shipping_country"] as! String,
            "shipping_state": arguments!["shipping_state"] as! String,
            "shipping_tel": arguments!["shipping_telephone"] as! String,
            "merchant_param1": arguments!["merchantParam1"] as! String,
            "merchant_param2": arguments!["merchantParam2"] as! String,
            "merchant_param3": arguments!["merchantParam3"] as! String,
            "merchant_param4": arguments!["merchantParam4"] as! String,
            "merchant_param5": arguments!["merchantParam5"] as! String,
            "siType": arguments!["siType"] as! String,
            "siMerchantRefNo": arguments!["siRef"] as! String,
            "siSetupAmount": arguments!["siSetupAmount"] as! String,
            "siAmount": arguments!["siAmount"] as! String,
            "siStartDate": arguments!["siStartDate"] as! String,
            "siFrequencyType": arguments!["siFreqType"] as! String,
            "siFrequency": arguments!["siFreq"] as! String,
            "siBillCycle": arguments!["siBillCycle"] as! String,
            "redirect_url": arguments!["redirect_url"] as! String,
            "cancel_url": arguments!["cancel_url"] as! String,
            "display_address": arguments!["display_address"] as! String
        ]
    }
    
    func getResponse(_ jsonResponse: [AnyHashable: Any]?) {
        // Pop payment view controller and return back to Flutter view controller
        self.navigationController?.popViewController(animated: true)
        paymentController = nil
        
        // Dump the JSON response
        dump(jsonResponse)
        
        // Jump from a background thread to iOS’s main thread to execute a channel method
        DispatchQueue.main.async {
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse!, options: []) {
                let jsonText = String(data: jsonData, encoding: .ascii)
                // Pass JSON response in string format to Flutter code
                self.flutterResult?(jsonText)
            }
        }
    }
}
