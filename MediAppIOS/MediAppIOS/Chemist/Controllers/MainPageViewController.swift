//
//  MainPageViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 23/10/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import Toast_Swift
class MainPageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var btnStockist: UIButton!
    @IBOutlet weak var btnChem: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    let preferences = UserDefaults.standard
    let choice = ["As Chemist"]
    var arrItems = ["uncheck","check"]
    var c_flag = 0
    var serverDBVersion = ""
    var serverAppVersion = ""
    var which_login : String = ""
    var checkFlag = false
    @IBOutlet weak var tableView: UITableView!
    var infoModel = UpdateInfoModel()
    let dropTables = DropAllTables()
    let priorityGropu = DispatchGroup()
    @IBOutlet weak var updatePopUp: UpdatePopUp!
    @IBOutlet weak var agreeView: UIView!
    @objc func updateAction(_ sender: Any){
        let url = "itms-apps://appstoreconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1470584981"
        if #available(iOS 10.0, *){
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnStockist.isHidden = true //Stockiest is Hidden Now
        btnRegister.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginbkg.png")!)
        btnStockist.layer.cornerRadius = 10
        btnStockist.layer.borderWidth = 2
        btnStockist.layer.borderColor = UIColor.black.cgColor
        btnChem.layer.cornerRadius = 10
        btnChem.layer.borderWidth = 2
        btnChem.layer.borderColor = UIColor.black.cgColor
        btnRegister.layer.cornerRadius = 10
        btnRegister.layer.borderWidth = 2
        btnRegister.layer.borderColor = UIColor.black.cgColor
        

        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        self.updatePopUp.isHidden = true
        updatePopUp.UpateBtn.addTarget(self, action: #selector(self.updateAction(_:)), for: .touchUpInside)

        priorityGropu.enter()
        let url = Constants.UpdateInfoUrl
        FetchHttpData.updateDataModels(url: url, type: UpdateInfoModel.self){
            response in
            self.infoModel = response as! UpdateInfoModel
//            let a = self.infoModel.app_version
            let a = "1.0.5"
            let appver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            
            if appver != a {
                self.dropTables.DropTables()
                self.preferences.set("true", forKey: "UpdateAvilable")
                
            }else{
                self.preferences.set("false", forKey: "UpdateAvilable")
            }
            
            
            self.priorityGropu.leave()
            self.priorityGropu.notify(queue: .main){
                let val = self.preferences.string(forKey: "UpdateAvilable")
                if val == "false" {
                    self.btnChem.isHidden = false
                    self.btnRegister.isHidden = false
                    self.agreeView.isHidden = false
                    self.updatePopUp.isHidden = true
                if self.preferences.string(forKey: "which_login") == "Chemist" {
                    if Reachability.isConnectedToNetwork(){
                        print("Internet Connection Available!")

                            self.chemLogin()
                    }else{
                        self.view.makeToast("Internet Connection Not Available!")
                    }
                    }
                }else{
                    self.btnChem.isHidden = true
                    self.btnRegister.isHidden = true
                    self.agreeView.isHidden = true
                    self.updatePopUp.isHidden = false
                }
            }
        }
        
       
        
//        preferences.set("", forKey: "which_login")


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RegisterChoiceTableViewCell
       cell.lbl.text = choice[indexPath.row]
//        cell.textLabel?.text = choice[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            c_flag = 0 // stockist
             preferences.set("stockist", forKey: "which_login")
        }else {
            c_flag = 1
             preferences.set("Chemist", forKey: "which_login")
        }
        performSegue(withIdentifier: "reg_choice_segue", sender: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "OwnerRegistrationViewController") as! OwnerRegistrationViewController
        //        vc.delegate = (self as! ChildViewControllerDelegate)
        //                    vc.walletData = WalletData
//        self.navigationController?.pushViewController(vc,animated: true)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reg_choice_segue" {
            let nav = segue.destination as! UINavigationController
            let send = nav.topViewController as! OwnerRegistrationViewController
        
        if c_flag == 0 {
        send.myChoice = true // stockist
        }else if c_flag == 1 {
        send.myChoice = false // temp changes after including stockist part make mychoice = false
        }
           
        }
        if segue.identifier == "login_segue" {
            
            let nav = segue.destination as! UINavigationController
            let send = nav.topViewController as! ChemistLoginViewController
//            let send = segue.destination as! ChemistLoginViewController
            if which_login == "Stockist" {
            send.login_track = 1
            }else if which_login == "Chemist" {
                send.login_track = 2
            }
        }
    }
    
    @IBAction func checkTerms(_ sender: Any) {
        if checkFlag == false {
            
        var  intItemCounter = 0
        for _ in arrItems {
        UIView.transition(with: sender as! UIView, duration: 1.5, options: .transitionFlipFromRight, animations: {
            (sender as AnyObject).setImage(UIImage(named: self.arrItems[intItemCounter]), for: .normal)
        }, completion: nil)
            intItemCounter = intItemCounter + 1
        }
            btnRegister.isHidden = false
            checkFlag = true
            
        }else{
            
            var  intItemCounter = 1
            for _ in arrItems {
                UIView.transition(with: sender as! UIView, duration: 1.5, options: .transitionFlipFromRight, animations: {
                    (sender as AnyObject).setImage(UIImage(named: self.arrItems[intItemCounter]), for: .normal)
                }, completion: nil)
                intItemCounter = intItemCounter - 1
            }
            btnRegister.isHidden = true
            checkFlag = false
            tableView.isHidden = true
        }
    }
    
    @IBAction func termsAndCodition(_ sender: Any) {
        toastGenrate(message:"1. General Terms & Conditions\n" +
            "a) In terms of Information Technology Act, 2000, this document is an electronic record. Being generated by a computer system it does not require any physical or digital signatures. This document is published in accordance with the provisions of Rule 3 (1) of the Information Technology (Intermediaries guidelines) Rules, 2011 that require publishing the rules and regulations, privacy policy and Terms of Use for access or usage of MEDI-APP Mobile Application. \n" +
            "b) The Mobile Application name MEDI-APP (hereinafter referred to as \"Application\") is owned by MILJON MEDI APP LLP, a Limited Liability Partnership firm incorporated as per Section 12(1)(b) of the LLP Act, 2008 (Hereinafter referred to as the “Company”), Registered at, 19, FLOOR-1, 98, MANSUR BUILDING,, SHAMALDAS GANDHI MARG, PRINCESS STREET, KALBADEVI, MUMBAI, Maharashtra, 400002, India. (Hereinafter referred MEDI-APP) \n" +
            "c) MEDI-APP is a mobile Application helping chemists, pharmacy retailers, hospitals and Doctors to find trade schemes/Bonus offers in real time directly from Pharmaceutical Companies, stockists and distributors registered with Medi-App, and place orders through the application. \n" +
            "d) Orders placed though the application will be supplied at the sole discretion and responsibility of the concerned Stockists, Distributors or Pharmaceutical Company and Medi-App is in no way responsible for the same under any circumstances. All commercial terms of payment, credit, delivery etc are between you and the concerned Stockists, Distributors or Pharmaceutical Company and Medi-App is in no way responsible or liable for the same.\n" +
            "e) Your use of our Application provides evidence that you have read and agreed to these Terms & Conditions and our PRIVACY POLICY. Please read both carefully. The use of this Application by you is governed by this policy and any policy so mentioned by terms of reference. Moving past home page, or using any of the services shall be taken to mean that you have read and agreed to all of the policies so binding in you and that you are contracting with the Company and have undertaken binding obligations with the company. If you do not agree with any of these terms, please exit MEDI-APP. \n" +
            "f) This Terms & Conditions and associated Privacy Policy shall be applicable to the Application and Users hereby accept that any usage of the Application shall be understood as acceptance of the Terms & Conditions and Privacy Policy. For the purpose of these Terms & Conditions, wherever the context so requires \"you\" or \"User\" shall mean any natural or legal person who has agreed to use the Application to browse and fetch Data services. The Application providing its services without registration does not absolve you of this contractual relationship. The term \"We\", \"Us\", \"Our\" shall mean MEDI-APP or Company. \n" +
            "g) You will be subject to the rules, guidelines, policies, terms, and conditions applicable to any service that is provided by this Application, and they shall be deemed to be incorporated into this Terms & Conditions and shall be considered as part and parcel of this Terms & Conditions.\n" +
            "h) We hold the sole right to modify the Terms & Conditions without prior permission from you or informing you. The relationship creates on you a duty to periodically check the terms and stay updated on its requirements. If you continue to use the Application following such a change, this is deemed as consent by you to the so amended policies. \n" +
            "i) As long as you comply with these Terms & Conditions, we grant you a personal, nonexclusive, non-transferable, limited privilege to enter and use the Application. By impliedly or expressly accepting these Terms & Conditions, you also accept and agree to be bound by other MEDI-APP Policies, inter alia Privacy Policy, which would be amended from time to time. \n" +
            "2. Access & Usage: \n" +
            "a) The use of this Application is available only to those above the age of 18 barring those ‘Incompetent to Contract’ which inter alia include insolvents and the same is not allowed to minors as described by the Indian Contract Act, 1872. Minors may use the site under the supervision of a parent or a legal guardian. The use of this Application is not limited to those above the age of 18 only and are applicable to all barring those ‘Incompetent to Contract’ which inter alia include insolvents under the Indian Contract Act, 1872. If you are a minor and wish to use the Application, you may do so through your legal guardian and MEDI-APP reserves the right to restrict your usage of the Application on knowledge of You being a minor. We reserve the right to restrict access of part/ whole of the Application for paying customers who may access this restricted area with a login id and password. \n" +
            "3. Contact: \n" +
            "a) By using this Application, your consent to be contacted for purposes of clarification calls for any clarifications sought by you is implied. The sharing of the information provided by you will governed by the Privacy Policy and We will not give out such contact information of yours to third parties not connected with the Web site without your consent. \n" +
            "4. User Fees & Charges: \n" +
            "The membership of this Application is free of cost and this includes the browsing of the Application and the use of the services. However, we reserve the right to amend this no-fee policy and charge for the services rendered. In a case that such change, Users will be intimated of the same, and it will be up to you to decide whether or not you will continue with services offered by us. Such changes are effective as soon as they are posted on the Application. \n" +
            "5. Third Party Information: \n" +
            "All text, graphics, user interfaces, visual interfaces, photographs, trademarks, logos, sounds, music and artwork (collectively, \"Content\"), includes our content and third party user generated content and We have no control over such third party user generated content as We are also an intermediary for the purposes of this Terms & Conditions. We are in no way responsible for the authenticity of the content and shall not be held liable in any manner for any falsification of information posted on the Application. Other than when provided for, the use of such content and it being reproduced, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted or distributed in any way (including \"mirroring\") to any other computer, server, Website or other medium for publication or distribution or for any commercial enterprise, without our express prior written consent is not allowed. The content that you post in the form of reviews, suggestions and feedbacks will become our property and you grant us the worldwide, perpetual and transferable rights in such Content. We shall be entitled to, consistent with our Privacy Policy as adopted in accordance with applicable law, use the Content or any of its elements for any type of use forever, including but not limited to promotional and advertising purposes and in any media whether now known or hereafter devised, including the creation of derivative works that may include the Content you provide and are not entitled to any payment or other compensation for such use. \n" +
            "6. User Obligation: \n" +
            "a) You are a restricted user of this Application and you are bound not to cut, copy, distribute, modify, recreate, reverse engineer, distribute, disseminate post, publish or create derivative works from, transfer, or sell any information or software obtained from the mobile Application. Unlimited or wholesale reproduction, copying of the content for commercial or non-commercial purposes and unwarranted modification of data and information within the content of the  Application is not permitted.\n" +
            "b) You agree not to access (or attempt to access) the mobile Application and/or the materials or Services by any means other than through the interface that is provided by the Web site. You acknowledge and agree that by accessing or using the application or Services, you may be exposed to content from other users that you may consider offensive, indecent or otherwise objectionable. We disclaim all liabilities arising in relation to such offensive content on the Web site. Further, you may report such offensive content. In places where this Application allows you to post or upload data/information, you undertake to ensure that such material is not offensive and in accordance with applicable laws. \n" +
            "7. Disclaimer of warranties and liabilities: \n" +
            "YOU EXPRESSLY UNDERSTAND AND AGREE THAT, TO THE MAXIMUM EXTENT PERMITTED BY applicable LAW: \n" +
            "a)  THE MOBILE Application, SERVICES AND OTHER MATERIALS ARE PROVIDED BY THIS Application IS ON AN \"AS IS\" BASIS WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED, STATUTORY OR OTHERWISE, INCLUDING THE IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. WITHOUT LIMITING THE FOREGOING, MEDI-APP MAKES NO WARRANTY THAT\n" +
            "i. YOUR REQUIREMENTS WILL BE MET OR THAT SERVICES PROVIDED WILL BE UNINTERRUPTED, TIMELY, SECURE OR ERROR-FREE; \n" +
            "ii. MATERIALS, INFORMATION OBTAINED AND RESULTS WILL BE EFFECTIVE, ACCURATE OR RELIABLE; \n" +
            "iii.  ANY ERRORS OR DEFECTS IN THE WEB SITE, SERVICES OR OTHER MATERIALS WILL BE CORRECTED. \n" +
            "b) TO THE MAXIMUM EXTENT PERMITTED BY applicable LAW, WE WILL HAVE NO LIABILITY RELATED TO USER CONTENT ARISING UNDER INTELLECTUAL PROPERTY RIGHTS, LIBEL, PRIVACY, PUBLICITY, OBSCENITY OR OTHER LAWS. WE ALSO DISCLAIM ALL LIABILITY WITH RESPECT TO THE MISUSE, LOSS, MODIFICATION OR UNAVAILABILITY OF ANY USER CONTENT.\n" +
            "c) WE AND OUR AFFILIATES ARE NOT RESPONSIBLE OR LIABLE FOR CONTENT POSTED BY THIRD PARTIES, ACTIONS OF ANY THIRD PARTY, OR FOR ANY DAMAGE TO, OR VIRUS THAT MAY INFECT, YOUR COMPUTER EQUIPMENT OR OTHER PROPERTY.\n" +
            "d) MEDI-APP CONTAINS FACTS, VIEWS, OPINIONS, STATEMENTS AND RECOMMENDATIONS OF THIRD PARTY INDIVIDUALS AND ORGANIZATIONS. WE DO NOT REPRESENT OR ENDORSE THE ACCURACY, CURRENTNESS OR RELIABILITY OF ANY ADVICE, OPINION, STATEMENT OR OTHER INFORMATION DISPLAYED, UPLOADED OR DISTRIBUTED IN ANY MANNER. ANY RELIANCE UPON ANY SUCH OPINION, ADVICE, STATEMENT OR INFORMATION IS AT YOUR RISK AND WE SHALL NOT BE HELD LIABLE IN ANY WAY.\n" +
            "e) IN NO EVENT SHALL WE OR OUR AFFILIATES, EMPLOYEES, AGENTS, CONTENT PROVIDERS OR LICENSORS BE LIABLE FOR ANY INDIRECT, CONSEQUENTIAL, SPECIAL, INCIDENTAL OR PUNITIVE DAMAGES INCLUDING, WITHOUT LIMITATION, DAMAGES RELATED TO UNAUTHORIZED ACCESS TO OR ALTERATION OF YOUR TRANSMISSIONS OR DATA, THE CONTENT OR ANY ERRORS OR OMISSIONS IN THE CONTENT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. IN NO EVENT SHALL WE OR OUR AFFILIATES, EMPLOYEES, AGENTS, CONTENT PROVIDERS OR LICENSORS BE LIABLE FOR ANY AMOUNT FOR DIRECT DAMAGES IN EXCESS OF Rs 1000 \n" +
            "f) THE USER UNDERSTANDS AND AGREES THAT ANY MATERIAL OR DATA DOWNLOADED OR OTHERWISE OBTAINED THROUGH THE MOBILE Application IS DONE ENTIRELY AT THEIR OWN DISCRETION AND RISK AND THEY WILL BE SOLELY RESPONSIBLE FOR ANY DAMAGE TO THEIR MOBILE PHONES or other devices OR LOSS OF DATA THAT RESULTS FROM THE DOWNLOAD OF SUCH MATERIAL OR DATA.\n" +
            "g)  MEDI-APP IS NOT RESPONSIBLE FOR ANY TYPOGRAPHICAL ERROR LEADING TO AN INVALID SCHEME/OFFER COUPONS. WE ACCEPT NO LIABILITY FOR ANY ERRORS OR OMISSIONS, WITH RESPECT TO ANY INFORMATION PROVIDED TO YOU WHETHER ON BEHALF OF ITSELF OR THIRD PARTIES. WE SHALL NOT BE LIABLE FOR ANY THIRD PARTY PRODUCT OR SERVICES. \n" +
            "8. Indemnification and Limitation of Liability \n" +
            "YOU AGREE TO INDEMNIFY, DEFEND AND HOLD HARMLESS THIS Application INCLUDING BUT NOT LIMITED TO ITS AFFILIATE VENDORS, AGENTS AND EMPLOYEES FROM AND AGAINST ANY AND ALL LOSSES, LIABILITIES, CLAIMS, DAMAGES, DEMANDS, COSTS AND EXPENSES (INCLUDING LEGAL FEES AND DISBURSEMENTS IN CONNECTION THEREWITH AND INTEREST CHARGEABLE THEREON) ASSERTED AGAINST OR INCURRED BY US THAT ARISE OUT OF, INCLUDING, BUT NOT LIMITED TO, CLAIMS FOR DEFAMATION, TRADE DISPARAGEMENT, PRIVACY AND INTELLECTUAL PROPERTY INFRINGEMENT,ANY BREACH OR NON-PERFORMANCE OF ANY REPRESENTATION, WARRANTY, COVENANT OR AGREEMENT MADE OR OBLIGATION TO BE PERFORMED BY YOU PURSUANT TO THESE TERMS OF USE) AND DAMAGES (INCLUDING ATTORNEYS' FEES AND COURT COSTS) ARISING FROM OR RELATING TO ANY ALLEGATION REGARDING: \n" +
            "i.  YOUR USE OF THE Application\n" +
            "ii. OUR USE OF ANY CONTENT OR INFORMATION YOU PROVIDE, AS LONG AS SUCH USE IS NOT INCONSISTENT WITH THIS AGREEMENT; \n" +
            "iii. INFORMATION OR MATERIAL POSTED OR TRANSMITTED THROUGH YOUR MEMBERSHIP ACCOUNT, EVEN IF NOT POSTED BY YOU; AND,\n" +
            "iv. ANY VIOLATION OF THIS AGREEMENT BY YOU. FURTHER, YOU AGREE TO HOLD US HARMLESS AGAINST ANY CLAIMS MADE BY ANY THIRD PARTY DUE TO, OR ARISING OUT OF, OR IN CONNECTION WITH, YOUR USE OF THE WEB SITE, ANY CLAIM THAT YOUR MATERIAL CAUSED DAMAGE TO A THIRD PARTY, YOUR VIOLATION OF THE TERMS OF USE, OR YOUR VIOLATION OF ANY RIGHTS OF ANOTHER, INCLUDING ANY INTELLECTUAL PROPERTY RIGHTS. \n" +
            "v. IN NO EVENT SHALL WE, ITS OFFICERS, DIRECTORS, EMPLOYEES, PARTNERS OR SUPPLIERS BE LIABLE TO YOU, THE VENDOR OR ANY THIRD PARTY FOR ANY SPECIAL, INCIDENTAL, INDIRECT, CONSEQUENTIAL OR PUNITIVE DAMAGES WHATSOEVER, INCLUDING THOSE RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER OR NOT FORESEEABLE OR WHETHER OR NOT WE HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES, OR BASED ON ANY THEORY OF LIABILITY, INCLUDING BREACH OF CONTRACT OR WARRANTY, NEGLIGENCE OR OTHER TORTIOUS ACTION, OR ANY OTHER CLAIM ARISING OUT OF OR IN CONNECTION WITH YOUR USE OF OR ACCESS TO THE Application, SERVICES OR MATERIALS. \n" +
            "THE LIMITATIONS AND EXCLUSIONS IN THIS SECTION APPLY TO THE MAXIMUM EXTENT PERMITTED BY applicable LAW.\n" +
            "9. Third party information \n" +
            "The Application hosts information provided by third party. We are in no way responsible to you for the accuracy, legitimacy and trueness of the information so hosted. You agree to not hold us liable for the falsification of any such provided information. Your dealings or communications through the Application with any party are solely between you and that third party. Under no circumstances will we be liable for any good, services, resources or content available through such third party dealings or communications, or for any harm related thereto. Please review carefully that third party's policies and practices and make sure you are comfortable with them before you engage in any transaction. Complaints, concerns or questions relating to materials provided by third parties should be forwarded directly to the third party. We are not responsible for the actions or policies of such third parties. \n" +
            "10. COPYRIGHT \n" +
            "All information, content, services and software displayed on, transmitted through, or used in connection with the Application, as well as its selection and arrangement, is owned by us, and its affiliated companies, licensors and suppliers. You may not, republish any portion of the Content on any Internet, Intranet or extranet site or incorporate the Content in any database, compilation, archive or cache. You may not distribute any Content to others, whether or not for payment or other consideration, and you may not modify, copy, frame, cache, reproduce, sell, publish, transmit, display or otherwise use any portion of the Content. \n" +
            "11.  DISCLAIMER \n" +
            "i. We reserve the right to change or discontinue, at any time, any aspect or feature of this Application. \n" +
            "ii. The Application is a platform that Users utilize to meet and interact with one another for their transactions. We are not a party to such interaction and take no liability that arises from any such communication.\n" +
            "iii. All communication which inter alia includes the contract, its terms, your obligations, the seller’s obligations, prices, etc are outcomes of the communication between the seller and You. This includes, without any limitation, the prices, shipping costs, payment details, date, period and mode of delivery, warranties related to products and services and after sales services related to products and services. We do not have any control over such information and play no determinative role in the finalization of the same and hence do not stand liable for the outcomes of such communication. \n" +
            "iv. We do not endorse any of the products/services offered for sale on the Application nor place any guarantee as to its nature, price, quality, etc.\n" +
            "v. Subject to the above sub-clauses, a contract exists between the seller/provider and the buyer and as such any breach of contract and thus, any claim arising from such breach is the subject matter of the seller/provider and the buyer alone and we are in no way a party to such breach or involved in any suit arising from the same breach. The contact/communication arising from such breach may entail between the seller and the buyer directly without Us being involved.\n" +
            "vi. As the buyer, you are expected to check the creditworthiness of the provider and the genuineness of the products or services offered by them. We are not liable for the same.\n" +
            "vii. As the contract is limited to the SERVICE PROVIDER and the buyer and not Us, we are in no way liable for any deficiency of service that may arise which includes and is not limited to cancellation of order due to low stocks, defected goods, and defective nature of goods.\n" +
            "viii. As we hold no possession, nor title of the products at any time, or enter/determine the communication between the buyer and the seller or determine its outcome, the contract is purely a bipartite contract between the buyer and the seller and We are not responsible for claims arising from such a contract. \n" +
            "ix. You release and indemnify Us and/or any of its officers and representatives from any cost, damage, liability or other consequence of any of the actions of the Users of the Application and specifically waive any claims that you may have in this behalf under any applicable law. \n" +
            "12. MISCELLANEOUS \n" +
            "We reserve the right to change these Terms & Conditions at any time in its discretion and to notify users of any such changes solely by changing this Terms & Conditions. Your continued use of the Web site after the posting of any amended Terms & Conditions shall constitute your agreement to be bound by any such changes. Your use of this site prior to the time this Terms & Conditions was posted will be governed according to the Terms & Conditions that Application lied at the time of your use. We may modify, suspend, discontinue or restrict the use of any portion, including the availability of any portion of the Content at any time, without notice or liability. We may deny access to any person or user at any time for any reason. In addition, we may at any time transfer rights and obligations under this Agreement to any affiliate, subsidiary or business unit, or any of their affiliated companies or divisions, or any entity that acquires MEDI-APP or any of their assets. We hereby reserve the right to block usage of the Website and the Application if any breach of the Terms & Conditions is caused by a User. This can in no way be construed as a waiver of any legal right under Indian law to claims any damages or initiate any legal proceedings against the User. \n" +
            "\n" +
            "© 2017 MEDI-APP. All rights reserved.")
    }
    

    
    @IBAction func registerClick(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            tableView.isHidden = false
        }else{
            self.view.makeToast("Internet Connection Not Avilable!")
        }
    }
    
    @IBAction func sockistAction(_ sender: Any) {
//        which_login = "Stockist"
//        preferences.set("Stockist", forKey: "which_login")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ChemistLoginViewController") as! ChemistLoginViewController
//        //        vc.delegate = (self as! ChildViewControllerDelegate)
//        vc.login_track = 1
//        navigationController?.pushViewController(vc,animated: true)
        self.view.makeToast("Coming Soon!!")
    }
    
    @IBAction func chemistAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            chemLogin()
        }else{
            print("Internet Connection not Available!")
            self.view.makeToast("Internet Connection not Available!")
        }
    }
   
    
    
   func chemLogin(){
    which_login = "Chemist"
    preferences.set("Chemist", forKey: "which_login")
    performSegue(withIdentifier: "login_segue", sender: nil)
    
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let vc = storyboard.instantiateViewController(withIdentifier: "ChemistLoginViewController") as! ChemistLoginViewController
//    //        vc.delegate = (self as! ChildViewControllerDelegate)
//    navigationController?.pushViewController(vc,animated: true)
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  
    }
    func toastGenrate(message : String) {
        let alert = UIAlertController(title: "Terms & Conditions", message: message, preferredStyle: UIAlertControllerStyle.alert)
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
@objc protocol TabBarSwitcher {
    func handleSwipes(sender:UISwipeGestureRecognizer)
}

extension TabBarSwitcher where Self: UIViewController {
    func initSwipe( direction: UISwipeGestureRecognizerDirection){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TabBarSwitcher.handleSwipes(sender:)))
        swipe.direction = direction
        self.view.addGestureRecognizer(swipe)
    }
}



class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}


extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
