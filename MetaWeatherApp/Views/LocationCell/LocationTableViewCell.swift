//
//  LocationTableViewCell.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(viewModel: LocationInfoProtocol) {
        self.cityName.text = viewModel.name
    }
    
}
