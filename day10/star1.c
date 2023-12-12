#include <stdio.h>


const int DIMENSIONS = 141;


int find_path(int x, int y, int prev_x, int prev_y, char grid[DIMENSIONS][DIMENSIONS + 2]) {
    char symbol = grid[y][x];
    int new_x;
    int new_y;

    switch (symbol) {
        case '|':
            if (x != prev_x) { return  -1; }
            new_x = x;
            new_y = y > prev_y ? y + 1 : y - 1;
            break;
        case '-':
            if (y != prev_y) { return  -1; }
            new_x = x > prev_x ? x + 1 : x - 1;
            new_y = y;
            break;
        case 'L':
            if (prev_x < x || prev_y > y) { return -1; }
            new_x = x < prev_x ? x : x + 1;
            new_y = y > prev_y ? y : y - 1;
            break;
        case '7':
            if (prev_x > x || prev_y < y) { return -1; }
            new_x = x > prev_x ? x : x - 1;
            new_y = y < prev_y ? y : y + 1;
            break;
        case 'F':
            if (prev_x < x || prev_y < y) { return -1; }
            new_x = x < prev_x ? x : x + 1;
            new_y = y < prev_y ? y : y + 1;
            break;
        case 'J':
            if (prev_x > x || prev_y > y) { return -1; }
            new_x = x > prev_x ? x : x - 1;
            new_y = y > prev_y ? y : y - 1;
            break;
        case 'S':
            return 1;
        default:
            return -1;
    }

    int result = find_path(new_x, new_y, x, y, grid);
    if (result == -1) {
        return -1;
    }

    return 1 + result;
}


int main() {
    FILE *fptr;
    fptr = fopen("input", "r");

    if (fptr == NULL) {
        printf("File not found...");
        fclose(fptr);
        return 1;
    }

    char grid[DIMENSIONS][DIMENSIONS + 2];
    int start_x = -1;
    int start_y = -1;

    int row = 0;
    while(fgets(grid[row], DIMENSIONS + 2, fptr)) {
        for (int i = 0; i < sizeof(grid[row]) - 1; i++) {
            if (grid[row][i] == 'S') {
                start_x = i;
                start_y = row;
            }
        }

        row++;
    };

    int steps_right = find_path(start_x + 1, start_y, start_x, start_y, grid);
    int steps_left = find_path(start_x - 1, start_y, start_x, start_y, grid);
    int steps_down = find_path(start_x, start_y + 1, start_x, start_y, grid);
    int steps_up = find_path(start_x, start_y - 1, start_x, start_y, grid);

    int furthest_step = 0;
    if (steps_right != -1) {
        furthest_step = steps_right / 2;
    } else if (steps_left != -1) {
        furthest_step = steps_left / 2;
    } else if (steps_down != -1) {
        furthest_step = steps_down / 2;
    } else if (steps_up != -1) {
        furthest_step = steps_up / 2;
    }

    printf("Furthest steps from start: %d\n", furthest_step);

    fclose(fptr);
    return 0;
}
