//
//  SelectedCategoryViewController.swift
//  ShoppingAppSprint
//
//  Created by Capgemini-DA087 on 9/26/22.
//

import UIKit
import Alamofire
import CoreData

class SelectedCategoryCell: UITableViewCell {
    

    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
   
}

class SelectedCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var selectedCategoryTableView: UITableView!
    var category: String = ""
    var productTitleArr = NSMutableArray()
    var productDescriptionArr = NSMutableArray()
    var localUrl: String = "https://dummyjson.com/products/category/"
    var productImageArr = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayselectedCategoryItems()
        // Do any additional setup after loading the view.
    }
    func displayselectedCategoryItems(){
        let url : String = localUrl + category + "/"
        Alamofire.request(url, method: .post, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success(_):
                if let items : [String : Any] = response.value as! [String : Any]? {
                    let jsonArr = items["products"] as! NSArray
                    for item in jsonArr{
                        let value = item as! NSDictionary
                        let titleStr = value["title"] as! String
                        let imgStr = value["thumbnail"] as! String
                        let descriptionStr = value["description"] as! String
                        self.productTitleArr.add(titleStr)
                        self.productImageArr.add(imgStr)
                        self.productDescriptionArr.add(descriptionStr)
                    }
                    print(self.productTitleArr)
                    print(self.productDescriptionArr)
                    DispatchQueue.main.async {
                        self.selectedCategoryTableView.delegate = self
                        self.selectedCategoryTableView.dataSource = self
                        self.selectedCategoryTableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectedCategoryTableView.dequeueReusableCell(withIdentifier: "SelectedCategoryCell", for: indexPath) as! SelectedCategoryCell
        cell.productTitleLabel?.text = productTitleArr[indexPath.row] as? String
        cell.productImageView.loadFrom(URLAddress: productImageArr[indexPath.row] as! String)
        cell.productDescriptionLabel?.text = productDescriptionArr[indexPath.row] as? String
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return cell
        
    }
    @objc func addToCart( sender : UIButton){
        let index = IndexPath(row: sender.tag, section: 0)
        let title = productTitleArr[index.row] as? String
        let description = productDescriptionArr[index.row] as? String
        let image = productImageArr[index.row] as? String
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let cart = NSEntityDescription.insertNewObject(forEntityName: "CartData", into: context) as! CartData
        cart.productImage = image
        cart.productTitle = title
        cart.productDescription = description
        do{
            try context.save()
            print("Data Stored")
        } catch {
            print("Can't Load")
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    

}
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        DispatchQueue.main.async {
            [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
