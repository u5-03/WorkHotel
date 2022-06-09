//
//  PinsMapView.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import UIKit
import SwiftUI
import MapKit
import WorkHotelCore

protocol MapDragDelegate: AnyObject {
    func didEndDrag(centerCoordinate: CLLocationCoordinate2D)
}

final class PinsMapView: UIView {
    private(set) lazy var mapView = MKMapView()
    weak var delegate: MapDragDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)

        setCenter(coordinator: WorkHotelCommon.defaultCoordinate, shouldAdjustRegion: true)
        // Show current user positin in map
        mapView.setUserTrackingMode(.follow, animated: true)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didEndDrag(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
    }

    override func layoutSubviews() {
        mapView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }

    @objc private func didEndDrag(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            delegate?.didEndDrag(centerCoordinate: mapView.centerCoordinate)
        }
    }

    func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }

    func clearAnnotations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
    }

    func setCenter(coordinator: CLLocationCoordinate2D, shouldAdjustRegion: Bool = false) {
        // Add animation, `animated` option of `setCenter` not working somehow
        UIView.animate(withDuration: 0.3) {
            self.mapView.setCenter(coordinator, animated: true)
            if shouldAdjustRegion {
                let defaultSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let defaultRegion = MKCoordinateRegion(center: coordinator, span: defaultSpan)
                self.mapView.region = defaultRegion
            }
        }
    }

    func selectPin(coordinator: CLLocationCoordinate2D) {
        guard let annotation = mapView.annotations.first(where: { $0.coordinate == coordinator }) else { return }
        mapView.selectAnnotation(annotation, animated: true)
    }
}

extension PinsMapView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
