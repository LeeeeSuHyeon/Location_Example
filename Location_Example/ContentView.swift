//
//  ContentView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/01/28.
//

import SwiftUI
import MapKit

// AR 환경 구축
//struct ContentView: View {
//    // 1.
//    @State var isPresented: Bool = false
//
//    var body: some View {
//        
//        Button {
//           isPresented.toggle()
//        } label: {
//           Label("View in AR", systemImage: "arkit")
//        }
//        .buttonStyle(BorderedProminentButtonStyle())
//        .padding(24)
//        
//        // 3.
//        .fullScreenCover(isPresented: $isPresented, content: {
//           ARTest(isPresented: $isPresented)
//        })
//
//    }
//}
//
//#Preview {
//    ContentView()
//}


// 위치 환경 구축
import SwiftUI
import MapKit

// CoreLocationEx 클래스 정의

struct ContentView: View {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .onAppear {
                // Map이 나타날 때 현재 위치를 표시
                if let location = coreLocation.locationManager.location?.coordinate {
                    region.center = location
                }
            }
            .onChange(of: coreLocation.locationManager.location) { _ in
                // 위치가 업데이트될 때 지도의 중심을 업데이트
                if let location = coreLocation.locationManager.location?.coordinate {
                    region.center = location
                }
            }
            .edgesIgnoringSafeArea(.all)
        
        VStack{
            Text("위도 : \(coreLocation.locationManager.location?.coordinate.latitude ?? 0.0)")
            Text("경도 : \(coreLocation.locationManager.location?.coordinate.longitude ?? 0.0)")
            Text("고도 : \(coreLocation.locationManager.location?.altitude ?? 0.0)")
            Text("수평 정확도 : \(coreLocation.locationManager.location?.verticalAccuracy ?? 0.0)")
            Text("수직 정확도 : \(coreLocation.locationManager.location?.horizontalAccuracy ?? 0.0)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
