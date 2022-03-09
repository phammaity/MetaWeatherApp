//
//  DateExtenstion.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation

extension Date {
    func toString(stringFormatter:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormatter
        return dateFormatter.string(from: self)
    }
}

