package main

import "fmt"

type Queue[T any] struct {
	data  []T
	front uintptr
	rear  uintptr
}

func (q *Queue[T]) enqueue(val T) {
	q.data = append(q.data, val)
	q.rear += 1

}
func (q *Queue[T]) dequeue() {
	q.data = q.data[1:len(q.data)]
	q.front += 1
}

func (q *Queue[T]) is_full() bool {
	return true
}

func queue() {
	queue := Queue[uint8]{}
	queue.enqueue(1)
	queue.enqueue(2)
	queue.enqueue(3)
	fmt.Println(queue)
}
