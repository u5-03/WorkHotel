//
//  MapView.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import UIKit
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    let locations: [CLLocationCoordinate2D]
    let centerCoordinate: CLLocationCoordinate2D
    let selectedCoordinate: CLLocationCoordinate2D

    let didTapPin: (CLLocationCoordinate2D) -> Void
    let didMoveMap:(CLLocationCoordinate2D) -> Void

    final class Coordinator: NSObject, MKMapViewDelegate, MapDragDelegate {
        private let mapView: MapView
        let didTapPin: (CLLocationCoordinate2D) -> Void
        let didMoveMap:(CLLocationCoordinate2D) -> Void

        init(_ mapView: MapView, didTapPin: @escaping (CLLocationCoordinate2D) -> Void, didMoveMap: @escaping (CLLocationCoordinate2D) -> Void) {
            self.mapView = mapView
            self.didTapPin = didTapPin
            self.didMoveMap = didMoveMap
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let coordinate = view.annotation?.coordinate else { return }
            didTapPin(coordinate)
        }

//        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//            didMoveMap(mapView.centerCoordinate)
//        }

        func didEndDrag(centerCoordinate: CLLocationCoordinate2D) {
            didMoveMap(centerCoordinate)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, didTapPin: didTapPin, didMoveMap: didMoveMap)
    }

    func makeUIView(context: Context) -> PinsMapView {
        let pinsMapView = PinsMapView()
        pinsMapView.mapView.delegate = context.coordinator
        pinsMapView.delegate = context.coordinator
        return pinsMapView
    }

    func updateUIView(_ uiView: PinsMapView, context: Context) {
        if locations.isEmpty { return }

        DispatchQueue.main.async {
            if locations != uiView.mapView.annotations.map(\.coordinate) {
                uiView.clearAnnotations()
            }
            for location in locations {
                let annotation = MKPointAnnotation()
                let centerCoordinate = location
                annotation.coordinate = centerCoordinate
                uiView.addAnnotation(annotation)
            }
            if uiView.mapView.centerCoordinate != centerCoordinate {
                uiView.setCenter(coordinator: centerCoordinate)
            }
            guard let selectedLocation = locations.first(where: { $0 == selectedCoordinate }) else { return }
            uiView.selectPin(coordinator: selectedLocation)
        }
    }
}
