
import UIKit
import Toast_Swift

class WalletViewController: UIViewController {
    var prefrences = UserDefaults.standard
    var emp_id : String = ""		
    
    @IBOutlet weak var creditBal: UILabel!
    @IBOutlet weak var redeemedLab: UILabel!
    @IBOutlet weak var deferredLab: UILabel!
    @IBOutlet weak var mddbtn: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    var spineerView : UIView!
    var WalletData : WalletModel!
    @IBOutlet var myView: UIView!
    var mddstr : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        view1.layer.cornerRadius = 10
        view1.layer.borderWidth = 2
        view1.layer.borderColor = UIColor.orange.cgColor
        view2.layer.cornerRadius = 10
        view2.layer.borderWidth = 2
        view2.layer.borderColor = UIColor.orange.cgColor
        
//        if mddstr != nil {
//        if mddstr == "" {
//            mddbtn.setTitle("My Dream Destination", for: .normal)
//        }else{
//            mddbtn.setTitle(mddstr, for: .normal)
//        }
//        }else{
//            mddbtn.setTitle("My Dream Destination", for: .normal)
//        }
        loadData()
        
    }
    
 
    func loadData(){
        spineerView = UIViewController.displaySpinner(onView: self.view)
        emp_id = prefrences.string(forKey: "EMP_ID")!
//        guard let url = URL(string:Constants.wallet_url+"?username=\(emp_id)&function_name=getWalletValues")//local
        guard let url = URL(string:Constants.walletlogin_url+"wallet.php?username=\(emp_id)&function_name=getWalletValues") //live
            else {
                print("URL Error!")
                return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                // data we are getting from network request
                if data != nil {
                let decoder = JSONDecoder()
               
                let response = try decoder.decode(WalletModel.self, from: data!)
                self.WalletData = response
                
                DispatchQueue.main.async {
                     self.mddstr = self.prefrences.string(forKey: "MyDreamDestination")
                    if self.mddstr != nil {
                        if self.mddstr == "" {
                            self.mddbtn.setTitle("My Dream Destination", for: .normal)
                            }else{
                            self.mddbtn.setTitle(self.mddstr, for: .normal)
                            }
                            }else{
                        self.mddbtn.setTitle("My Dream Destination", for: .normal)
                            }
                    self.creditBal.text = self.WalletData.CF_CREDITED_POINTS
                    self.deferredLab.text = self.WalletData.CF_DEFERRED_POINTS
                    self.redeemedLab.text = self.WalletData.CF_REDEEMED_POINTS
                    UIViewController.removeSpinner(spinner: self.spineerView)
                }
          
                }else {

                    DispatchQueue.main.async {
                        self.view.makeToast("Data Not Found!!")
                        UIViewController.removeSpinner(spinner: self.spineerView)
                    }
                }
            }
           
            catch _ {
                
                print("Error at getting wallet data!")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Error at getting wallet data! ", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            UIViewController.removeSpinner(spinner: self.spineerView)
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        }}))
                      self.present(alert, animated: true, completion: nil)
                }
  
            }
        }
        task.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wallet_to_tabsVC" {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.buildNavigationDrawer(drawer: "chemist")
        }
    }
    
    @IBAction func AnimateAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RedeemOfferDetailVC") as! RedeemOfferDetailVC
//        vc.delegate = (self as! ChildViewControllerDelegate)
        vc.walletData = WalletData
        navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func howItWorks(_ sender: Any) {
        toastGenrate(title: "How It Work", message: "For every purchase of Rs.50 (on PTR) , you will earn 1 MR (Medi Reward) point.\n"+"While placing order you can view the potential points which will be generated once order is supplied.\n"+"Once the order is “Mark is accepted”, points of the order will be added in “Deferred” bucket. " +
            "You can view all these orders under “Deferred” tab of “View Transaction History”\n"+"Once the order is “Mark as Delivered” , points of the order will be moved from “Deferred” to “Credit Balance” Bucket," +
            "there by increasing Credit balance. You can view all these orders under “Credit Balance” tab of “View Transaction History”\n"+"As the MR points get accumulated, you will have an option to redeem points in exchange of gifts or tour.\n"+"Once you click Redeem button, your request for the redemption will be sent to Medi APP HO for approval. " +
            "These points will be shown under “Redeemed” Bucket. You can view all these orders " +
            "under “Redeemed” tab of “View Transaction History”\n"+"Once the redeem request for Gift/Tour is approved and Gift sent by HO, these points will be removed from Redeemed.\n"+"You can view all orders detail for which Gift/Tour is exchanged  under “Closed” tab .")
    }
    
    @IBAction func termsAndConditions(_ sender: Any) {
        toastGenrate(title: "Terms & Conditions", message: "Medi Reward Program duration 1 Oct 2018 to 25th Mar 2019\n"+"All orders placed on Medi APP and supplied will only be considered\n"+"For every Rs.50/- of purchase for orders placed on MediApp and supplied by MediApp Super Distributor," +
            "1 MR point will be generated.\n"+"Point is generated for every individual order for complete block of Rs. 50;" +
            "and not sum of all orders supplied.\n"+"MR points are generated on PTR (without  taxes) and not the final invoice (with taxes)\n"+"The order is to be “Mark as Accepted” by the Super Distributor to get MR points in “Deferred” \n"+"The MR points will be reflecting in “Credit Balance” ONLY after order is “Mark as Delivered” by Retail Chemist.\n"+"All Estimates generated are to be “Mark as Accepted” by Super Distributor and to be “Mark as Delivered” " +
            "on or before 20 Apr 2019.\n"+"MR points have to be redeemed on or before 10th May 2019, failing which they will lapse.\n"+"Supply of any order placed on Medi APP is the sole discretion of the Super Distributor" +
            "concerned and Miljon Medi APP LLP will in no way responsible for non supply of any order so placed.\n"+"Goa/Bangkok/Europe Trip dates will be decided and intimated by the company.\n"+"Itinerary and inclusions will be informed at the end of the program and will be binding on" +
            " those opting for the respective Trip\n"+"The Company reserves the rights to cancel/change/modify the Incentive scheme at any time without any notice.")
    }
    
    
    
    @IBAction func myDreamDest(_ sender: Any) {
        
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyDremDestinationVC") as! MyDremDestinationVC
        //        vc.delegate = (self as! ChildViewControllerDelegate)
        if WalletData != nil {
        vc.walletImage = WalletData.WALLET_IMGES
        vc.optionData = WalletData.redeem_option
        vc.redeemType = WalletData.redeem_type_master
        navigationController?.pushViewController(vc,animated: true)
        }else {
            self.view.makeToast("Offers Not Found!!")

        }
    }
    
    
    @IBAction func redeemData(_ sender: Any) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RedeemOfferViewController") as! RedeemOfferViewController
        //        vc.delegate = (self as! ChildViewControllerDelegate)
        if WalletData != nil {
        vc.str = WalletData.redeem_offer
        vc.redeemOption = WalletData.redeem_option
        vc.Current_Points = WalletData.CF_CREDITED_POINTS
        navigationController?.pushViewController(vc,animated: true)
        }
    }
    
    @IBAction func ViewTransactionAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
        //        vc.delegate = (self as! ChildViewControllerDelegate)
        if WalletData != nil {
        vc.transData = WalletData.redeem_list
         vc.creditBalance = WalletData.CF_CREDITED_POINTS
        navigationController?.pushViewController(vc,animated: true)
        }
    }
    
    func toastGenrate(title:String,message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
}
    

