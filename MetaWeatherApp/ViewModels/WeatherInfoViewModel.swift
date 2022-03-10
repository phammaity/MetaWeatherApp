//
//  WeatherInfoViewModel.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation
import Combine

protocol WeatherInfoDelegate: AnyObject {
    func startLoading()
    func dataDidLoad()
    func dataLoadError(error: String)
}

protocol WeatherInfoProtocol: AnyObject {
    var locationName: String {get}
    var tempString: String {get}
    var windSpeedString: String {get}
    var windDirectionString: String {get}
}

class WeatherInfoViewModel: WeatherInfoProtocol {
    private let locationVM: LocationInfoProtocol
    private var weatherInfo: WeatherInfo?
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var serviceManager: NetworkServiceProtocol
    private weak var delegate: WeatherInfoDelegate?
    
    init(locationVM: LocationInfoProtocol, serviceManager: NetworkServiceProtocol = NetworkService.shared, delegate: WeatherInfoDelegate) {
        self.locationVM = locationVM
        self.delegate = delegate
        self.serviceManager = serviceManager
        
        self.fetchWeatherInfo()
    }
    
    private func fetchWeatherInfo() {
        let now = Date()
        serviceManager.getWeatherInfo(woeid: locationVM.woeid, day: now)
            .sink {[weak self] (response) in
                if let _ = response.error {
                    self?.delegate?.dataLoadError(error: "System error")
                }else {
                    self?.weatherInfo = response.value?.first
                    self?.delegate?.dataDidLoad()
                }
            }
            .store(in: &cancellableSet)
    }
    
//MARK: WeatherInfoProtocol
    var locationName: String {
        return locationVM.name
    }
    
    var tempString: String {
        guard let info = weatherInfo else {
            return "_ _"
        }
        return String(format: "%.0f°", info.theTemp.rounded())
    }
    
    var windSpeedString: String {
        guard let info = weatherInfo else {
            return "_ _"
        }
        
        return String(format: "Wind speed: %.2f mph", info.windSpeed)
    }
    
    var windDirectionString: String {
        guard let info = weatherInfo else {
            return "_ _"
        }
        
        return String(format: "Wind direction: %.1f°", info.windDirection)
    }
    
}
