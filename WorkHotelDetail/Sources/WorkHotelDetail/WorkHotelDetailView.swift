//
//  WorkHotelDetailView.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/08.
//

import SwiftUI
import WorkHotelCore
import WorkHotelCore

public struct WorkHotelDetailView: View {
    private let hotelInfo: VacantHotelSearchBasicInfoResponse
    private var sightseeingSpotURL: URL? {
        let urlString = "https://www.google.com/search?q=\((hotelInfo.address1 + hotelInfo.address2).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)+\("観光スポット".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        return URL(string: urlString)
    }

    public init(hotelInfo: VacantHotelSearchBasicInfoResponse) {
        self.hotelInfo = hotelInfo
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(hotelInfo.hotelName)
                            .font(.system(size: 18, weight: .bold))
                        HStack {
                            if let reviewAverage = hotelInfo.reviewAverage {
                                StarReviewView(reviewAverage: reviewAverage)
                                    .frame(width: 90, height: 18)
                            }
                            if let reviewAverage = hotelInfo.reviewAverage {
                                Text(String(reviewAverage))
                                    .font(.system(size: 14))
                            }
                            if let reviewCount = hotelInfo.reviewCount {
                                Text("(レビュー数: \(reviewCount))")
                                    .font(.system(size: 14))
                            }
                            Spacer()
                        }
                        if let hotelSpecial = hotelInfo.hotelSpecial {
                            Text(hotelSpecial)
                                .foregroundColor(Color(.systemGray))
                                .font(.system(size: 14, weight: .regular))
                        }
                        Text("最安料金: \(hotelInfo.hotelMinCharge)円")
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 4)
                    AsyncImage(url: hotelInfo.hotelImageURL, transaction: Transaction(animation: .easeInOut(duration: 0.6))) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error != nil {
                            Text("No image")
                        } else {
                            ProgressView()
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                }
                SubTitleView(title: "住所") {
                    HStack {
                        Text(hotelInfo.postalCode + "\n" + hotelInfo.address1 + hotelInfo.address2)
                        Spacer()
                        if let mapURL = URL(string: "maps://?q=\(hotelInfo.latitude),\(hotelInfo.longitude)") {
                            Link(destination: mapURL) {
                                Image(systemName: "map.fill")
                                    .resizable()
                                    .imageScale(.large)
                                    .padding(6)
                                    .background(Color(WorkHotelCommon.themeColor))
                                    .foregroundColor(.white)
                                    .frame(width: 28, height: 28)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.trailing, 4)
                }
                SubTitleView(title: "アクセス") {
                    Text(hotelInfo.access)
                }
                if let nearestStation = hotelInfo.nearestStation {
                    SubTitleView(title: "最寄駅") {
                        Text(nearestStation)
                    }
                }
                SubTitleView(title: "電話番号") {
                    HStack {
                        Text(hotelInfo.telephoneNo)
                            .lineLimit(1)
                        Spacer()
                        Button {
                            guard let url = URL(string: "tel://" + hotelInfo.telephoneNo) else { return }
                            UIApplication.shared.open(url)
                        } label: {
                            Image(systemName: "phone.fill")
                                .resizable()
                                .imageScale(.large)
                                .padding(6)
                                .background(Color(WorkHotelCommon.themeColor))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.trailing, 4)
                }
                SubTitleView(title: "WEBページで詳細を確認") {
                    VStack(alignment: .leading, spacing: 8) {
                        Link(destination: hotelInfo.hotelInformationURL) {
                            Text("ホテル情報")
                                .frame(height: 24)
                        }
                        .foregroundColor(Color(WorkHotelCommon.themeColor))
                        Link(destination: hotelInfo.planListURL) {
                            Text("プラン一覧")
                                .frame(height: 24)
                        }
                        .foregroundColor(Color(WorkHotelCommon.themeColor))
                        if let sightseeingSpotURL = sightseeingSpotURL {
                            Link(destination: sightseeingSpotURL) {
                                Text("周辺の観光スポット")
                                    .frame(height: 24)
                                    .frame(height: 24)
                            }
                            .foregroundColor(Color(WorkHotelCommon.themeColor))
                        }
                    }
                }
                Spacer()
                    .frame(height: 20)
            }
        }
    }
}

public struct WorkHotelDetailView_Previews: PreviewProvider {
    public static var previews: some View {
        WorkHotelDetailView(hotelInfo: .mock)
    }
}
