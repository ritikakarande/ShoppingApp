//
//  SendNotificationViewController.swift
//  ShoppingAppSprint
//
//  Created by Capgemini-DA087 on 9/27/22.
//

import UIKit
import ShoppingNotifcationFramework
class SendNotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sendNotifaction = ShopNotifications()
        sendNotifaction.sendNotification()
        // Do any additional setup after loading the view.
    }
    

 
}

