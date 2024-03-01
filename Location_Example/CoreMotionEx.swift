import SwiftUI
import CoreMotion
import Alamofire

// - ObservableObject를 준수하여 데이터 바인딩을 가능하게 함
// - 데이터의 변경 사항을 SwiftUI에 알릴 수 있음
class MotionManager: ObservableObject {
    
    private let motionManager = CMMotionManager() //  인스턴스를 사용하여 기기의 모션 데이터를 캡처하고 관리
    
    // @Published로 표시되어 있어 데이터가 변경될 때 SwiftUI에게 알리고 해당 데이터를 관리
    @Published var acceleration: CMAcceleration? // CMAcceleration은 가속도를 나타내는 데이터
    @Published var gryo : CMGyroData?
    @Published var magentometer : CMMagneticField?

    // MotionManger 클래스의 초기화 메서드
    init() {
        // 가속도 데이터 업데이트 간격 설정 (1초)
        motionManager.accelerometerUpdateInterval = 2
        motionManager.gyroUpdateInterval = 2
        motionManager.magnetometerUpdateInterval = 2
        
        // Acceleromter 가속도 데이터 감지 시작
        // 이 메서드는 가속도 데이터가 업데이트될 때마다 제공된 클로저를 호출
        motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
            guard let accelerometerData = accelerometerData else { return }
            self.acceleration = accelerometerData.acceleration
        }
        
        // gryo 자이로스코프 데이터 감지 시작
        // 이 메서드는 자이로스코프 데이터가 업데이트될 때마다 제공된 클로저를 호출
        motionManager.startGyroUpdates(to: .main) { gryoData, error in
            guard let gryo = gryoData else { return }
            self.gryo = gryo
        }
        
        // Acceleromter 자기장 감지 시작
        // 이 메서드는 자기장 업데이트될 때마다 제공된 클로저를 호출 (자기계의 자기장 벡터)
        motionManager.startMagnetometerUpdates(to: .main) { magentomerData, error in
            guard let magenetometer = magentomerData else { return }
            self.magentometer = magentomerData?.magneticField
        }
    }
}

struct CoreMotionEx: View {

    // MotionManager의 인스턴스를 생성하고, @ObservedObject 속성으로 표시하여 해당 인스턴스의 변경 사항을 관찰
    @ObservedObject var motionManager = MotionManager()
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    // post 요청 후 받을 data
    @State private var responseData: String = ""

    var body: some View {
        VStack {
            if let acceleration = motionManager.acceleration {
                // acceleration.x : x축 가속도
                Text("X: \(acceleration.x), Y: \(acceleration.y), Z: \(acceleration.z)")
            } else {
                Text("No acceleration data")
            }
            
            if let gryo = motionManager.gryo {
                // gyro.rotationRate.x : x축 회전 속도
                Text("X: \(gryo.rotationRate.x), Y: \(gryo.rotationRate.y), Z: \(gryo.rotationRate.z)")
            } else {
                Text("No gryo data")
            }
            
            if let magentometer = motionManager.magentometer{
                //  X, Y 및 Z 값은 각각 기기의 가로, 세로 및 수직 방향의 자기장 세기
                Text("X : \(magentometer.x), Y: \(magentometer.y), Z: \(magentometer.z)")
            } else {
                Text("No magnetometer data")
            }
            
            if let location = coreLocation.location {
                Text("altitude : \(location.altitude)")
            } else {
                Text("No location - altitude data")
            }
        }
        .onAppear{
            // 2초에 한 번씩 postData 함수 호출
            Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true){ timer in
                
                var date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = dateFormatter.string(from: date)
                
                
                var param = coreMotionRequest(
                    accValueX: Double(motionManager.acceleration?.x ?? 0),
                    accValueY: Double(motionManager.acceleration?.y ?? 0),
                    accValueZ: Double(motionManager.acceleration?.z ?? 0),
                    gyroValueX: Double(motionManager.gryo?.rotationRate.x ?? 0),
                    gyroValueY: Double(motionManager.gryo?.rotationRate.y ?? 0),
                    gyroValueZ: Double(motionManager.gryo?.rotationRate.z ?? 0),
                    magValueX: Double(motionManager.magentometer?.x ?? 0),
                    magValueY: Double(motionManager.magentometer?.y ?? 0),
                    magValueZ: Double(motionManager.magentometer?.z ?? 0),
                    apValue: Double(coreLocation.location?.altitude ?? 0),
                    time: dateString)
                print("dataString : ", dateString)
                postData(parameter : param)
            }
        }
    }
    
    func postData(parameter : coreMotionRequest) {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "https://c896-210-119-237-40.ngrok-free.app/save/data") else {
            print("Invalid URL")
            return
        }
        
        // Alamofire를 사용하여 GET 요청 생성
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseString { response in
            // 에러 처리
            switch response.result {
            case .success(let value):
                // 성공적인 응답 처리
                self.responseData = value
            case .failure(let error):
                // 에러 응답 처리
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

