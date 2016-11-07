//
//  ViewController.swift
//  tips
//
//  Created by Erik Clineschmidt on 11/6/16.
//  Copyright © 2016 Erik Clineschmidt. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var base_cost: UILabel!
    
    @IBOutlet var percents: [UILabel]!
    
    @IBOutlet var tip_amounts: [UILabel]!
    
    @IBOutlet var user_total: [UILabel]!
    
    @IBOutlet weak var dec_btn: UIButton!
    @IBOutlet var calcbtns: [UIButton]!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var percent_slider: UISlider!
    
    @IBOutlet weak var partysize_slider: UISlider!
    
    var costary: [Int] = []
    var decary: [Int] = []
    var cost = 0.00
    var partyfactor = 1.0
    var base_percent = 10
    var dec_flag =  false
    
    func resetUI(){
        cost = 0.00
        base_percent = 10
        base_cost.text = String(cost)
        costary = []
        decary = []
        dec_flag =  false
        
        updateUI()
        
//        self.percent_slider.setValue(10.0, animated: true)
//        self.partysize_slider.setValue(1.0, animated: true)
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetUI()
    }
    
    @IBAction func dec_btn_action(_ sender: UIButton) {
        dec_flag = true
    }
    func update_cost(numb: Int){
        
        var display_string: String = ""
        
        cost = 0
        
        // store the integer values or decimal values
        
        if(dec_flag == true && decary.count<2){
            decary.append(numb)
        }else if(dec_flag == false){
            costary.append(numb)
        }
        
        // work out the display string
        
        for n in costary {
             display_string += String(n)
        }
        if(decary.count == 2){
            display_string += "."
            display_string += String(decary[0])
            display_string += String(decary[1])
        }
        base_cost.text = "$" + display_string
        
        // calculate the numeric cost
        
        if (costary.count) == 1 {
            cost += Double(costary[0])
        }
        if (costary.count) > 1 {
            var counter = costary.count-1
            cost = Double(costary[counter])
            counter -= 1
            for idx in 0...costary.count-2 {
                let factor = pow(Double(10), Double(counter + 1))
                let add_this = Double(costary[idx]) * factor
                cost += add_this
                counter -= 1
            }
        }
        
        // if decimal places, add them in
        
        if(decary.count == 2){
            var dec = 0.0
            dec += Double(decary[1])
            dec += Double(decary[0]) * 10
            cost += (dec/100.0)
        }
        
        updateUI()
    }
    
    func updateUI(){
        
        let p1 = base_percent
        let p2 = base_percent + 5
        let p3 = base_percent + 10
        
        let tipamt1 = ((Double(p1) * (cost / partyfactor)) / 100)
        let tipamt2 = ((Double(p2) * (cost / partyfactor)) / 100)
        let tipamt3 = ((Double(p3) * (cost / partyfactor)) / 100)
        
        self.percents[0].text = String(p1) + "%"
        self.percents[1].text = String(p2) + "%"
        self.percents[2].text = String(p3) + "%"
        
        self.tip_amounts[0].text = String("$") + String(format: "%.02f", tipamt1)
        self.tip_amounts[1].text = String("$") + String(format: "%.02f", tipamt2)
        self.tip_amounts[2].text = String("$") + String(format: "%.02f", tipamt3)
        
        self.user_total[0].text = String("$") + String(format: "%.02f", (tipamt1 + (cost/partyfactor)))
        self.user_total[1].text = String("$") + String(format: "%.02f", (tipamt2 + (cost/partyfactor)))
        self.user_total[2].text = String("$") + String(format: "%.02f", (tipamt3 + (cost/partyfactor)))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func percents_action(_ sender: UISlider) {
        base_percent = Int(floor(sender.value))
        updateUI()
    }

    @IBAction func partysize_action(_ sender: UISlider) {
        partyfactor = floor(Double(sender.value))
        updateUI()
    }
    
    @IBAction func calcbtns_action(_ sender: UIButton) {
        update_cost(numb: Int(sender.tag))
    }

}

