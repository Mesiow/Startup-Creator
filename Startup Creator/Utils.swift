//
//  Utils.swift
//  Startup Creator
//
//  Created by Chris W on 1/5/25.
//

import UIKit
import MarkdownKit

func parseMarkdownToPlainText(markdown: String) -> String? {
    return NSAttributedString(string: markdown).string
}

func getMarkdownTextFromGPTResponse(content: String, fontSize: CGFloat, truncate: Bool = false) -> NSAttributedString? {
    //Get the gpt content string with its markdown
    let markdownParser = MarkdownParser()
    let parsedStr = markdownParser.parse(content)
  
    let mutableAttributedString = NSMutableAttributedString(attributedString: parsedStr)
    if truncate {
        //Line break
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        mutableAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0,mutableAttributedString.length))
    }
    
    //Text Color
    let textColor = UIColor.label
    mutableAttributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0,length:mutableAttributedString.length))
    
    // Apply the new font size to the entire text while keeping existing attributes (like bold and italics)
    mutableAttributedString.enumerateAttributes(in: NSRange(location: 0, length:mutableAttributedString.length),options: []) { attributes, range, _ in
        if let currentFont = attributes[.font] as? UIFont {
            // Only change the font size, keep the other properties like bold, italic intact
            let newFontSize = UIFont(descriptor: currentFont.fontDescriptor.withSize(fontSize), size: fontSize)
            mutableAttributedString.addAttribute(.font, value: newFontSize, range: range)
        }
    }
    return mutableAttributedString
}
