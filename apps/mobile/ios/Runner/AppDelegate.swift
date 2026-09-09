import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "NoryvaIdentityMetadata") {
      FlutterMethodChannel(name: "noryva/identity_metadata", binaryMessenger: registrar.messenger())
        .setMethodCallHandler { call, result in
          guard call.method == "get" else { result(FlutterMethodNotImplemented); return }
          result(["osMajor": ProcessInfo.processInfo.operatingSystemVersion.majorVersion,
                  "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1.0"])
        }
    }
  }
}
