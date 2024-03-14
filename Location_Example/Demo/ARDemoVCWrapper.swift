//
//  ARDemoVCWrapper.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation
import SwiftUI

struct ARDemoVCWrapper: UIViewControllerRepresentable {
    
    var coreLocation: CoreLocationEx
    
    func makeUIViewController(context: Context) -> ARDemoViewController {
        return ARDemoViewController(coreLocation : coreLocation)
    }
    
    func updateUIViewController(_ uiViewController: ARDemoViewController, context: Context) {
        // Update code if needed
    }
}
