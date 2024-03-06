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
        let ex : [SCNVector3] = [SCNVector3(x: -1.0, y: -0.0, z: -0.0),
                                 SCNVector3(x: 1.0, y: -0.0, z: -0.0),
                                 SCNVector3(x: -1.0, y: -0.0, z: -0.3),
                                 SCNVector3(x: 1.0, y: -0.0, z: -0.3)]
        
        // 상대적인 좌표를 사용하여 경로 노드에 선을 추가
        let pathLine = SCNNode(geometry: SCNGeometry.line(from: ex, thickness: 10))
        routeNode.addChildNode(pathLine)
        
        
        // Scene에 경로 노드 추가
        scene.rootNode.addChildNode(routeNode)
    }
}

extension SCNGeometry {
    static func line(from points: [SCNVector3], thickness: CGFloat) -> SCNGeometry {
        var vertices: [SCNVector3] = [] // 사각형의 꼭지점을 저장할 배열
        var normals: [SCNVector3] = [] // 법선 벡터를 저장할 배열
        var indices: [Int32] = [] // 정점 인덱스를 저장할 배열

        // 직사각형의 정점과 법선 벡터를 계산합니다.
        for i in 0..<points.count {
            let point = points[i]

            // 직선 세그먼트에 대한 수직 벡터를 계산합니다.
            let nextPoint = points[(i + 1) % points.count]
            let diffVector = nextPoint - point
            let perpendicularVector = SCNVector3(-diffVector.z, 0, diffVector.x).normalized()

            // 직사각형의 네 꼭지점을 계산합니다.
            let halfThickness = Float(thickness) / 2.0
            let topLeft = point + perpendicularVector * halfThickness
            let topRight = nextPoint + perpendicularVector * halfThickness
            let bottomLeft = point - perpendicularVector * halfThickness
            let bottomRight = nextPoint - perpendicularVector * halfThickness

            // 정점을 추가합니다.
            vertices.append(contentsOf: [topLeft, topRight, bottomRight, bottomLeft])
            
            // 법선을 추가합니다.
            normals.append(contentsOf: [SCNVector3(0, 1, 0), SCNVector3(0, 1, 0), SCNVector3(0, 1, 0), SCNVector3(0, 1, 0)])

            // 정점 인덱스를 추가합니다.
            let baseIndex = Int32(i * 4)
            indices.append(contentsOf: [baseIndex, baseIndex + 1, baseIndex + 2, baseIndex, baseIndex + 2, baseIndex + 3])
        }

        // Geometry sources를 생성합니다.
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let normalSource = SCNGeometrySource(normals: normals)

        // Geometry element를 생성합니다.
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)

        // Geometry를 생성합니다.
        let geometry = SCNGeometry(sources: [vertexSource, normalSource], elements: [element])
        
        // Geometry에 적절한 머티리얼을 설정합니다.
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue // 원하는 색상을 설정합니다.

        geometry.materials = [material]
        
        return geometry
    }

    
    
    
//    // 상대적인 좌표들을 이어서 선을 만드는 메서드
//    static func line(from points: [SCNVector3], tickness : CGFloat) -> SCNGeometry {
//        let sources = SCNGeometrySource(vertices: points)
//        var indices: [Int32] = []
//        for i in 0..<points.count {
//            indices.append(Int32(i))
//        }
//        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
//
//        // 두께와 색상을 적용하여 머티리얼을 생성합니다.
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.blue
//        
//        // 두꺼운 선을 위한 머티리얼을 설정합니다.
//        material.isDoubleSided = true
//        material.lightingModel = .constant
//        material.emission.contents = UIColor.red
//        material.transparency = 0.7 // 불투명도
//        
//        // 머티리얼을 사용하여 두꺼운 선의 형태를 정의합니다.
//        let geometry = SCNGeometry(sources: [sources], elements: [element])
//        geometry.materials = [material]
//        
//        // 두꺼운 선의 머티리얼을 설정합니다.
//        return geometry
//    }
}

// 벡터 덧셈 및 곱셈을 추가하는 확장
extension SCNVector3 {
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    static func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
        return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
    }

    func normalized() -> SCNVector3 {
        let length = sqrt(x * x + y * y + z * z)
        return SCNVector3(x / length, y / length, z / length)
    }
}
