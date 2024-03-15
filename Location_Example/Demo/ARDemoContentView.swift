//
//  ARDemoContentView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import SwiftUI
import CoreLocation

struct ARDemoContentView: View {
    @ObservedObject var coreLocation = CoreLocationEx()
    
    var body: some View {
        if coreLocation.location != nil {
            VStack{
                ARDemoVCWrapper(coreLocation: coreLocation)
//                NaverMap(coreLocation: coreLocation)
                ARCLMapView()
            }
            
        }
    }
}
