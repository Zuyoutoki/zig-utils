// SPDX-License-Identifier: MIT
// Copyright (c) 2021 Zuyoutoki
// This file is part of [zig-utils](https://github.com/Zuyoutoki/zig-utils/),
// which is MIT license. The MIT license requires this copyright notice to be
// included in all copies and substancial portions of the software.
const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const stderr = std.io.getStdErr().writer();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stderr.print("usage: touch FILE...\n", .{});
        return;
    }
    for (args[1..]) |arg| {
        var f_path = try std.fs.path.resolve(allocator, &[_][]const u8{arg});
        var cwd = std.fs.cwd();

        var f_file = cwd.createFile(f_path, .{ .truncate = false }) catch |e| switch (e) {
            error.SharingViolation => {
                try stderr.print("error: SharingViolation for '{s}'\n", .{arg});
                return;
            },
            error.PathAlreadyExists => {
                try stderr.print("error: PathAlreadyExists for '{s}'\n", .{arg});
                return;
            },
            error.FileNotFound => {
                try stderr.print("error: FileNotFound for '{s}' \n", .{arg});
                return;
            },
            error.AccessDenied => {
                try stderr.print("error: AccessDenied for '{s}'\n", .{arg});
                return;
            },
            error.PipeBusy => {
                try stderr.print("error: PipeBusy for '{s}'\n", .{arg});
                return;
            },
            error.NameTooLong => {
                try stderr.print("error: NameTooLong for '{s}'\n", .{arg});
                return;
            },
            error.InvalidUtf8 => {
                try stderr.print("error: InvalidUtf8 for '{s}'\n", .{arg});
                return;
            },
            error.BadPathName => {
                try stderr.print("error: BadPathName for '{s}'\n", .{arg});
                return;
            },
            error.Unexpected => {
                try stderr.print("error: Unexpected for '{s}'\n", .{arg});
                return;
            },
            error.SymLinkLoop => {
                try stderr.print("error: SymLinkLoop for '{s}'\n", .{arg});
                return;
            },
            error.ProcessFdQuotaExceeded => {
                try stderr.print("error: ProcessFdQuotaExceeded for '{s}'\n", .{arg});
                return;
            },
            error.SystemFdQuotaExceeded => {
                try stderr.print("error: SystemFdQuotaExceeded for '{s}'\n", .{arg});
                return;
            },
            error.NoDevice => {
                try stderr.print("error: NoDevice for '{s}'\n", .{arg});
                return;
            },
            error.SystemResources => {
                try stderr.print("error: SystemResources for '{s}'\n", .{arg});
                return;
            },
            error.FileTooBig => {
                try stderr.print("error: FileTooBig for '{s}'\n", .{arg});
                return;
            },
            error.IsDir => {
                try stderr.print("error: IsDir for '{s}'\n", .{arg});
                return;
            },
            error.NoSpaceLeft => {
                try stderr.print("error: NoSpaceLeft for '{s}'\n", .{arg});
                return;
            },
            error.NotDir => {
                try stderr.print("error: NotDir for '{s}'\n", .{arg});
                return;
            },
            error.DeviceBusy => {
                try stderr.print("error: DeviceBusy for '{s}'\n", .{arg});
                return;
            },
            error.FileLocksNotSupported => {
                try stderr.print("error: FileLocksNotSupported for '{s}'\n", .{arg});
                return;
            },
            error.WouldBlock => {
                try stderr.print("error: WouldBlock for '{s}'\n", .{arg});
                return;
            },
        };
        defer f_file.close();

        var cur_time = std.time.nanoTimestamp();
        try f_file.updateTimes(cur_time, cur_time);
    }
}
