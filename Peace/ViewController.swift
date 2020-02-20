//
//  ViewController.swift
//  Peace
//
//  Created by Joseph McCraw on 2/20/20.
//  Copyright © 2020 Joseph McCraw. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBAction func shareTapped(_ sender: UIButton) {
        guard let quote = shareQuote else {
            fatalError("Can't share a non-existent quote.")
        }
        let ac = UIActivityViewController(activityItems: [quote.shareMessage], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = sender
        present(ac, animated: true)
        
    }
    
    @IBOutlet weak var quote: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    
    var shareQuote: Quote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (allowed, error) in
            if allowed {
                self.configureAlerts()
            }
        }
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
        shareQuote = selectedQuote
        
        let insetAmount: CGFloat = 200
        let drawBounds = quote.bounds.inset(by: UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount))
        
        var quoteRect = CGRect(x: 0, y: 0, width: .max, height: .max)
        
        var fontSize: CGFloat = 120
        
        var font: UIFont!
        
        var attributes: [NSAttributedString.Key: Any]! // .Key is now required.
        var str: NSAttributedString!
        
        while true {
            font = UIFont(name: "Georgia-Italic", size: fontSize)!
            attributes = [.font: font!, .foregroundColor: UIColor.white]
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
        let renderer = UIGraphicsImageRenderer(bounds: quoteRect.insetBy(dx: -30, dy: -30), format: format)
        quote.image = renderer.image(actions: { (ctx) in
            for i in 1...5 {  //Darken Shadow by 5x
                ctx.cgContext.setShadow(offset: .zero, blur: CGFloat(i * 2), color: UIColor.black.cgColor)
                str.draw(in: quoteRect)
            }
        })
    }
    
    func configureAlerts() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        let shuffledQuotes = quotes.shuffled()
        var dateComponents = DateComponents()
        
        for i in 1...7 {
            let content = UNMutableNotificationContent()
            content.title = "Peace"
            content.body = shuffledQuotes[i].text
            
            dateComponents.day = i
            if let alertDate = Calendar.current.date(byAdding: dateComponents, to: Date()) {
                var alertComponents = Calendar.current.dateComponents([.day, .month, .year], from: alertDate)
                
                alertComponents.hour = 8  // Set Alert to 8AM
                
                //let trigger = UNCalendarNotificationTrigger(dateMatching: alertComponents, repeats: false)
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 5), repeats: false)  //For testing
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }
            
            
        }
    }
    
}

