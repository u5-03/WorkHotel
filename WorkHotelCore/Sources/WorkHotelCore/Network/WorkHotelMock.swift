//
//  WorkHotelMock.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/09.
//

import Foundation

public struct WorkHotelMock: WorkHotelProtocol {
    public init() {}

    public func fetchVacantHotels(parameters: VacantHotelSearchParameter) async throws -> VacantHotelSearchResponse {
        print("URL: Mock request")
        return VacantHotelSearchResponse(
            pagingInfo: .init(recordCount: 1, pageCount: 1, page: 1, first: 1, last: 1),
            hotels: [
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
                .init(hotel: [.basicInfo(basicInfo: .mock)]),
            ])
    }
}
