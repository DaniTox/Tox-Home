//
//  ViewController.swift
//  Tox Home
//
//  Created by Dani Tox on 07/05/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var homeView = HomeView()
    let model = ToxModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        
        
        model.statusCompletion = { [weak self] (toxStatus) in
            toxStatus.printAll()
            DispatchQueue.main.async {
                self?.homeView.tableView.reloadData()
            }
        }
        
        model.actionCompletion = { [weak self] in
            self?.model.getStates()
        }
        
        
        model.getStates()
        
        model.performActionOnDevice(device: .luceCucinaSetOn)
    }

    override func loadView() {        
        view = homeView
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
    }

    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 7
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 50
        default:
            return 50
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Impostazioni"
        case 1:
            return "Apparecchiature"
        default:
            return nil
        }
        
    }
    
    lazy var temperatureLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc private func setLuceCamera(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @objc private func setLuceSala(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @objc private func setLuceCucina(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        var title : String = "" {
            didSet {
                cell.textLabel?.text = title
            }
        }
        
        switch indexPath.section {
        case 0:
            title = "Modifica parametri"
            cell.accessoryType = .disclosureIndicator
        case 1:
            switch indexPath.row {
            case 0:
                title = "Allarme"
                cell.accessoryType = .disclosureIndicator
            case 1:
                title = "Luce Camera"
                let luceSwitch = UISwitch()
                luceSwitch.addTarget(self, action: #selector(setLuceCamera(_:)), for: .valueChanged)
                luceSwitch.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(luceSwitch)
                luceSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
                luceSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            case 2:
                title = "Luce Sala"
                let luceSwitch = UISwitch()
                luceSwitch.addTarget(self, action: #selector(setLuceSala(_:)), for: .valueChanged)
                luceSwitch.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(luceSwitch)
                luceSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
                luceSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            case 3:
                title = "Luce Cucina"
                let luceSwitch = UISwitch()
                luceSwitch.addTarget(self, action: #selector(setLuceCucina(_:)), for: .valueChanged)
                luceSwitch.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(luceSwitch)
                luceSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
                luceSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            case 4:
                title = "Condizionatore"
                cell.accessoryType = .disclosureIndicator
            case 5:
                title = "Temperatura"
                temperatureLabel.text = "\(model.latestAvailableStatus?.temperatura ?? 0)° C"
                cell.addSubview(temperatureLabel)
                temperatureLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                temperatureLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
            case 6:
                title = "Videocamera"
                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        default:
            break
        }
        
        
        return cell
    }
    
}


