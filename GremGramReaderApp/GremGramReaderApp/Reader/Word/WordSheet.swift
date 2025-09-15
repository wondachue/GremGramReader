//
//  WordSheet.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//

import SwiftUI
import SafariServices
import AVFoundation

struct WordSheet: View {
    let word: String
    let languageCode: String?

    @State private var showSafari = false
    @State private var showAppleDict = false
    @State private var isSpeaking = false

    // Reuse your existing lookup URL builder
    private var lookupURL: URL? {
        DictionaryLookupService.target(for: word, langCode: languageCode)
    }

    private let synth = AVSpeechSynthesizer()
    @State private var synthDelegate: SynthDelegate?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                header

                // Quick Action Tiles
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12)],
                          spacing: 12) {
                    ActionTile(title: Word.Lookup.dictionary,
                               systemImage: "book.pages",
                               role: .plain) {
                        showAppleDict = true
                    }

                    ActionTile(title: Word.Lookup.web,
                               systemImage: "safari.fill",
                               role: .accent) {
                        showSafari = true
                    }
                    .disabled(lookupURL == nil)

                    ActionTile(title: Word.copy,
                               systemImage: "doc.on.doc",
                               role: .plain) {
                        UIPasteboard.general.string = word
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }

                    ActionTile(title: Word.speak,
                               systemImage: isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill",
                               role: .plain) {
                        speak()
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if synthDelegate == nil {
                let d = SynthDelegate(isSpeaking: $isSpeaking)
                synth.delegate = d
                synthDelegate = d
            }
        }
        .onDisappear {
            synth.stopSpeaking(at: .immediate)
        }
        // Sheets for lookups
        .sheet(isPresented: $showSafari) {
            if let url = lookupURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            } else {
                Text(Word.Lookup.error).padding()
            }
        }
        .sheet(isPresented: $showAppleDict) {
            AppleDictionaryView(term: word)
        }
        // Bottom-sheet behavior
        .presentationDetents([.height(260), .medium, .large])
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        .presentationDragIndicator(.visible)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Spacer()
            Text(word)
                .font(.title2.bold())

            HStack(spacing: 8) {
                if let code = languageCode, !code.isEmpty {
                    Label(code.uppercased(), systemImage: "globe")
                        .labelStyle(.titleAndIcon)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.secondary.opacity(0.15)))
                }
            }
        }
    }

    // MARK: - TTS

    private func speak() {
        if synth.isSpeaking {
            synth.stopSpeaking(at: .immediate)
            isSpeaking = false
            return
        }
        let utterance = AVSpeechUtterance(string: word)
        if let code = languageCode, let voice = AVSpeechSynthesisVoice(language: code) {
            utterance.voice = voice
        }
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0

        isSpeaking = true
        synth.speak(utterance)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

}

// MARK: - Tile Button

private enum TileRole { case accent, plain }

private struct ActionTile: View {
    let title: LocalizedStringResource
    let systemImage: String
    let role: TileRole
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title3)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Theme.paper.accent.opacity(0.15))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - AVSpeechSynthesizer Delegate Wrapper

final class SynthDelegate: NSObject, AVSpeechSynthesizerDelegate {
    @Binding var isSpeaking: Bool
    init(isSpeaking: Binding<Bool>) { self._isSpeaking = isSpeaking }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

// MARK: - Preview

#Preview("WordSheet – EN") {
    WordSheet(word: "serendipity", languageCode: "en")
        .preferredColorScheme(.light)
}

#Preview("WordSheet – RTL") {
    WordSheet(word: "كِتاب", languageCode: "ar")
        .preferredColorScheme(.dark)
}
