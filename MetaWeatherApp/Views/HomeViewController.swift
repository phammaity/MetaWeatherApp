//
//  HomeViewController.swift
//  MetaWeatherApp
//
//  Created by Ty Pham on 09/03/2022.
//

import UIKit

class HomeViewController: BaseViewController {
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


//MARK: HomeDelegate
extension HomeViewController: HomeDelegate {
    func startLoading() {
        //TODO: display start indicator
    }
    
    func dataDidLoad() {
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        //TODO: close start indicator
    }
    
    func dataLoadError(error: String) {
        self.tableView.refreshControl?.endRefreshing()
        self.showErrorAlert(error: error)
        //TODO: close start indicator
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
