//
//  MenuViewController.swift
//  Asteroids.io
//
//  Created by Tony on 5/7/19.
//  Copyright © 2019 cmsc436. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func joinPressed(_ sender: Any) {
        dismiss(animated: true) {
            SocketIOManager.default.connect()
        }
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
