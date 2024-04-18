//
//  SCNNode_Extension.swift
//  Location_Example
//
//  Created by 이수현 on 4/18/24.
//

import SceneKit

extension SCNNode {
    func removeFlicker (withRenderingOrder renderingOrder: Int = Int.random(in: 1..<Int.max)) {
        self.renderingOrder = renderingOrder
        if let geom = geometry {
            geom.materials.forEach { $0.readsFromDepthBuffer = false }
        }
    }
}
