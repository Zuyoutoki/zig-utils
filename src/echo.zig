// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Zuyoutoki
// This file is part of [zig-utils](https://github.com/Zuyoutoki/zig-utils/),
// which is MIT licensed. The MIT license requires this copyright notice to be
// included in all copies and substantial portions of the software.
const std = @import("std");
const allocator = std.heap.page_allocator;

const usage =
    \\Usage: echo [options] [string...]
    \\
    \\Options:
    \\  -h, --help      Print this help and exit
    \\  -n              Do not output a trailing newline
    \\
;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();
    const all_args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, all_args);

    var trailing_newline: bool = true;

    const args = all_args[1..];
    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.startsWith(u8, arg, "-")) {
            if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
                _ = try stdout.print("{s}", .{usage});
                return;
            } else if (std.mem.eql(u8, arg, "-n")) {
                trailing_newline = false;
            } else {
                _ = try stderr.print("error: Unknown option: {s}\n", .{arg});
                return;
            }
        } else break;
    }

    while (i < args.len) : (i += 1) {
        _ = try stdout.write(args[i]);
        if (i + 1 < args.len) _ = try stdout.write(" ");
    }
    if (trailing_newline) _ = try stdout.write("\n");
    return;
}
