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

    const exe_touch = b.addExecutable("touch", "src/touch.zig");
    exe_touch.setTarget(target);
    exe_touch.setBuildMode(mode);
    exe_touch.install();
}
