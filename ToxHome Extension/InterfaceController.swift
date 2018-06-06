//
//  InterfaceController.swift
//  ToxHome Extension
//
//  Created by Dani Tox on 06/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet var statusLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        changeColorTo(.yellow)
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    private func changeColorTo(_ color : UIColor) {
        statusLabel.setTextColor(color)
        
        switch color {
        case .yellow:
            statusLabel.setText("In attesa")
        case .red:
            statusLabel.setText("Error")
        case .green:
            statusLabel.setText("Fatto")
        default:
            statusLabel.setText("NULL")
        }
    }
    
    
    @IBAction func testImpiantoAction() {
        changeColorTo(.yellow)
        
        let session = WCSession.default
        let message = ["activate" : true]
        let handler : ([String : Any]) -> Void = { [weak self] (dataReceived) in
            if let resultCode = dataReceived["result"] as? Int {
                print("Ricevuto \(resultCode) in risposta da iPhone")
                self?.changeColorTo(.green)
            } else {
                self?.changeColorTo(.red)
            }
        }
        session.sendMessage(message, replyHandler: handler) { [weak self] (error) in
            print("\(error.localizedDescription)")
            self?.changeColorTo(.red)
        }
    }
}
