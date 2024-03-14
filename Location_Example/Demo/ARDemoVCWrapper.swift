//
//  ARDemoVCWrapper.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation
import SwiftUI

struct ARDemoVCWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ARDemoViewController {
        return ARDemoViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARDemoViewController, context: Context) {
        // Update code if needed
    }
}
