import kotlin.math.*
import java.util.PriorityQueue

val grid = ArrayList<List<Int>>()

while (true) {
    val s = readlnOrNull()
    if (s == null) {
        break
    }
    grid.add(s.map { it - '0' })
}

fun solve(grid: List<List<Int>>): Int {
    val n = grid.size
    val m = grid[0].size

    val dist = Array(n) { Array(m) { Int.MAX_VALUE } }
    val vis = Array(n) { Array(m) { false } }
    val pq = PriorityQueue<Pair<Int, Pair<Int, Int>>> {
        a, b -> a.first - b.first
    }

    dist[0][0] = 0
    pq.add(Pair(0, Pair(0, 0)))

    while (pq.size > 0) {
        val (d, cell) = pq.poll()!!
        val (i, j) = cell
        if (vis[i][j])
            continue
        vis[i][j] = true

        val neighbors = listOf(
            Pair(i - 1, j), Pair(i + 1, j),
            Pair(i, j - 1), Pair(i, j + 1),
        ).filter { it.first in 0 until n && it.second in 0 until m }

        for ((a, b) in neighbors) {
            if (d + grid[a][b] < dist[a][b]) {
                dist[a][b] = d + grid[a][b]
                pq.add(Pair(dist[a][b], Pair(a, b)))
            }
        }
    }

    return dist[n - 1][m - 1]
}

// Part 1
println(solve(grid))

// Part 2
val n = grid.size
val m = grid[0].size
val bigGrid = List<List<Int>>(5 * n) {
    i -> List<Int>(5 * m) {
        j -> run {
            val offset = i / n + j / m
            val num = grid[i % n][j % m] + offset
            (num - 1) % 9 + 1
        }
    }
}
println(solve(bigGrid))
