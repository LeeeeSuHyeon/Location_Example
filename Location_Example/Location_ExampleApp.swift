//
//  Location_ExampleApp.swift
//  Location_Example
//
//  Created by 이수현 on 2024/01/28.
//

import SwiftUI
import ARKit

@main
struct Location_ExampleApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ARDemoContentView()
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // ARKit 활성화
//        ARConfiguration.isSupported // ARKit을 지원하는지 확인
//        return true
//    }
//}

