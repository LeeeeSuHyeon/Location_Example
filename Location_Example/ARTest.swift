import SwiftUI
import ARKit
import RealityKit

struct ARTest: View {
    // AR 기능 on/off 변수
    @Binding var isPresented : Bool
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @State private var modelName : String =  "CC0_-_Arrow_5"
    
    // 집 - 엔티티의 위도 및 경도
    let latitude: [CLLocationDegrees] = [37.455008, 37.455008, 37.455008, 37.4550075, 37.4550075, 37.4550075, 37.455007, 37.455007, 37.455007]
    let longitude: [CLLocationDegrees] = [127.127830, 127.127820, 127.127825, 127.127825, 127.127830, 127.127820,127.127830,127.127825,127.127820]
    let targetLocation = CLLocation(latitude: 37.45502080771848, longitude: 127.12796925578931)
    
    
    // 사용자가 설정한 위치
//    @State private var userLocation: CLLocation?
    
    
    var body: some View {
        // 뷰의 오른쪽 상단에 버튼을 배치하기 위해 ZStack을 .topTrailing 정렬 사용
        ZStack(alignment: .topTrailing){
            VStack{
                ARViewContainer(
                    targetLocation: targetLocation,
                    targetLatitude: latitude,
                    targetLongitude: longitude,
                    modelName: $modelName
                )
                .edgesIgnoringSafeArea(.all)

//                 UseMap(coreLocation: coreLocation)
            }
           
            
            Button(){
                isPresented.toggle()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .background(.ultraThinMaterial) // .ultraThinMaterial 속성을 이용하여 버튼 뒤를 가리지 않도록 설정
                    .clipShape(Circle())
            }
            .padding(24)
        }
        
    }
        
}


struct ARViewContainer: UIViewRepresentable {
    
    // 목표 위치
    let targetLocation: CLLocation
    let targetLatitude : [CLLocationDegrees]
    let targetLongitude : [CLLocationDegrees]
    
    
//    // 집 - 엔티티의 위도 및 경도
//    let latitude: [CLLocationDegrees] = [37.4550002, 37.454986572265625, 37.455015, 37.455040, 37.455004, 37.455008, 37.455008, 37.455008]
//    let longitude: [CLLocationDegrees] = [127.127829002, 127.12797670696119, 127.127904, 127.127850, 127.127829, 127.127830, 127.127840, 127.127850]
    
    
    // AI관 - 엔티티의 위도 및 경
//    let latitude: [CLLocationDegrees] = [37.455062, 37.455102, 37.455079, 37.455100, 37.455077, 37.455122, 37.455072, 37.455077]
//    let longitude: [CLLocationDegrees] = [127.133291, 127.133282, 127.133212, 127.133515, 127.133598, 127.133613, 127.133331, 127.133346]
    
    
    @Binding var modelName: String
    
        // 2.
        func makeUIView(context: Context) -> ARView {
            // 2.a
            let arView = ARView(frame: .zero)
            
            // 3.
            let config = ARWorldTrackingConfiguration()
                    // 3.a
            config.planeDetection = [.horizontal, .vertical]
                    // 3.b
            config.environmentTexturing = .automatic
            
            // 4.
            arView.session.run(config)
            
            
            // 엔티티 추가
            addEntity(arView: arView)
                    
            return arView
        }
    
    func addEntity(arView: ARView) {
        print("addEntity - called")
        
        for i in 0..<targetLatitude.count {
               let targetPosition = SIMD3<Float>(
                   Float(targetLongitude[i]),
                   0, // Assuming flat ground, no altitude difference
                   Float(targetLatitude[i])
               )
               
               // 엔티티 생성 및 배치
               let entity = ModelEntity(mesh: .generateSphere(radius: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: true)])
               let anchor = AnchorEntity(world: targetPosition)
               anchor.addChild(entity)
               arView.scene.addAnchor(anchor)
           }
        print("anchor : ", arView.scene.anchors.count)

    }



    
    func updateUIView(_ arView: ARView, context: Context) {
//            // 5.a
//            let anchorEntity = AnchorEntity(plane: .any)
//
//            // 6.
//        guard let modelEntity = try? Entity.loadModel(named: modelName) else {
//            print("Failed to load model entity")
//            return
//        }
//
//            // 7.
//            anchorEntity.addChild(modelEntity)
//
//            // 8.
//            uiView.scene.addAnchor(anchorEntity)
        
        
        
//            for i in 0..<latitude.count{
//                // 위도 및 경도를 CLLocation으로 변환
//                let location = CLLocation(latitude: latitude[i], longitude: longitude[i])
//                
//                // CLLocation을 ARAnchor로 변환
//                let anchor = ARGeoAnchor(name : "arrow", coordinate: location.coordinate)
//                
//                // ARAnchor를 ARView의 세션에 추가
//                arView.session.add(anchor: anchor)
//                
//                
//                // 엔티티 생성 및 추가
//                guard let modelEntity = try? ModelEntity(mesh: .generateSphere(radius: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: false)]) else {
//                    print("entity - Error")
//                    return
//                }
//
//                // ARAnchor에 엔티티를 연결
//                let anchorEntity = AnchorEntity(anchor: anchor)
//                anchorEntity.addChild(modelEntity)
//                
//                
//                // ARView의 scene에 앵커 엔티티 추가
//                arView.scene.addAnchor(anchorEntity)
//            }
        }
        
    }

