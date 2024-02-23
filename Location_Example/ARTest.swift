import SwiftUI
import ARKit
import RealityKit

struct ARTest: View {
    // AR 기능 on/off 변수
    @Binding var isPresented : Bool
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    
    @State private var modelName : String =  "CC0_-_Arrow_5"
    
    // ARViewContainer에 엔티티를 추가하기 위한 플래그
    @State private var isEntityAdded = false
    
    var body: some View {
        // 뷰의 오른쪽 상단에 버튼을 배치하기 위해 ZStack을 .topTrailing 정렬 사용
        ZStack(alignment: .topTrailing){
            VStack{
                ZStack{
                    ARViewContainer(modelName: $modelName)
                        .edgesIgnoringSafeArea(.all)
                    
                    Image(modelName)
                        .resizable()
                        .frame(width: 150, height:150)
                        .tint(.blue)
                        
                }
                 UseMap(coreLocation: coreLocation)
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
    
    // 엔티티의 위도 및 경도
    let latitude: CLLocationDegrees = 37.455008
    let longitude: CLLocationDegrees = 127.127818
    
    
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
            
            // 위도 및 경도를 CLLocation으로 변환
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            // CLLocation을 ARAnchor로 변환
            let anchor = ARGeoAnchor(coordinate: location.coordinate)
            
            // ARAnchor를 ARView의 세션에 추가
            arView.session.add(anchor: anchor)
            
            // 엔티티 생성 및 추가
            let entity = ModelEntity(mesh: .generateSphere(radius: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: false)])
            
            // ARAnchor에 엔티티를 연결
            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(entity)
            
            
            // ARView의 scene에 앵커 엔티티 추가
            arView.scene.addAnchor(anchorEntity)
                    
            return arView
        }

//    func updateUIView(_ uiView: ARView, context: Context) {
//
//        // 코디네이터가 존재하고 엔티티가 추가되지 않았을 때만 실행
//        if let cameraTransform = uiView.session.currentFrame?.camera.transform,
//           !context.coordinator.isEntityAdded {
//            
//            // 카메라의 변환 행렬에서 카메라의 위치를 추출
//            let cameraPosition = simd_make_float3(cameraTransform.columns.3)
//            
//            // AnchorEntity를 생성하고 카메라의 위치에 배치
//            let anchorEntity = AnchorEntity(world: cameraPosition)
//            
//            // USDZ 파일을 로드하고 엔티티를 추가
//            if let modelEntity = try? Entity.loadModel(named: modelName) {
//                anchorEntity.addChild(modelEntity)
//                uiView.scene.addAnchor(anchorEntity)
//                
//                // 엔티티가 추가되었음을 표시
//                context.coordinator.isEntityAdded = true
//            }
//        }
    
    func updateUIView(_ uiView: ARView, context: Context) {
            // 5.a
            let anchorEntity = AnchorEntity(plane: .any)
            
            // 6.
            guard let modelEntity = try? Entity.loadModel(named: modelName) else { return }
            
            // 7.
            anchorEntity.addChild(modelEntity)
            
            // 8.
            uiView.scene.addAnchor(anchorEntity)
        }
    }

    
    // Coordinator 클래스 생성
        func makeCoordinator() -> Coordinator {
            Coordinator()
        }
        
        class Coordinator {
            // 엔티티 추가 여부 플래그
            var isEntityAdded = false
        }


