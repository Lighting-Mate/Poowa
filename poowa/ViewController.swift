import UIKit



class ViewController: UIViewController {

    enum ViewState: Int {
        case disconnected
        case connected
        case ready
    }
    
    var manager : PoowaCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = PoowaCentralManager()
        manager.delegate = self // poowa::protocol -> poowa -> manager -> ViewContoller
        
        Slider.minimumValue = 0
        Slider.maximumValue = 255
        Slider.value = 0
    }
    
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var logText: UITextView!
    @IBOutlet weak var Slider: UISlider!
    
    var viewState: ViewState = .disconnected {
        didSet {
            switch viewState {
            case .disconnected:
                topLabel.text = "Disconnected"
            case .connected:
                topLabel.text = "Probing..."
            case .ready:
                topLabel.text = "Ready"
            }
        }
    }
    
    @IBAction func sendButton(_ sender: Any) {
        manager.poowa?.changeText(text: inputText.text!)
        // TODO: 下記のコードをESP32の状態とリンクさせる。(多分実装しない)
        logText.text += "send Data to 'ESP32': \(inputText.text!) \n"
    }
    
    @IBAction func onChangeSlider(_ sender: UISlider) { // sender.value: Float
//        print( Int(sender.value) )
        let intVal: UInt8 = UInt8( sender.value )
        manager.poowa?.changeNumber( number: intVal )
        logText.text = "send BrightValue Data to 'ESP32': \(intVal) \n"
    }
    
    @IBAction func connectButton(_ sender: Any) {
        manager.startScan()
    }
    
    @IBAction func disconnectButton(_ sender: Any) {
        manager.disconnect()
    }
}



extension ViewController: PoowaDelegate{
    func Connected()      { viewState = .connected }
    func Disconnected()   { viewState = .disconnected }
    func Ready()          { viewState = .ready }
}
