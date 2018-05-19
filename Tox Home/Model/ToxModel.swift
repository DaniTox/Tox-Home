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
    
    
    static let shared = ToxModel()
    
    private init() { }
    
    public func startModel() {
        startPingingServer()
        setTimerForUpdateSignals()
    }
    public func stopModel() {
        freeTimerForPing()
        freeTimerForSignals()
    }
    
    private func getStates(/*statusHandler : @escaping (ToxStatus) -> Void*/) {
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
            isPortaLocked = (json.door == 0) ? true : false
            
            
            self?.statusCompletion?(json)
            
        }.resume()
    }
    
    private var timer : Timer?
    public func setTimerForUpdateSignals(_ time: Double = 7.0) {
        self.getStates()
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { [weak self] (timer) in
            self?.getStates()
            print("Segnali ottenuti")
        })
    }
    public func freeTimerForSignals() {
        timer?.invalidate()
        timer = nil
    }
    
    public func performActionOnDevice(device: ToxDevices) {
        
        let base = baseUrl
        guard let trailingUrl = ToxUrls[device] else {
            print("TrailingURL: \(String(describing: ToxUrls[device]))")
            return
        }
        
        let finalUrlString = "\(base)/\(trailingUrl)"
        print(finalUrlString)
        guard let url = URL(string: finalUrlString) else {
            print("Errore url: \(finalUrlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                print("ACTION RESPONSE CODE: \(response.statusCode)")
            }
            
            
        }.resume()
        
        
    }
    
    
    private func ping() {
        let base = baseUrl
        let offset = "ping"
        let urlString = "\(base)/\(offset)"
        
        guard let url = URL(string: urlString) else {
            print("Errore url ping: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("PING: \(response.statusCode)")
            }
        }.resume()
        
        
    }
    private var pingTimer : Timer?
    private func startPingingServer() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] (timer) in
            self?.ping()
        })
    }
    private func freeTimerForPing() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
}
