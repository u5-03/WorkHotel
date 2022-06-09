//
//  WorkHotelProtocol.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import Foundation

public protocol WorkHotelProtocol {
    func fetchVacantHotels(parameters: VacantHotelSearchParameter) async throws -> VacantHotelSearchResponse
}
