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
        let source = CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315)
        let destination = CLLocationCoordinate2D(latitude: 37.452451, longitude: 127.132802)
        let route = PathData().route
        
        if coreLocation.location != nil{
            VStack{
                ARCLViewControllerWrapper(start: source, end: destination, route : route)
                NaverMap(coreLocation: coreLocation)
            }
        }
    }
}

