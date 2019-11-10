//
//  ViewController.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    //WillSet - property observer - ran before the value has been set
    //DidSet - property observer - ran after the value has been set
    var cities = [City]() {
        didSet {
            orderedCities = order(cities: cities)
        }
    }
    
    var orderedCities = [String:[City]]() {
        didSet {
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    
    var filteredCities = [City]()
    
    //computed property - dynamically changes - everytime you access the variable it calculates the value
    var isFiltering: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //capture list - how you capture properties inside of your closure (weak/strong)
        //escaping closures can cause Retain Cycles, use weak to NOT increase the retain count
        CityManager.shared.getCities { [weak self] cts in
            self?.cities = cts
            print("City Count: \(cts.count)")
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        
        searchTableView.sectionIndexColor = UIColor.red
    }
    
    
    func order(cities: [City]) -> [String: [City]] {
        
        //create an empty dictionary
        var orderedCities = [String:[City]]()
        
        //loop through the cities and append the city to the correct letter
        for city in cities {
            let first = city.name.first!.uppercased()
            if orderedCities[first] == nil {
                orderedCities[first] = [city]
            } else {
                orderedCities[first]!.append(city)
            }
        }
        
         //loop through the dictionary and sort the cities
        for (key, cities) in orderedCities {
            orderedCities[key] = cities.sorted(by: { (cityOne, cityTwo) -> Bool in
                cityOne.name < cityTwo.name
            })
        }
        
//        var orderedCities = Dictionary(grouping: cities, by: {$0.name.first!.uppercased()})
//
//        for (key, cities) in orderedCities {
//            orderedCities[key] = cities.sorted(by: {$0.name < $1.name})
//        }
        
        return orderedCities
    }
    
    func getCities(for section: Int) -> [City] {
        //get the keys from the dict & order the keys
        let keys = orderedCities.keys.sorted(by: { $0 < $1})
        //get correct key for section
        let key = keys[section]
        //use the ordered keys to subscript the dictionary
        return orderedCities[key]!
    }
    
    func filter(cities bySearch: String) {
        
        //filter - the array based on a predicate
        filteredCities = cities.filter({
            $0.name.lowercased().contains(bySearch.lowercased()) ||
                $0.state.lowercased().contains(bySearch.lowercased())  })
        
        searchTableView.reloadData()
    }


}
//MARK: TableView

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //ternary operator - true statement on left, false on right
        return isFiltering ? 1 : orderedCities.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cities = getCities(for: section)
        return isFiltering ? filteredCities.count : cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableCell", for: indexPath) as! CityTableCell
        let cities = isFiltering ? filteredCities : getCities(for: indexPath.section)
        let city = cities[indexPath.row]
        let population = city.population.addCommas ?? "Not Available" //nil coalescing - give optional default value
        cell.cityMainLabel.text = "\(city.name), \(city.state)"
        cell.citySubLabel.text = "Population: \(population)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = orderedCities.keys.sorted(by: {$0 < $1})
        return isFiltering ? "Cities" : keys[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let keys = orderedCities.keys.sorted(by: {$0 < $1})
        return isFiltering ? nil : keys
    }

}

extension SearchViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cities = isFiltering ? filteredCities : getCities(for: indexPath.section)
        let city = cities[indexPath.row]
        CityManager.shared.save(city) //saving to CoreData
        
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVC.hidesBottomBarWhenPushed = true
        mapVC.city = city
        
        navigationController?.view.backgroundColor = .white
        navigationController?.pushViewController(mapVC, animated: true) //give you the back button - push onto stack
    }
    
}

//MARK: SearchResultsUpdating Delegate
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else { return }
        filter(cities: search)
    }
    

}
