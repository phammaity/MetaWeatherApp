//
//  LocationViewModel.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation

protocol LocationInfoProtocol {
    var name: String {get}
    var woeid: Int {get}
}

class LocationInfoViewModel: LocationInfoProtocol {
    private let locationModel: LocationModel
    
    init(locationModel: LocationModel) {
        self.locationModel = locationModel
    }
    
    var name: String {
        return locationModel.title
    }
    
    var woeid: Int {
        return locationModel.woeid
    }
     
}
