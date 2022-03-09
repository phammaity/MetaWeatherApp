//
//  HomeViewModel.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation
import Combine
import Foundation

protocol HomeDelegate: AnyObject {
    func startLoading()
    func dataDidLoad()
    func dataLoadError(error: String)
}

protocol HomeProtocol: AnyObject {
    func numberOfRows() -> Int
    func locationVM(at index: Int) -> LocationInfoProtocol
    func search(keyword: String)
}

class HomeViewModel: HomeProtocol {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var serviceManager: NetworkServiceProtocol
    private weak var delegate: HomeDelegate?
    var locationVMs: [LocationInfoProtocol] = []
    
    init(serviceManager: NetworkServiceProtocol = NetworkService.shared, delegate: HomeDelegate){
        self.serviceManager = serviceManager
        self.delegate = delegate
    }
    
    private func handleResponseData(data: [LocationModel]) {
        self.locationVMs = data.map{LocationInfoViewModel(locationModel: $0)}
    }
    
//MARK: HomeProtocol
    func search(keyword: String) {
        self.delegate?.startLoading()
        serviceManager.searchLocation(name: keyword)
            .sink {[weak self] (response) in
                if let _ = response.error {
                    self?.delegate?.dataLoadError(error: "System error")
                }else {
                    self?.handleResponseData(data: response.value ?? [])
                    self?.delegate?.dataDidLoad()
                }
            }
            .store(in: &cancellableSet)
    }
    
    func numberOfRows() -> Int {
        return self.locationVMs.count
    }
    
    func locationVM(at index: Int) -> LocationInfoProtocol {
        return self.locationVMs[index]
    }
}
