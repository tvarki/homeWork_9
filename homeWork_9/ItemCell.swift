

import UIKit

//MARK: - Cell button click delegate
protocol cellButtonClickedDelegate: class{
    func iconButtonPress(cell : ItemCell)
}

//MARK: - Cell Identifiable protocol
protocol CellIdentifiable {
    static var identifier: String { get }
}

extension UITableViewCell: CellIdentifiable {

    static var identifier: String {
        return String(describing: Self.self)
    }

}

//MARK: - ItemCell class
class ItemCell: UITableViewCell {
    func iconButtonPress() {
        delegate?.iconButtonPress(cell: self)
    }
    
    weak var delegate : cellButtonClickedDelegate?
   
    @IBAction func buttonClicked(_ sender: UIButton) {
        iconButtonPress()
    }
    
    @IBOutlet var labelView: UILabel!
    
    @IBOutlet var imageButton: UIButton!
    
}
