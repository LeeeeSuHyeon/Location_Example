//
//  ARDemoVCWrapper.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation
import SwiftUI
import CoreLocation

struct ARDemoVCWrapper: UIViewControllerRepresentable {
    
    // obeservedObject로 수정해야 할듯 -> 변경될 때마다 경로 추가 함수 호출되도록 
    var coreLocation: CoreLocationEx
    var route : [CLLocationCoordinate2D]
    
    func makeUIViewController(context: Context) -> ARDemoViewController {
        return ARDemoViewController(coreLocation : coreLocation, route : route)
    }
    
    func updateUIViewController(_ uiViewController: ARDemoViewController, context: Context) {
        // Update code if needed
    }
}
