//
//  DetailVC.swift
//  Tox Home
//
//  Created by Dani Tox on 19/05/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Impostazioni"
    }
    
    override func loadView() {
        super.loadView()
        self.view = homeView
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeView.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Indirizzo IP"
            cell.accessoryType = .disclosureIndicator
            let ipLabel = UILabel()
            ipLabel.text = baseUrl
            ipLabel.textColor = .lightGray
            ipLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(ipLabel)
            ipLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -30).isActive = true
            ipLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            
            
        default:
            break
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ChangeIPVC()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
