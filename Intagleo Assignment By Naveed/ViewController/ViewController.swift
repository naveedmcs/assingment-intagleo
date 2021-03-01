//
//  ViewController.swift
//  Intagleo Assignment By Naveed
//
//  Created by Muhammad  Naveed on 28/02/2021.
//  Copyright © 2021 Itagleo. All rights reserved.
//

import UIKit




class ViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchBarView: UISearchBar!
    
    //MARK:-  dependencies
    private let photosAPIManager = PhotosAPIManager()
    
    
    // sorting type
    enum SortType: String, CaseIterable  {
        case Ascending
        case Descending
    }
    
    //MARK:-  private properties
    private var currentSortOrder: SortType = .Ascending {
        didSet {
            self.groupCategoryByAlbumID = self.group(photosResponseList, order: currentSortOrder)
            self.tableView.reloadData()
        }
    }
    private var photosResponseList = [PhotoResponseModel]() {
        didSet {
            self.groupCategoryByAlbumID = self.group(photosResponseList, order: currentSortOrder)
            self.tableView.reloadData()
        }
    }

    private var groupCategoryByAlbumID: [[PhotoResponseModel]] = []
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK:-  viewi life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photos List"
        self.setupSearchViewController()
        self.tableView.tableFooterView = UIView()
        self.requestToFetchPhotosList()
        
        
    }
    
    
    //MARK:-  setupviews
    private func setupSearchViewController(){
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search By ID"
        searchController.searchBar.keyboardType = .numberPad
        self.navigationItem.searchController = self.searchController
        searchController.delegate = self
        self.definesPresentationContext = true
        
    }
    //MARK:-  private methods
    private func group(_ result : [PhotoResponseModel], order: SortType)-> [[PhotoResponseModel]] {
        self.navigationItem.title = "Photo List (\(result.count))"
        switch order {
        case .Ascending:
            return Dictionary(grouping: result) { $0.albumID! }
                .sorted(by: {$0.key < $1.key})
                .map {$0.value}
        case .Descending:
            return Dictionary(grouping: result) { $0.albumID! }
                .sorted(by: {$0.key > $1.key})
                .map {$0.value}
        }
        
        
    }
    
    private func openSortingSelectionPopUp() {
        let selectedValue = currentSortOrder.rawValue
        let action = UIAlertController.actionSheetWithItems(
            items:[(SortType.Ascending.rawValue,SortType.Ascending.rawValue),
                   (SortType.Descending.rawValue,SortType.Descending.rawValue)],
            currentSelection: selectedValue, action: { [self] (value)  in
                self.currentSortOrder = SortType(rawValue: value) ?? .Ascending
                if currentSortOrder == .Ascending {
                    self.photosResponseList.reverse()//.sort{$0.id! < $1.id!}
                }
                else if currentSortOrder == .Descending {
                    self.photosResponseList.reverse()//.sort{$0.id! > $1.id!}
                }
                
            })
        action.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(action, animated: true, completion: nil)
    }
    
    
    //MARK:-  actions
    @IBAction private func searchBtnTapped() {
        
    }
    
    @IBAction private func sortBtntapped() {
        openSortingSelectionPopUp()
    }
    
    
    
    
    
}

//MARK:-  api request
private extension ViewController {
    
    func requestToFetchPhotosList() {
        tableView.showActivityIndicator()
        photosAPIManager.photoList { [weak self] (result) in
            guard let self = self else { return }
            self.tableView.hideActivityIndicator()
            switch result {
            case .success(let response):
                self.photosResponseList = response
            case .failure(let error):
                self.showAlert(alertMessage: error)
            }
        }
    }
    
}


//MARK:-  tableview data Source
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupCategoryByAlbumID.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupCategoryByAlbumID[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.className) as! PhotoTableViewCell
        let section = groupCategoryByAlbumID[indexPath.section]
        cell.updateCell(object: section[indexPath.row])
        return cell
    }
    
    
}
//MARK:-  tableview delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  "Album ID: \( groupCategoryByAlbumID[section].first?.albumID?.toString ?? "--")"
        
    }
}




//MARK:-  search Controller Implementation
extension ViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text?.count ?? 0 > 0 {
            let searchID = Int(searchController.searchBar.text!) ?? 0
            let currentList = self.photosResponseList
            let filteredResult = currentList.filter({$0.id == searchID})
            self.groupCategoryByAlbumID = self.group(filteredResult, order: currentSortOrder)
            self.tableView.reloadData()
        } else {
            
            self.groupCategoryByAlbumID = self.group(self.photosResponseList, order: currentSortOrder)
            self.tableView.reloadData()
        }
    }
    
}



