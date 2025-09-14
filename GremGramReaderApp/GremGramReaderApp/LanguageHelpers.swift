//
//  LanguageHelpers.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//

import NaturalLanguage

enum LangDetect {
    /// Returns a BCP-47 code like "en", "ja", "ga", or "und" (undetermined).
    static func dominantCode(for text: String) -> String {
        // Work on a trimmed sample for speed/robustness
        let sample = String(text.prefix(8000))
        guard let lang = NLLanguageRecognizer.dominantLanguage(for: sample) else {
            return "und"
        }
        return lang.rawValue
    }

    /// Top N hypotheses with confidence (0.0–1.0), highest first.
    static func topHypotheses(for text: String, max: Int = 3) -> [(code: String, confidence: Double)] {
        let sample = String(text.prefix(8000))
        let r = NLLanguageRecognizer()
        r.processString(sample)
        return r.languageHypotheses(withMaximum: max)
            .sorted { $0.value > $1.value }
            .map { ($0.key.rawValue, $0.value) }
    }
}
