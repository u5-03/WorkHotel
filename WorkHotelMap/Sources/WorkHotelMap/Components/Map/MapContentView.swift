//
//  MapContentView.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import SwiftUI
import MapKit
import WorkHotelCore
import WorkHotelCore

struct MapContentView: View {
    @Binding var mapActionType: MapActionType
    @Binding var didEndMapScrollAnimation: CLLocationCoordinate2D
    let selectedIndex: Int
    let centerCoordinate: CLLocationCoordinate2D
    let locations: [CLLocationCoordinate2D]
    
    init(mapActionType: Binding<MapActionType>,
         didEndMapScrollAnimation: Binding<CLLocationCoordinate2D>,
         selectedIndex: Int, centerCoordinate: CLLocationCoordinate2D, locations: [CLLocationCoordinate2D]) {
        self._mapActionType = mapActionType
        self._didEndMapScrollAnimation = didEndMapScrollAnimation
        self.selectedIndex = selectedIndex
        self.centerCoordinate = centerCoordinate
        self.locations = locations
    }

    var body: some View {
        MapView(locations: locations,
                centerCoordinate: centerCoordinate,
                selectedIndex: selectedIndex) { coordinate in
            mapActionType = .selectPin(coordinate: coordinate)
        } didStartDrag: { coordinate in
            mapActionType = .didStartDrag(coordinate: coordinate)
        } didMoveMap: { centerCoordinate in
            if self.centerCoordinate != centerCoordinate {
                didEndMapScrollAnimation = centerCoordinate
            }
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct MapContentView_Previews: PreviewProvider {
    @State static private var mapActionType = MapActionType.pageOpen
    @State static private var didEndMapScrollAnimation = WorkHotelCommon.defaultCoordinate
    private static let selectedIndex = 0
    private static let centerCoordinate = WorkHotelCommon.defaultCoordinate
    private static let locations: [CLLocationCoordinate2D] = [
        VacantHotelSearchBasicInfoResponse.mock,
        VacantHotelSearchBasicInfoResponse.mock,
        VacantHotelSearchBasicInfoResponse.mock
    ]
        .map({  CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
    static var previews: some View {
        MapContentView(mapActionType: $mapActionType, didEndMapScrollAnimation: $didEndMapScrollAnimation, selectedIndex: selectedIndex, centerCoordinate: centerCoordinate, locations: locations)
    }
}
