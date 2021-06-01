//
//  ViewController.swift
//  Assignment_API_Sqlite
//
//  Created by Mirajkar on 01/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    //MARK: Global variables
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        NetworkManager.shared.getUsersInfo { (message) in
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
}


extension UserViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DBHelper.shared.read().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        let userObj = DBHelper.shared.read()[indexPath.row]
        cell.nameLabel.text = userObj.name
        cell.emailLabel.text = userObj.email
        cell.zipcodeLabel.text = userObj.zipcode
        cell.companyNameLabel.text = userObj.companyName
        //
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    //MARK: UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "UserDetailViewControllerID") as? UserDetailViewController else {
            return
        }
        detailVC.userObject = DBHelper.shared.read()[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: view.frame.width / 2)
    }
}
