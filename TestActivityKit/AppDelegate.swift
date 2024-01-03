//
//  AppDelegate.swift
//  TestActivityKit
//
//  Created by huihui.zhang on 2023/12/31.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        
        return true
    }

}



extension UIFont {
    enum PingFangSCType: String {
        case regular = "PingFangSC-Regular"
        case medium = "PingFangSC-Medium"
        case semibold = "PingFangSC-Semibold"
        case light = "PingFangSC-Light"
        case ultralight = "PingFangSC-Ultralight"
        case thin = "PingFangSC-Thin"
    }
    
    static func PingFang(size: CGFloat, type: PingFangSCType = .regular) -> UIFont {
        if let font = UIFont(name: type.rawValue, size: size) {
            return font
        } else {
            return .systemFont(ofSize: size)
        }
    }
}
