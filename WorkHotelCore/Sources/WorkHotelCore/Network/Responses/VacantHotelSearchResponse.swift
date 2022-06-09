//
//  WorkHotelResponse.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import Foundation
import CoreLocation

// Ref: https://webservice.rakuten.co.jp/documentation/vacant-hotel-search#inputParameter
public struct VacantHotelSearchResponse: Decodable {
    public let pagingInfo: VacantHotelSearchPagingInfoResponse
    public let hotels: [VacantHotelSearchHotelResponse]

    enum CodingKeys: String, CodingKey {
        case pagingInfo
        case hotels
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagingInfo = try container.decode(VacantHotelSearchPagingInfoResponse.self, forKey: .pagingInfo)
        hotels = try container.decode([VacantHotelSearchHotelResponse].self, forKey: .hotels)
    }

    public init(pagingInfo: VacantHotelSearchPagingInfoResponse, hotels: [VacantHotelSearchHotelResponse]) {
        self.pagingInfo = pagingInfo
        self.hotels = hotels
    }
}

public struct VacantHotelSearchPagingInfoResponse: Decodable {
    public let recordCount: Int
    public let pageCount: Int
    public let page: Int
    public let first: Int
    public let last: Int

    enum CodingKeys: String, CodingKey {
        case recordCount
        case pageCount
        case page
        case first
        case last
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recordCount = try container.decode(Int.self, forKey: .recordCount)
        pageCount = try container.decode(Int.self, forKey: .pageCount)
        page = try container.decode(Int.self, forKey: .page)
        first = try container.decode(Int.self, forKey: .first)
        last = try container.decode(Int.self, forKey: .last)
    }

    public init(recordCount: Int, pageCount: Int, page: Int, first: Int, last: Int) {
        self.recordCount = recordCount
        self.pageCount = pageCount
        self.page = page
        self.first = first
        self.last = last
    }
}

public struct VacantHotelSearchHotelResponse: Decodable {
    public let hotel: [VacantHotelSearchHotelContentResponse]

    enum CodingKeys: String, CodingKey {
        case hotel
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hotel = try container.decode([VacantHotelSearchHotelContentResponse].self, forKey: .hotel)
    }

    public init(hotel: [VacantHotelSearchHotelContentResponse]) {
        self.hotel = hotel
    }
}

public enum VacantHotelSearchHotelContentResponse: Decodable {
    case basicInfo(basicInfo: VacantHotelSearchBasicInfoResponse)
    case roomInfo(roomInfo: VacantHotelSearchRoomInfoResponse)

    public var isHotelBasicInfo: Bool {
        switch self {
        case .basicInfo: return true
        case .roomInfo: return false
        }
    }

    public var hotelBacisInfo: VacantHotelSearchBasicInfoResponse? {
        switch self {
        case .basicInfo(let basicInfo):
            return basicInfo
        case .roomInfo:
            return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case hotelBasicInfo
        case roomInfo
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let roomInfo = try container.decode(VacantHotelSearchRoomInfoResponse.self, forKey: .roomInfo)
            self = .roomInfo(roomInfo: roomInfo)
        } catch {
            do {
                let hotelBasicInfo = try container.decode(VacantHotelSearchBasicInfoResponse.self, forKey: .hotelBasicInfo)
                self = .basicInfo(basicInfo: hotelBasicInfo)
            } catch {
                throw error
            }
        }
    }
}

public struct VacantHotelSearchBasicInfoResponse: Decodable, Identifiable {
    public let id = UUID()
    public let hotelNo: Int
    public let hotelName: String
    public let hotelKanaName: String?
    public let hotelSpecial: String?
    public let hotelInformationURL: URL
    public let planListURL: URL
    public let dpPlanListURL: URL?
    public let hotelMinCharge: Int
    public let latitude: Double
    public let longitude: Double
    public let postalCode: String
    public let address1: String
    public let address2: String
    public let telephoneNo: String
    public let faxNo: String?
    public let access: String
    public let parkingInformation: String
    public let nearestStation: String?
    public let hotelImageURL: URL
    public let hotelThumbnailURL: URL
    public let roomImageURL: URL?
    public let roomThumbnailURL: URL?
    public let hotelMapImageURL: URL
    public let reviewCount: Int?
    public let reviewAverage: Double?

    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    enum CodingKeys: String, CodingKey {
        case hotelNo
        case hotelName
        case hotelKanaName
        case hotelSpecial
        case hotelInformationUrl
        case planListUrl
        case dpPlanListUrl
        case hotelMinCharge
        case latitude
        case longitude
        case postalCode
        case address1
        case address2
        case telephoneNo
        case faxNo
        case access
        case parkingInformation
        case nearestStation
        case hotelImageUrl
        case hotelThumbnailUrl
        case roomImageUrl
        case roomThumbnailUrl
        case hotelMapImageUrl
        case reviewCount
        case reviewAverage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hotelNo = try container.decode(Int.self, forKey: .hotelNo)
        hotelName = try container.decode(String.self, forKey: .hotelName)
        hotelKanaName = try container.decode(String?.self, forKey: .hotelKanaName)
        hotelSpecial = try container.decode(String?.self, forKey: .hotelSpecial)
        hotelInformationURL = try container.decode(URL.self, forKey: .hotelInformationUrl)
        planListURL = try container.decode(URL.self, forKey: .planListUrl)
        dpPlanListURL = try container.decode(URL?.self, forKey: .dpPlanListUrl)
        hotelMinCharge = try container.decode(Int.self, forKey: .hotelMinCharge)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        address1 = try container.decode(String.self, forKey: .address1)
        address2 = try container.decode(String.self, forKey: .address2)
        telephoneNo = try container.decode(String.self, forKey: .telephoneNo)
        faxNo = try container.decode(String?.self, forKey: .faxNo)
        access = try container.decode(String.self, forKey: .access)
        parkingInformation = try container.decode(String.self, forKey: .parkingInformation)
        nearestStation = try container.decode(String?.self, forKey: .nearestStation)
        hotelImageURL = try container.decode(URL.self, forKey: .hotelImageUrl)
        hotelThumbnailURL = try container.decode(URL.self, forKey: .hotelThumbnailUrl)
        roomImageURL = try container.decode(URL?.self, forKey: .roomImageUrl)
        roomThumbnailURL = try container.decode(URL?.self, forKey: .roomThumbnailUrl)
        hotelMapImageURL = try container.decode(URL.self, forKey: .hotelMapImageUrl)
        reviewCount = try container.decode(Int?.self, forKey: .reviewCount)
        reviewAverage = try container.decode(Double?.self, forKey: .reviewAverage)
    }

    public init(hotelNo: Int, hotelName: String, hotelKanaName: String, hotelSpecial: String?, hotelInformationURL: URL, planListURL: URL, dpPlanListURL: URL, hotelMinCharge: Int, latitude: Double, longitude: Double, postalCode: String, address1: String, address2: String, telephoneNo: String, faxNo: String, access: String, parkingInformation: String, nearestStation: String, hotelImageURL: URL, hotelThumbnailURL: URL, roomImageURL: URL?, roomThumbnailURL: URL?, hotelMapImageURL: URL, reviewCount: Int, reviewAverage: Double) {
        self.hotelNo = hotelNo
        self.hotelName = hotelName
        self.hotelKanaName = hotelKanaName
        self.hotelSpecial = hotelSpecial
        self.hotelInformationURL = hotelInformationURL
        self.planListURL = planListURL
        self.dpPlanListURL = dpPlanListURL
        self.hotelMinCharge = hotelMinCharge
        self.latitude = latitude
        self.longitude = longitude
        self.postalCode = postalCode
        self.address1 = address1
        self.address2 = address2
        self.telephoneNo = telephoneNo
        self.faxNo = faxNo
        self.access = access
        self.parkingInformation = parkingInformation
        self.nearestStation = nearestStation
        self.hotelImageURL = hotelImageURL
        self.hotelThumbnailURL = hotelThumbnailURL
        self.roomImageURL = roomImageURL
        self.roomThumbnailURL = roomThumbnailURL
        self.hotelMapImageURL = hotelMapImageURL
        self.reviewCount = reviewCount
        self.reviewAverage = reviewAverage
    }
}

public extension VacantHotelSearchBasicInfoResponse {
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}

public extension VacantHotelSearchBasicInfoResponse {
    static var mock: VacantHotelSearchBasicInfoResponse {
        return VacantHotelSearchBasicInfoResponse(hotelNo: .random(in: 0...1_000_000),
                                                  hotelName: .random(length: .random(in: 0...100)),
                                                  hotelKanaName: .random(length: .random(in: 0...200)),
                                                  hotelSpecial: .random(length: .random(in: 0...200)),
                                                  hotelInformationURL: URL(string: "https://img.travel.rakuten.co.jp/image/tr/api/re/pvonD/?f_no=141356")!,
                                                  planListURL: URL(string: "https://img.travel.rakuten.co.jp/image/tr/api/re/vFumt/?f_no=141356&f_flg=PLAN")!,
                                                  dpPlanListURL: URL(string: "https://img.travel.rakuten.co.jp/image/tr/api/re/WzozX/?noTomariHotel=141356")!,
                                                  hotelMinCharge: .random(in: 0...100_000),
                                                  latitude: .random(in: 35.4...35.5),
                                                  longitude: .random(in: 139.6...139.7),
                                                  postalCode: .random(length: 8),
                                                  address1: .random(length: 20),
                                                  address2: .random(length: 20),
                                                  telephoneNo: .random(length: 10),
                                                  faxNo: .random(length: 10),
                                                  access: .random(length: 60),
                                                  parkingInformation: .random(length: 30),
                                                  nearestStation: .random(length: 10),
                                                  hotelImageURL: URL(string: "https://img.travel.rakuten.co.jp/share/HOTEL/80777/80777.jpg")!,
                                                  hotelThumbnailURL: URL(string: "https://img.travel.rakuten.co.jp/HIMG/90/141356.jpg")!,
                                                  roomImageURL: URL(string: "https://img.travel.rakuten.co.jp/share/HOTEL/68268/68268_ky.jpg")!,
                                                  roomThumbnailURL: URL(string: "https://img.travel.rakuten.co.jp/HIMG/INTERIOR/68268.jpg")!,
                                                  hotelMapImageURL: URL(string: "https://img.travel.rakuten.co.jp/share/HOTEL/141356/141356map.gif")!,
                                                  reviewCount: .random(in: 0...8),
                                                  reviewAverage: .random(in: 0...5))
    }
}

// In this phase, `RoomInfo` response is not used.
public struct VacantHotelSearchRoomInfoResponse: Decodable {}

public extension Array where Element == VacantHotelSearchBasicInfoResponse {
    func sorted(by location: CLLocation) -> [VacantHotelSearchBasicInfoResponse] {
        return sorted(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
}
