//
//  YQHomeViewController.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/30/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class YQHomeViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cartButton: YQBarButtonItem!
    
    var categories = [YQCategory]()
    var filtereditems = [YQCategory]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: .zero)
        self.searchBar.autocapitalizationType = .none
        self.fetchCategories()
    }

    func fetchCategories() {
        let router = Router(endpoint: .GetCategories)
        self.showLoadingScreen()
        APIManager.shared.getCategories(router: router, success: { (categories) in
            self.categories = categories
            self.filtereditems = categories
            self.tableView.reloadData()
            self.hideLoadingScreen()
            
        }, failure: { (error: Error) in
            DispatchQueue.main.async {
                self.hideLoadingScreen()
            }
            print(error)
            //Show error
        })
    }
    
    @IBAction func didClickMenuButton(_ sender: Any) {
        if let drawer = self.navigationController?.parent as? YQDrawerController {
            drawer.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func didClickCartButton(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtereditems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! YQItemViewCell
        let category = self.filtereditems[indexPath.row]
        cell.titleLabel.text = category.title
        cell.items = category.items
        cell.itemsCollectionView.tag = indexPath.row
        
        cell.updateCart = {[weak self] () -> Void in
            if let weakSelf = self {
                weakSelf.updateCartIcon()
            }
        }
        
        return cell
    }
    
    func updateCartIcon() {
        self.cartButton.badgeValue = YQUser.shared.bag.count
    }
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let text = searchText.trimmingCharacters(in: CharacterSet.whitespaces).characters.count
        
        if text > 0 {
            var array = [YQCategory]()
            for category in self.categories {
                let filteredArray = category.items.filter({ (item) -> Bool in
                    return item.itemName.lowercased().contains(searchText.lowercased())
                })
                
                if filteredArray.count > 0 {
                    let object = category.copy() as! YQCategory
                    object.items = filteredArray
                    array.append(object)
                }
            }
            
            self.filtereditems = array
        }
        else {
            self.filtereditems = self.categories
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}

class YQItemViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    var updateCart: (() -> Void)? = nil
    
    var items = [YQItem]() {
        didSet {
            self.itemsCollectionView.reloadData()
        }
    }
    
    // MARK: - Collection view data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! YQProductViewCell
        let item = self.items[indexPath.row]
        cell.itemName.text = item.itemName
        cell.itemImageView.setImageWithUrl(item.itemUrl, placeHolderImage: UIImage(named: "placeholder"))
        
        if YQUser.shared.bag[item.itemSku] != nil {
            cell.notInCart()
        }
        else {
            cell.addedToCart()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        if YQUser.shared.bag[item.itemSku] != nil {
            YQUser.shared.bag[item.itemSku] = nil
        }
        else {
            YQUser.shared.bag[item.itemSku] = item
        }
        
        if let block = self.updateCart {
            block()
        }
        
        self.itemsCollectionView.reloadItems(at: [indexPath])
    }
}

class YQProductViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemImageView.layer.borderColor = UIColor(red: (236/255), green: (236/255), blue: (236/255), alpha: 0.7).cgColor
    }
    
    func addedToCart() {
        self.addToCartButton.setTitle("ADD TO CART", for: .normal)
        self.addToCartButton.backgroundColor = UIColor(red: (21/255), green: (161/255), blue: (223/255), alpha: 1.0)
    }
    
    func notInCart() {
        self.addToCartButton.setTitle("ADDED", for: .normal)
        self.addToCartButton.backgroundColor = UIColor(red: (221/255), green: (221/255), blue: (221/255), alpha: 1.0)
    }
}
