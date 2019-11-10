//
//  RecentsViewController.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController {
    
    @IBOutlet weak var recentsTableView: UITableView!
    
    var coreCities = [CoreCity]() {
        didSet {
            DispatchQueue.main.async {
                self.recentsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentsTableView.tableFooterView = UIView(frame: .zero)
        recentsTableView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreCities = CityManager.shared.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if coreCities.isEmpty {
            let alert = UIAlertController(title: "No Recent Cities", message: "Select a city on the search tab to start", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        //recentsTableView.isEditing = !recentsTableView.isEditing
        recentsTableView.isEditing.toggle()
    }
    
    

}

extension RecentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableCell", for: indexPath) as! RecentTableCell
        let city = coreCities[indexPath.row]
        let population = city.population!.addCommas ?? "Not Available"
        cell.recentMainLabel.text = "\(city.name!), \(city.state!)"
        cell.recentSubLabel.text = "Population: \(population)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = coreCities[indexPath.row]
            CityManager.shared.delete(city) //delete from CoreData
            coreCities.remove(at: indexPath.row) //remove from data source array
        }
    }
    

}
