//
//  StarReviewView.swift
//
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import SwiftUI

public struct StarReviewView: View {
    let reviewAverage: Double
    let maxReviewPoint = 5
    private var reviewAverageFloored: Int {
        return Int(floor(reviewAverage))
    }
    private var reviewAverageFraction: Double {
        return reviewAverage - Double(reviewAverageFloored)
    }
    private var reviewAverageList: [Double] {
        var list = (0..<reviewAverageFloored).map({ _ in Double(1) })
        if reviewAverageFloored != maxReviewPoint {
            list.append(reviewAverageFraction)
        }
        list += (0..<maxReviewPoint - list.count).map({ _ in Double(0) })
        return list
    }

    public init(reviewAverage: Double) {
        self.reviewAverage = reviewAverage
    }

    private func commonStarView(color: UIColor, viewLength: CGFloat) -> some View {
        return Image(systemName: "star.fill")
            .resizable()
            .foregroundColor(Color(color))
            .frame(width: viewLength, height: viewLength)
    }

    private func reviewSingleStar(reviewPoint: Double, viewLength: CGFloat) -> some View {
        return ZStack {
            commonStarView(color: .systemGray5, viewLength: viewLength)
            commonStarView(color: WorkHotelCommon.themeColor, viewLength: viewLength)
                .mask(Rectangle().padding(.trailing, viewLength * (1 - reviewPoint)))
        }
    }

    public var body: some View {
        GeometryReader { gr in
            HStack(spacing: 0) {
                ForEach(0..<reviewAverageList.count, id: \.asString) { index in
                    reviewSingleStar(reviewPoint: reviewAverageList[index], viewLength: gr.size.height)
                }
            }
        }
    }
}

public struct StarReviewView_Previews: PreviewProvider {
    public static var previews: some View {
        StarReviewView(reviewAverage: 3.5)
            .frame(height: 20)
            .background(Color.blue)
    }
}

