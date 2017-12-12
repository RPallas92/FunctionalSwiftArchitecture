//
//  MasterViewController.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/4/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import UIKit

class CategoryListVC: UITableViewController, JokeCategoriesListView{
    
    var detailViewController: DetailViewController? = nil
    var categories = [CategoryViewModel]()
    var context:GetCategoriesContext?


    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        self.setUpDependencyGraph()
        
        //Execute presentation logic - run side effects
        getCategories().runT(context!, { _ in })
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func setUpDependencyGraph() {
        self.context = GetCategoriesContext(view: self)
    }
    func drawCategories(categories: [CategoryViewModel]) {
        self.categories = categories
        self.tableView.reloadData()
    }
    
    func showGenericError() {
        //TODO
    }

    // MARK: - Segues

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }*/

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        onJokeCategoryClick(categoryName: category.name).run(self.context!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel!.text = category.name
        return cell
    }
}

