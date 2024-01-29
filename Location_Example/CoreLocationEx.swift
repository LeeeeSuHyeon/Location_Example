//
//  CoreLocationEx.swift
//  Location_Example
//
//  Created by 이수현 on 2024/01/28.
//

import SwiftUI
import CoreLocation

class CoreLocationEx: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var altitude: Double = 0.0

    var locationManager = CLLocationManager()

    override init() {
        super.init()
        self.setupLocationManager()
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate as Any)
        } else {
            print("위치 서비스 Off 상태")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            altitude = location.altitude
        }
    }

    // This method can cause UI unresponsiveness if invoked on the main thread. Instead, consider waiting for the `-locationManagerDidChangeAuthorization:` callback and checking `authorizationStatus` first.
    // 비동기처리 하지 않으면 위와 같은 오류 발생
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.global().async {
            self.checkUserDeviceLocationServiceAuthorization()
        }
    }


    func checkUserDeviceLocationServiceAuthorization() {
        // 3.1
       guard CLLocationManager.locationServicesEnabled() else {
           // 시스템 설정으로 유도하는 커스텀 얼럿
           showRequestLocationServiceAlert()
           return
       }
           
           
       // 3.2
       let authorizationStatus: CLAuthorizationStatus
           
       // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
       if #available(iOS 14.0, *) {
           authorizationStatus = locationManager.authorizationStatus
       } else {
           authorizationStatus = CLLocationManager.authorizationStatus()
       }
           
       // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
       checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    // 앱에 대한 위치 권한이 부여된 상태인지 확인하는 메서드
       func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
           switch status {
           case .notDetermined:
               // 사용자가 권한에 대한 설정을 선택하지 않은 상태
               
               // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               
               // 권한 요청을 보낸다.
               locationManager.requestWhenInUseAuthorization()
                   
           case .denied, .restricted:
               // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
               // 시스템 설정에서 설정값을 변경하도록 유도한다.
               // 시스템 설정으로 유도하는 커스텀 얼럿
               showRequestLocationServiceAlert()
               
           case .authorizedWhenInUse:
               // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
               // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
               locationManager.startUpdatingLocation()
               
           default:
               print("Default")
           }
       }
       
       
       
       // 설정으로 이동하는 알림
       func showRequestLocationServiceAlert() {
           let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
           let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
               if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(appSetting)
               }
           }
    //        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
    //            async { await self?.reloadData }
    //        }
    //        requestLocationServiceAlert.addAction(cancel)
           requestLocationServiceAlert.addAction(goSetting)
           
//           present(requestLocationServiceAlert, animated: true)
       }
}
