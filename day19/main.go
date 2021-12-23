package main

import (
	"fmt"
	"log"
	"sync"
)

const (
	axisX = 1
	axisY = 2
	axisZ = 3
)

type axes [3]int
type vec [3]int

// An element of Z^3 * S_4
type transform struct {
	axes  axes // List of axes to specify the rotational pose
	shift vec  // Translational offset, applied after the rotation
}

var identity = transform{axes{axisX, axisY, axisZ}, vec{0, 0, 0}}

// 24 symmetries of a cube, isomorphic to S_4
var symmetries = []axes{
	{axisX, axisY, axisZ},
	{axisY, axisZ, axisX},
	{axisZ, axisX, axisY},
}

func init() {
	for i := 0; i < 3; i++ {
		t := symmetries[i]
		symmetries = append(symmetries, axes{-t[0], -t[1], t[2]})
		symmetries = append(symmetries, axes{-t[0], t[1], -t[2]})
		symmetries = append(symmetries, axes{t[0], -t[1], -t[2]})
	}
	for i := 0; i < 12; i++ {
		t := symmetries[i]
		symmetries = append(symmetries, axes{-t[1], t[0], t[2]})
	}
}

func add(v, w vec) (ret vec) {
	for i := 0; i < 3; i++ {
		ret[i] = v[i] + w[i]
	}
	return
}

func sub(v, w vec) (ret vec) {
	for i := 0; i < 3; i++ {
		ret[i] = v[i] - w[i]
	}
	return
}

func manhattan(v, w vec) (ret int) {
	for i := 0; i < 3; i++ {
		diff := v[i] - w[i]
		if diff > 0 {
			ret += diff
		} else {
			ret -= diff
		}
	}
	return
}

func rotate(axes axes, v vec) (ret vec) {
	for i := 0; i < 3; i++ {
		neg := axes[i] < 0
		idx := axes[i]
		if neg {
			idx *= -1
		}
		ret[i] = v[idx-1]
		if neg {
			ret[i] *= -1
		}
	}
	return
}

// Compose the results of two rotation transforms with each other.
func compose(a, b axes) axes {
	// Trick: Treat axes as the result of applying rotate(axes, []int{1, 2, 3}).
	return axes(rotate(a, vec(b)))
}

func (tr *transform) apply(v vec) vec {
	return add(rotate(tr.axes, v), tr.shift)
}

// Count the number of common elements between two sets of points
func isect(a, b []vec) (count int) {
	m := make(map[vec]struct{})
	for _, x := range a {
		m[x] = struct{}{}
	}
	for _, y := range b {
		if _, ok := m[y]; ok {
			count++
		}
	}
	return
}

// Returns a transform t such that apply(t, p2[i]) == p1[i]
func align(p1, p2 []vec) *transform {
	for _, v := range p1 {
		for _, u := range p2 {
			for _, ax := range symmetries {
				t := transform{ax, sub(v, rotate(ax, u))}
				var newp2 []vec
				for _, x := range p2 {
					newp2 = append(newp2, t.apply(x))
				}
				if isect(p1, newp2) >= 12 {
					return &t
				}
			}
		}
	}
	return nil
}

func main() {
	var temp string
	var scans [][]vec
	for {
		if _, err := fmt.Scanf("--- scanner %s ---\n", &temp); err != nil {
			break
		}
		var points []vec
		for {
			var v vec
			if _, err := fmt.Scanf("%d,%d,%d\n", &v[0], &v[1], &v[2]); err != nil {
				break
			}
			points = append(points, v)
		}
		scans = append(scans, points)
	}

	n := len(scans)
	poses := make([]*transform, n)
	poses[0] = &identity
	q := make(chan int, len(poses))
	q <- 0
	var mu sync.Mutex
	for range scans {
		a := <-q
		mu.Lock()
		for b := range scans {
			if poses[b] == nil {
				a, b := a, b
				go func() {
					t := align(scans[a], scans[b])
					mu.Lock()
					defer mu.Unlock()
					if t != nil && poses[b] == nil {
						poses[b] = &transform{
							compose(poses[a].axes, t.axes),
							poses[a].apply(t.shift),
						}
						q <- b
					}
				}()
			}
		}
		mu.Unlock()
	}

	points := make(map[vec]struct{})
	for i, pose := range poses {
		if pose == nil {
			log.Fatalf("scanner %v has no pose", i)
		}
		for _, v := range scans[i] {
			points[pose.apply(v)] = struct{}{}
		}
	}

	largestDist := 0
	for i := range poses {
		for j := i + 1; j < len(poses); j++ {
			d := manhattan(poses[i].shift, poses[j].shift)
			if d > largestDist {
				largestDist = d
			}
		}
	}

	fmt.Println(len(points))
	fmt.Println(largestDist)
}
