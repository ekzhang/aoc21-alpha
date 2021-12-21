import scala.io.StdIn.readLine

@main def main = {
  val nums = readLine().split(",").map(_.toInt).sorted
  val median = nums(nums.length / 2)
  println(nums.map((x: Int) => (x - median).abs).sum)

  var best = Int.MaxValue
  for (x <- nums(0) to nums.last) {
    val cost = nums.map((y: Int) => {
      val d = (x - y).abs
      d * (d + 1) / 2
    }).sum
    best = best.min(cost)
  }
  println(best)
}
