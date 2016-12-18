//
//  EnterLocationViewController.swift
//  CityWhether
//
//  Created by Hari Krishna Bista on 12/17/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit

class EnterLocationViewController: UIViewController {

    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnWhetherTapped(_ sender: Any) {
        
        self.txtCity.resignFirstResponder();
        self.txtState.resignFirstResponder();
        self.txtCountry.resignFirstResponder();
        
        self.dismiss(animated: true, completion: nil);
        
        self.performSegue(withIdentifier: "segueToHomeView", sender: self);
        
    }
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        self.txtCity.resignFirstResponder();
        self.txtState.resignFirstResponder();
        self.txtCountry.resignFirstResponder();
        
        self.dismiss(animated: true, completion: nil);

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
