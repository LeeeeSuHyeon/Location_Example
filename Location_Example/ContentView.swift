//
//  ContentView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/01/28.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    // ContentView가 초기화될 때 CoreLocationEx 인스턴스 생성
    @ObservedObject private var coreLocation = CoreLocationEx()
    
    var body: some View {
        
        var latitude = coreLocation.latitude
        var longitude = coreLocation.longitude
        
        @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        Map(coordinateRegion: $region)
        
        
        VStack{
            Text("위도 : \(coreLocation.locationManager.location?.coordinate.latitude ?? 0.0)")
            Text("경도 : \(coreLocation.locationManager.location?.coordinate.longitude ?? 0.0)")
            Text("고도 : \(coreLocation.locationManager.location?.altitude ?? 0.0)")
            Text("수평 정확도 : \(coreLocation.locationManager.location?.verticalAccuracy ?? 0.0)")
            Text("수직 정확도 : \(coreLocation.locationManager.location?.horizontalAccuracy ?? 0.0)")
            
            
            
//            Text("위도: \(coreLocation.latitude)")
//            Text("경도: \(coreLocation.longitude)")
//            Text("고도: \(coreLocation.altitude)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
