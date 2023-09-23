const std = @import("std");

const src = "src/kdbindings";

const headers = &[_][]const u8{
    "binding.h",
    "binding_evaluator.h",
    "genindex_array.h",
    "make_node.h",
    "node.h",
    "node_functions.h",
    "node_operators.h",
    "property.h",
    "property_updater.h",
    "signal.h",
    "utils.h",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var inst_step = b.getInstallStep();
    for (headers) |header| {
        const h_step = b.addInstallHeaderFile(
            std.fs.path.join(b.allocator, &.{ "src", "kdbindings", header }) catch @panic("OOM"),
            std.fs.path.join(b.allocator, &.{ "kdbindings", header }) catch @panic("OOM"),
        );
        inst_step.dependOn(&h_step.step);
    }

    @import("tests/build.zig").build(b, target, optimize);
}
