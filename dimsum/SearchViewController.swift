//
//  ViewController.swift
//  dimsum
//
//  Created by tyfoo on 21/08/2018.
//  Copyright © 2018 foo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)
    
    /*
    {
        "title" : "\u91D1\u79D8\u4E66"
    }
     */
    // Sample JSON response that return title with unicode characters based on json above
    let jsonString = "{ \"title\" : \"\\u91D1\\u79D8\\u4E66\"}"
    // dummy list data
    var dramaList:[String] = ["一千零一夜","为啥没延禧攻略","奶奶强盗团","延禧攻略","强盗团","国产凌凌漆"]
    
    // Unicode Binary in UInt16 format
    let value1: UInt16 = 0x653B
    let value2: UInt16 = 0x5FC3
    let value3: UInt16 = 0x8BA1
    
    var filtered:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        setupData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Setup list data
    func setupData() {
        
        // Convert UInt16 to string
        let first = String(UnicodeScalar(value1)!)
        let second = String(UnicodeScalar(value2)!)
        let third = String(UnicodeScalar(value3)!)
        dramaList.append(first+second+third)
        
        // Convert json string to data in UTF16 format
        guard let jsonData = jsonString.data(using: String.Encoding.utf16) else {
            print(#function, "Failed to convert json string to UTF16 data")
            return
        }
        
        // Serialize json object and add to data list
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dict = jsonObj as? [String: String], let title = dict["title"]
            {
                dramaList.append(title)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    /// Call this method to setup configuration of search controller on view did load.
    func configureSearchController() {
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        self.tableView.accessibilityLabel = "SearchTable"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerCellNib(SearchTableViewCell.self)
        filtered = dramaList
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.reloadData()
        
    }
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let oriCount = dramaList.count
        if isFiltering() {
            return filtered.count
        }
        return oriCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath)
        var item: String
        if isFiltering() {
            item = filtered[indexPath.row]
        } else {
            let list: [String] = dramaList
            item = list[indexPath.row]
        }

        cell.textLabel?.text = item

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String) {
        filtered = dramaList.filter({( occ : String) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else {
                return occ.contains(searchText)
            }
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!searchBarIsEmpty())
    }
}

extension SearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

