import UIKit
import MapKit
import SQLite3
//import TextFieldEffects
class TabDeleteViewController : UIViewController,BEMCheckBoxDelegate {
    var model : WalletModel!
    var db: OpaquePointer? = nil
    var dbStatement: OpaquePointer? = nil
    var StatementString : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MediAppDatabase.sqlite")
        if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
            print("error opening database")
            }

    }
    
    func deleteSqlTableData(query : String) {
        //////////////Delete All data from cart table before insert new one /////////////////////////////////

        if sqlite3_prepare(self.db, query, -1, &dbStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(self.db)!)
            print("error preparing insert: \(errmsg)")
            return
        }else{
            print("Success")
        }
        
        if sqlite3_step(self.dbStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(self.db)!)
            print("failure inserting operation: \(errmsg)")
            return
        }else{
            print("Success")
        }
        sqlite3_finalize(self.dbStatement)
    }
    @IBAction func DropAll(_ sender: Any) {
    StatementString = "DROP TABLE \(Constants.TABLE_GST_PRODUCT_MASTER);"
    deleteSqlTableData(query: StatementString)
    StatementString = "DROP TABLE \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER);"
    deleteSqlTableData(query: StatementString)
    }
    
    
    @IBAction func MoveToMain(_ sender: Any) {
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    
    
    
}
