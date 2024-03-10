//
//  MatrixHelper.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/09.
//

import Foundation
import GLKit.GLKMatrix4
import SceneKit
import CoreLocation



class MatrixHelper {
    
    //    column 0  column 1  column 2  column 3
    //         1        0         0       X          x        x + X*w 
    //         0        1         0       Y      x   y    =   y + Y*w 
    //         0        0         1       Z          z        z + Z*w 
    //         0        0         0       1          w           w    
    
    // 변환 행렬
    static func translationMatrix(with matrix: matrix_float4x4, for translation : vector_float4) -> matrix_float4x4 {
        var matrix = matrix
        matrix.columns.3 = translation
        return matrix
    }
    
    //    column 0  column 1  column 2  column 3
    //        cosθ      0       sinθ      0    
    //         0        1         0       0    
    //       −sinθ      0       cosθ      0    
    //         0        0         0       1    
        
    // 회전 행렬
    static func rotateAroundY(with matrix: matrix_float4x4, for degrees: Float) -> matrix_float4x4 {
        var matrix : matrix_float4x4 = matrix
        
        matrix.columns.0.x = cos(degrees)
        matrix.columns.0.z = -sin(degrees)
        
        matrix.columns.2.x = sin(degrees)
        matrix.columns.2.z = cos(degrees)
        return matrix.inverse
    }
    
    
    static func transformMatrix(for matrix: simd_float4x4, originLocation: CLLocation, location: CLLocation) -> simd_float4x4 {
        let distance = Float(location.distance(from: originLocation))
        let bearing = GLKMathDegreesToRadians(Float(originLocation.coordinate.direction(to: location.coordinate)))
        let position = vector_float4(0.0, 0.0, -distance, 0.0)
        let translationMatrix = MatrixHelper.translationMatrix(with: matrix_identity_float4x4, for: position)
        let rotationMatrix = MatrixHelper.rotateAroundY(with: matrix_identity_float4x4, for: bearing)
        let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
        return simd_mul(matrix, transformMatrix)
    }
}


let metersPerRadianLat: Double = 6373000.0
let metersPerRadianLon: Double = 5602900.0



extension CLLocationCoordinate2D {
    
  func calculateBearing(to coordinate: CLLocationCoordinate2D) -> Double {
    let a = sin(coordinate.longitude.toRadians() - longitude.toRadians()) * cos(coordinate.latitude.toRadians())
    let b = cos(latitude.toRadians()) * sin(coordinate.latitude.toRadians()) - sin(latitude.toRadians()) * cos(coordinate.latitude.toRadians()) * cos(coordinate.longitude.toRadians() - longitude.toRadians())
    return atan2(a, b)
  }
  
  func direction(to coordinate: CLLocationCoordinate2D) -> CLLocationDirection {
    return self.calculateBearing(to: coordinate).toDegrees()
  }
//    
//    func coordinate(with bearing: Double, and distance: Double) -> CLLocationCoordinate2D {
//        
//        let distRadiansLat = distance / metersPerRadianLat  // earth radius in meters latitude
//        let distRadiansLong = distance / metersPerRadianLon // earth radius in meters longitude
//        
//        let lat1 = self.latitude.toRadians()
//        let lon1 = self.longitude.toRadians()
//        
//        let lat2 = asin(sin(lat1) * cos(distRadiansLat) + cos(lat1) * sin(distRadiansLat) * cos(bearing))
//        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadiansLong) * cos(lat1), cos(distRadiansLong) - sin(lat1) * sin(lat2))
//        
//        return CLLocationCoordinate2D(latitude: lat2.toDegrees(), longitude: lon2.toDegrees())
//    }
}
