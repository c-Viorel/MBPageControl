//
//  ViewController.swift
//  MBPageControl
//
//  Created by Viorel Porumbescu on 04/08/2017.
//  Copyright © 2017 Viorel. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {



    @IBOutlet weak var txt1: NSTextField!
    @IBOutlet weak var txt2: NSTextField!

    @IBOutlet weak var txt3: NSTextField!
    @IBOutlet weak var txt4: NSTextField!
    @IBOutlet weak var txt5: NSTextField!


    @IBOutlet weak var inactive: MBPageControlView!

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
          inactive.isEnabled = false 
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func pageControl1Action(_ sender: MBPageControlView) {
        txt1.stringValue = "\(sender.indexOfSelectedItem)"
    }

    @IBAction func pageControl2Action(_ sender: MBPageControlView) {
        txt2.stringValue = "\(sender.indexOfSelectedItem)"
    }
    @IBAction func pageControl3Action(_ sender: MBPageControlView) {
        txt3.stringValue = "\(sender.indexOfSelectedItem)"
    }
    @IBAction func pageControl4Action(_ sender: MBPageControlView) {
        txt4.stringValue = "\(sender.indexOfSelectedItem)"
    }
    @IBAction func pageControl5Action(_ sender: MBPageControlView) {
        txt5.stringValue = "\(sender.indexOfSelectedItem)"
    }




}

