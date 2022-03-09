//
//  NetworkService.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation
import Alamofire
import Combine

protocol NetworkServiceProtocol {
    func searchLocation(name: String) -> AnyPublisher<DataResponse<[LocationModel], NetworkError>, Never>
    
    func getWeatherInfo(woeid: Int, day: Date) -> AnyPublisher<DataResponse<[WeatherInfo], NetworkError>, Never>
}

class NetworkService: NetworkServiceProtocol {
    
    enum ApiResquest: String {
        case searchLocation = "location/search?query="
        case fetchWeatherInfo = "location/%d/%@"
    }
    
    static let shared: NetworkServiceProtocol = NetworkService()
    private let baseUrlString = "https://www.metaweather.com/api/"
    private init() { }

    func searchLocation(name: String) -> AnyPublisher<DataResponse<[LocationModel], NetworkError>, Never> {
        let validQuery = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = baseUrlString + ApiResquest.searchLocation.rawValue + validQuery
        let url = URL(string: urlString)!
        
        let requestData = AF.request(url, method: .get)
        
        return makeRequest(request: requestData)
        
    }
    
    func getWeatherInfo(woeid: Int, day: Date) -> AnyPublisher<DataResponse<[WeatherInfo], NetworkError>, Never> {
        let urlString = baseUrlString + String(format: ApiResquest.fetchWeatherInfo.rawValue, woeid, day.toString(dateFormatter: "yyyy/mm/dd"))
        
        let url = URL(string: urlString)!
        
        let requestData = AF.request(url, method: .get)
        
        return makeRequest(request: requestData)
    }
    
    func makeRequest<T: Decodable>(request: DataRequest) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        return request
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let systemError = response.data.flatMap {
                        try? JSONDecoder().decode(SystemError.self, from: $0)
                    }
                    return NetworkError(error: error, systemError: systemError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
