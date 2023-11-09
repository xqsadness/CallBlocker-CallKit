//
//  ListChooseView.swift
//  DefualtSource
//
//  Created by darktech4 on 12/09/2023.
//

import SwiftUI

struct ListChooseView: View {
    @State var select: Int = 0
    
    var body: some View {
        VStack{
            VStack{
                ZStack{
                    Button {
                        withAnimation {
                            select = 0
                        }
                    } label: {
                        HStack{
                            VStack{
                                Text("$ 39,99 yearly")
                                    .font(Font.medium(size: 17))
                                    .foregroundColor(Color.text)
                                
                                Text("Best Choice")
                                    .font(Font.medium(size: 12))
                                    .foregroundColor(Color.text)
                                    .padding(.trailing, 40)
                                    .opacity(0.6)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("81% OFF")
                                .font(Font.medium(size: 13))
                                .foregroundColor(Color.text)
                                .padding(8)
                                .background(Color(hex: "#FFB930"))
                                .cornerRadius(56)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .frame(height: 26)
                        }
                        .padding(25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.background2)
                        .frame(height: 64)
                        .cornerRadius(34)
                    }
                    if select == 0{
                        RoundedRectangle(cornerRadius: 34)
                            .stroke(Color.yellow, lineWidth: 1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 64)
                    }
                }
                
                ZStack{
                    Button {
                        withAnimation {
                            select = 1
                        }
                    } label: {
                        HStack{
                            VStack{
                                Text("$ 9,99 monthly")
                                    .font(Font.medium(size: 17))
                                    .foregroundColor(Color.text)
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("42% OFF")
                                .font(Font.medium(size: 13))
                                .foregroundColor(Color.text)
                                .padding(8)
                                .background(Color(hex: "#FFB930"))
                                .cornerRadius(56)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .frame(height: 26)
                        }
                        .padding(25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 64)
                        .background(Color.background2)
                        .cornerRadius(34)
                    }
                    if select == 1{
                        RoundedRectangle(cornerRadius: 34)
                            .stroke(Color.yellow, lineWidth: 1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 64)
                    }
                }
                
                ZStack{
                    Button {
                        withAnimation {
                            select = 2
                        }
                    } label: {
                        HStack{
                            VStack{
                                Text("$ 3,99 weekly")
                                    .font(Font.medium(size: 17))
                                    .foregroundColor(Color.text)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 64)
                        .background{Color.background2}
                        .cornerRadius(34)
                    }
                    if select == 2{
                        RoundedRectangle(cornerRadius: 34)
                            .stroke(Color.yellow, lineWidth: 1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 64)
                    }
                }
                
                Button {
                    
                } label: {
                    HStack{
                        VStack{
                            Text("Try 3 Days Free Now")
                                .font(Font.bold(size: 17))
                                .foregroundColor(Color.text)
                                .frame(minWidth: 200)
                            
                            Text("$ 39,99 Yearly After Trial Ends")
                                .font(Font.medium(size: 12))
                                .foregroundColor(Color.text)
                                .frame(minWidth: 220)
                                .opacity(0.6)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 76)
                    .background(Color(hex: "FFB930"))
                    .cornerRadius(80)
                }
            } .padding(.bottom,20)
        }
        .padding(2)
    }
}
