//
//  WorkHotelRepository.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import Foundation

public struct WorkHotelRepository: WorkHotelProtocol {
    public init() {}
    
    public func fetchVacantHotels(parameters: VacantHotelSearchParameter) async throws -> VacantHotelSearchResponse {
        let baseURLString = "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20170426?\(parameters.asQueryParameter)"
        guard let url = URL(string: baseURLString),
              let urlRequest = try? URLRequest(url: url, method: .get) else {
            throw WorkHotelError.invalidRequestURL
        }

        return try await WorkHotelNetwork.shared.sendRequest(request: urlRequest)
    }
}
