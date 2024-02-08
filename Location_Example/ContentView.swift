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
    
    @State var isPresented: Bool = false
    @State var start = "출발 위치"
    @State var end = "도착 위치"
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    TextField("출발 위치를 입력하시오.", text: $start)
                    TextField("도착 위치를 입력하시오.", text: $start)
                }
                Button {
                   isPresented.toggle()
                } label: {
                   Label("View in AR", systemImage: "arkit")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(24)
    
                // 3.
                .fullScreenCover(isPresented: $isPresented, content: {
                   ARTest(isPresented: $isPresented)
                })
            }
            
            UseMap(coreLocation: coreLocation)
            

        }
        
    }
}

#Preview {
    ContentView()
}


//VStack{
//    Text("위도 : \(coreLocation.locationManager.location?.coordinate.latitude ?? 0.0)")
//    Text("경도 : \(coreLocation.locationManager.location?.coordinate.longitude ?? 0.0)")
//    Text("고도 : \(coreLocation.locationManager.location?.altitude ?? 0.0)")
//    Text("수평 정확도 : \(coreLocation.locationManager.location?.verticalAccuracy ?? 0.0)")
//    Text("수직 정확도 : \(coreLocation.locationManager.location?.horizontalAccuracy ?? 0.0)")
//}
//.padding()
