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
    let model = ToxModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        
        let barButton = UIBarButtonItem(title: "Test", style: .done, target: self, action: #selector(openNewController))
        navigationItem.setRightBarButton(barButton, animated: true)
        
        model.statusCompletion = { [weak self] (toxStatus) in
            print("HomeVC ha ottenuto i nuovi parametri")
            DispatchQueue.main.async {
                self?.homeView.tableView.reloadData()
            }
        }
        

    }
    
    
    @objc private func openNewController() {
        let vc = SettingsVC()
        navigationController?.pushViewController(vc, animated: true )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        homeView.tableView.reloadData()
        model.startModel()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        model.stopModel()
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
            return 8
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
        if sender.isOn {
            model.performActionOnDevice(device: .luceCameraSetOn)
        } else {
            model.performActionOnDevice(device: .luceCameraSetOff)
        }
    }
    
    @objc private func setLuceSala(_ sender: UISwitch) {
        if sender.isOn {
            model.performActionOnDevice(device: .luceSalaSetOn)
        } else {
            model.performActionOnDevice(device: .luceSalaSetOff)
        }
    }
    
    @objc private func setLuceCucina(_ sender: UISwitch) {
        if sender.isOn {
            model.performActionOnDevice(device: .luceCucinaSetOn)
        } else {
            model.performActionOnDevice(device: .luceCucinaSetOff)
        }
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
                title = "Porta"
                cell.accessoryType = .disclosureIndicator
                
                let label = UILabel()
                label.text = (isPortaLocked) ? "Bloccata" : "Sbloccata"
                label.textAlignment = .right
                label.textColor = .lightGray
                label.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(label)
                label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -30).isActive = true
                label.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
                label.widthAnchor.constraint(equalToConstant: 150).isActive = true
                
                
            case 1:
                title = "Allarme"
                cell.accessoryType = .disclosureIndicator
                
                let label = UILabel()
                switch ToxModel.shared.latestAvailableStatus?.allarme ?? 3 {
                case 0, 1, 2:
                    label.text = "In allerta..."
                case 3:
                    label.text = "Disarmata"
                case 4:
                    label.text = "IN ALLARME!!!"
                    label.textColor = .red
                default: break
                }
                label.textAlignment = .right
                label.textColor = .lightGray
                label.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(label)
                label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -30).isActive = true
                label.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
                label.widthAnchor.constraint(equalToConstant: 150).isActive = true
                
            case 2:
                title = "Luce Camera"
                let luceSwitch = UISwitch()
                if let status = model.latestAvailableStatus {
                    if status.luceCamera == 1 {
                        luceSwitch.isOn = true
                    } else {
                        luceSwitch.isOn = false
                    }
                }
                luceSwitch.addTarget(self, action: #selector(setLuceCamera(_:)), for: .valueChanged)
                luceSwitch.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(luceSwitch)
                luceSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
                luceSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            case 3:
                title = "Luce Sala"
                let luceSwitch = UISwitch()
                if let status = model.latestAvailableStatus {
                    if status.luceSala == 1 {
                        luceSwitch.isOn = true
                    } else {
                        luceSwitch.isOn = false
                    }
                }
                luceSwitch.addTarget(self, action: #selector(setLuceSala(_:)), for: .valueChanged)
                luceSwitch.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(luceSwitch)
                luceSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
                luceSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            case 4:
                title = "Luce Cucina"
                let luceSwitch = UISwitch()
                if let status = model.latestAvailableStatus {
                    if status.luceCucina == 1 {
                        luceSwitch.isOn = true
                    } else {
                        luceSwitch.isOn = false
                    }
                }
                luceSwitch.addTarget(self, action: #selector(setLuceCucina(_:)), for: .valueChanged)
                luceSwitch.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(luceSwitch)
                luceSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
                luceSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            case 5:
                title = "Condizionatore"
                cell.accessoryType = .disclosureIndicator
                
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = (model.latestAvailableStatus?.ventola == 1) ? "Acceso" : "Spento"
                label.textColor = .lightGray
                cell.addSubview(label)
                label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -30).isActive = true
                label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            case 6:
                title = "Temperatura"
                temperatureLabel.text = "\(model.latestAvailableStatus?.temperatura ?? 0)° C"
                cell.addSubview(temperatureLabel)
                temperatureLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                temperatureLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
            case 7:
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = SettingsVC()
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = PortaVC()
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = AllarmeVC()
                navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = CondizionatoreVC()
                navigationController?.pushViewController(vc, animated: true)
            case 7:
                
                let alert = UIAlertController(title: "Indirizzo IP", message: "Inserisci l'indirizzo IP del raspberry Pi con la porta. (8085)", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.text = "192.168.1.2:8085"
                }
                let action = UIAlertAction(title: "Vai", style: .cancel) { (action) in
                    DispatchQueue.main.async { [weak self] in
                        
                        let address = alert.textFields![0].text
                        
                        let vc = VideoCameraVC()
                        vc.urlB = address ?? "192.168.1.2:8085"
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)

            default:
                break
            }
        default:
            break
        }
    }
    
}


