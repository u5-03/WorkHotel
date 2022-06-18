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
    let selectedIndex: Int
    
    let didTapPin: (CLLocationCoordinate2D) -> Void
    let didStartDrag: (CLLocationCoordinate2D) -> Void
    let didMoveMap:(CLLocationCoordinate2D) -> Void
    
    final class Coordinator: NSObject, MKMapViewDelegate, MapViewDelegate {
        
        private let mapView: MapView
        private var disableNotifySelectionPin = false
        
        let didTapPin: (CLLocationCoordinate2D) -> Void
        let didStartDrag: (CLLocationCoordinate2D) -> Void
        let didMoveMap: (CLLocationCoordinate2D) -> Void
        
        init(mapView: MapView, disableNotifySelectionPin: Bool = false, didTapPin: @escaping (CLLocationCoordinate2D) -> Void, didStartDrag: @escaping (CLLocationCoordinate2D) -> Void, didMoveMap: @escaping (CLLocationCoordinate2D) -> Void) {
            self.mapView = mapView
            self.disableNotifySelectionPin = disableNotifySelectionPin
            self.didTapPin = didTapPin
            self.didStartDrag = didStartDrag
            self.didMoveMap = didMoveMap
        }
        
        func didChangeDisableNotifySelectionPin(disableNotifySelectionPin: Bool) {
            self.disableNotifySelectionPin = disableNotifySelectionPin
        }
        
        func didStartDrag(centerCoordinate: CLLocationCoordinate2D) {
            didStartDrag(centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let coordinate = view.annotation?.coordinate else { return }
            // Avoid select pin loop
            if disableNotifySelectionPin {
                disableNotifySelectionPin.toggle()
            } else {
                didTapPin(coordinate)
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            didMoveMap(mapView.centerCoordinate)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(mapView: self, didTapPin: didTapPin, didStartDrag: didStartDrag, didMoveMap: didMoveMap)
    }
    
    func makeUIView(context: Context) -> PinsMapView {
        let pinsMapView = PinsMapView(centerCoordinate: centerCoordinate)
        pinsMapView.mapView.delegate = context.coordinator
        pinsMapView.delegate = context.coordinator
        return pinsMapView
    }
    
    func updateUIView(_ uiView: PinsMapView, context: Context) {
        DispatchQueue.main.async {
            if uiView.mapView.centerCoordinate != centerCoordinate {
                uiView.setCenter(coordinator: centerCoordinate, animated: true)
            }
            if locations.isEmpty { return }
            
            if !uiView.mapView.annotations.map(\.coordinate).allSatisfy({ locations.contains($0) }) {
                uiView.clearAnnotations()
            }
            
            for location in locations {
                let annotation = MKPointAnnotation()
                let centerCoordinate = location
                annotation.coordinate = centerCoordinate
                uiView.addAnnotation(annotation)
            }
            let selectedCoordinate = locations[selectedIndex]
            uiView.selectPin(coordinator: selectedCoordinate)
        }
    }
}
