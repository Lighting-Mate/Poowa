// centralManager(iOS側)のクラス定義

import Foundation
import CoreBluetooth

class PoowaCentralManager : NSObject {
    static let serviceUUID = CBUUID(string:"7F9B5867-6E4B-4EF8-923F-D32903E1E43C")
    
    let manager : CBCentralManager
    var poowa: Poowa?
    weak var delegate : PoowaDelegate? // poowa::protocol -> poowa -> manager
    
    override init(){
        manager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        manager.delegate = self // CBCentralManager -> manager
    }
    
    // poowaと接続していたらコネクションを断つ
    func disconnect(){
        if let device = poowa {
            manager.cancelPeripheralConnection(device.peripheral)
        }
    }
    
    // serviceUUIDに対応するペリフェラルを探す。
    func startScan(){
        manager.scanForPeripherals(withServices: [PoowaCentralManager.serviceUUID], options: nil)
    }
    
}




extension PoowaCentralManager : CBCentralManagerDelegate {

    // セントラルマネージャが起動した時など。stateの変化ごとに行う処理
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown, .resetting:
            break
        case .poweredOn:
            print("poowaCentralManagerの起動を確認。")
            startScan()
        default:
            print("Manager State : \(central.state.rawValue)")
        }
    }
    
    // 何かしらのペリフェラル(アドバタイズデータ)を見つけた時の処理
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("ペリフェラルを見つけました")
        if poowa == nil { // 他のpoowaと接続していなければ接続を開始する
            poowa = Poowa(peripheral: peripheral)
            poowa?.delegate = self.delegate // poowa::protocol -> poowa -> manager
            manager.connect(peripheral, options: nil) // options で serviceUUIDを指定できる。
            manager.stopScan() // 接続したのでペリフェラルを探す必要がないので終了。
        }
    }
    
    // ペリフェラルとのコネクションが成立した時に行う処理
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("コネクションを成立しました：\(peripheral)")
        if let device = poowa, device.peripheral == peripheral {
            device.conenctCallback()
        }
    }
    
    // ペリフェラルとコネクションを絶った時に行う処理
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("コネクションを断ちました。")
        if let device = poowa, device.peripheral == peripheral { // 接続しているペリフェラルがあり、かつ接続が切れたペリフェラルが同一のものと判断できる時
            device.disconnectCallback()
            self.poowa = nil
        }
    }
    
}
