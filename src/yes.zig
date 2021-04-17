// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Zuyoutoki
// This file is part of [zig-utils](https://github.com/Zuyoutoki/zig-utils/),
// which is MIT licensed. The MIT license requires this copyright notice to be
// included in all copies and substantial portions of the software.
const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len > 1) {
        while (true) {
            for (args[1..]) |arg| {
                _ = try stdout.write(arg);
                _ = try stdout.write(" ");
            }
            _ = try stdout.write("\n");
        }
    } else {
        while (true) {
            _ = try stdout.print("y\n", .{});
        }
    }
    return;
}
