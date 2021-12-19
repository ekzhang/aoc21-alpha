const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();

    var buf: [32]u8 = undefined;
    var ans1: u32 = 0;
    var ans2: u32 = 0;
    var window = try std.BoundedArray(u32, 4).init(0);
    while (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const val = try std.fmt.parseInt(u32, input, 10);
        try window.append(val);
        if (window.len >= 2 and val > window.get(window.len - 2)) {
            ans1 += 1;
        }
        if (window.len == 4) {
            if (window.get(3) > window.get(0)) {
                ans2 += 1;
            }
            _ = window.orderedRemove(0);
        }
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{}\n{}\n", .{ ans1, ans2 });
}
