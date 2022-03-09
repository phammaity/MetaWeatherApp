//
//  LocationModel.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation

struct LocationModel: Codable {
    var woeid: Int
    var title: String
    var locationType: String

    enum CodingKeys: String, CodingKey {
        case woeid
        case title
        case locationType
    }
}
