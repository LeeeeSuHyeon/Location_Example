import SwiftUI
import ARKit
import RealityKit

struct ARTest: View {
    // AR 기능 on/off 변수
    @Binding var isPresented : Bool
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation: CoreLocationEx
    
//    @State private var modelName : String =  "CC0_-_Arrow_5"
    
    var body: some View {
        // 뷰의 오른쪽 상단에 버튼을 배치하기 위해 ZStack을 .topTrailing 정렬 사용
        ZStack(alignment: .topTrailing){
            VStack{
                ARViewContainer(
//                    modelName: $modelName
                )
                .edgesIgnoringSafeArea(.all)

                NaverMap(coreLocation : coreLocation)
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
    
    
//    @Binding var modelName: String
    
    // 2.
    func makeUIView(context: Context) -> ARSCNView {
        
        // ARSCNView 인스턴스 생성
        let arView = ARSCNView()
        
        // ARScene 생성
        let scene = SCNScene()
        
        // Scene에 3D 객체 추가
//        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        let boxNode = SCNNode(geometry: boxGeometry)
//        boxNode.position = SCNVector3(0, 0, -0.5)
//        scene.rootNode.addChildNode(boxNode)

        // ARScene을 ARSCNView에 할당
        arView.scene = scene
        
        drawRoute(on: scene)
        
        // 3.
        let config = ARWorldTrackingConfiguration()
        // 3.a
//        config.planeDetection = [.horizontal, .vertical]
//        // 3.b
//        config.environmentTexturing = .automatic
        
        // 4.
        arView.session.run(config)
                
        return arView
    }


    
    func updateUIView(_ arView: ARSCNView, context: Context) {
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
        
        }
    
    func drawRoute(on scene: SCNScene) {
        let route : [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315),
            CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
            CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
            CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
            CLLocationCoordinate2D(latitude: 37.455486, longitude: 127.129632),
            CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
            CLLocationCoordinate2D(latitude: 37.454814, longitude: 127.127927),
            CLLocationCoordinate2D(latitude: 37.455010, longitude: 127.127867),
            CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315)
        ]
        
        // 경로를 표시할 노드 생성
        let routeNode = SCNNode()

        // 경로의 모양을 결정하는 도형 생성
        let routeShape = SCNShape(path: createPath(points: route), extrusionDepth: 0.1)
        routeShape.firstMaterial?.diffuse.contents = UIColor.blue // 경로의 색상 설정

        // 경로 노드에 도형을 적용
        routeNode.geometry = routeShape

        // 경로 노드의 위치 설정 (AR 환경 상에서 경로가 어디에 표시될지)
        routeNode.position = SCNVector3(0, 0, -1) // 적절한 위치로 조정 필요

        // 경로 노드를 Scene에 추가
            scene.rootNode.addChildNode(routeNode)
    }
    
    
    // 경로의 좌표들을 SceneKit에서 사용할 수 있는 경로로 변환
    func createPath(points: [CLLocationCoordinate2D]) -> UIBezierPath {
        let path = UIBezierPath()
        guard let firstPoint = points.first else { return path } // 경로의 시작 지점

        // 경로의 시작점 설정
        path.move(to: CGPoint(x: CGFloat(firstPoint.longitude), y: CGFloat(firstPoint.latitude)))

        // 나머지 경로의 점들을 연결
        for point in points.dropFirst() {
            path.addLine(to: CGPoint(x: CGFloat(point.longitude), y: CGFloat(point.latitude)))
        }

        return path
    }
        
}

