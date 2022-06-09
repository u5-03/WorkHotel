//
//  SubTitleView.swift
//  ShowRoom
//
//  Created by yugo.sugiyama on 2021/11/26.
//  Copyright © 2021 SHOWROOM Inc. All rights reserved.
//

import SwiftUI

public struct SubTitleView<T: View>: View {

    private let title: String
    private let childView: T
    private let padding: CGFloat = 4

    public init( title: String, @ViewBuilder childView: () -> T) {
        self.title = title
        self.childView = childView()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(.label))
                    .background(Color.clear)
                    .padding(.horizontal, padding)
                Spacer()
            }
            .frame(height: 40)
            .background(Color(UIColor.systemGray5))
            childView
                .background(Color(UIColor.systemBackground))
                .padding(padding)
        }
    }
}

public struct SubTitleView_Previews: PreviewProvider {
    public static var previews: some View {
        VStack(alignment: .leading) {
            SubTitleView(title: "Test") {
                Text("Test!!")
                    .frame(height: 200)
            }
            Spacer()
        }
        .padding(.vertical)
    }
}
