import os

fn check(line []int, drawn []int) bool {
	return line.all(it in drawn)
}

fn won(board [][]int, drawn []int) bool {
	idx := [0, 1, 2, 3, 4]
	mut ret := false
	ret = ret || board.any(check(it, drawn))
	for col in idx {
		ret = ret || check(idx.map(board[it][col]), drawn)
	}
	ret = ret || check(idx.map(board[it][it]), drawn)
	ret = ret || check(idx.map(board[it][4 - it]), drawn)
	return ret
}

nums := os.get_line().split(',').map(it.int())

mut boards := [][][]int{}
os.get_line()
for {
	lines := os.get_lines()
	if lines.len == 0 {
		break
	}
	board := lines.map(it.split(' ').filter(it != '').map(it.int()))
	boards << board
}

mut first_score := -1
mut last_score := -1

for i := 1; i <= nums.len; i++ {
	drawn := nums[..i]
	mut new_boards := [][][]int{}
	for board in boards {
		if won(board, drawn) {
			mut sum := 0
			for row in board {
				for val in row {
					if val !in drawn {
						sum += val
					}
				}
			}
			score := sum * drawn.last()
			if first_score == -1 {
				first_score = score
			}
			last_score = score
		} else {
			new_boards << board
		}
	}
	boards = new_boards.clone()
}

println(first_score)
println(last_score)
