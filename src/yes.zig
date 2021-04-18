// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Zuyoutoki
// This file is part of [zig-utils](https://github.com/Zuyoutoki/zig-utils/),
// which is MIT licensed. The MIT license requires this copyright notice to be
// included in all copies and substantial portions of the software.
const std = @import("std");
const allocator = std.heap.page_allocator;

const usage =
    \\Usage: yes [string...]
    \\       yes <option>
    \\
    \\Options:
    \\  -h, --help      Print this help and exit
    \\
;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();
    const all_args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, all_args);

    const args = all_args[1..];
    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.startsWith(u8, arg, "-")) {
            if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
                _ = try stdout.print("{s}", .{usage});
                return;
            } else {
                _ = try stderr.print("error: Unknown option", .{});
                return;
            }
        }
    }

    while (args.len != 0) {
        for (args) |arg| {
            _ = try stdout.write(arg);
            _ = try stdout.write(" ");
        }
        _ = try stdout.write("\n");
    }
    while (true) {
        _ = try stdout.print("y\n", .{});
    }
    return;
}
