//
//  WeatherInfo.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation

struct WeatherInfo: Codable {
    var id: Int
    var theTemp: Float
    var windSpeed: Float
    var windDirection: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
    }
}
