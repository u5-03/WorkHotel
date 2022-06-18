//
//  VacantHotelSearchParameter.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import Foundation
import SwiftExtensions
import CoreLocation

public enum VacantHotelSearchParameterValidationType {
    case checkinDateSmallerToday
    case checkoutDateSmallerCheckinDate
    case maxChargeSmallerMinCharge

    public var message: String {
        switch self {
        case .checkinDateSmallerToday:
            return "チェックイン日は本日以降の日付を指定してください"
        case .checkoutDateSmallerCheckinDate:
            return "チェックアウト日は、チェックインの日付を指定してください"
        case .maxChargeSmallerMinCharge:
            return "上限金額は下限金額より大きい数字を指定してください"
        }
    }
}

public struct VacantHotelSearchParameter {
    // NetworkCredentials file is added in gitignore
    // If you cloned this repository, you must rewrite applicationId below.
    private let applicationId = NetworkCredentials.applicationId
    private let datumType = 1
    // Number of acquisitions per page
    private let hits = 30
    private let searchRadius = 2.5
    public var checkinDate = Date()
    public var checkoutDate = Date().offsetDays(offset: 1) ?? Date()
    public var coordinater = WorkHotelCommon.defaultCoordinate
    public var adultNum = 1
    public var roomNum = 1
    public var maxCharge: Double = 30_000
    public var minCharge: Double = 1_000
    public var kinenEnable = true
    public var internetEnable = true
    public var daiyokuEnable = false
    public var onsenEnable = false
    public var breakfastEnable = false
    public var dinnerEnable = false

    public var validationMessageTypes: [VacantHotelSearchParameterValidationType] {
        var validationTypes: [VacantHotelSearchParameterValidationType] = []
        if checkinDate.diffDays(with: Date()) > 0 {
            validationTypes.append(.checkinDateSmallerToday)
        }
        if checkinDate.diffDays(with: checkoutDate) <= 0 {
            validationTypes.append(.checkoutDateSmallerCheckinDate)
        }
        if minCharge >= maxCharge {
            validationTypes.append(.maxChargeSmallerMinCharge)
        }
        return validationTypes
    }

    public var asQueryParameter: String {
        var squeezeConditions: [String] = []
        if kinenEnable {
            squeezeConditions.append("kinen")
        }
        if internetEnable {
            squeezeConditions.append("internet")
        }
        if daiyokuEnable {
            squeezeConditions.append("daiyoku")
        }
        if onsenEnable {
            squeezeConditions.append("onsen")
        }
        if breakfastEnable {
            squeezeConditions.append("breakfast")
        }
        if dinnerEnable {
            squeezeConditions.append("dinner")
        }
        let checkinDateFormatted = checkinDate.asString(withFormat: .dateFormat)
        let checkoutDateFormatted = checkoutDate.asString(withFormat: .dateFormat)
        let squeezeConditionText = squeezeConditions.isEmpty ? "" : "&squeezeCondition=\(squeezeConditions.joined(separator: ","))"
        // e.g. ?format=json&checkinDate=2022-06-10&checkoutDate=2022-06-11&latitude=128440.51&longitude=503172.21&hits=1&applicationId=\(applicationId)
        return "format=json&applicationId=\(applicationId)&hits=\(hits)&searchRadius=\(searchRadius)&datumType=\(datumType)&checkinDate=\(checkinDateFormatted)&checkoutDate=\(checkoutDateFormatted)&latitude=\(coordinater.latitude)&longitude=\(coordinater.longitude)&adultNum=\(adultNum)&roomNum=\(roomNum)&maxCharge=\(Int(maxCharge))&minCharge=\(Int(minCharge))\(squeezeConditionText)"
    }

    public init() {}
}
