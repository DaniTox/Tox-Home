//
//  VideoCameraVC.swift
//  Tox Home
//
//  Created by Dani Tox on 05/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import WebKit

class VideoCameraVC: UIViewController {

    var homeView = HomeView()
    
    var urlB : String = "192.168.1.2:8085"
    
    let wkview = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ToxCamera"
        
        let stringUrl = "http://\(self.urlB)"
        guard let url = URL(string: stringUrl) else { print("Error url: \(stringUrl)"); return }
        let request = URLRequest(url: url)
        
        
        wkview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wkview)
        wkview.load(request)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        wkview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        wkview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        wkview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        wkview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
 
}
