//
//  ContentView.swift
//  warGame
//
//  Created by Richard Urunuela on 13/10/2020.
//

import SwiftUI
struct Card:View {
    @ObservedObject var game:Game
    var isJ1 = false
    var cardName:String = ""
    var delayValue = 0.0
    var handler : (() -> ())?
    @Binding var cardisHidden :Bool
    @Binding var secondCardisHidden :Bool
//game.listeCards[isJ1 ? game.posJ1 : game.posJ1]
    var body: some View {
        Image(cardisHidden ? "back": (isJ1 ? game.cardJ1 : game.cardJ2))            .rotation3DEffect(self.cardisHidden ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
            .animation(Animation.easeInOut.delay(delayValue)).onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                guard self.cardisHidden else {
                    return
                }
            cardisHidden.toggle()
            
            
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.6 ){
                    print(" OK ")
                    self.secondCardisHidden = false
                    if let handler = handler {
                        handler()
                    }
                    
                }
        })
    }
}

class Game:ObservableObject {


    let order = "2345679TJQKA"
    var listeCards = ["2H","3H","4H","5H","6H","7H","8H"]
    
    func incPos(){
        
            
            print(self.posJ1)
            self.posJ1 += 1
        
    }
    var cardJ1:String{
        get{
            let res = self.listeCards[posJ1]
            print(posJ1)
            return res
        }
    }
    var cardJ2:String{
        get{
            return self.listeCards[self.listeCards.count - posJ1 - 1]
        }
    }
    @Published var posJ1:Int = 0
   
    
    init(){
    
        self.listeCards = listeCards.shuffled()
    }
    
}

struct Board: View {
    @State var cardOneHidden = true
    @State var cardtwoHidden = true
    var game = Game()
    var body: some View {
        
        HStack(){
            
            Card(game:game ,isJ1:true,
                 handler :{
                     
                     DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1 ) {
                        DispatchQueue.main.async {
                         game.incPos()
                         cardOneHidden = true
                         cardtwoHidden = true
                        }
                     }
                 },cardisHidden: self.$cardOneHidden, secondCardisHidden: self.$cardtwoHidden)
                
            
            Card(game:game,  cardisHidden: self.$cardtwoHidden, secondCardisHidden: self.$cardtwoHidden
            )
            
            
                
            
           
            
        }
        
    }
}


struct ContentView: View {
    var body: some View {
        VStack(){
            
            Image("logo_min").resizable().frame(width: 60, height: 60, alignment: .center).aspectRatio(contentMode: .fit)
            Text(" WAR ").font(.custom("RulerGold", size: 48))
            Spacer().frame(width:10 , height: 20, alignment: .center)
            
                Board()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
