//
//  MeditationTimerViewModel.swift
//  MeditationTimerCombine
//
//  Created by 仲優樹 on 2025/06/26.
//

import Foundation
import Combine

class MeditationTimerViewModel: ObservableObject {
    @Published var remainingSeconds: Int = 10
    @Published var quote: String?
    @Published var isRunning: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func startTimer() {
        guard !isRunning else { return }
        
        isRunning = true
        self.remainingSeconds = 10
        self.quote = nil
        
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .scan(10) { seconds, _ in
                max(seconds - 1, 0)
            }
            .handleEvents(receiveOutput: { [weak self] value in
                self?.remainingSeconds = value
            })
            .prefix(while: { $0 > 0 })
        
        let subscription = timerPublisher
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetchQuote()
            }, receiveValue: { _ in })
        
        subscription.store(in: &cancellables)
    }
    
    private func fetchQuote() {
        let quotePublisher = Deferred {
            Just("「今、この瞬間に心を集中させなさい。」 - 仏陀")
                .delay(for: .seconds(1), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        
        let quoteSubscription = quotePublisher
            .sink { [weak self] value in
                self?.quote = value
                self?.isRunning = false
            }
        
        quoteSubscription.store(in: &cancellables)
    }
}
