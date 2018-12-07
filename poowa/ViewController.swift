import UIKit



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    enum ViewState: Int {
        case disconnected
        case connected
        case ready
    }
    
    // cellの色の配列
    let colors: [UIColor] = [UIColor.blue, UIColor.cyan, UIColor.green, UIColor.yellow, UIColor.orange, UIColor.red]
    let colorNames: [String] = ["blue", "cyan", "green", "yellow", "orange", "red"]
    
    
    // collectionView Section Value
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // cellの数を返す関数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    // cellに情報を入れていく関数
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.colorReact.backgroundColor = colors[indexPath.item]
        cell.colorReact.text = ""
        cell.colorName = colorNames[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell : CollectionViewCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let alert: UIAlertController = UIAlertController(title: "選択した色は〜？", message: "選んだカラーは\(cell.colorName)です", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
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
