package main

import "fmt"

type Stack[T any] struct {
	data []T
}

func (s *Stack[T]) push(value T) {
	s.data = append(s.data, value)
}

func (s *Stack[T]) pop() T {
	var ret T = s.data[len(s.data)-1]
	s.data = s.data[0 : len(s.data)-1]

	return ret
}

func stack() {
	var stack = Stack[uint8]{}
	stack.push(10)
	stack.push(20)
	stack.push(30)
	stack.push(40)
	fmt.Println(stack.data)
	stack.pop()
	fmt.Println(stack.data)
}
