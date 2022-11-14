const std = @import("std");

const fs = std.fs;

const raylibSrc = "src/raylib/raylib/src/";
const bindingSrc = "src/raylib/";

const APP_NAME = "tiles";

pub fn build(b: *std.build.Builder) !void {

    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    switch (target.getOsTag()) {
        else => {
            std.log.info("building for desktop\n", .{});
            const exe = b.addExecutable(APP_NAME, "src/main.zig");
            exe.setTarget(target);
            exe.setBuildMode(mode);
            
            const rayBuild = @import("src/raylib/raylib/src/build.zig");
            const raylib = rayBuild.addRaylib(b, target);
            exe.linkLibrary(raylib);
            exe.addIncludePath(raylibSrc);
            exe.addIncludePath(raylibSrc ++ "extras/");
            exe.addIncludePath(bindingSrc);
            exe.addCSourceFile(bindingSrc ++ "marshal.c", &.{});

            switch (raylib.target.getOsTag()) {
                //dunno why but macos target needs sometimes 2 tries to build
                .macos => {
                    exe.linkFramework("Foundation");
                    exe.linkFramework("Cocoa");
                    exe.linkFramework("OpenGL");
                    exe.linkFramework("CoreAudio");
                    exe.linkFramework("CoreVideo");
                    exe.linkFramework("IOKit");
                },
                .linux => {
                    exe.addLibraryPath("/usr/lib64/");
                    exe.linkSystemLibrary("GL");
                    exe.linkSystemLibrary("rt");
                    exe.linkSystemLibrary("dl");
                    exe.linkSystemLibrary("m");
                    exe.linkSystemLibrary("X11");
                },
                else => {
                    exe.linkSystemLibrary("opengl32");
                    exe.linkSystemLibrary("gdi32");
                    exe.linkSystemLibrary("winmm");
                },
            }

            exe.linkLibC();
            exe.install();

            const run_cmd = exe.run();
            run_cmd.step.dependOn(b.getInstallStep());
            if (b.args) |args| {
                run_cmd.addArgs(args);
            }

            const run_step = b.step("run", "Run the app");
            run_step.dependOn(&run_cmd.step);
        },
    }
}