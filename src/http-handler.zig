const picozig = @import("picozig");
const std = @import("std");
const generateHttpResponse = picozig.generateHttpResponse;
const HttpResponse = picozig.HttpResponse;
const HttpRequest = picozig.HttpRequest;

const http = @import("httpserver");

const HttpProcessor = http.HttpProcessor;
const ProtocolHandler = http.ProtocolHandler;

const HandlerError = http.HandlerError;

// http Error

const Root = struct {
    pub fn handle(request: HttpRequest, allocator: std.mem.Allocator) ![]const u8 {
        _ = request;
        return try generateHttpResponse(
            allocator,
            200,
            "text/plain",
            "Under construction!",
        );
    }
    pub fn deinit() void {}
    pub fn addHandler(handler: ProtocolHandler) void {
        _ = handler;
    }
    pub fn init(allocator: std.mem.Allocator) Root {
        _ = allocator;
        return Root{};
    }
};

const DHT = struct {
    pub fn handle(request: HttpRequest, allocator: std.mem.Allocator) ![]const u8 {
        const path = request.params.path;
        std.debug.print("Path: {s}\n", .{path}); // Исправлено: добавлен path в форматные аргументы
        // split

        var items = std.mem.splitScalar(u8, path, '/');
        _ = items.next().?;
        _ = items.next().?;
        const subpath = items.next().?;

        std.debug.print("Subpathy: {s}\n", .{subpath}); // Исправлено: добавлен subpath в форматные аргументы

        return try generateHttpResponse(
            allocator,
            200,
            "text/plain",
            "DHT! ",
        );
    }
    pub fn deinit() void {}
    pub fn addHandler(handler: ProtocolHandler) void {
        _ = handler;
    }
    pub fn init(allocator: std.mem.Allocator) DHT {
        _ = allocator;
        return DHT{};
    }
};
pub fn httpHandler(allocator: std.mem.Allocator, data: []const u8) HandlerError![]const u8 {
    // std.debug.print("Data: {s}\n", .{data});
    var headers: [32]picozig.Header = undefined;
    const httpParams = picozig.HttpParams{
        .method = "",
        .path = "",
        .minor_version = 0,
        .num_headers = 0,
        .bytes_read = 0,
    };

    // Create HttpRequest structure
    var httpRequest = picozig.HttpRequest{
        .params = httpParams,
        .headers = &headers,
        .body = "",
    };
    _ = picozig.parseRequest(data, &httpRequest);

    var processor = HttpProcessor.init(allocator);
    defer processor.deinit();

    try processor.addHandler(.{
        .pathPrefix = "/dht/",
        .method = "GET",
        .handleFn = DHT.handle,
    });
    try processor.addHandler(.{
        .pathPrefix = "/",
        .method = "GET",
        .handleFn = Root.handle,
    });

    const response = processor.processRequest(httpRequest);

    return response;
}
