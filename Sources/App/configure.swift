import Vapor
import telegram_vapor_bot

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 80
    
    
    let tgApi: String = "5989670598:AAGC7ZLs8j4d55AaiYHwixSpCJWo54pJBbE"
    let connection: TGConnectionPrtcl = TGLongPollingConnection()
    TGBot.configure(connection: connection, botId: tgApi, vaporClient: app.client)
    try TGBot.shared.start()
    TGBot.log.logLevel = .error
    DefaultBotHandlers.addHandlers(app: app, bot: TGBot.shared)
    
    // register routes
    try routes(app)
}
