//
//  ViewController.swift
//  universal
//
//  Created by IRFAN TRIHANDOKO on 07/12/18.
//  Copyright © 2018 IRFAN TRIHANDOKO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func detailsBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Details", bundle: nil).instantiateInitialViewController() as! DetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

