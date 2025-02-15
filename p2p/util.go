// Copyright 2019 The go-grosh Authors
// This file is part of the go-grosh library.
//
// The go-grosh library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-grosh library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-grosh library. If not, see <http://www.gnu.org/licenses/>.

package p2p

import (
	"container/heap"
	"time"
)

// expHeap tracks strings and their expiry time.
type expHeap []expItem

// expItem is an entry in addrHistory.
type expItem struct {
	item string
	exp  time.Time
}

// nextExpiry returns the next expiry time.
func (h *expHeap) nextExpiry() time.Time {
	return (*h)[0].exp
}

// add adds an item and sets its expiry time.
func (h *expHeap) add(item string, exp time.Time) {
	heap.Push(h, expItem{item, exp})
}

// remove removes an item.
func (h *expHeap) remove(item string) bool {
	for i, v := range *h {
		if v.item == item {
			heap.Remove(h, i)
			return true
		}
	}
	return false
}

// contains checks whether an item is present.
func (h expHeap) contains(item string) bool {
	for _, v := range h {
		if v.item == item {
			return true
		}
	}
	return false
}

// expire removes items with expiry time before 'now'.
func (h *expHeap) expire(now time.Time) {
	for h.Len() > 0 && h.nextExpiry().Before(now) {
		heap.Pop(h)
	}
}

// heap.Interface boilerplate
func (h expHeap) Len() int            { return len(h) }
func (h expHeap) Less(i, j int) bool  { return h[i].exp.Before(h[j].exp) }
func (h expHeap) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *expHeap) Push(x interface{}) { *h = append(*h, x.(expItem)) }
func (h *expHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}
