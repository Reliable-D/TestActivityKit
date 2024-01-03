//
//  HomeViewController.swift
//  TestActivityKit
//
//  Created by dengle on 2024/1/3.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        
        
        let btn1 = UIButton()
        btn1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn1)
        btn1.addTarget(self, action: #selector(clickStartBtn(sender:)), for: .touchUpInside)
        btn1.setTitle("Start Live Activity", for: .normal)
        btn1.setTitleColor(.red, for: .normal)
        
        NSLayoutConstraint.activate([
            btn1.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            btn1.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
            
            
        ])
    }

    
    @objc func clickStartBtn(sender: UIButton) {
        
    }
}
