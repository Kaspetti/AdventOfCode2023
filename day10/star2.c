#include <stdio.h>
#include <string.h>


const int DIMENSIONS = 141;


int find_path(int x, int y, int prev_x, int prev_y, const char grid[DIMENSIONS][DIMENSIONS + 2], int *areax2) {
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

    int result = find_path(new_x, new_y, x, y, grid, areax2);
    if (result == -1) {
        return -1;
    }

    *areax2 += (y + new_y) * (x - new_x);
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

    int right_areax2 = 0;
    int left_areax2 = 0;
    int down_areax2 = 0;
    int up_areax2 = 0;

    int steps_right = find_path(start_x + 1, start_y, start_x, start_y, grid, &right_areax2);
    int steps_left = find_path(start_x - 1, start_y, start_x, start_y, grid, &left_areax2);
    int steps_down = find_path(start_x, start_y + 1, start_x, start_y, grid, &down_areax2);
    int steps_up = find_path(start_x, start_y - 1, start_x, start_y, grid, &up_areax2);

    int steps = 0;
    int area = 0;
    if (steps_right != -1) {
        steps = steps_right;
        area = right_areax2 / 2;
    } else if (steps_left != -1) {
        steps = steps_left;
        area = left_areax2 / 2;
    } else if (steps_down != -1) {
        steps = steps_down;
        area = down_areax2 / 2;
    } else if (steps_up != -1) {
        steps = steps_up;
        area = up_areax2 / 2;
    }


    int internal_points = -1 * (-area + steps / 2 - 1);
    printf("Total internal points: %d\n", internal_points);

    fclose(fptr);
    return 0;
}
