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

        let path = Path().homeToAI
        
        if coreLocation.location != nil{
            VStack{
                ARCLViewControllerWrapper(path : path, coreLocation: coreLocation)
//                ARCLMapView(coreLocation: coreLocation)
                AppleMap(coreLocation: coreLocation, path: path)
            }
        }
    }
}

