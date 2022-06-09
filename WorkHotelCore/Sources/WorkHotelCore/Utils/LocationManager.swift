//
//  LocationManager.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/09.
//

import Foundation
import CoreLocation
import SwiftUI

public class LocationManager: NSObject, ObservableObject {
    @Published public var error: WorkHotelError?
    @Published public var userLocation: CLLocationCoordinate2D = WorkHotelCommon.defaultCoordinate
    @Published public var locationServicesEnabled = false
    private let locationManager = CLLocationManager()

    public override init() {
        super.init()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationServicesEnabled = false
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            guard let coordinate = locationManager.location?.coordinate else { return }
            userLocation = coordinate
            locationServicesEnabled = true
        default:
            locationServicesEnabled = false
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationServicesEnabled = false
        print(error.localizedDescription)
    }
}
