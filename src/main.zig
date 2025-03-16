const std = @import("std");
const Thread = std.Thread;

const http = @import("httpserver");

const DataHandler = http.DataHandler;
const httpHandler = @import("./http-handler.zig").httpHandler;

pub fn main() !void {
    const handler = DataHandler{
        .processFn = httpHandler,
    };
    http.start(handler) catch |err| {
        std.debug.print("Ошибка запуска сервера: {s}\n", .{@errorName(err)});
    };
}
