//
//  ViewController.swift
//  HamburgerMenuButtonTestApp
//
//  Created by Stephan Ziegenaus on 05.03.17.
//  Copyright © 2017 KachelSolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var menuButton: HamburgerMenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func toggleMenu(_ sender: UISwitch) {
        menuButton.isMenuOpen = !sender.isOn
    }

}

