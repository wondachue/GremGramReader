//
//  ReaderView.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//

import SwiftUI
import SwiftData

struct ReaderView: View {
    @Bindable var book: Book

    // UI state
    @State private var selectedWord: String?
    @State private var showWordSheet = false
    @State private var pageIndex: Int = 0
    @State private var theme: Theme = .paper
    @State private var fontSize: CGFloat = 18

    private var lastPage: Int { max(book.pages.count - 1, 0) }
    private var firstPage: Int { 0 }
    private var isRTL: Bool { book.readingDirection == .rightToLeft }

    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Reading surface
                TabView(selection: $pageIndex) {
                    ForEach(Array(book.pages.enumerated()), id: \.offset) { idx, page in
                        SelectableTextView(
                            text: page,
                            font: .systemFont(ofSize: fontSize, weight: .regular),
                            textColor: UIColor(theme.textColor),
                            onWordTap: { word in
                                selectedWord = word
                                showWordSheet = true
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(theme.pageFill)
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .tag(idx)
                    }

                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Bottom controls
                footer
            }
        }
        .navigationTitle(book.title)
        .toolbarBackground(theme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(theme == .night ? .dark : .light, for: .navigationBar)
        .tint(theme.accent)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showWordSheet) {
            WordSheet(word: selectedWord ?? "", languageCode: book.language)
        }
    }

    private var footer: some View {
        HStack {
            Button(action: isRTL ? nextPage : prevPage) {
                Image(systemName: "chevron.left")
                    .labelStyle(.iconOnly)
                    .font(.title3)
            }
            .disabled(isRTL ? pageIndex >= lastPage : pageIndex == firstPage)
            .accessibility(label: isRTL ? Text(Reader.Accessibility.continueButton) : Text(Reader.Accessibility.previousButton))

            Spacer()

            Text(Reader.pageCount(pageIndex + 1, totalPages: book.pages.count))
                .font(.footnote.monospacedDigit())
                .foregroundStyle(theme.textColor.opacity(0.7))

            Spacer()

            Button(action: isRTL ? prevPage : nextPage) {
                Image(systemName: "chevron.right")
                    .labelStyle(.iconOnly)
                    .font(.title3)
            }
            .disabled(isRTL ? pageIndex == firstPage : pageIndex >= lastPage)
            .accessibility(label: isRTL ? Text(Reader.Accessibility.previousButton) : Text(Reader.Accessibility.continueButton))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    // MARK: Actions

    private func nextPage() {
        guard pageIndex < lastPage else { return }
        withAnimation(.easeInOut(duration: 0.15)) { pageIndex += 1 }
    }

    private func prevPage() {
        guard pageIndex > firstPage else { return }
        withAnimation(.easeInOut(duration: 0.15)) { pageIndex -= 1 }
    }
}

// MARK: - Preview

#Preview("Reader – Light") {
    let samplePages =
        """
        吾輩わがはいは猫である。名前はまだ無い。
        　どこで生れたかとんと見当けんとうがつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪どうあくな種族であったそうだ。この書生というのは時々我々を捕つかまえて煮にて食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌てのひらに載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。掌の上で少し落ちついて書生の顔を見たのがいわゆる人間というものの見始みはじめであろう。この時妙なものだと思った感じが今でも残っている。第一毛をもって装飾されべきはずの顔がつるつるしてまるで薬缶やかんだ。その後ご猫にもだいぶ逢あったがこんな片輪かたわには一度も出会でくわした事がない。のみならず顔の真中があまりに突起している。そうしてその穴の中から時々ぷうぷうと煙けむりを吹く。どうも咽むせぽくて実に弱った。これが人間の飲む煙草たばこというものである事はようやくこの頃知った。
        この書生の掌の裏うちでしばらくはよい心持に坐っておったが、しばらくすると非常な速力で運転し始めた。書生が動くのか自分だけが動くのか分らないが無暗むやみに眼が廻る。胸が悪くなる。到底とうてい助からないと思っていると、どさりと音がして眼から火が出た。それまでは記憶しているがあとは何の事やらいくら考え出そうとしても分らない。
        　ふと気が付いて見ると書生はいない。たくさんおった兄弟が一疋ぴきも見えぬ。肝心かんじんの母親さえ姿を隠してしまった。その上今いままでの所とは違って無暗むやみに明るい。眼を明いていられぬくらいだ。はてな何でも容子ようすがおかしいと、のそのそ這はい出して見ると非常に痛い。吾輩は藁わらの上から急に笹原の中へ棄てられたのである。
        """
    let b = Book(
        timestamp: Date(),
        title: "吾輩は猫である",
        text: samplePages,
        language: "ja"
    )
    return ReaderView(book: b)
}
