//
//  WorkHotelMapView.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import SwiftUI
import WorkHotelCore
import WorkHotelDetail
import WorkHotelSearchOption

@MainActor
public struct WorkHotelMapView: View {
    // WorkHotelRepository or WorkHotelMock
    @StateObject private var viewModel = WorkHotelMapViewModel(repository: WorkHotelRepository())

    public init() {}

    @ViewBuilder
    private var workHotelDetailView: some View {
        if !viewModel.hotelList.isEmpty, viewModel.hotelList.count > viewModel.selectedIndex {
            WorkHotelDetailView(hotelInfo: viewModel.hotelList[viewModel.selectedIndex])
                .navigationBarTitle("ホテル詳細", displayMode: .inline)
        } else  {
            EmptyView()
        }
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(isActive: $viewModel.isPushNavigationActive) {
                    workHotelDetailView
                } label: {
                    EmptyView()
                }
                MapContentView(
                    selectedCoordinate: $viewModel.selectedCoordinate,
                    centerCoordinate: $viewModel.centerCoordinate,
                    willSearchCoordinate: $viewModel.willSearchCoordinate,
                    locations: viewModel.hotelList.map(\.coordinate))
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            viewModel.changeCenterPosition(to: viewModel.locationManager.userLocation)
                        } label: {
                            Image(systemName: "location.fill")
                                .resizable()
                                .imageScale(.large)
                                .padding(12)
                                .background(Color(WorkHotelCommon.themeColor))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
                        }
                        .hidden(!viewModel.locationManager.locationServicesEnabled)
                        .padding(20)
                        Spacer()
                        Button {
                            viewModel.shouldShowSearchOption = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .imageScale(.large)
                                .padding(12)
                                .background(Color(WorkHotelCommon.themeColor))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        }
                        .padding(20)
                    }
                    if !viewModel.hotelList.isEmpty {
                        CarouselView(hotelList: viewModel.hotelList, currentIndex: $viewModel.selectedIndex, isPushNavigationActive: $viewModel.isPushNavigationActive)
                            .frame(height: 100)
                            .padding(.bottom, 12)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer, prompt: Text("地名を検索"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(Color(WorkHotelCommon.themeColor))
        .overlay {
            if viewModel.isLoading {
                ProgressView("Fetching data, please wait...")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(WorkHotelCommon.themeColor)))
            }
        }
        .alert(isPresented: $viewModel.shouldShowErrorAlert, error: viewModel.error, actions: {
            Button("OK", action: {})
        })
        .sheet(isPresented: $viewModel.shouldShowSearchOption) {
            WorkHotelSearchOptionView(parameter: $viewModel.searchParameter)
        }
        .task {
            await viewModel.fetchVacantHotelList()
        }
    }
}

public struct WorkHotelMapView_Previews: PreviewProvider {
    public static var previews: some View {
        WorkHotelMapView()
    }
}
