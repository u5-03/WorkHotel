//
//  CarouselView.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/07.
//

import SwiftUI
import WorkHotelCore
import WorkHotelCore
import WorkHotelDetail

struct CarouselView: View {
    let hotelList: [VacantHotelSearchBasicInfoResponse]
    @Binding var currentIndex: Int
    @Binding var isPushNavigationActive: Bool
    @GestureState private var dragOffset: CGFloat = 0
    private let itemPadding: CGFloat = 16
    private let itemWidthRatio: CGFloat = 0.8

    private func carouselItemView(index: Int, itemSize: CGSize) -> some View {
        return HStack(spacing: 0) {
            // TODO: Image cache
            AsyncImage(url: hotelList[index].hotelImageURL, transaction: Transaction(animation: .easeInOut(duration: 0.6))) { phase in
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
            .frame(width: 150)
            .clipped()
            VStack(alignment: .leading, spacing: 8) {
                Text(hotelList[index].hotelName)
                    .foregroundColor(Color(.label))
                    .font(.system(size: 12, weight: .bold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(hotelList[index].access)
                    .foregroundColor(Color(.systemGray))
                    .font(.system(size: 8, weight: .bold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if let reviewAverage = hotelList[index].reviewAverage {
                    StarReviewView(reviewAverage: reviewAverage)
                        .frame(height: 12)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 8)
        }
        .frame(width: itemSize.width * itemWidthRatio, height: itemSize.height)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .padding(.leading, index == 0 ? itemSize.width * (1 - itemWidthRatio) / 2 : 0)
    }

    var body: some View {
        GeometryReader { gr in
            LazyHStack(spacing: itemPadding) {
                ForEach(hotelList.indices, id: \.self) { index in
                    carouselItemView(index: index, itemSize: gr.size)
                        .onTapGesture {
                            isPushNavigationActive = true
                        }
                }
            }
            .offset(x: dragOffset)
            .offset(x: -CGFloat(currentIndex) * (gr.size.width * itemWidthRatio + itemPadding))
            .gesture(
                DragGesture()
                    .updating($dragOffset, body: { value, state, _ in
                        // Since it is not necessary to scroll at the beginning and end, control by dragging to 1/5 of the screen size
                        if currentIndex == 0, value.translation.width > 0 {
                            state = value.translation.width / 5
                        } else if currentIndex == (hotelList.count - 1), value.translation.width < 0 {
                            state = value.translation.width / 5
                        } else {
                            state = value.translation.width
                        }
                    })
                    .onEnded({ value in
                        var newIndex = currentIndex
                        // Judging paging from drag width
                        if abs(value.translation.width) > gr.size.width * 0.3 {
                            newIndex = value.translation.width > 0 ? currentIndex - 1 : currentIndex + 1
                        }
                        // Check not to exceed the minimum page and maximum page
                        if newIndex < 0 {
                            newIndex = 0
                        } else if newIndex > (hotelList.count - 1) {
                            newIndex = hotelList.count - 1
                        }
                        $currentIndex.wrappedValue = newIndex
                    })
            )
            .animation(.interpolatingSpring(mass: 0.6, stiffness: 150, damping: 80, initialVelocity: 0.1), value: UUID())
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    @State static private var currentIndex = 0
    @State static private var isPushNavigationActive = false
    private static let hotelList: [VacantHotelSearchBasicInfoResponse] = [.mock, .mock, .mock, .mock, .mock]
    static var previews: some View {
        VStack {
            Spacer()
            CarouselView(hotelList: hotelList, currentIndex: $currentIndex, isPushNavigationActive: $isPushNavigationActive)
                .frame(height: 100)
        }
        .preferredColorScheme(.light)
        .previewDevice(device: .iPhone11Pro)
        .background(Color.orange)
        .previewInterfaceOrientation(.portrait)
        VStack {
            Spacer()
            CarouselView(hotelList: hotelList, currentIndex: $currentIndex, isPushNavigationActive: $isPushNavigationActive)
                .frame(height: 100)
        }
        .preferredColorScheme(.dark)
        .previewDevice(device: .iPhone11Pro)
        .background(Color.orange)
        .previewInterfaceOrientation(.portrait)
    }
}
