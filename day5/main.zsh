# Solution to Day 5 in Zsh
# Referencing https://zsh.sourceforge.io/Guide/zshguide.html

declare -A counts
declare -A counts_diag

add_point() {
  if [[ -n $1[$2,$3] ]]; then
    (( $1[$2,$3]++ ))
  else
    $1[$2,$3]=1
  fi
}

while IFS= read -r line; do
  read left right < <(cut -d' ' -f1,3 <<<$line)
  leftp=(${(s/,/)left})
  rightp=(${(s/,/)right})
  x1=$leftp[1]
  y1=$leftp[2]
  x2=$rightp[1]
  y2=$rightp[2]
  if (( $x1 == $x2 )); then
    for j in $(seq $y1 $y2); do
      add_point counts $x1 $j
      add_point counts_diag $x1 $j
    done
  elif (( $y1 == $y2 )); then
    for i in $(seq $x1 $x2); do
      add_point counts $i $y1
      add_point counts_diag $i $y1
    done
  elif (( ($x2 > $x1 && $y2 > $y1) || ($x2 < $x1 && $y2 < $y1) )); then
    for i in $(seq $x1 $x2); do
      add_point counts_diag $i $(( $i + $y1 - $x1 ))
    done
  elif (( ($x2 < $x1 && $y2 > $y1) || ($x2 > $x1 && $y2 < $y1) )); then
    for i in $(seq $x1 $x2); do
      add_point counts_diag $i $(( $x1 + $y1 - $i ))
    done
  else
    echo "Invalid line:"
    echo $line
    exit 1
  fi
done

ans=0
for key val in "${(@kv)counts}"; do
  if (( $val >= 2 )); then
    (( ans++ ))
  fi
done
echo $ans

ans=0
for key val in "${(@kv)counts_diag}"; do
  if (( $val >= 2 )); then
    (( ans++ ))
  fi
done
echo $ans
