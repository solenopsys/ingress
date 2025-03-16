const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    // Определяем все зависимости
    const http_mod = b.dependency("httpuring", .{}).artifact("httpuring");

    const udp_mod = b.dependency("udp_uring", .{}).artifact("udp_uring");

    const rediszig_mod = b.dependency("redis", .{}).artifact("redis");
    const pico_mod = b.dependency("picozig", .{}).artifact("picozig");

    const exe = b.addExecutable(.{
        .name = "ingress",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Подключаем модули к корневому модулю
    exe.root_module.addImport("httpserver", http_mod.root_module);
    exe.root_module.addImport("udp", udp_mod.root_module);
    exe.root_module.addImport("redis", rediszig_mod.root_module);
    exe.root_module.addImport("picozig", pico_mod.root_module);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run ingress");
    run_step.dependOn(&run_cmd.step);
}
