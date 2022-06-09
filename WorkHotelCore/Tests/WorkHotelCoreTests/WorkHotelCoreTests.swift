import XCTest
@testable import WorkHotelCore

final class WorkHotelCoreTests: XCTestCase {
    func testVancantHotelSearchResponse() throws {
        let json = """
        {
            "pagingInfo": {
                "recordCount": 74,
                "pageCount": 74,
                "page": 1,
                "first": 1,
                "last": 1
            },
            "hotels": [
                {
                    "hotel": [
                        {
                            "hotelBasicInfo": {
                                "hotelNo": 141356,
                                "hotelName": "高濃度炭酸泉　八重桜の湯　スーパーホテルＰｒｅｍｉｅｒ東京駅八重洲中央口",
                                "hotelInformationUrl": "https://img.travel.rakuten.co.jp/image/tr/api/re/pvonD/?f_no=141356",
                                "planListUrl": "https://img.travel.rakuten.co.jp/image/tr/api/re/vFumt/?f_no=141356&f_flg=PLAN",
                                "dpPlanListUrl": "https://img.travel.rakuten.co.jp/image/tr/api/re/WzozX/?noTomariHotel=141356",
                                "reviewUrl": "https://img.travel.rakuten.co.jp/image/tr/api/re/gJNfM/?f_hotel_no=141356",
                                "hotelKanaName": "やえざくらのゆ　すーぱーほてるぷれみあとうきょうえきやえすちゅうおうぐち",
                                "hotelSpecial": "男女別の大浴場「高濃度人工炭酸泉 八重桜の湯」 ゆっくりとお湯につかり免疫力アップ！ カップル・女性にお勧め♪",
                                "hotelMinCharge": 3010,
                                "latitude": 128433.61,
                                "longitude": 503183,
                                "postalCode": "104-0028",
                                "address1": "東京都",
                                "address2": "中央区八重洲2-2-7　 ",
                                "telephoneNo": "03-3241-9000",
                                "faxNo": "03-3241-9003",
                                "access": "東京駅より徒歩３分（八重洲中央口より）、羽田空港よりリムジンバスで30分、成田空港よりJRエクスプレスで60分。",
                                "parkingInformation": "立体駐車場20台/1泊1000円/入庫時間15：00～24：00・出庫時間7：00～11：00/",
                                "nearestStation": "東京",
                                "hotelImageUrl": "https://img.travel.rakuten.co.jp/share/HOTEL/141356/141356.jpg",
                                "hotelThumbnailUrl": "https://img.travel.rakuten.co.jp/HIMG/90/141356.jpg",
                                "roomImageUrl": null,
                                "roomThumbnailUrl": null,
                                "hotelMapImageUrl": "https://img.travel.rakuten.co.jp/share/HOTEL/141356/141356map.gif",
                                "reviewCount": 2724,
                                "reviewAverage": 4.55,
                                "userReview": "綺麗で清潔。スタッフもアットホームな雰囲気で心安らぎます。　2022-06-06 23:13:22投稿"
                            }
                        },
                        {
                            "roomInfo": [
                                {
                                    "roomBasicInfo": {
                                        "roomClass": "sma",
                                        "roomName": "【素泊まり】お部屋タイプお任せ【当日までのお楽しみ】",
                                        "planId": 5111060,
                                        "planName": "【素泊まり】キャッシュレスde三密回避♪オンライン決済限定プラン☆高濃度人工炭酸泉付き",
                                        "pointRate": 1,
                                        "withDinnerFlag": 0,
                                        "dinnerSelectFlag": 0,
                                        "withBreakfastFlag": 0,
                                        "breakfastSelectFlag": 0,
                                        "payment": "2",
                                        "reserveUrl": "https://img.travel.rakuten.co.jp/image/tr/api/re/IdsCY/?f_no=141356&f_syu=sma&f_hi1=2022-06-10&f_hi2=2022-06-11&f_heya_su=1&f_otona_su=1&f_s1=0&f_s2=0&f_y1=0&f_y2=0&f_y3=0&f_y4=0&f_camp_id=5111060",
                                        "salesformFlag": 0
                                    }
                                },
                                {
                                    "dailyCharge": {
                                        "stayDate": "2022-06-10",
                                        "rakutenCharge": 9900,
                                        "total": 9900,
                                        "chargeFlag": 0
                                    }
                                }
                            ]
                        },
                        {
                            "roomInfo": [
                                {
                                    "roomBasicInfo": {
                                        "roomClass": "sma",
                                        "roomName": "【素泊まり】お部屋タイプお任せ【当日までのお楽しみ】",
                                        "planId": 5111907,
                                        "planName": "【素泊まり】【東京都民応援】近場で安全！健康イオン水大浴場＆高濃度人工炭酸泉で身近な贅沢を！",
                                        "pointRate": 1,
                                        "withDinnerFlag": 0,
                                        "dinnerSelectFlag": 0,
                                        "withBreakfastFlag": 0,
                                        "breakfastSelectFlag": 0,
                                        "payment": "1",
                                        "reserveUrl": "https://img.travel.rakuten.co.jp/image/tr/api/re/IdsCY/?f_no=141356&f_syu=sma&f_hi1=2022-06-10&f_hi2=2022-06-11&f_heya_su=1&f_otona_su=1&f_s1=0&f_s2=0&f_y1=0&f_y2=0&f_y3=0&f_y4=0&f_camp_id=5111907",
                                        "salesformFlag": 0
                                    }
                                },
                                {
                                    "dailyCharge": {
                                        "stayDate": "2022-06-10",
                                        "rakutenCharge": 9900,
                                        "total": 9900,
                                        "chargeFlag": 0
                                    }
                                }
                            ]
                        },
                        {
                            "roomInfo": [
                                {
                                    "roomBasicInfo": {
                                        "roomClass": "sma",
                                        "roomName": "【素泊まり】お部屋タイプお任せ【当日までのお楽しみ】",
                                        "planId": 5109768,
                                        "planName": "【素泊まり】【楽天限定】直前プラン☆健康イオン水大浴場＆高濃度人工炭酸泉付き",
                                        "pointRate": 1,
                                        "withDinnerFlag": 0,
                                        "dinnerSelectFlag": 0,
                                        "withBreakfastFlag": 0,
                                        "breakfastSelectFlag": 0,
                                        "payment": "1",
                                        "reserveUrl": "https://img.travel.rakuten.co.jp/image/tr/api/re/IdsCY/?f_no=141356&f_syu=sma&f_hi1=2022-06-10&f_hi2=2022-06-11&f_heya_su=1&f_otona_su=1&f_s1=0&f_s2=0&f_y1=0&f_y2=0&f_y3=0&f_y4=0&f_camp_id=5109768",
                                        "salesformFlag": 0
                                    }
                                },
                                {
                                    "dailyCharge": {
                                        "stayDate": "2022-06-10",
                                        "rakutenCharge": 10000,
                                        "total": 10000,
                                        "chargeFlag": 0
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        }
        """
        let res = try! JSONDecoder().decode(VacantHotelSearchResponse.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(res.pagingInfo.page, 1)
        XCTAssertEqual(res.hotels.count, 1)
        XCTAssertEqual(res.hotels.first?.hotel.count, 4)
        let hotelBasicInfo = res.hotels.first!.hotel.first(where: \.isHotelBasicInfo)!.hotelBacisInfo!
        XCTAssertEqual(hotelBasicInfo.hotelNo, 141356)
        XCTAssertEqual(hotelBasicInfo.hotelName, "高濃度炭酸泉　八重桜の湯　スーパーホテルＰｒｅｍｉｅｒ東京駅八重洲中央口")
        XCTAssertEqual(hotelBasicInfo.hotelKanaName, "やえざくらのゆ　すーぱーほてるぷれみあとうきょうえきやえすちゅうおうぐち")
        XCTAssertEqual(hotelBasicInfo.hotelInformationURL, URL(string: "https://img.travel.rakuten.co.jp/image/tr/api/re/pvonD/?f_no=141356")!)
        XCTAssertEqual(hotelBasicInfo.planListURL, URL(string: "https://img.travel.rakuten.co.jp/image/tr/api/re/vFumt/?f_no=141356&f_flg=PLAN")!)
        XCTAssertEqual(hotelBasicInfo.dpPlanListURL, URL(string: "https://img.travel.rakuten.co.jp/image/tr/api/re/WzozX/?noTomariHotel=141356")!)
        XCTAssertEqual(hotelBasicInfo.latitude, 128433.61)
        XCTAssertEqual(hotelBasicInfo.longitude, 503183)
        XCTAssertEqual(hotelBasicInfo.postalCode, "104-0028")
        XCTAssertEqual(hotelBasicInfo.address1, "東京都")
        XCTAssertEqual(hotelBasicInfo.address2, "中央区八重洲2-2-7　 ")
        XCTAssertEqual(hotelBasicInfo.telephoneNo, "03-3241-9000")
        XCTAssertEqual(hotelBasicInfo.faxNo, "03-3241-9003")
        XCTAssertEqual(hotelBasicInfo.access, "東京駅より徒歩３分（八重洲中央口より）、羽田空港よりリムジンバスで30分、成田空港よりJRエクスプレスで60分。")
        XCTAssertEqual(hotelBasicInfo.nearestStation, "東京")

        XCTAssertEqual(hotelBasicInfo.hotelImageURL, URL(string:  "https://img.travel.rakuten.co.jp/share/HOTEL/141356/141356.jpg")!)
        XCTAssertEqual(hotelBasicInfo.hotelThumbnailURL, URL(string: "https://img.travel.rakuten.co.jp/HIMG/90/141356.jpg")!)
        XCTAssertEqual(hotelBasicInfo.roomImageURL, nil)
        XCTAssertEqual(hotelBasicInfo.hotelMapImageURL, URL(string: "https://img.travel.rakuten.co.jp/share/HOTEL/141356/141356map.gif")!)
        XCTAssertEqual(hotelBasicInfo.reviewCount, 2724)
        XCTAssertEqual(hotelBasicInfo.reviewAverage, 4.55)
    }

    func testSearchOptionValidation() throws {
        var parameter = VacantHotelSearchParameter()
        XCTAssertEqual(parameter.validationMessageTypes, [])

        parameter.checkinDate = Date().offsetDays(offset: -1)!
        XCTAssertEqual(parameter.validationMessageTypes, [.checkinDateSmallerToday])
        parameter.checkinDate = Date().offsetDays(offset: -2)!
        parameter.checkoutDate = Date().offsetDays(offset: -2)!
        XCTAssertEqual(parameter.validationMessageTypes, [.checkinDateSmallerToday, .checkoutDateSmallerCheckinDate])
        parameter.checkoutDate = Date().offsetDays(offset: -3)!
        XCTAssertEqual(parameter.validationMessageTypes, [.checkinDateSmallerToday, .checkoutDateSmallerCheckinDate])

        parameter = VacantHotelSearchParameter()
        parameter.maxCharge = 1000
        parameter.minCharge = 1000
        XCTAssertEqual(parameter.validationMessageTypes, [.maxChargeSmallerMinCharge])

        parameter.maxCharge = 1000
        parameter.minCharge = 1001
        XCTAssertEqual(parameter.validationMessageTypes, [.maxChargeSmallerMinCharge])

        parameter.maxCharge = 1001
        parameter.minCharge = 1000
        XCTAssertEqual(parameter.validationMessageTypes, [])
    }
}
