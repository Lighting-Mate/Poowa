import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorReact: UILabel!
    
    var colorName: String = ""
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        // cellを丸くする
        self.layer.cornerRadius = 20.0
    }
}
