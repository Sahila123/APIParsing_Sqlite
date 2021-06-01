//
//  UserDetailViewController.swift
//  Assignment_API_Sqlite
//
//  Created by Mirajkar on 01/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    //MARK: Global variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!

    var userObject : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = userObject?.name
        emailLabel.text = userObject?.email
        zipcodeLabel.text = userObject?.zipcode
        companyNameLabel.text = userObject?.companyName

    }

}
