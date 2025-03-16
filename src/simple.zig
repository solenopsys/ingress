const std = @import("std");
const posix = std.posix;
const log = std.debug.print;

const server_module = @import("httpuring");
const UdpIoUringServer = server_module.UdpIoUringServer;

// Пример функции обработчика сообщений
fn benchmarkMessageHandler(data: []const u8, client_addr: *const posix.sockaddr, client_addr_len: posix.socklen_t, userdata: ?*anyopaque) void {
    log("Received message: {s}\n", .{data});
    log("Client address: {any}\n", .{client_addr});
    log("Client address length: {d}\n", .{client_addr_len});
    log("Userdata: {any}\n", .{userdata});
}

pub fn main(allocator: std.mem.Allocator) !void {

    // Инициализация UDP сервера
    var server = try UdpIoUringServer.init(allocator, 8888, &benchmarkMessageHandler, null);
    defer server.deinit();
    try server.run();
}
