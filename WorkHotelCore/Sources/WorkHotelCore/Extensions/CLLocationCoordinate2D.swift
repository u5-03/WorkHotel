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

    public var roughRoundedCoordinate: CLLocationCoordinate2D {
        return roundedCoordinate(dicimalPointDigits: 3)
    }

    private func roundedCoordinate(dicimalPointDigits: Int) -> CLLocationCoordinate2D {
        let powedValue = pow(10, Double(dicimalPointDigits))
        let roundedLatitude = Double(round(powedValue * latitude) / powedValue)
        
        let roundedLongitude = Double(round(powedValue * longitude) / powedValue)
        return CLLocationCoordinate2D(latitude: roundedLatitude, longitude: roundedLongitude)
    }

    // Small digits do not included in the calculation of Equatable
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        let digits = 6
        let lhsRoundedCoordinate = lhs.roundedCoordinate(dicimalPointDigits: digits)
        let rhsRoundedCoordinate = rhs.roundedCoordinate(dicimalPointDigits: digits)
        return lhsRoundedCoordinate.latitude == rhsRoundedCoordinate.latitude
        && lhsRoundedCoordinate.longitude == rhsRoundedCoordinate.longitude
    }
}
