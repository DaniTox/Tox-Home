//
//  Contants.swift
//  Tox Home
//
//  Created by Dani Tox on 12/05/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

var baseUrl : String {
    get {
        return UserDefaults.standard.string(forKey: "baseUrl") ?? "http://192.168.1.13:8080"
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "baseUrl")
    }
}

var isPortaLocked : Bool {
    get {
        return UserDefaults.standard.bool(forKey: "isPortaLocked")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "isPortaLocked")
    }
}


var isFanDynamic : Bool {
    get {
        return UserDefaults.standard.bool(forKey: "isFanDynamic")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "isFanDynamic")
    }
}

enum CondizionatoreMode {
    case staticMode
    case dynamicMode
}


class ToxStatus : Codable {
    
    var luceSala : Int
    var temperatura : Int
    var door : Int
    var luceCamera : Int
    var allarme : Int
    var luceCucina : Int
    var ventola : Int
    
    func printAll() {
        print("LuceSala : \(luceSala)\nTempertaura: \(temperatura)\nDoor: \(door)")
        print("LuceCamera : \(luceCamera)\nAllarme: \(allarme)\nLuceCucina: \(luceCucina)")
    }
    
    init(luceSala : Int, temp : Int, door: Int, luceCamera: Int, allarme: Int, luceCucina: Int, ventola: Int) {
        self.luceSala = luceSala
        self.temperatura = temp
        self.door = door
        self.luceCamera = luceCamera
        self.allarme = allarme
        self.luceCucina = luceCucina
        self.ventola = ventola
    }
}

let ToxUrls : [ToxDevices : String] = [
    .doorLockState : "DOOR/state",
    .doorLockOpen : "DOOR/open",
    .doorLockClose : "DOOR/close",
    
    .temperatura : "TEMPERATURA/get",
    
    .luceCameraState: "LUCE_BED/state",
    .luceCameraSetOn: "LUCE_BED/setON",
    .luceCameraSetOff: "LUCE_BED/setOFF",
    
    .luceSalaState: "LUCE_SALA/state",
    .luceSalaSetOn: "LUCE_SALA/setON",
    .luceSalaSetOff: "LUCE_SALA/setOFF",
    
    .luceCucinaState : "LUCE_CUCINA/state",
    .luceCucinaSetOn : "LUCE_CUCINA/setON",
    .luceCucinaSetOff : "LUCE_CUCINA/setOFF",
    
    .allarmeDisarma : "ALLARME/disarma",
    .allarmeArma : "ALLARME/arma_1",
    
    .ventolaAccendi : "VENTOLA/accendi",
    .ventolaSpegni : "VENTOLA/spegni"
    
]
enum ToxDevices  {
    
    case doorLockState
    case doorLockOpen
    case doorLockClose
    
//    case ventolaState = ""
//    case ventolaSetOn = ""
//    case ventolaSetOff = ""
    
    case temperatura
    
    case luceCameraState
    case luceCameraSetOn
    case luceCameraSetOff
    
    case luceSalaState
    case luceSalaSetOn
    case luceSalaSetOff
    
    case luceCucinaState 
    case luceCucinaSetOn 
    case luceCucinaSetOff
    
//    case camera = ""
    case allarmeArma
    case allarmeDisarma
    
    case ventolaAccendi
    case ventolaSpegni
    
    static let allValues = [doorLockState, doorLockOpen, temperatura, luceCameraState, luceCameraSetOn, luceCameraSetOff, luceSalaState, luceSalaSetOn, luceSalaSetOff, luceCucinaState, luceCucinaSetOn, luceCucinaSetOff, allarmeArma, allarmeDisarma, ventolaAccendi, ventolaSpegni]
}








