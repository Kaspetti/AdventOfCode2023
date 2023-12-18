const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input_path = "input";

    var grid = try get_lines(input_path, allocator);
    defer grid.deinit();
    var rotated_grid = try get_lines(input_path, allocator);
    rotate_grid(rotated_grid);
    defer rotated_grid.deinit();

    const galaxy_rows_table = try get_galaxy_rows_table(&grid, allocator);
    const galaxy_columns_table = try get_galaxy_rows_table(&rotated_grid, allocator);

    const expansion_rate = 1000000;

    var galaxy_coords = std.ArrayList(struct { x: isize, y: isize }).init(allocator);
    for (grid.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            if (char == '#') {
                var x_expand: usize = 0;
                var y_expand: usize = 0;
                for (0..y) |i| {
                    if (!galaxy_rows_table[i]) {
                        y_expand += expansion_rate - 1;
                    }
                }
                for (0..x) |i| {
                    if (!galaxy_columns_table[i]) {
                        x_expand += expansion_rate - 1;
                    }
                }

                const g_x: isize = @bitCast(x + x_expand);
                const g_y: isize = @bitCast(y + y_expand);
                try galaxy_coords.append(.{ .x = g_x, .y = g_y });
            }
        }
    }

    var total_length: isize = 0;
    for (0..galaxy_coords.items.len - 1) |i| {
        for (i + 1..galaxy_coords.items.len) |j| {
            const galaxy_0 = galaxy_coords.items[i];
            const galaxy_1 = galaxy_coords.items[j];

            total_length += abs(galaxy_0.x - galaxy_1.x) + abs(galaxy_0.y - galaxy_1.y);
        }
    }

    std.debug.print("The total length of all paths: {d}\n", .{total_length});
}

fn abs(n_1: isize) isize {
    if (n_1 < 0) {
        return n_1 * -1;
    }

    return n_1;
}

fn get_galaxy_rows_table(grid: *const std.ArrayList([]u8), allocator: std.mem.Allocator) ![]bool {
    var galaxy_rows_table: []bool = try allocator.alloc(bool, grid.items.len);

    for (grid.items, 0..) |line, row| {
        if (contains_galaxy(line)) {
            galaxy_rows_table[row] = true;
        }
    }

    return galaxy_rows_table;
}

fn get_lines(file_name: []const u8, allocator: std.mem.Allocator) !std.ArrayList([]u8) {
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

fn contains_galaxy(line: []const u8) bool {
    for (line) |char| {
        if (char == '#') {
            return true;
        }
    }

    return false;
}
