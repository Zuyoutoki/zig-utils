// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Zuyoutoki
// This file is part of [zig-utils](https://github.com/Zuyoutoki/zig-utils/),
// which is MIT licensed. The MIT license requires this copyright notice to be
// included in all copies and substantial portions of the software.
const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var buffer: [64]u8 = undefined;
    const hostname = try std.os.gethostname(&buffer);
    _ = try stdout.print("{s}\n", .{hostname});
}
