//
//  WorkHotelMapViewModel.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import Foundation
import WorkHotelCore
import WorkHotelCore
import Combine
import CoreLocation

@MainActor
final class WorkHotelMapViewModel: NSObject, ObservableObject {
    @Published var selectedIndex = 0
    @Published var selectedCoordinate = WorkHotelCommon.defaultCoordinate
    @Published var willSearchCoordinate = WorkHotelCommon.defaultCoordinate
    @Published var centerCoordinate = WorkHotelCommon.defaultCoordinate
    @Published var searchParameter = VacantHotelSearchParameter()
    @Published private(set) var hotelList: [VacantHotelSearchBasicInfoResponse] = []
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var shouldShowErrorAlert = false
    @Published var shouldShowSearchOption = false {
        didSet {
            if !shouldShowSearchOption, shouldShowSearchOption != oldValue {
                Task {
                    await fetchVacantHotelList(shouldSwitchLoading: false)
                }
            }
        }
    }
    @Published var error: WorkHotelError? {
        didSet {
            shouldShowErrorAlert = true
        }
    }
    @Published var isPushNavigationActive = false
    @Published private(set) var locationManager = LocationManager()
    private var repository: WorkHotelProtocol
    private var cancellableSet = Set<AnyCancellable>()

    init(repository: WorkHotelProtocol) {
        self.repository = repository
        super.init()

        $selectedCoordinate
            .removeDuplicates()
            .sink { [weak self] selectedCoordinate in
                guard let self = self,
                      let selectedIndex = self.hotelList.map(\.coordinate).firstIndex(where: { $0 == selectedCoordinate }) else { return }
                self.selectedIndex = selectedIndex
            }
            .store(in: &cancellableSet)
        $selectedIndex
            .removeDuplicates()
            .sink { [weak self] selectedIndex in
                guard let self = self, !self.hotelList.isEmpty else { return }
                self.selectedCoordinate = self.hotelList.map(\.coordinate)[selectedIndex]
                if selectedIndex != 0 {
                    self.centerCoordinate = self.selectedCoordinate
                }
            }
            .store(in: &cancellableSet)
        $willSearchCoordinate
            //  Skip default first value
            .dropFirst()
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] centerCoordinate in
                guard let self = self else { return }
                Task {
                    await self.fetchVacantHotelList(shouldSwitchLoading: false)
                }
            }
            .store(in: &cancellableSet)
        $searchText
            .filter({ !$0.trim().isEmpty })
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchLocation(keyword: searchText)
            }
            .store(in: &cancellableSet)
        locationManager.$userLocation
            .dropFirst()
            .sink { [weak self] coordinate in
                self?.changeCenterPosition(to: coordinate)
            }
            .store(in: &cancellableSet)
    }

    func fetchVacantHotelList(shouldSwitchLoading: Bool = true) async {
        if shouldSwitchLoading {
            isLoading = true
        }
        do {
            searchParameter.coordinater = centerCoordinate
            let response = try await repository.fetchVacantHotels(parameters: searchParameter)
            selectedIndex = 0
            hotelList = response.hotels.flatMap({ $0.hotel.compactMap(\.hotelBacisInfo) }).sorted(by: searchParameter.coordinater.location)
        } catch {
            if let error = error as? WorkHotelError {
                if error.shouldShowErrorAlert {
                    self.error = error
                }
            } else {
                self.error = .unknown
            }
            hotelList = []
        }
        isLoading = false
    }

    func changeCenterPosition(to coordinate: CLLocationCoordinate2D) {
        centerCoordinate = coordinate
        searchParameter.coordinater = coordinate
        willSearchCoordinate = coordinate
        Task {
            await fetchVacantHotelList(shouldSwitchLoading: false)
        }
    }

    private func searchLocation(keyword: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(keyword) { [weak self] placemarks, error in
            if let placemarks = placemarks,
                !placemarks.isEmpty,
               let coordinate = placemarks.first?.location?.coordinate {
                self?.centerCoordinate = coordinate
                self?.willSearchCoordinate = coordinate
            } else {
                self?.error = WorkHotelError.failedToFindLocationFromKeyword
            }
        }
    }
}
