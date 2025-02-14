//
//  GameViewController.swift
//  RecycleGame
//
//  Created by Mathieu Ponal on 14/02/2025.
//

import UIKit

class GameViewController: UIViewController {
    
    var sorted: Int = 0;

    @IBOutlet var bin_list: [UIImageView]!
    
    @IBOutlet var waste_list: [UIImageView]!
    
    var selected_waste: UIImageView?
    
    var previous_pos: CGPoint = .zero
    var init_pos: CGPoint = .zero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        for waste in waste_list {
            if waste.frame.contains(touch.preciseLocation(in: waste.superview)) {
                selected_waste = waste
//                waste.superview?.bringSubviewToFront(self.view)
                previous_pos = touch.location(in: self.view)
                init_pos = waste.center
                break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first, let selected_waste = selected_waste else { return }
        
        let delta_x = touch.location(in: self.view).x - previous_pos.x
        let delta_y = touch.location(in: self.view).y - previous_pos.y
        
        previous_pos = touch.location(in: self.view)
        
        selected_waste.center = CGPoint(x: selected_waste.center.x + delta_x, y: selected_waste.center.y + delta_y)
        
        for bin in bin_list {
            if bin.frame.contains(touch.location(in: bin.superview)) {
                bin.isHighlighted = true
            } else {
                bin.isHighlighted = false
            }
        }
    }
    
    func win_alert() {
        let alert = UIAlertController(title: "Congratulation !", message: "You sorted everything correclty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        if let waste = selected_waste {
            for bin in bin_list {
                if bin.frame.contains(touch.preciseLocation(in: bin.superview)) {
                    if bin.tag == waste.tag {
                        waste.isHidden = true
                        sorted = sorted + 1
                        if sorted == waste_list.count {
                            win_alert()
                        }
                    } else {
                        waste.center = init_pos
                    }
                    bin.isHighlighted = false
                    break
                }
            }
            self.selected_waste = nil
        }
    }

}
