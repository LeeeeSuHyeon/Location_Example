//
//  Map.swift
//  Location_Example
//
//  Created by 이수현 on 2024/02/07.
//

import Foundation
import SwiftUI
import MapKit

// Map 뷰의 annotationItems 매개변수에 전달된 배열의 요소는 Identifiable 프로토콜을 준수해야 함
// onChnage() 메서드로 annotations의 변화를 확인하려면 Equatable 프로토콜을 준수해야 함
struct Address : Identifiable, Equatable {
    static func == (lhs: Address, rhs: Address) -> Bool {
        lhs.id == rhs.id    // id가 같으면 같은 인스턴스로 취급
    }
    
    let id = UUID()
    let name : String
    let address : CLLocationCoordinate2D
}

class UseMapViewModel: ObservableObject {
    @Published var annotations = [Address]()

    func setMapView(coordinate: CLLocationCoordinate2D, addr: String) {
        print("called UseMapViewModel()")
        let newAddress = Address(name: addr, address: coordinate)
        annotations.append(newAddress)
        print(annotations)
    }
}


struct UseMap : View {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @ObservedObject var viewModel = UseMapViewModel()
    
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    )
    
    var body : some View {
        if viewModel.annotations.isEmpty {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .onReceive(coreLocation.$location) { newLocation in
                    if let location = newLocation?.coordinate {
                        // Map이 나타날 때 현재 위치를 표시
                        region.center = location
                    }
                }
                .onAppear {
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
        } else {
            // annotationContent 매개변수가 필요하며, 이는 맵 뷰에서 각 애노테이션을 어떻게 표시할지에 대한 클로저
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: viewModel.annotations) { address in
                MapMarker(coordinate: address.address, tint: .red)
            }
            .onAppear{
                print("else Map - onAppear")
                if let location = viewModel.annotations.last?.address {
                    region.center = location
                }
            }
            .mapControlVisibility(.hidden)
            .onChange(of: viewModel.annotations) { _ in
                // 마커가 추가될 때마다 지도의 중심을 가장 최근에 추가된 마커의 위치로 업데이트
                if let location = viewModel.annotations.last?.address {
                    region.center = location
                }
            }
            
        }
    }
    
    
    
//    // MARK : 검색한 위치로 이동 & marker 추가
//    func setMapView(coordinate: CLLocationCoordinate2D, addr: String) {
//        print("called setMapView()")
//        region.center = coordinate
//        let addr = Address(name: addr, address: coordinate)
//        self.annotations.append(addr)
////        let annotation = MKPointAnnotation()
////        annotation.coordinate = coordinate
////        annotation.title = addr
//        
//    }

}

