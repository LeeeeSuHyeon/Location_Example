//
//  CoreLocationEx.swift
//  Location_Example
//
//  Created by 이수현 on 2024/01/28.
//

import Foundation
import UIKit
import CoreLocation

class ViewController : UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 델리게이트 설정
        locationManager.delegate = self
        
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 사용자에게 허용 받기 alert 띄우기
        locationManager.requestWhenInUseAuthorization()
        
        // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()  // 위치 받아오기 시작
            print(locationManager.location?.coordinate)
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
    
}
