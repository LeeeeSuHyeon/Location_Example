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
    
    var coreLocation: CoreLocationEx
    var route : [CLLocationCoordinate2D]
    
    func makeUIViewController(context: Context) -> ARDemoViewController {
        return ARDemoViewController(coreLocation : coreLocation, route : route)
    }
    
    func updateUIViewController(_ uiViewController: ARDemoViewController, context: Context) {
        // Update code if needed
    }
}
