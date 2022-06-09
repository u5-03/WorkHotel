import Foundation
import Alamofire

final class WorkHotelNetwork {
    static let shared = WorkHotelNetwork()

    private init() {}

    func sendRequest<R: Decodable>(request: URLRequest) async throws -> R {
        guard let requestURL = request.url, let method = request.method else {
            throw WorkHotelError.invalidRequestURL
        }
        let response = await AF.request(requestURL, method: method).serializingDecodable(R.self).response
        if let httpStatusCode = response.response?.statusCode,
           httpStatusCode == 404 {
            throw WorkHotelError.dataNotFound
        } else if let error = response.error {
            throw WorkHotelError.requestError(message: error.localizedDescription)
        } else if let value = response.value {
            return value
        } else {
            throw WorkHotelError.unknown
        }
    }
}
