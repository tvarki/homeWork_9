
import UIKit

//MARK: - ViewController
class ViewController: UIViewController, cellButtonClickedDelegate {
    
    @IBOutlet var tableView: UITableView!
    private var emptyLabel: UIView!
    private let refreshControl = UIRefreshControl()
    private var data: [(String,Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = getNewData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        configurePullToRefresh()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(UINib(nibName: "ItemCellXib", bundle: nil), forCellReuseIdentifier: ItemCell.identifier)
    }
    
//MARK: - Delegate function for change image on button
    func iconButtonPress(cell:ItemCell) {
        tableView.beginUpdates()
        cell.imageButton.setImage(getImage(), for:.normal)
        tableView.endUpdates()
    }
    
//MARK: - PullToRefresh
    
    private func configurePullToRefresh() {
        refreshControl.tintColor = UIColor.red
        refreshControl.attributedTitle = NSAttributedString(string: "Refrashing Table")
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.data = self.getNewData()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
//MARK: - Delete Action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [ indexPath ], with: .automatic)
            data.remove(at: indexPath.row)
            tableView.endUpdates()
        }
    }
    
//MARK: - Swipe Action
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemCell else{
            return UISwipeActionsConfiguration(actions: [])
        }
        var tmp : String
        var tmpAT : UITableViewCell.AccessoryType = .none
        
        if cell.accessoryType == .none{
            tmp = "Check"
            tmpAT = .checkmark
        }
        else{
            tmp = "UnCheck"
            tmpAT = .none
        }
        
        let action = UIContextualAction(style: .normal, title: tmp) { (action, view, completionHandler) in
            cell.accessoryType = tmpAT
            if cell.accessoryType == .checkmark{
                self.data[indexPath.row].1 = true
            }else{
                self.data[indexPath.row].1 = false
            }
                
            completionHandler(true)
            
        }
        let configuration = UISwipeActionsConfiguration(actions: [ action ])
        return configuration
    }
    
    //MARK: - Deselect Action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell else {return ItemCell()}
        cell.labelView?.text = data[indexPath.row].0
        
        if(data[indexPath.row].1)
        {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        cell.imageButton.setImage(getImage(), for:.normal)
        cell.delegate = self
        return cell
    }
    
}

// MARK: - Extension for support functions

extension ViewController {
    
    func getImage() -> UIImage! {
        
        let int: Int = Int.random(in: 0...10000)
        
        switch int%3 {
        case  0 :
            return UIImage(systemName: "pencil")!
            
        case  1 :
            return UIImage(systemName: "pencil.circle")!
            
        case  2 :
            return UIImage(systemName: "pencil.slash")!
            
        default:
            return UIImage(systemName: "multiply.circle.fill")!
        }
        
    }
    
    func getNewData()->[(String,Bool)]{
        //Алексей Соболевский сказал что можно получить новые данные, а не перетасовывать старые
        var tmp: [(String,Bool)]=[]
        for _ in 0...Int.random(in: 0...1000) {
            tmp.append((randomString(length: Int.random(in: 1...101)), false))
        }
        return tmp
    }
    
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    
    
}
