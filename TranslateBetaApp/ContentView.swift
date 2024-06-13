//
//  ContentView.swift
//  TranslateBetaApp
//
//  Created by M on 14/06/2024.
//

import SwiftUI
import Translation

struct ContentView: View {
    
    var sourceText: String
    @State private var targetText: String?
    @State private var configuration: TranslationSession.Configuration?
    let translationBatch: [TranslationSession.Request] = [
        TranslationSession.Request(sourceText: "Hello you are my world", clientIdentifier: "000"),
        TranslationSession.Request(sourceText: "I can see through my eyes", clientIdentifier: "001"),
        TranslationSession.Request(sourceText: "We need to work hard", clientIdentifier: "002")
    ]
    
    var body: some View {
        VStack {
            Text(targetText ?? sourceText)
                .translationTask(configuration) { session in
                    do {
                        for try await response in session.translate(batch: translationBatch) {
                            print(response.targetText, response.clientIdentifier ?? "")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            
            Button {
                if configuration == nil {
                    configuration = TranslationSession.Configuration()
                    return
                }
                
                configuration?.invalidate()
            } label: {
                Text("Translate")
            }

        }
        .padding()
    }
}

struct MyTranslationView: View {
    
    var sourceText: String
    @State private var targetText: String?
    
    var body: some View {
        VStack {
            Text(targetText ?? sourceText)
                .translationTask { session in
                    do {
                        let response = try await session.translate(sourceText)
                        targetText = response.targetText
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        }
        .padding()
    }
}
