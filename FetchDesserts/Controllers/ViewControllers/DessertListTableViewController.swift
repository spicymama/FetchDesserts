//
//  DessertListTableViewController.swift
//  FetchDesserts
//
//  Created by Gavin Woffinden on 4/24/22.
//

import UIKit

class DessertListTableViewController: UITableViewController {
    var refresh: UIRefreshControl = UIRefreshControl()
    var desserts: [Dessert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        FetchDesserts.DessertController.fetchDesserts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newDes):
                    self.desserts = newDes
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
            self.loadData()
        }
    }
    
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.addSubview(refresh)
        self.tableView.reloadData()
    }
    
    
    @objc func loadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desserts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "desCell", for: indexPath) as? DessertTableViewCell else {return UITableViewCell()}
        let dessert = desserts[indexPath.row]
        cell.dessert = dessert
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? DetailViewController else {return}
            let selectedDessert = desserts[indexPath.row]
            DessertController.recipeID = selectedDessert.dessertID
            destinationVC.selectedDessert = selectedDessert
        }
    }
}
