// Poowaのデバイス単位のクラス定義
// PoowaをPeripheralとして制御する。

import Foundation
import CoreBluetooth

// interface 宣言みたいなもの
protocol PoowaDelegate: class {
    func Connected()
    func Disconnected()
    func Ready()
}

class Poowa: NSObject {
    static let characteristicUUID = CBUUID(string: "E4025514-0A8D-4C0B-B173-5D5535DCF29E")

    let peripheral : CBPeripheral
    weak var delegate: PoowaDelegate? // poowa::protocol -> poowa
    private var poowaTextCharacteristic : CBCharacteristic? // textを管理する特性
    
    
    init(peripheral: CBPeripheral){
        self.peripheral = peripheral
        super.init()
        peripheral.delegate = self // CBPeripheral -> poowa
    }
    
    
    func changeText(text: String){
        if let chara = poowaTextCharacteristic, let sendData = text.data(using: .utf8) {
            peripheral.writeValue(sendData, for: chara, type: .withResponse)
        }
    }
    
    
    
    /// ----- CentralManager Callback Functions -----
    func conenctCallback() {
        peripheral.discoverServices(nil)
        delegate?.Connected()
    }
    
    func disconnectCallback() {
        delegate?.Disconnected()
    }
    
}




extension Poowa : CBPeripheralDelegate {
    
    // 何かしらのサービスが見つかった時の処理
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("サービスを発見しました")
        peripheral.services?.forEach {
            print("  \($0)")
            peripheral.discoverCharacteristics(nil, for: $0)
            //特性を探す - 見つけたい特性のUUID、その特性が属するサービスのUUIDを指定できる。
        }
    }
    
    // 特性が見つかった時に行う処理
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("特性を発見しました")
        service.characteristics?.forEach {
            print("  \($0)")
            if $0.uuid == Poowa.characteristicUUID {
                self.poowaTextCharacteristic = $0
            }
        }
        delegate?.Ready()
    }

}
