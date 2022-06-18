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

protocol MapViewDelegate: AnyObject {
    func didChangeDisableNotifySelectionPin(disableNotifySelectionPin: Bool) -> Void
    func didStartDrag(centerCoordinate: CLLocationCoordinate2D)
}

final class PinsMapView: UIView {
    private(set) lazy var mapView = MKMapView()
    weak var delegate: MapViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(frame: CGRect = .zero, centerCoordinate: CLLocationCoordinate2D) {
        super.init(frame: frame)
        addSubview(mapView)

        setCenter(coordinator: centerCoordinate, shouldAdjustRegion: true, animated: false)
        // Show current user positin in map
        mapView.setUserTrackingMode(.follow, animated: true)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didChangeDrag(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
    }

    override func layoutSubviews() {
        mapView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }

    @objc private func didChangeDrag(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            delegate?.didStartDrag(centerCoordinate: mapView.centerCoordinate)
        }
    }

    func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }

    func clearAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }

    func setCenter(coordinator: CLLocationCoordinate2D, shouldAdjustRegion: Bool = false, animated: Bool) {
        // Add animation, `animated` option of `setCenter` not working somehow
        UIView.execute(isAnimated: animated, withDuration: 0.3) {
            self.mapView.setCenter(coordinator, animated: true)
            if shouldAdjustRegion {
                let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let defaultRegion = MKCoordinateRegion(center: coordinator, span: defaultSpan)
                self.mapView.region = defaultRegion
            }
        }
    }

    func selectPin(coordinator: CLLocationCoordinate2D) {
        guard let annotation = mapView.annotations.first(where: { $0.coordinate == coordinator }),
              mapView.selectedAnnotations.first?.coordinate != annotation.coordinate else { return }

        delegate?.didChangeDisableNotifySelectionPin(disableNotifySelectionPin: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
}

extension PinsMapView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
