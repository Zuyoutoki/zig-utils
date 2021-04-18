// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Zuyoutoki
// This file is part of [zig-utils](https://github.com/Zuyoutoki/zig-utils/),
// which is MIT licensed. The MIT license requires this copyright notice to be
// included in all copies and substantial portions of the software.
const std = @import("std");
const allocator = std.heap.page_allocator;

const usage =
    \\Usage: touch [options] <file...>
    \\
    \\Options:
    \\  -h, --help          Print this help and exit
    \\  -a                  Change only the access time
    \\  -c, --no-create     Do not create any file
    \\  -m                  Change only the modification time
    \\
;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();
    const all_args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, all_args);

    var no_create: bool = false;
    var atime_only: bool = false;
    var mtime_only: bool = false;

    const args = all_args[1..];
    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.startsWith(u8, arg, "-")) {
            if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
                _ = try stdout.print("{s}", .{usage});
                return;
            } else if (std.mem.eql(u8, arg, "-a")) {
                if (mtime_only) {
                    _ = try stderr.print("error: -a and -m cannot be used at the same time\n", .{});
                    return;
                }
                atime_only = true;
            } else if (std.mem.eql(u8, arg, "-c") or std.mem.eql(u8, arg, "--no-create")) {
                no_create = true;
            } else if (std.mem.eql(u8, arg, "-m")) {
                if (atime_only) {
                    _ = try stderr.print("error: -a and -m cannot be used at the same time\n", .{});
                    return;
                }
                mtime_only = true;
            } else {
                _ = try stderr.print("error: Unknown option: {s}\n", .{arg});
                return;
            }
        } else break;
    }

    if (args.len == i) {
        try stderr.print("{s}", .{usage});
        return;
    }
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        var f_path = try std.fs.path.resolve(allocator, &[_][]const u8{arg});
        var cwd = std.fs.cwd();
        var f_file: std.fs.File = undefined;

        if (no_create) {
            f_file = cwd.openFile(f_path, .{}) catch |e| switch (e) {
                error.PathAlreadyExists => {
                    try stderr.print("error: PathAlreadyExists for '{s}'\n", .{arg});
                    return;
                },
                error.FileNotFound => {
                    try stderr.print("error: FileNotFound for '{s}'\n", .{arg});
                    return;
                },
                error.AccessDenied => {
                    try stderr.print("error: AccessDenied for '{s}'\n", .{arg});
                    return;
                },
                else => return e,
            };
        } else {
            f_file = cwd.createFile(f_path, .{ .truncate = false }) catch |e| switch (e) {
                error.FileNotFound => {
                    try stderr.print("error: FileNotFound for '{s}'\n", .{arg});
                    return;
                },
                error.AccessDenied => {
                    try stderr.print("error: AccessDenied for '{s}'\n", .{arg});
                    return;
                },
                else => return e,
            };
        }
        defer f_file.close();

        var cur_time = std.time.nanoTimestamp();
        var f_stat = try f_file.stat();
        if (atime_only) {
            try f_file.updateTimes(cur_time, f_stat.mtime);
        } else if (mtime_only) {
            try f_file.updateTimes(f_stat.atime, cur_time);
        } else {
            try f_file.updateTimes(cur_time, cur_time);
        }
    }
}
