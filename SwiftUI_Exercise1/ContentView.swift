//
//  ContentView.swift
//  ThinkingInSwiftUI
//
//  Created by 이재현 on 2021/03/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    
    var counter = State(initialValue: 0)
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.contents) { content in
                        NavigationLink(destination: photoView(content)) { Text(content.author)
                                .padding()
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadData()
            }
            
        }
    }
    
    func photoView(_ content: ContentViewModel.Content) -> some View {
        PhotoView(url: URL(string: content.download_url)!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
