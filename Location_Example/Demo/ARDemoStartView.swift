//
//  ARDemoStartView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/15.
//

import SwiftUI
import CoreLocation


struct ARDemoStartView: View {
    
    @ObservedObject var coreLocation : CoreLocationEx
    let route : [CLLocationCoordinate2D]
    
    var body: some View {
        VStack{
            ARDemoVCWrapper(coreLocation: coreLocation, route : route)
            NaverMap(coreLocation: coreLocation, route: route)
                .frame(height: 200)
        }
    }
}

