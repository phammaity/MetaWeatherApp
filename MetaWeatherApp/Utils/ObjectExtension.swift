//
//  ObjectExtension.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation

extension NSObject {

    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
