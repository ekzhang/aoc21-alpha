"""Preprocessing script to convert the input into a tabular format for Q."""

with open("input.txt", "r") as f:
    lines = f.readlines()

grid = {}

for i, line in enumerate(lines):
    for j, c in enumerate(line.strip()):
        grid[(i, j)] = int(c)

counter = 0
components = {}


def dfs(cell):
    stack = []

    def visit(cell):
        if cell in grid and grid[cell] < 9 and cell not in components:
            components[cell] = counter
            stack.append(cell)

    visit(cell)
    while stack:
        i, j = stack.pop()
        visit((i + 1, j))
        visit((i - 1, j))
        visit((i, j + 1))
        visit((i, j - 1))


for cell, value in grid.items():
    if value == 9:
        components[cell] = -1
    elif cell not in components:
        dfs(cell)
        counter += 1

with open("cells.csv", "w") as f:
    print("row,col,value,component", file=f)
    for (i, j), value in grid.items():
        print(f"{i},{j},{value},{components[(i, j)]}", file=f)
