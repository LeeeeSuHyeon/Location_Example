//
//  ARCLContentView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/10.
//

import SwiftUI
import CoreLocation

struct ARCLContentView: View {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    
    var body: some View {

        let route = PathData().route
        
        if coreLocation.location != nil{
            VStack{
                ARCLViewControllerWrapper(route : route, coreLocation: coreLocation)
//                NaverMap(coreLocation: coreLocation)
                ARCLMapView(coreLocation: coreLocation)
            }
        }
    }
}

