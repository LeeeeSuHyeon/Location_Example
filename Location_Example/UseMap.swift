//
//  Map.swift
//  Location_Example
//
//  Created by 이수현 on 2024/02/07.
//

import Foundation
import SwiftUI
import MapKit

struct UseMap : View {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    )
    
    var body : some View{
        Map(coordinateRegion: $region, showsUserLocation: true)
            .onReceive(coreLocation.$location){ newLocation in
                if let location = newLocation?.coordinate {
                    region.center = location
                }
            }
            .onAppear {
                // Map이 나타날 때 현재 위치를 표시
                if let location = coreLocation.locationManager.location?.coordinate {
                    region.center = location
                }
            }
//            .onChange(of: coreLocation.locationManager.location) { _ in
//                // 위치가 업데이트될 때 지도의 중심을 업데이트
//                if let location = coreLocation.locationManager.location?.coordinate {
//                    region.center = location
//                }
//            }
            .edgesIgnoringSafeArea(.all)
    }

}

