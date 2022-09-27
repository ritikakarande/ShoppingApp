//
//  CartViewController.swift
//  ShoppingAppSprint
//
//  Created by Capgemini-DA087 on 9/26/22.
//

import UIKit
import CoreData

class CartViewCell: UITableViewCell{
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
}
class CartViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //loading core data in result array
    var result:[CartData] = []
    @IBOutlet weak var CartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Cart"
        fetch()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.CartTableView.delegate = self
            self.CartTableView.dataSource = self
            self.CartTableView.reloadData()
            
        }
    }
    func fetch() {
        let request = NSFetchRequest<CartData>(entityName: "CartData")
        do{
            result = try context.fetch(request)
        } catch {
            printContent("Fetch error")
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CartTableView.dequeueReusableCell(withIdentifier: "CartViewCell", for: indexPath) as! CartViewCell
        let cellData = result[indexPath.row]
        cell.itemTitle?.text = cellData.productTitle
        cell.itemImage.loadFrom(URLAddress: cellData.productImage!)
        cell.itemDescription?.text = cellData.productDescription
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

    @IBAction func orderNowClicked(_ sender: Any) {
        let addressMapVC = self.storyboard?.instantiateViewController(withIdentifier: "PlaceOrderViewController") as! PlaceOrderViewController
        self.navigationController?.pushViewController(addressMapVC, animated: true)
    }
}
