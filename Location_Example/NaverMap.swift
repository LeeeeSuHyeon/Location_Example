//
//  NaverMap.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/02.
//

import SwiftUI
import NMapsMap


struct NaverMap: View {
    
    var body: some View {
        NaMapView()
            .edgesIgnoringSafeArea(.all)
    }
}



struct NaMapView: UIViewRepresentable {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView() // 지도 객체 생성
        
        mapView.showCompass = true // 나침반
        mapView.showScaleBar = true // 축척 바
        mapView.showZoomControls = true // 줌 버튼
        mapView.showLocationButton = true // 현위치 버튼
        
        
        return mapView
    }

    func updateUIView(_ mapView: NMFNaverMapView, context: Context) {
        
        // 위치 정보가 제대로 전달되었는지 확인하고 전달된 경우에만 위도와 경도를 사용합니다.
        if let location = coreLocation.location {
            let latitude = location.coordinate.latitude // 현재 위도
            let longitude = location.coordinate.longitude // 현재 경도
            
            mapView.mapView.locationOverlay.hidden = true // 위치 오버레이 활성화
            mapView.mapView.locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude) // 현재위치로 오버레이 설정
            mapView.mapView.positionMode = .compass // 위치 추적 활성화, 현위치 오버레이, 카메라 좌표, 헤딩이 사용자 위치 및 방향을 따라 움직임
            
            let cameraUpdate =  NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude)) // 현재 위치로 카메라 위치 변경,
            mapView.mapView.moveCamera(cameraUpdate)
        }
    }
}
