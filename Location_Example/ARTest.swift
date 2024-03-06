import SwiftUI
import ARKit
import RealityKit

struct ARTest: View {
    // AR 기능 on/off 변수
    @Binding var isPresented : Bool
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation: CoreLocationEx
    
    var body: some View {
        // 뷰의 오른쪽 상단에 버튼을 배치하기 위해 ZStack을 .topTrailing 정렬 사용
        ZStack(alignment: .topTrailing){
            VStack{
                ARViewContainer(coreLocation: coreLocation)
                .edgesIgnoringSafeArea(.all)

                NaverMap(coreLocation : coreLocation)
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
    
    @ObservedObject var coreLocation: CoreLocationEx
    
    let route : [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315),
        CLLocationCoordinate2D(latitude: 37.455179, longitude: 127.132041),
        CLLocationCoordinate2D(latitude: 37.454974, longitude: 127.131895),
        CLLocationCoordinate2D(latitude: 37.455043, longitude: 127.131246),
        CLLocationCoordinate2D(latitude: 37.455486, longitude: 127.129632),
        CLLocationCoordinate2D(latitude: 37.454869, longitude: 127.128768),
        CLLocationCoordinate2D(latitude: 37.454814, longitude: 127.127927),
        CLLocationCoordinate2D(latitude: 37.455010, longitude: 127.127867)
    ]
    
//    @Binding var modelName: String
    
    // 2.
    func makeUIView(context: Context) -> ARSCNView {
        
        // ARSCNView 인스턴스 생성
        let arView = ARSCNView()
        
        // ARScene 생성
        let scene = SCNScene()

        // ARScene을 ARSCNView에 할당
        arView.scene = scene
        
        drawRoute(on: scene, userLocation: coreLocation.location!, routeCoordinates: route)
        
        // 3.
        let config = ARWorldTrackingConfiguration()
        
        // 4.
        arView.session.run(config)
                
        return arView
    }


    
    func updateUIView(_ arView: ARSCNView, context: Context) {
        
        }
    
    func drawRoute(on scene: SCNScene, userLocation: CLLocation, routeCoordinates: [CLLocationCoordinate2D]) {
        // 경로를 표시할 노드 생성
        let routeNode = SCNNode()
        
        // 상대적 위치 배열
        var relativeRoute = [SCNVector3]()
        
        // 사용자의 현재 위치를 SCNVector3로 변환 (x : 수평(경도), y : 수직(위도), z : 깊이(거리)) -> 일반적인 좌표쳬계와 다르게 해석됨
        let userPosition = SCNVector3(x: Float(userLocation.coordinate.longitude), y: 0, z: Float(-userLocation.coordinate.latitude))
        
        // 경로 노드에 경로의 각 좌표를 추가
        for coordinate in routeCoordinates {
            // 경로 좌표를 SCNVector3로 변환
            let routePosition = SCNVector3(x: Float(coordinate.longitude), y: 0, z: Float(-coordinate.latitude))
            
            // 사용자의 현재 위치와 경로 좌표 사이의 거리와 방향을 계산하여 오일러 각도로 변환
            let distance = userLocation.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            
            // 경로 좌표와 사용자 위치의 차이를 이용하여 방향을 계산합니다.
            let direction = atan2(coordinate.latitude - userLocation.coordinate.latitude, coordinate.longitude - userLocation.coordinate.longitude)

            
            // 경로 노드의 위치 설정
            let routeNodePosition = SCNVector3(x: Float(distance * cos(direction)),
                                               y: 0,
                                               z: Float(-distance * sin(direction)))
            
            // 상대적 위치 배열에 추가
            relativeRoute.append(routeNodePosition)
        }
        print("drawRoute - relativeRoute : \(relativeRoute)")
        
        // x가 음수먼 왼쪽? z가 앞쪽 y 는 위아래인듯 
        let ex : [SCNVector3] = [SCNVector3(x: -0.0, y: -0.0, z: -1.0),
                                 SCNVector3(x: -0.0, y: -0.0, z: -2.0),
                                 SCNVector3(x: -0.0, y: -0.0, z: -3.0),
                                 SCNVector3(x: -0.0, y: -0.0, z: -4.0)]
        
        // 상대적인 좌표를 사용하여 경로 노드에 선을 추가
        let pathLine = SCNNode(geometry: SCNGeometry.line(from: ex))
        routeNode.addChildNode(pathLine)
        
        // Scene에 경로 노드 추가
        scene.rootNode.addChildNode(routeNode)
    }
}

extension SCNGeometry {
    // 상대적인 좌표들을 이어서 선을 만드는 메서드
    static func line(from points: [SCNVector3]) -> SCNGeometry {
        let sources = SCNGeometrySource(vertices: points)
        var indices: [Int32] = []
        for i in 0..<points.count {
            indices.append(Int32(i))
        }
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        // 두께와 색상을 적용하여 머티리얼을 생성합니다.
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        
        // 두꺼운 선을 위한 머티리얼을 설정합니다.
        material.isDoubleSided = true
        material.lightingModel = .constant
        material.emission.contents = UIColor.blue
        material.transparency = 0.8 // 불투명도
        
        // 머티리얼을 사용하여 두꺼운 선의 형태를 정의합니다.
        let geometry = SCNGeometry(sources: [sources], elements: [element])
        geometry.materials = [material]
        
        // 두꺼운 선의 머티리얼을 설정합니다.
        return geometry
    }
}

