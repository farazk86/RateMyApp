import Flutter
import UIKit
import StoreKit

public class SwiftRateMyAppPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "rate_my_app", binaryMessenger: registrar.messenger())
    let instance = SwiftRateMyAppPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments: [String: Any?] = (call.arguments ?? [:]) as! [String: Any?]
    switch call.method {
    case "launchNativeReviewDialog":
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            result(true)
        } else {
            result(false)
        }
    case "isNativeDialogSupported":
        if #available(iOS 10.3, *) {
            result(true)
        }
        else {
            result(false)
        }
    case "launchStore":
        let appId: String? = arguments["appId"] as! String?
        if appId == nil || appId!.isEmpty {
            result(FlutterError(code: "empty_app_id", message: "App id cannot be null or empty.", details: nil))
        }
        else if #available(iOS 10.0, *) {
            let iTunesLink: String = "itms-apps://itunes.apple.com/app/id\(appId!)?action=write-review"
            let itunesURL: URL = URL(string: iTunesLink)!
            if UIApplication.shared.canOpenURL(itunesURL) {
                UIApplication.shared.open(itunesURL, options: [:])
            }
            result(true)
        }
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
