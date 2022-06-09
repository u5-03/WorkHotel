//
//  WorkHotelSearchOptionView.swift
//  
//
//  Created by yugo.sugiyama on 2022/06/09.
//

import SwiftUI
import WorkHotelCore
import WorkHotelCore

public struct WorkHotelSearchOptionView: View {

    @Binding private var parameter: VacantHotelSearchParameter
    @State private var shouldShowValidationAlert = false
    @Environment(\.presentationMode) var presentationMode
    private let horizontalMargin: CGFloat = 8

    private var validationMessage: String {
        return parameter.validationMessageTypes
            .map(\.message).joined(separator: "\n")
    }

    public init(parameter: Binding<VacantHotelSearchParameter>) {
        self._parameter = parameter
    }

    private func optionToggle(title: String, bindValue: Binding<Bool>) -> some View {
        return Toggle(isOn: bindValue) {
            Text(title)
        }
        .tint(Color(WorkHotelCommon.themeColor))
    }

    private func optionSlider(title: String, bindValue: Binding<Double>) -> some View {
        return HStack {
            Text(title)
                .frame(width: 160, alignment: .leading)
            Slider(value: bindValue, in: 0...30_000, step: 1_000, onEditingChanged: { _ in })
                .tint(Color(WorkHotelCommon.themeColor))
        }
    }

    private func optionDatePicker(title: String, bindValue: Binding<Date>) -> some View {
        return DatePicker(title, selection: bindValue, displayedComponents: .date)
            .datePickerStyle(.compact)
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .accentColor(Color(WorkHotelCommon.themeColor))
    }

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    SubTitleView(title: "宿泊人数") {
                        Stepper(value: $parameter.adultNum, in: 1...10) {
                            Text("大人: \(parameter.adultNum)人")
                        }
                        .padding(.trailing, horizontalMargin)
                    }
                    SubTitleView(title: "部屋数") {
                        Stepper(value: $parameter.roomNum, in: 1...5) {
                            Text("部屋数: \(parameter.roomNum)部屋")
                        }
                        .padding(.trailing, horizontalMargin)
                    }
                    SubTitleView(title: "金額") {
                        VStack {
                            optionSlider(title: "下限金額: \(Int(parameter.minCharge))円", bindValue: $parameter.minCharge)
                            optionSlider(title: "上限金額: \(Int(parameter.maxCharge))円", bindValue: $parameter.maxCharge)
                        }
                        .padding(.trailing, horizontalMargin)
                    }

                    SubTitleView(title: "日付") {
                        VStack {
                            optionDatePicker(title: "チェックイン", bindValue: $parameter.checkinDate)
                            optionDatePicker(title: "チェックアウト", bindValue: $parameter.checkoutDate)
                        }
                        .padding(.trailing, horizontalMargin)
                    }

                    SubTitleView(title: "オプション") {
                        VStack {
                            optionToggle(title: "朝食", bindValue: $parameter.breakfastEnable)
                            optionToggle(title: "夕食", bindValue: $parameter.dinnerEnable)
                            optionToggle(title: "大浴場", bindValue: $parameter.daiyokuEnable)
                            optionToggle(title: "温泉", bindValue: $parameter.onsenEnable)
                            optionToggle(title: "禁煙", bindValue: $parameter.kinenEnable)
                            optionToggle(title: "インターネット", bindValue: $parameter.internetEnable)
                        }
                        .padding(.trailing, horizontalMargin)
                    }
                    Spacer()
                        .frame(height: 20)
                }
            }
            .navigationBarTitle("検索設定", displayMode: .inline)
            .navigationBarItems(
                leading: Button("検索") {
                    if parameter.validationMessageTypes.isEmpty {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        shouldShowValidationAlert = true
                    }
                }
                    .foregroundColor(Color(WorkHotelCommon.themeColor))
            )
            .alert(isPresented: $shouldShowValidationAlert) {
                Alert(title: Text(validationMessage))
            }
        }
        .interactiveDismissDisabled()
    }
}

public struct WorkHotelSearchOptionView_Previews: PreviewProvider {
    @State private static var parameter = VacantHotelSearchParameter()

    public static var previews: some View {
        WorkHotelSearchOptionView(parameter: $parameter)
    }
}
