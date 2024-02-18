//
//  ContentView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/01/28.
//

// 위치 환경 구축
import SwiftUI
import MapKit

// 검색 위치 정보 딕셔너리 [위치명 : [위도, 경도, 고도]]
let address : [String : [Float]] = ["AI공학관" : [37.455189, 127.133435, 61.228996],
                                    "중앙도서관" : [37.452561, 127.132950, 81.299942]]

// 검색 위치 정보 딕셔너리 [위치명 : CLLocation]
let addr: [String: CLLocation] = [
    "AI공학관 105호": CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.455189, longitude: 127.133435), altitude: 61.228996, horizontalAccuracy: 1.0, verticalAccuracy: 1.0, timestamp: Date()),
    "중앙도서관 노트북열람실": CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.452561, longitude: 127.132950), altitude: 81.299942, horizontalAccuracy: 1.0, verticalAccuracy: 1.0, timestamp: Date())
]


struct ContentView: View {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @State var isPresented: Bool = false
    @State var start = ""
    @State var end = ""
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    TextField("출발 위치를 입력하시오.", text: $start)
                        .padding()
                        .border(.black)
                    TextField("도착 위치를 입력하시오.", text: $end) // 서버에서 ai == ai공하관 == AI 작업 필요
                        .padding()
                        .border(.black)
                }
                .padding(.leading, 20)
                
                
                VStack{
                    // 위치 검색 버튼
                    Button {
                        Search(end)
                    } label: {
                        Text("Search")
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .frame(width: 100, height: 30)
                    
                    // ar 이동 버튼
                    Button {
                       isPresented.toggle()
                    } label: {
                       Label("AR", systemImage: "arkit")
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .frame(width: 100, height: 30)
        
                    // 3.
                    .fullScreenCover(isPresented: $isPresented, content: {
                       ARTest(isPresented: $isPresented)
                    })
                }

            }
                
            UseMap(coreLocation: coreLocation)
            

        }
        
    }
}

func Search(_ end : String){
    let search = addr[end]
    print(search ?? "\(end) search 없음")
    print(search?.coordinate ?? "\(end) search.coordinate 없음")
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
