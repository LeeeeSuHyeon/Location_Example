import Foundation
import ARCL
import SceneKit
import NMapsMap

/// A block that will build an SCNBox with the provided distance.
/// Note: the distance should be assigned to the length
public typealias BoxBuilder = (_ distance: CGFloat) -> SCNBox

/// A Node that is used to show directions in AR-CL.
public class PolylineNode: LocationNode {
    public private(set) var locationNodes = [LocationNode]()

    public let polyline: [NMGLatLng]
    public let altitude: CLLocationDistance
    public let boxBuilder: BoxBuilder

    /// Creates a `PolylineNode` from the provided polyline, altitude (which is assumed to be uniform
    /// for all of the points) and an optional SCNBox to use as a prototype for the location boxes.
    ///
    /// - Parameters:
    ///   - polyline: The polyline that we'll be creating location nodes for.
    ///   - altitude: The uniform altitude to use to show the location nodes.
    ///   - tag: a String attribute to identify the node in the scene (e.g when it's touched)
    ///   - boxBuilder: A block that will customize how a box is built.
    public init(polyline: [NMGLatLng],
                altitude: CLLocationDistance,
                location : CLLocation?,
                tag: String? = nil,
                boxBuilder: BoxBuilder? = nil) {
        self.polyline = polyline
        self.altitude = altitude
        self.boxBuilder = boxBuilder ?? Constants.defaultBuilder

        super.init(location: location)

        self.tag = tag ?? Constants.defaultTag

        constructNodes()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Implementation

private extension PolylineNode {

    struct Constants {
        static let defaultBuilder: BoxBuilder = { (distance) -> SCNBox in
            let box = SCNBox(width: 1, height: 0.2, length: distance, chamferRadius: 0)
            box.firstMaterial?.diffuse.contents = UIColor(red: 47.0/255.0, green: 125.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            return box
        }
        static let defaultTag: String = ""
    }

    /// This is what actually builds the SCNNodes and appends them to the
    /// locationNodes collection so they can be added to the scene and shown
    /// to the user.  If the prototype box is nil, then the default box will be used
    func constructNodes() {
        
        
        for i in 0 ..< polyline.count - 1 {
            let currentLocation = CLLocation(latitude: polyline[i].lat, longitude: polyline[i].lng)
            let nextLocation = CLLocation(latitude: polyline[i + 1].lat, longitude: polyline[i + 1].lng)
            let midLocation = currentLocation.approxMidpoint(to: nextLocation)

            let distance = currentLocation.distance(from: nextLocation)

            let box = boxBuilder(CGFloat(distance))
            let boxNode = SCNNode(geometry: box)
            boxNode.removeFlicker()

            let bearing = -currentLocation.bearing(between: nextLocation)

            // Orient the line to point from currentLocation to nextLocation
            boxNode.eulerAngles.y = Float(bearing).degreesToRadians

            let locationNode = LocationNode(location: midLocation, tag: tag)
            locationNode.addChildNode(boxNode)

            locationNodes.append(locationNode)
        }
    }

}


extension SCNNode {
    /// Overlapping nodes require unique renderingOrder values to avoid flicker
    /// This method will select random values if you don't care which node is in front of the other,
    /// or you can specify a particular z-order value
    /// Note: rendering order will be changed later based on distance from camera
    func removeFlicker (withRenderingOrder renderingOrder: Int = Int.random(in: 1..<Int.max)) {
        self.renderingOrder = renderingOrder
        if let geom = geometry {
            geom.materials.forEach { $0.readsFromDepthBuffer = false }
        }
    }
}
