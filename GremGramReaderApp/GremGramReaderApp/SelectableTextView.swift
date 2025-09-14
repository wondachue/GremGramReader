//
//  SelectableTextView.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//

import SwiftUI
import UIKit
import NaturalLanguage

struct SelectableTextView: UIViewRepresentable {
    var text: String
    var font: UIFont = .preferredFont(forTextStyle: .body)
    var textColor: UIColor = .label
    var highlightColor: UIColor = UIColor.systemYellow.withAlphaComponent(0.45)
    var onWordTap: (String) -> Void

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = false          // we'll handle tap selection ourselves
        tv.isScrollEnabled = true
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0

        tv.attributedText = context.coordinator.makeAttributed(text: text)

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        tv.addGestureRecognizer(tap)
        context.coordinator.textView = tv
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // Don’t nuke the highlight on trivial updates
        if uiView.text != text {
            uiView.attributedText = context.coordinator.makeAttributed(text: text)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject {
        var parent: SelectableTextView
        weak var textView: UITextView?
        private var highlightedRange: NSRange?

        init(_ parent: SelectableTextView) { self.parent = parent }

        func makeAttributed(text: String) -> NSAttributedString {
            NSAttributedString(
                string: text,
                attributes: [
                    .font: parent.font,
                    .foregroundColor: parent.textColor
                ]
            )
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let tv = textView else { return }

            var point = gesture.location(in: tv)
            point.x -= tv.textContainerInset.left
            point.y -= tv.textContainerInset.top

            let lm = tv.layoutManager
            let container = tv.textContainer
            let glyphIndex = lm.glyphIndex(for: point, in: container, fractionOfDistanceThroughGlyph: nil)
            let charIndex = lm.characterIndexForGlyph(at: glyphIndex)

            let s = tv.attributedText.string
            guard charIndex < s.utf16.count else { return }

            // Use NLTokenizer for robust “word” detection (handles CJK)
            let tokenizer = NLTokenizer(unit: .word)
            tokenizer.string = s
            let idx = String.Index(utf16Offset: charIndex, in: s)
            let tokenRange = tokenizer.tokenRange(at: idx)
            guard !tokenRange.isEmpty else { return }

            // Filter out pure punctuation “tokens”
            let token = String(s[tokenRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            guard token.rangeOfCharacter(from: .alphanumerics) != nil || token.count > 1 else { return }

            let lower = tokenRange.lowerBound.utf16Offset(in: s)
            let upper = tokenRange.upperBound.utf16Offset(in: s)
            let nsRange = NSRange(location: lower, length: upper - lower)

            // Apply highlight
            let mut = NSMutableAttributedString(attributedString: tv.attributedText)
            if let old = highlightedRange { mut.removeAttribute(.backgroundColor, range: old) }
            mut.addAttribute(.backgroundColor, value: parent.highlightColor, range: nsRange)
            tv.attributedText = mut
            highlightedRange = nsRange

            parent.onWordTap(token)
        }
    }
}
