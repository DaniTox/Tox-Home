//
//  ToxModel.swift
//  Tox Home
//
//  Created by Dani Tox on 12/05/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

class ToxModel {
    
    var statusCompletion : ((ToxStatus) -> Void)?
    var actionCompletion : (() -> Void)?
    
    var latestAvailableStatus : ToxStatus?
    
    func getStates(/*statusHandler : @escaping (ToxStatus) -> Void*/) {
        let urlString = "\(baseUrl)/STATUS/GETALL"
        guard let url = URL(string: urlString) else { print("Errore url: \(urlString)"); return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else { return }
            
            guard let json = try? JSONDecoder().decode(ToxStatus.self, from: data) else {
                let str = String(data: data, encoding: .utf8)
                print("Errore decoding json data. Ora printo data:\n\(str ?? "TOX:NODATA")")
                return
            }
            
            self?.latestAvailableStatus = json
            self?.statusCompletion?(json)
            
        }.resume()
    }
    
    
    func performActionOnDevice(device: ToxDevices) {
        
        let base = baseUrl
        guard let trailingUrl = ToxUrls[device] else {
            print("TrailingURL: \(String(describing: ToxUrls[device]))")
            return
        }
        
        let finalUrlString = "\(base)/\(trailingUrl)"
        guard let url = URL(string: finalUrlString) else {
            print("Errore url: \(finalUrlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            
            
        }.resume()
        
        
    }
}
