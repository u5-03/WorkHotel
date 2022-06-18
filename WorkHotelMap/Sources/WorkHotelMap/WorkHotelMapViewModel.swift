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

struct MapViewParameter {
    let mapActionType: MapActionType
    let centerCoordinate: CLLocationCoordinate2D
    let selectedCoordinate: CLLocationCoordinate2D
    let locations: [CLLocationCoordinate2D]
}

enum MapActionType: Equatable {
    case selectPin(coordinate: CLLocationCoordinate2D)
    case didSwipeCarousel(index: Int)
    case didSearchLocation(coordinate: CLLocationCoordinate2D)
    case didStartDrag(coordinate: CLLocationCoordinate2D)
    case goToCurrentLocation(centerCoordinate: CLLocationCoordinate2D)
    case pageOpen
    
    fileprivate var isSearchHotelsEnable: Bool {
        switch self {
        case .selectPin, .didSwipeCarousel:
            return false
        case .didSearchLocation, .goToCurrentLocation, .pageOpen, .didStartDrag:
            return true
        }
    }

    fileprivate var shouldMoveCenterCoordinate: Bool {
        switch self {
        case .selectPin, .didSwipeCarousel:
            return false
        case .didSearchLocation, .goToCurrentLocation, .pageOpen, .didStartDrag:
            return true
        }
    }

    fileprivate var isCenterCoordinatePreset: Bool {
        switch self {
        case .selectPin, .didSwipeCarousel, .didStartDrag, .pageOpen:
            return false
        case .didSearchLocation, .goToCurrentLocation:
            return true
        }
    }
}

@MainActor
final class WorkHotelMapViewModel: NSObject, ObservableObject {
    
    @Published var selectedIndex = 0 {
        didSet {
            print("DidSet: selectedIndex \(selectedIndex)")
        }
    }
    @Published private(set) var centerCoordinate = WorkHotelCommon.defaultCoordinate
    @Published var searchParameter = VacantHotelSearchParameter()
    @Published private(set) var hotelList: [VacantHotelSearchBasicInfoResponse] = [] {
        didSet {
            if !hotelList.isEmpty {
                selectedIndex = 0
            }
        }
    }
    @Published private(set) var isLoading = false
    @Published var searchText = ""
    @Published var shouldShowErrorAlert = false
    @Published var mapActionType: MapActionType = .pageOpen
    @Published var didEndMapScrollAnimation = WorkHotelCommon.defaultCoordinate
    @Published private var fetchTask: Task<(), Never>?
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

        $selectedIndex
            .removeDuplicates()
            .sink { [weak self] selectedIndex in
                guard let self = self else { return }
                self.mapActionType = .didSwipeCarousel(index: selectedIndex)
            }
            .store(in: &cancellableSet)
        $didEndMapScrollAnimation
            .removeDuplicates()
            .filter({ $0 != WorkHotelCommon.defaultCoordinate })
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { centerCoordinate in
                if self.mapActionType.isSearchHotelsEnable,
                   (self.mapActionType.isCenterCoordinatePreset || self.centerCoordinate.roughRoundedCoordinate != centerCoordinate.roughRoundedCoordinate) {
                    self.searchParameter.coordinater = centerCoordinate
                    self.fetchTask?.cancel()
                    self.fetchTask = Task {
                        await self.fetchVacantHotelList(shouldSwitchLoading: false)
                    }
                }
                if self.mapActionType.shouldMoveCenterCoordinate,
                   self.centerCoordinate != centerCoordinate {
//                    self.centerCoordinate = centerCoordinate
                }
            }
            .store(in: &cancellableSet)
        $mapActionType
            .removeDuplicates()
            .sink { [weak self] actionType in
                guard let self = self else { return }
                print("MapAction: \(actionType)")
                switch actionType {
                case .selectPin(let coordinate):
                    guard let selectedIndex = self.hotelList.map(\.coordinate).firstIndex(where: { $0 == coordinate }) else { return }
                    if self.selectedIndex != selectedIndex {
                        self.selectedIndex = selectedIndex
                        self.centerCoordinate = coordinate
                    }
                case .didSwipeCarousel(let selectedIndex):
                    guard !self.hotelList.isEmpty else { return }
                    let selectedCoordinate = self.hotelList.map(\.coordinate)[selectedIndex]
                    if self.centerCoordinate != selectedCoordinate {
                        self.centerCoordinate = selectedCoordinate
                        self.selectedIndex = selectedIndex
                    }
                    if selectedIndex != 0 {
                    }
                case .didStartDrag:
                    break
                case .goToCurrentLocation(let coordinate):
                    self.centerCoordinate = coordinate
                case .didSearchLocation(let coordinate):
                    self.centerCoordinate = coordinate
                case .pageOpen:
                    self.fetchTask = Task {
//                        await self.fetchVacantHotelList()
                    }

                }
            }
            .store(in: &cancellableSet)
        $searchText
            .filter({ !$0.trim().isEmpty })
            .debounce(for: 1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchLocation(keyword: searchText)
            }
            .store(in: &cancellableSet)
        locationManager.$userLocation
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] coordinate in
//                if coordinate == WorkHotelCommon.defaultCoordinate { return }
                self?.mapActionType = .goToCurrentLocation(centerCoordinate: coordinate)
                self?.fetchTask = Task {
                    await self?.fetchVacantHotelList()
                }
            }
            .store(in: &cancellableSet)
    }

    private func fetchVacantHotelList(shouldSwitchLoading: Bool = true) async {
        if shouldSwitchLoading {
            isLoading = true
        }
        do {
            searchParameter.coordinater = centerCoordinate
            let response = try await repository.fetchVacantHotels(parameters: searchParameter)
            hotelList = response.hotels.flatMap({ $0.hotel.compactMap(\.hotelBacisInfo) }).sorted(by: searchParameter.coordinater.location)
        } catch {
            if !Task.isCancelled  {
                if let error = error as? WorkHotelError {
                    if error.shouldShowErrorAlert {
                        self.error = error
                    }
                } else {
                    self.error = .unknown
                }
                hotelList = []
            }
        }
        isLoading = false
    }

    func gotoCurrentLocation() {
        mapActionType = .goToCurrentLocation(centerCoordinate: locationManager.userLocation)
    }

    private func searchLocation(keyword: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(keyword) { [weak self] placemarks, error in
            if let placemarks = placemarks,
                !placemarks.isEmpty,
               let coordinate = placemarks.first?.location?.coordinate {
                self?.mapActionType = .didSearchLocation(coordinate: coordinate)
            } else {
                self?.error = WorkHotelError.failedToFindLocationFromKeyword
            }
        }
    }
}
