//
//  AlertErrorController.swift
//  WeatherApp
//
//  Created by Admin on 27.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class AlertErrorController: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    public func showAlert(title: String?, message: String?, in vc: UIViewController){
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
           vc.present(alert, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
