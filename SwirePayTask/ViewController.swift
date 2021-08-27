//
//  ViewController.swift
//  SwirePayTask
//
//  Created by Logesh on 26/08/21.
//  Copyright © 2021 logesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let shape = CAShapeLayer()
    let trackShape = CAShapeLayer()
    weak var animationTimer : Timer!
    var circlePath = UIBezierPath()

    private let starImage: UIImageView = {
        let image = UIImage.init(named: "starImage")
        return UIImageView(image: image)
    }()
    
    @IBOutlet weak var lblStartButton: UIButton!
    
    @IBAction func startTheLoader(_ sender: Any)
    {
        self.animationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startAnimation), userInfo: nil, repeats: true)
        self.lblStartButton.isEnabled = false
        self.lblStartButton.alpha = 0.5
        self.getServerData { (status) in
            if status {
                self.stopAnimation()
            }
            else {
                print(status)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starImage.sizeToFit()
        view.addSubview(starImage)
        starImage.center = view.center
        
        circlePath = UIBezierPath(arcCenter: view.center, radius: 150,startAngle: -(.pi * 2),endAngle: .pi * 2,clockwise: true)
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 15
        trackShape.strokeColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(trackShape)
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 15
        shape.strokeColor = UIColor.darkGray.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        view.layer.addSublayer(shape)
    }
        
    @objc public func startAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 2
        animation.fillMode = .forwards
        self.shape.add(animation, forKey: "animation")
    }
    
    func stopAnimation() {
        DispatchQueue.main.async {
            self.lblStartButton.isEnabled = true
            self.lblStartButton.alpha = 1.0
        }
        self.animationTimer.invalidate()
    }
    
    //Server call
    func getServerData(_ completionHandler: @escaping (Bool) -> ()) {
        
        let url = URL(string: "https://reqres.in/api/users?delay=3")
        let request = URLRequest(url: url!)

        URLSession.shared.dataTask(with: request as URLRequest)
        { (data, response, error) in
            if error == nil
            {
                if let data = data, let result = String(data: data, encoding: String.Encoding.utf8)
                {
                    print(result)
                    completionHandler(true)
                }
            }
            else
            {
                completionHandler(false)
            }
        }.resume()
    }
    
}
