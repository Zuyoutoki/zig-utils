// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Zuyoutoki
// This file is part of [zig-utils](https://github.com/Zuyoutoki/zig-utils/),
// which is MIT license. The MIT license requires this copyright notice to be
// included in all copies and substancial portions of the software.
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe_echo = b.addExecutable("echo", "src/echo.zig");
    exe_echo.setTarget(target);
    exe_echo.setBuildMode(mode);
    exe_echo.install();

    const exe_false = b.addExecutable("false", "src/false.zig");
    exe_false.setTarget(target);
    exe_false.setBuildMode(mode);
    exe_false.install();

    const exe_hostname = b.addExecutable("hostname", "src/hostname.zig");
    exe_hostname.setTarget(target);
    exe_hostname.setBuildMode(mode);
    exe_hostname.install();

    const exe_touch = b.addExecutable("touch", "src/touch.zig");
    exe_touch.setTarget(target);
    exe_touch.setBuildMode(mode);
    exe_touch.install();

    const exe_true = b.addExecutable("true", "src/true.zig");
    exe_true.setTarget(target);
    exe_true.setBuildMode(mode);
    exe_true.install();

    const exe_yes = b.addExecutable("yes", "src/yes.zig");
    exe_yes.setTarget(target);
    exe_yes.setBuildMode(mode);
    exe_yes.install();
}
