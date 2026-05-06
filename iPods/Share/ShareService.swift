//
//  ShareService.swift
//  iPods
//
//  Created by Sakina Rajabova
//

import UIKit

struct ShareService {
    
    static func sharePodcast(
        feedID: Int,
        title: String,
        from viewController: UIViewController,
        sourceView: UIView?
    ) {
        let deepLinkURL = URL(string: "podcastapp://episode?feedId=\(feedID)")!
        let textToShare = "Послушай подкаст «\(title)»"
        
        let activityVC = UIActivityViewController(
            activityItems: [textToShare, deepLinkURL],
            applicationActivities: nil
        )
        
        
        if let popover = activityVC.popoverPresentationController, let sourceView = sourceView {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
        }
        
        viewController.present(activityVC, animated: true)
    }
}
