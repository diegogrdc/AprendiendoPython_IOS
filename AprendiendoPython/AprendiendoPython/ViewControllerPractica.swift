//
//  ViewControllerPractica.swift
//  AprendiendoPython
//
//  Created by Diego Garcia Rodriguez del Campo on 20/04/21.
//

import UIKit

class ViewControllerPractica: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func returnMenu(segue: UIStoryboardSegue) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
