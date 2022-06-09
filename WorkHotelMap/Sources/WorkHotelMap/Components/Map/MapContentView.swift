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
    @Binding var selectedCoordinate: CLLocationCoordinate2D
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var willSearchCoordinate: CLLocationCoordinate2D
    let locations: [CLLocationCoordinate2D]

    var body: some View {
        MapView(locations: locations,
                centerCoordinate: centerCoordinate,
                selectedCoordinate: selectedCoordinate) { selectedCoordinate in
            if self.selectedCoordinate != selectedCoordinate {
                self.selectedCoordinate = selectedCoordinate
            }
        } didMoveMap: { centerCoordinate in
            if self.centerCoordinate != centerCoordinate {
                self.willSearchCoordinate = centerCoordinate
                self.centerCoordinate = centerCoordinate
            }
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct MapContentView_Previews: PreviewProvider {
    @State private static var selectedCoordinate = WorkHotelCommon.defaultCoordinate
    @State private static var centerCoordinate = WorkHotelCommon.defaultCoordinate
    @State private static var willSearchCoordinate = WorkHotelCommon.defaultCoordinate
    private static let locations: [CLLocationCoordinate2D] = [
        VacantHotelSearchBasicInfoResponse.mock,
        VacantHotelSearchBasicInfoResponse.mock,
        VacantHotelSearchBasicInfoResponse.mock
    ]
        .map({  CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
    static var previews: some View {
        MapContentView(selectedCoordinate: $selectedCoordinate, centerCoordinate: $centerCoordinate, willSearchCoordinate: $willSearchCoordinate, locations: locations)
    }
}
