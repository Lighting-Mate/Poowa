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
        manager.delegate = self
    }
    
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    
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
