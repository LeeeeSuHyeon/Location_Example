//
//  ARViewController.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation
import UIKit
import CoreLocation
import SceneKit
import AVFoundation
import ARKit

class ARViewController : UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    
    var source: CLLocationCoordinate2D?         // 출발지 주소
    var destination: CLLocationCoordinate2D?    // 목적지 주소
    var sourcePosition = SCNVector3()           // 출발지 상대적 위치
    var destinationPosition = SCNVector3()      // 목적지 상대적 위치
    var stepData = [Step]()                     // 출발지와 목적지 사이 중간 위치들
    var name: String?                           // 경로에 대한 이름
    var sourceDetail: LocationDetails?          // 출발지 위치의 세부 정보
    var destinationDetail: LocationDetails?     // 목적지 위치의 세부 정보
    var mode: String?                           // 이동 모드
//    var apiKey = ""

    // MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ARSCNView 생성
       sceneView = ARSCNView(frame: view.bounds)
        
        // ARSCNView를 UIViewController에 추가
        view.addSubview(sceneView)
        
        // ARSCNView의 delegate 설정
        sceneView.delegate = self
        
        
        checkCameraAccess() // 카메라 엑세스 권한 환인
//        sourceDestinationLabel.text = name  // 출발지와 목적지 정보 표시
    }
    
    // 카메라 엑세스 확인 메서드
    private func checkCameraAccess() {
        
        // 현재 앱이 카메라 엑세스 허용했으면 getIntermediateCordinates() 호출하여 중간좌표를 가져옴
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
             getIntermediateCordinates()
            
        // 카메라 엑세스를 허용하지 않았으면 사용자에게 권한 요청
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                // 권한 허용
                if granted {
                    self.getIntermediateCordinates()
                // 권한 거부
                } else {
//                        self.alert(info: AlertConstants.cameraAccessErrorMessage)
                    print("checkCameraAccess : 권한 거부")
                }
            })
        }
    } // end of checkCameraAccess()
    
    
    // 중간 노드들의 정보를 계산하고 가져오는 메서드
    private func getIntermediateCordinates() {
        if let sourceDetail = sourceDetail, let destinationDetail = destinationDetail {
            source = CLLocationCoordinate2D(latitude: sourceDetail.lat, longitude: sourceDetail.lng)
            destination = CLLocationCoordinate2D(latitude: destinationDetail.lat, longitude: destinationDetail.lng)
            
            // 중간 노드(Steps)를 받아옴
            let steps = GetIntermediateCordinate.getCordinates(source: sourceDetail, destination: destinationDetail)
            self.stepData = steps
            arConfigurationInitialize()
            arViewSetup()
          }
    } // end of getIntermediateCordinates()
    
    
    // AR 환경 초기화 메서드
    private func arConfigurationInitialize() {
        if  ARWorldTrackingConfiguration.isSupported { // 장치가 ARWorldTrackingConfiguration 지원하는지 확인
            let configuration = ARWorldTrackingConfiguration() // AR 환경 설정
            configuration.worldAlignment = .gravityAndHeading // 중력과 디바이스의 방향에 따라 정렬
            sceneView.session.run(configuration) // AR 세션 시작
        } else {
//            alert(info: AlertConstants.arErrorMessage) // AR 에러 메시지
            print("arConfigurationInitialize - Error")
        }
    } // end of arConfigurationInitialize()
    
    
    // AR 뷰 설정
    private func arViewSetup() {
        placeSourceNode() // 출발지 노드 배치
        if let source = source, let destination = destination {
            for intermediateLocation in stepData.enumerated() {
                var text = "\(TextNodeConstant.direction) : " + intermediateLocation.element.locationName
                text += "\n \(TextNodeConstant.distance) :" + intermediateLocation.element.distance
                text += " \n \(TextNodeConstant.duration) : " + intermediateLocation.element.duration
                placeDestinationNode(source: source, destination: intermediateLocation.element.endLocation, text: text)
            }
            placeDestinationNode(source: source, destination: destination, text: TextNodeConstant.destination)
        }
    } // end of arViewSetup()
    
    
    // 출발지 노드 AR 환경에 배치
    private func placeSourceNode() {
        let box = SCNBox(width: ArkitNodeDimension.sourceNodeWidth, height: ArkitNodeDimension.sourceNodeHeight, length: ArkitNodeDimension.sourceNodeLength, chamferRadius: ArkitNodeDimension.sourceChamferRadius)
        let sourceNode = SCNNode(geometry: box)
        sourceNode.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
        sourceNode.position = SCNVector3(0, -(ArkitNodeDimension.nodeYPosition), 0)
        sceneView.scene.rootNode.addChildNode(sourceNode)
    } // end of placeSourceNode()
    
    
    // 목적지 노드를 AR 환경에 배치
    private func placeDestinationNode(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, text: String) {
            let distance = distanceBetweenCoordinate(source: source, destination: destination)
            let destinationNode = SCNNode(geometry: intermediateNodeGeometry())
            let  transformationMatrix = transformMatrix(source: source, destination: destination, distance: distance, text: text)
            destinationNode.transform = transformationMatrix
            sceneView.scene.rootNode.addChildNode(destinationNode)
            placeCylinder(source: sourcePosition, destination: destinationNode.position)
            let directionTextNode = placeDirectionText(textPosition: destinationNode.position, text: text)
            destinationNode.addChildNode(directionTextNode)
            sourcePosition = destinationNode.position
    } // end of placeDestinationNode()
    
    
    // 두 좌표 간 거리 계산
    private func distanceBetweenCoordinate(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Double {
            let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
            let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
            let distance = sourceLocation.distance(from: destinationLocation)
            return distance
    } // end of distanceBetweenCoordinate
    
    
    // 중간노드의 기하학 모양 정의, 노드 생성
    private func intermediateNodeGeometry() -> SCNBox {
        let intermediateBox = SCNBox(width: ArkitNodeDimension.destinationNodeWidth, height: ArkitNodeDimension.destinationNodeHeight, length: ArkitNodeDimension.destinationNodeLength, chamferRadius: ArkitNodeDimension.destinationChamferRadius)
        intermediateBox.firstMaterial?.diffuse.contents = UIColor.purple
        return intermediateBox
    } // end of itermediateNodeGeometry
    
    
    // 출발지와 목적지 사이의 변환 행렬 계산 후 노드 위치 방향 설정
    private func transformMatrix(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, distance: Double, text: String) -> SCNMatrix4 {
       let translation = SCNMatrix4MakeTranslation(0, 0, Float(-distance)) // 이동행렬
//       let rotation = SCNMatrix4MakeRotation(-1 * GLKMathDegreesToRadians(Float(GMSGeometryHeading(source, destination))), 0, 1, 0) // 회전행렬
        // GMSGeometryHeading : 베어링 각도를 구해야 함
        let rotation = SCNMatrix4MakeRotation(-1, 0, 1, 0)
       let transformationMatrix = SCNMatrix4Mult(translation, rotation)
       return (transformationMatrix)
    } // end of tansformMatrix
    
    
    // 출발지와 목적지 사이에 실린더 노드 배치하는 역할
    private func placeCylinder(source: SCNVector3, destination: SCNVector3) {
        let  height = source.distance(receiver: destination)
        let  cylinder = SCNCylinder(radius: ArkitNodeDimension.cylinderRadius, height: CGFloat(height))
        cylinder.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode(geometry: cylinder)
        node.position = SCNVector3((source.x + destination.x) / 2, Float(-(ArkitNodeDimension.nodeYPosition)), (source.z + destination.z) / 2)
        let dirVector = SCNVector3Make(destination.x - source.x, destination.y - source.y, destination.z - source.z)
        let yAngle = atan(dirVector.x / dirVector.z)
        node.eulerAngles.x = .pi / 2
        node.eulerAngles.y = yAngle
        sceneView.scene.rootNode.addChildNode(node)
    } // end of placeCylinder 
    
    
    
    // 3D 텍스트 노드를 생성 후 방향 제어
    private func placeDirectionText(textPosition: SCNVector3, text: String) -> SCNNode {
        let textNode = SCNNode(geometry: getIntermediateNodeText(text: text))
        textNode.constraints = [SCNBillboardConstraint()]
        return textNode
    } // end of placeDirectionText
    
    
    // 3D 텍스트 객체 생성 함수
    private func getIntermediateNodeText(text: String) -> SCNText {
        let intermediateNodeText = SCNText(string: text, extrusionDepth: ArkitNodeDimension.textDepth)
        intermediateNodeText.font = UIFont(name: "Optima", size: ArkitNodeDimension.textSize)
        intermediateNodeText.firstMaterial?.diffuse.contents = UIColor.red
        intermediateNodeText.containerFrame = CGRect(x: 0.0, y: 0.0, width: 20, height: 10)
        intermediateNodeText.isWrapped = true
        return intermediateNodeText
    } // end of getIntermediateNodeText
}
