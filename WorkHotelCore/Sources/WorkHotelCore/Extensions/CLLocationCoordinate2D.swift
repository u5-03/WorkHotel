//
//  CLLocationCoordinate2D.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/08.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
