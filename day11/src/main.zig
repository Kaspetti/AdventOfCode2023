const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input_list = try get_lines("input", allocator);
    defer input_list.deinit();

    var empty_rows = std.ArrayList(usize).init(allocator);
    defer empty_rows.deinit();
    for (input_list.items, 0..) |line, row| {
        if (!contains_galaxy(line)) {
            try empty_rows.append(row);
        }
    }

    rotate_grid(input_list);

    var empty_columns = std.ArrayList(usize).init(allocator);
    for (input_list.items, 0..) |line, column| {
        if (!contains_galaxy(line)) {
            try empty_columns.append(column);
        }
    }

    rotate_grid(input_list);

    std.debug.print("Empty rows: {d}\n", .{empty_rows.items});
    std.debug.print("Empty columns: {d}\n", .{empty_columns.items});
}

fn get_lines(comptime file_name: []const u8, allocator: std.mem.Allocator) !std.ArrayList([]u8) {
    const file = try std.fs.cwd().openFile(file_name, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var input_stream = buf_reader.reader();

    var input_list = std.ArrayList([]u8).init(allocator);

    var buffer: [200]u8 = undefined;
    while (try input_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        const line_cp: []u8 = try allocator.alloc(u8, line.len);
        std.mem.copyForwards(u8, line_cp, line);

        try input_list.append(line_cp);
    }

    return input_list;
}

fn rotate_grid(grid: std.ArrayList([]u8)) void {
    const N = grid.items.len;
    var items = grid.items;

    for (0..N / 2) |i| {
        for (i..N - i - 1) |j| {
            const temp = items[i][j];
            items[i][j] = items[N - 1 - j][i];
            items[N - 1 - j][i] = items[N - 1 - i][N - 1 - j];
            items[N - 1 - i][N - 1 - j] = items[j][N - 1 - i];
            items[j][N - 1 - i] = temp;
        }
    }
}

fn contains_galaxy(line: []u8) bool {
    for (line) |char| {
        if (char == '#') {
            return true;
        }
    }

    return false;
}
