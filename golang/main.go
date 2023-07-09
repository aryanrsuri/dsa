package main

import (
	"fmt"
)

func main() {
	queue := Queue[uint8]{}
	queue.enqueue(1)
	queue.enqueue(2)
	queue.enqueue(3)
	queue.enqueue(4)
	fmt.Println(queue.data, queue.front, queue.rear)
	queue.dequeue()
	fmt.Println(queue.data, queue.front, queue.rear)
}
