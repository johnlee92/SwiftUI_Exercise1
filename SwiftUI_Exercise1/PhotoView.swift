//
//  PhotoView.swift
//  ThinkingInSwiftUI
//
//  Created by 이재현 on 2021/03/24.
//

import SwiftUI
import Combine

struct PhotoView: View {
    
    final class ImageLoader: ObservableObject {
        
        @Published var image: UIImage?
        
        let url: URL
        
        private var cancellable: AnyCancellable?
        
        init(url: URL) {
            self.url = url
        }
        
        func load() {
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink {
                    [weak self] in self?.image = $0
                }
        }
            
        func cancel() {
            cancellable?.cancel()
        }
    }
    
    @StateObject var imageLoader: ImageLoader
    
    let url: URL
    
    init(url: URL) {
        self.url = url
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            
            } else {
                ProgressView()
            }
        }.onAppear {
            imageLoader.load()
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(url: URL(string: "https://picsum.com/200")!)
    }
}
