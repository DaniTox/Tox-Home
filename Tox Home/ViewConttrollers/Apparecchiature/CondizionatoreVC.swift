//
//  CondizionatoreVC.swift
//  Tox Home
//
//  Created by Dani Tox on 20/05/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class CondizionatoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let homeView = HomeView()
    
    var condizionatoreMode : CondizionatoreMode = (isFanDynamic) ? .dynamicMode : .staticMode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Condizionatore"
    }

    override func loadView() {
        super.loadView()
        self.view = homeView
        
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Modalità"
        case 1:
            return "Parametri"
        default:
            return nil
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Statico"
                if condizionatoreMode == .staticMode {
                    cell.accessoryType = .checkmark
                
                }
            case 1:
                cell.textLabel?.text = "Dinamico"
                if condizionatoreMode == .dynamicMode {
                    cell.accessoryType = .checkmark
                }
                
            default: break
            }
        case 1:
            if condizionatoreMode == .dynamicMode {
                 cell.textLabel?.text = "Temperatura minima:"
                
                let textField = UITextField()
                
                cell.addSubview(textField)
                
                
            } else {
                cell.textLabel?.text = "Attiva/Disattiva"
                
                let fanSwitch = UISwitch()
                fanSwitch.isOn = (ToxModel.shared.latestAvailableStatus?.ventola ?? 0 == 0) ? false : true
                fanSwitch.translatesAutoresizingMaskIntoConstraints = false
                fanSwitch.addTarget(self, action: #selector(fanSwitchPressed(_:)), for: .valueChanged)
                cell.addSubview(fanSwitch)
                fanSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -30).isActive = true
                fanSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            }
           
        default:
            break
        }
        
        return cell
    }
    
    @objc private func fanSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            ToxModel.shared.performActionOnDevice(device: .ventolaAccendi)
        } else {
            ToxModel.shared.performActionOnDevice(device: .ventolaSpegni)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.condizionatoreMode = .staticMode
                isFanDynamic = false
            case 1:
                self.condizionatoreMode = .dynamicMode
                isFanDynamic = true
            default:
                break
            }
            
            tableView.reloadData()
        }
    }
    
}
