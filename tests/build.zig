const std = @import("std");

const here = "tests/";

const tests = [_][]const []const u8{ &[_][]const u8{
    here ++ "property/tst_property.cpp",
}, &[_][]const u8{
    here ++ "node/tst_node.cpp",
}, &[_][]const u8{
    here ++ "binding/tst_binding.cpp",
}, &[_][]const u8{
    here ++ "signal/tst_signal.cpp",
}, &[_][]const u8{
    here ++ "utils/tst_gen_index_array.cpp",
    here ++ "utils/tst_get_arity.cpp",
    here ++ "utils/tst_utils_main.cpp",
} };

pub fn build(
    b: *std.Build,
    target: std.zig.CrossTarget,
    optimize: std.builtin.Mode,
) void {
    const run_tests_step = b.step("tests", "run tests");

    for (tests) |sources| {
        std.debug.assert(sources.len > 0);
        const exe = b.addExecutable(.{
            .target = target,
            .optimize = optimize,
            .name = std.fs.path.stem(sources[0]),
        });
        exe.linkLibC();
        exe.linkLibCpp();
        exe.addIncludePath(.{ .path = "tests/doctest" });
        exe.addIncludePath(.{ .path = std.fs.path.join(b.allocator, &.{ b.install_prefix, "include" }) catch @panic("OOM") });
        exe.step.dependOn(b.getInstallStep());
        exe.addCSourceFiles(sources, &.{
            "-std=c++17",
            // TODO: probably get rid of UB
            "-fno-sanitize=undefined",
        });
        const run_test = b.addRunArtifact(exe);
        run_tests_step.dependOn(&run_test.step);
    }
}
