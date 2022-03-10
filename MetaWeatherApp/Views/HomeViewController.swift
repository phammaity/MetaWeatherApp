//
//  HomeViewController.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: HomeProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = HomeViewModel(delegate: self)
        
        //configure tableview
        tableView.registerCellFromNib(LocationTableViewCell.self)
        
        //configure searchbar
        searchBar.placeholder = "Search city by name"
        noResultLabel.isHidden = true
    }

    private func showWeatherDetail(locationVM: LocationInfoProtocol) {
        let vc = WeatherViewController.instantiate(locationVM: locationVM)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(LocationTableViewCell.self, forIndexPath: indexPath)
        
        if let locationVM = self.viewModel?.locationVM(at: indexPath.row) {
            cell.configureUI(viewModel: locationVM)
        }
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let locationVM = viewModel?.locationVM(at: indexPath.row) else {
            return
        }
        showWeatherDetail(locationVM: locationVM)
    }
}

//MARK: HomeDelegate
extension HomeViewController: HomeDelegate {
    func startLoading() {
        //TODO: display start indicator
    }
    
    func dataDidLoad() {
        self.noResultLabel.isHidden = !(viewModel?.isNoResult ?? false)
        self.tableView.reloadData()
    }
    
    func dataLoadError(error: String) {
        self.noResultLabel.isHidden = true
        self.showErrorAlert(error: error)
    }
}

//MARK: SearchDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let keyword = searchBar.text, keyword.isEmpty == false else {
            return
        }
        viewModel?.search(keyword: keyword)
    }
}
