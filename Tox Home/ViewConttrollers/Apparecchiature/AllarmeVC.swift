//
//  AllarmeVC.swift
//  Tox Home
//
//  Created by Dani Tox on 19/05/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import LocalAuthentication

class AllarmeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Allarme"
    }

    override func loadView() {
        super.loadView()
        self.view = homeView
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
    }
    
    var timer: Timer?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ToxModel.shared.startModel()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { [weak self] (timer) in
            self?.homeView.tableView.reloadData()
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ToxModel.shared.stopModel()
        timer?.invalidate()
        timer = nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Stato allarme"
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
            label.textColor = .lightGray
            cell.addSubview(label)
            label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
            label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true 
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
            
        case 1:
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.blue.lighter()
            switch ToxModel.shared.latestAvailableStatus?.allarme ?? 3 {
            case 0, 1, 2, 4:
                cell.textLabel?.text = "Disarma"
            case 3:
                cell.textLabel?.text = "Attiva allarme"
            default: break
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let allarmeState = ToxModel.shared.latestAvailableStatus?.allarme ?? 3
        
        switch indexPath.row {
        case 1:
            
            if allarmeState == 3 {
                ToxModel.shared.performActionOnDevice(device: .allarmeArma)
                ToxModel.shared.reloadStates()
                tableView.reloadData()
            } else {
                auth()
            }
            ToxModel.shared.reloadStates()
        default:
            break
        }
    }
    
    
    private func auth() {
        func disarmaAllarme() {
            ToxModel.shared.performActionOnDevice(device: .allarmeDisarma)
            ToxModel.shared.reloadStates()
            homeView.tableView.reloadData()
        }
        
        let context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Metti l'impronta per sbloccare la porta"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { [weak self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        disarmaAllarme()
                    } else {
                        let alert = UIAlertController(title: "Errore", message: "C'è stato un errore nell'autenticazione", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
        else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Inserisci il codice per sbloccare la porta"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { [weak self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        disarmaAllarme()
                    } else {
                        let alert = UIAlertController(title: "Errore", message: "C'è stato un errore nell'autenticazione", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
        else {
            let alert = UIAlertController(title: "Errore", message: "Non hai nessun metodo di autenticazione", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
