//
//  ConnectionsViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 15/11/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class ConnectionsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TabBarSwitcher {

    
    @IBOutlet weak var searchBar: UISearchBar!
    var sv : UIView!
    var connectionData : connection_model!
    var currentChemInfo : ChemInfo!
    var searchData : connection_model!
    var searching = false
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.connectionData != nil{
        if searching {
            return self.searchData.chemistinfo?.count ?? 0
        }else{
            return self.connectionData.chemistinfo?.count ?? 0
        }
        }else{
            UIViewController.removeSpinner(spinner: self.sv)
            loadData()
        }
    return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionsTableViewCell
        if searching {
            cell.lable1.text = "\t"+(searchData.chemistinfo?[indexPath.row].FST_NAME)!
        }else{
            cell.lable1.text = "\t"+(connectionData.chemistinfo?[indexPath.row].FST_NAME)!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            currentChemInfo = searchData.chemistinfo?[indexPath.row]
            performSegue(withIdentifier: "toChemInfo", sender: nil)
        }else{
            currentChemInfo = connectionData.chemistinfo?[indexPath.row]
            performSegue(withIdentifier: "toChemInfo", sender: nil)
    }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChemInfo" {
            let sender = segue.destination as! ViewChemistInfoViewController
            sender.chemInfo = currentChemInfo
        }
        if segue.identifier == "cart_to_tabsVC"{
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.buildNavigationDrawer(drawer: "chemist")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
     let preferences = UserDefaults.standard
   
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            tabBarController?.selectedIndex = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
       
        loadData()
        
        initSwipe(direction: .left)
        searchBar.delegate = self
    }
    func loadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIViewController.removeSpinner(spinner: self.sv)
        }
       
    }
    func loadData(){
        if Reachability.isConnectedToNetwork() {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        let emp_id = preferences.string(forKey: "EMP_ID")!
        let url = "\(Constants.stockisturl)index.php?end_point=stockiestLogin&emp_id=\(emp_id)"
            FetchHttpData.updateDataModels(url: url, type: connection_model.self){
                response in
                self.connectionData = response as? connection_model
                self.searchData = response as? connection_model
                self.loadTable()
                print(self.connectionData)
            }
            
//        guard let url = URL(string:"\(Constants.stockisturl)index.php?end_point=stockiestLogin&emp_id=\(emp_id)")
//
//            else {
//                print("URL Error!")
//                UIViewController.removeSpinner(spinner: self.sv)
//                return
//            }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            do {
//                let decoder = JSONDecoder()
//                if data != nil {
//                let response = try decoder.decode(connection_model.self, from: data!)
//                self.connectionData = response
//                self.searchData = response
//                self.loadTable()
//                }else{
//                    DispatchQueue.main.async {
//                        self.view.makeToast("Check Internet!")
//                        UIViewController.removeSpinner(spinner: self.sv)
//                    }
//                }
//            }
//
//            catch _ {
//
//                print("Error at getting connctions data!")
//                print(error as Any)
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "Alert", message: "Error at getting connections data! ", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                        switch action.style{
//                        case .default:
//                            print("default")
//
//                            UIViewController.removeSpinner(spinner: self.sv)
//                            self.performSegue(withIdentifier: "cart_to_tabsVC", sender: nil)
//
//
//                        case .cancel:
//                            print("cancel")
//
//                        case .destructive:
//                            print("destructive")
//
//
//                        }}))
//                    self.present(alert, animated: true, completion: nil)
//                }
//
//            }
//        }
//        task.resume()
    } else {
    self.view.makeToast("Please Check Internet !!!")
    }
}
}
extension ConnectionsViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData.chemistinfo?.removeAll()
        if searchText.count == 0 {
            searching = false
            searchData = connectionData
            tableView.reloadData()
        }else{
            searching = true
            searchData.chemistinfo?.removeAll()
//            searchData.chemistinfo = connectionData.chemistinfo.filter({ $0.FST_NAME.lowercased().prefix(searchText.count) ==  searchText.lowercased()})
            searchData.chemistinfo = connectionData.chemistinfo?.filter({$0.FST_NAME.lowercased().contains(searchText.lowercased())})
            
            tableView.reloadData()
        }

    }
}

