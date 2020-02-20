//
//  ViewController.swift
//  Peace
//
//  Created by Joseph McCraw on 2/20/20.
//  Copyright © 2020 Joseph McCraw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quote: UIImageView!
    @IBOutlet weak var background: UIImageView!
    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateQuote()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateQuote()
    }
    
    func updateQuote() {
        guard let backgroundImageName = images.randomElement() else  {
            fatalError("No random image.")
        }
        background.image = UIImage(named: backgroundImageName)
        
        guard let selectedQuote = quotes.randomElement() else {
            fatalError("No random quote.")
        }
        print(selectedQuote)
        
        let insetAmount: CGFloat = 200
        let drawBounds = quote.bounds.inset(by: UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount))
        
        
        var quoteRect = CGRect(x: 0, y: 0, width: .max, height: .max)
        
        var fontSize: CGFloat = 120
        
        var font: UIFont!
        
        var attributes: [NSAttributedString.Key: Any]! // .Key is now required.
        var str: NSAttributedString!
        
        while true {
            font = UIFont(name: "Georgia-Italic", size: fontSize)!
            attributes = [.font: font, .foregroundColor: UIColor.white]
            //attributes = [font: font, ]
            str = NSAttributedString(string: selectedQuote.text, attributes: attributes)
            
            quoteRect = str.boundingRect(with: CGSize(width: drawBounds.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            if quoteRect.height > drawBounds.height {
                fontSize -= 4
            } else {
                break
            }
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(bounds: quoteRect, format: format)
        quote.image = renderer.image(actions: { (ctx) in
            for i in 1...5 {  //Darken Shadow by 5x
                ctx.cgContext.setShadow(offset: .zero, blur: CGFloat(i * 2), color: UIColor.black.cgColor)
                str.draw(in: quoteRect)
            }
        })
        
        
    }
    
    
}

