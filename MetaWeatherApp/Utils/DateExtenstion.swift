//
//  DateExtenstion.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation
extension Date {
    func toString(dateFormatter:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatter
        return dateFormatter.string(from: self)
    }
}
