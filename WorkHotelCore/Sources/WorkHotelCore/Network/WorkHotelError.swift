//
//  WorkHotelError.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import Foundation

public enum WorkHotelError: LocalizedError {
    case invalidRequestURL
    case dataNotFound
    case failedToFindLocationFromKeyword
    case requestError(message: String)
    case customError(message: String)
    case unknown

    init(error: Error) {
        self = .requestError(message: error.localizedDescription)
    }

    public var shouldShowErrorAlert: Bool {
        switch self {
        case .dataNotFound: return false
        default: return true
        }
    }

    public var errorDescription: String? {
        switch self {
        case .invalidRequestURL:
            return "リクエストのURLが有効でありません"
        case .dataNotFound:
            return "データが見つかりません"
        case .failedToFindLocationFromKeyword:
            return "キーワードの検索の失敗しました"
        case .requestError(let message):
            return "リクエストエラー: \(message)"
        case .customError(let message):
            return message
        case .unknown:
            return "エラーが発生しました"
        }
    }
}
