//
//  ARCLContentView.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/10.
//

import SwiftUI
import CoreLocation

struct ARCLContentView: View {
    var body: some View {
        let source = CLLocationCoordinate2D(latitude: 37.455086, longitude: 127.133315)
        let destination = CLLocationCoordinate2D(latitude: 37.452451, longitude: 127.132802)
        VStack{
            ARCLViewControllerWrapper(start: source, end: destination)
            ARCLMapView(sourceCoordinate: source, destinationCoordinate: destination)
        }
    }
}

