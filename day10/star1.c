#include <stdio.h>


const int DIMENSIONS = 141;


int find_paths(int x, int y, int prev_x, int prev_y, char grid[DIMENSIONS + 2][DIMENSIONS + 2]) {
    char symbol = grid[y][x];
    int new_x;
    int new_y;

    switch (symbol) {
        case '|':
            new_x = x;
            new_y = y > prev_y ? y + 1 : y - 1;
            break;
        case '-':
            new_x = x > prev_x ? x + 1 : x - 1;
            new_y = y;
            break;
        case 'L':
            new_x = x < prev_x ? x : x + 1;
            new_y = y > prev_y ? y : y - 1;
            break;
        case '7':
            new_x = x > prev_x ? x : x - 1;
            new_y = y < prev_y ? y : y + 1;
            break;
        case 'F':
            new_x = x < prev_x ? x : x + 1;
            new_y = y < prev_y ? y : y + 1;
            break;
        case 'J':
            new_x = x > prev_x ? x : x - 1;
            new_y = y > prev_y ? y : y - 1;
            break;
        case 'S':
            return 1;
        default:
            return -1;
    }

    int result = find_paths(new_x, new_y, x, y, grid);
    if (result == -1) {
        return -1;
    }

    return 1 + result;
}


int max(int n_1, int n_2) {
    return n_2 > n_1 ? n_2 : n_1;
}


int main() {
    FILE *fptr;
    fptr = fopen("input", "r");

    if (fptr == NULL) {
        printf("File not found...");
        fclose(fptr);
        return 1;
    }

    char grid[DIMENSIONS + 2][DIMENSIONS + 2];
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

    int steps_right = find_paths(start_x + 1, start_y, start_x, start_y, grid);
    int steps_left = find_paths(start_x - 1, start_y, start_x, start_y, grid);
    int steps_down = find_paths(start_x, start_y + 1, start_x, start_y, grid);
    int steps_up = find_paths(start_x, start_y - 1, start_x, start_y, grid);

    int max_steps = max(steps_right, steps_left);
    max_steps = max(max_steps, steps_down);
    max_steps = max(max_steps, steps_up);

    printf("Furthest steps from start: %d\n", max_steps / 2);

    fclose(fptr);
    return 0;
}
