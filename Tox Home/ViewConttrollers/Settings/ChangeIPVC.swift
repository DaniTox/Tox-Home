//
//  ChangeIPVC.swift
//  Tox Home
//
//  Created by Dani Tox on 19/05/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class ChangeIPVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Indirizzo IP"
    }

    override func loadView() {
        self.view = homeView
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        
        textField.delegate = self
        textField.becomeFirstResponder()
    }
    
    private func saveUrl() {
        if let textInput = textField.text, !textInput.isEmpty {
            baseUrl = textInput
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("keyboard pressed return")
        
        saveUrl()
        
        navigationController?.popViewController(animated: true)
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveUrl()
        
    }
    
    var textField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = baseUrl
        textField.clearButtonMode = .always
        textField.autocapitalizationType = .none
        return textField
    }()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        
        cell.addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
        textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
