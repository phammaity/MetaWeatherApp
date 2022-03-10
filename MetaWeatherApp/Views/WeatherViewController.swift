//
//  WeatherViewController.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import Foundation
import UIKit

class WeatherViewController: BaseViewController {
    class func instantiate(locationVM: LocationInfoProtocol) -> WeatherViewController {
        let screen = AppStoryboards.main.instantiate(viewControllerClass: WeatherViewController.self)
        screen.viewModel = WeatherInfoViewModel(locationVM: locationVM, delegate: screen)
        return screen
    }
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var viewModel: WeatherInfoProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.startAnimating()
    }
    
    private func reloadData() {
        locationNameLabel.text = viewModel?.locationName
        tempLabel.text = viewModel?.tempString
        windSpeedLabel.text = viewModel?.windSpeedString
        windDirectionLabel.text = viewModel?.windDirectionString
    }
    
}

extension WeatherViewController: WeatherInfoDelegate {
    func startLoading() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func dataDidLoad() {
        indicator.isHidden = true
        indicator.stopAnimating()
        reloadData()
    }
    
    func dataLoadError(error: String) {
        indicator.isHidden = true
        indicator.stopAnimating()
        showErrorAlert(error: error)
    }
}
