//
//  File.swift
//  
//
//  Created by Mikhail on 12.12.2022.
//

import Vapor
import telegram_vapor_bot

final class DefaultBotHandlers {

    static func addHandlers(app: Vapor.Application, bot: TGBotPrtcl) {
        defaultHandler(app: app, bot: bot)
        commandPingHandler(app: app, bot: bot)
        commandShowButtonsHandler(app: app, bot: bot)
        buttonsActionHandler(app: app, bot: bot)
    }

    /// add handler for all messages unless command "/ping"
    private static func defaultHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        
        
        let handler = TGMessageHandler(filters: (.all && !.command.names(["/ping"]))) { update, bot in
            let messageSend = update.message?.text
            //361137464
            print(" \(update.message!.chat.id)" + " " + "\(update.message!.chat.username)")
            
            let params: TGSendMessageParams =  .init(chatId: .chat(-1001809992271), text: messageSend ?? "")
                //.chat(update.message!.chat.id), text: "Success")
    
           
            try bot.sendMessage(params: params)
        }
        bot.connection.dispatcher.add(handler)
        
//        let handler2 = TGMessageHandler(filters: (.command.names(["/oops"]))) { update, bot in
//            let delet = TGDeleteMessageParams(chatId: .chat(update.message?.chat.id ?? 121313141244), messageId: update.message!.messageId)
//            //params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "Comand OK!")
//            try bot.deleteMessage(params: delet)
//        }
//        bot.connection.dispatcher.add(handler2)
        
        
        
    }

    /// add handler for command "/ping"
    private static func commandPingHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/ping"]) { update, bot in
            try update.message?.reply(text: "pong", bot: bot)
        }
        bot.connection.dispatcher.add(handler)
    }
    
    /// add handler for command "/show_buttons" - show message with buttons
    private static func commandShowButtonsHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/show_buttons"]) { update, bot in
            guard let userId = update.message?.from?.id else { fatalError("user id not found") }
            let buttons: [[TGInlineKeyboardButton]] = [
                [.init(text: "Button 1", callbackData: "press 1"), .init(text: "Button 2", callbackData: "press 2")]
            ]
            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
            let params: TGSendMessageParams = .init(chatId: .chat(userId),
                                                    text: "Keyboard activ",
                                                    replyMarkup: .inlineKeyboardMarkup(keyboard))
            try bot.sendMessage(params: params)
        }
        bot.connection.dispatcher.add(handler)
    }
    
    /// add two handlers for callbacks buttons
    private static func buttonsActionHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCallbackQueryHandler(pattern: "press 1") { update, bot in
            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                                            text: update.callbackQuery?.data  ?? "data not exist",
                                                            showAlert: nil,
                                                            url: nil,
                                                            cacheTime: nil)
            try bot.answerCallbackQuery(params: params)
        }

        let handler2 = TGCallbackQueryHandler(pattern: "press 2") { update, bot in
            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                                            text: update.callbackQuery?.data  ?? "data not exist",
                                                            showAlert: nil,
                                                            url: nil,
                                                            cacheTime: nil)
            try bot.answerCallbackQuery(params: params)
        }

        bot.connection.dispatcher.add(handler)
        bot.connection.dispatcher.add(handler2)
    }
}
