import CoreBluetooth


// CBManagerState 自体は enum型
extension CBManagerState {
    var name : String {
        get{
            let enumName = "CBManagerState"
            var valueName = ""
            
            switch self {
            case .poweredOff:
                valueName = enumName + "PoweredOff"
            case .poweredOn:
                valueName = enumName + "PoweredOn"
            case .resetting:
                valueName = enumName + "Resetting"
            case .unauthorized:
                valueName = enumName + "Unauthorized"
            case .unknown:
                valueName = enumName + "Unknown"
            case .unsupported:
                valueName = enumName + "Unsupported"
            default:
                break
            }
            
            return valueName
        }
    }
}

extension CBPeripheralState
{
    var name : String {
        get{
            let enumName = "CBPeripheralState"
            var valueName = ""
            
            switch self {
            case .connected:
                valueName = enumName + "Connected"
            case .connecting:
                valueName = enumName + "Connecting"
            case .disconnected:
                valueName = enumName + "Disconnected"
            default:
                break
            }
            
            return valueName
        }
    }
}
