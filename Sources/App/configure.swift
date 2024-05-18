import Redis
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let redisConfiguration = try RedisConfiguration(hostname: Environment.get("REDIS_HOST") ?? "localhost")
    app.redis.configuration = redisConfiguration

    // register routes
    try routes(app)

    // Finish the configuration
    try await app.asyncBoot()

    app.logger.info("We are about to ping redis")

    // We need to check or update something in redis before we can accept the requests
    // Basically, something similar to auto migrations with Fluent
    let pong = try await app.redis.ping().get()

    app.logger.info("Ping returned: \(pong)")
}
