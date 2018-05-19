//
//  PortaVC.swift
//  Tox Home
//
//  Created by Dani Tox on 19/05/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import LocalAuthentication

class PortaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Porta"
    }

    override func loadView() {
        super.loadView()
        self.view = homeView
        
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func auth() {
        func sbloccaPorta() {
            ToxModel.shared.performActionOnDevice(device: .doorLockOpen)
            isPortaLocked = false
            homeView.tableView.reloadData()
        }
        
        
        let context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Metti l'impronta per sbloccare la porta"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { [weak self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        sbloccaPorta()
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
                        sbloccaPorta()
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
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Stato porta"
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = (isPortaLocked == true) ? "Bloccata" : "Sbloccata"
            label.textAlignment = .right
            label.textColor = .lightGray
            cell.addSubview(label)
            label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
            label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
        case 1:
            cell.textLabel?.text = (isPortaLocked == true) ? "Sblocca (con codice/Touch ID" : "Blocca"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.blue.lighter()
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
        if indexPath.row != 1 { return }
        
        if !isPortaLocked {
            ToxModel.shared.performActionOnDevice(device: .doorLockClose)
            isPortaLocked = true
            tableView.reloadData()
        } else {
            auth()
        }
        
    }
    
}
