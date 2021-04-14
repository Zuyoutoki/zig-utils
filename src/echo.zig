// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Zuyoutoki
// This file is part of [zig-utils](https://github.com/Zuyoutoki/zig-utils/),
// which is MIT license. The MIT license requires this copyright notice to be
// included in all copies and substancial portions of the software.
const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    for (args[1..]) |arg| {
        _ = try stdout.write(arg);
        _ = try stdout.write(" ");
    }
    _ = try stdout.write("\n");
    return;
}
