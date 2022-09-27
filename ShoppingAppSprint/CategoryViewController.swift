//
//  CategoryViewController.swift
//  ShoppingAppSprint
//
//  Created by Capgemini-DA087 on 9/26/22.
//

import UIKit
import Alamofire


class CategoryTableViewCell: UITableViewCell{
    @IBOutlet weak var categoryLabel: UILabel!
}

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTableView: UITableView!
    var categoryArray = NSMutableArray()
    
    // Displays category types by fetching json link using alamofire
    func displayCategories() {
        
        // Fetching data from dummyjson URL using alamofire framework
        Alamofire.request("https://dummyjson.com/products/categories/", method: .post, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success :
                if let item: [String] = response.value as! [String]? {
                    for i in item{
                        self.categoryArray.add(i)
                        
                    }
                }
                //Displaying data through main thread
                DispatchQueue.main.async {
                    self.categoryTableView.delegate = self
                    self.categoryTableView.dataSource = self
                    self.categoryTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
      }
        //print(categoryArray)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Categories"
        displayCategories()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel?.text = categoryArray[indexPath.row] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Function for selecting a category
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectedCategoryViewController") as! SelectedCategoryViewController
        selectedCategoryVC.category = categoryArray[indexPath.row] as! String
        self.navigationController?.pushViewController(selectedCategoryVC, animated: true)
    }

}
