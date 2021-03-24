//
//  ContentViewModel.swift
//  ThinkingInSwiftUI
//
//  Created by 이재현 on 2021/03/24.
//

import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    
    @Published var contents: [Content] = []
    
    struct Content: Codable, Identifiable {
        var id: String
        var author: String
        var width: Int
        var height: Int
        var url: String
        var download_url: String
    }
    
    private let url = URL(string: "https://picsum.photos/v2/list")!
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    func loadData() {
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { $0.data }
            .decode(type: [Content].self, decoder: JSONDecoder())
            .print()
            .assertNoFailure()
            .receive(on: DispatchQueue.main)
            .assign(to: \.contents, on: self)
            .store(in: &cancellables)
    }
}
