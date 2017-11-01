//
//  YQMenuViewController.swift
//  Younique
//
//  Created by Krishna Pradeep on 10/28/17.
//  Copyright © 2017 Krishna Pradeep. All rights reserved.
//

import UIKit

class YQMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    
    let menuArray = ["Home", "History", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.isScrollEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickDropShipButton(_ sender: Any) {
        let url = URL(string: "https://www.youniqueproducts.com/account/signin?jwt=\(YQUser.shared.accessToken)")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    @IBAction func didClickPaypalButton(_ sender: Any) {
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
        return self.menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! YQMenuTableViewCell
        
        cell.titleLabel.text = self.menuArray[indexPath.row]
        cell.menuImageView.image = UIImage(named: self.menuArray[indexPath.row].lowercased())
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let drawer = self.parent as? YQDrawerController {
                drawer.setDrawerState(.closed, animated: true)
            }
        default:
            break
        }
    }
}

class YQMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
