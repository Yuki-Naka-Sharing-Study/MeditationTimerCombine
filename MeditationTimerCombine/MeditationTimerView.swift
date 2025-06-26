//
//  MeditationTimerView.swift
//  MeditationTimerCombine
//
//  Created by 仲優樹 on 2025/06/26.
//

import SwiftUI

struct MeditationTimerView: View {
    @StateObject private var viewModel = MeditationTimerViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🧘‍♀️ 瞑想タイマー")
                .font(.largeTitle)
            
            Text("\(viewModel.remainingSeconds) 秒")
                .font(.title)
                .foregroundColor(.blue)
            
            if let quote = viewModel.quote {
                Text("✨ 名言 ✨")
                    .font(.headline)
                Text(quote)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Button(action: {
                viewModel.startTimer()
            }) {
                Text("スタート")
                    .font(.title2)
                    .padding()
                    .background(viewModel.isRunning ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(viewModel.isRunning)
        }
        .padding()
    }
}
