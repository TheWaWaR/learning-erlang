package main

import (
	"os"
	"fmt"
	"flag"
	"bufio"
	"net"
	"log"
	"strconv"
)

var (
	addr = flag.String("addr", "localhost:1234", "Server address.")
	logf = flag.String("log", "/tmp/weet_im.log", "Log file path.")
	PREFIX_LEN = 8+1
	BUF_SIZE = 1024
	running = true
)


func init() {
	flag.Parse()
}

func recv(conn net.Conn) (res []byte, err error){
	head := make([]byte, PREFIX_LEN)
	var length int
	
	n, err := conn.Read(head)
	if err != nil {
		log.Println("Recv error: %v", err)
		return head, err
	} 
	
	for {
		if (n >= PREFIX_LEN) {
			length, _ = strconv.Atoi(string(head[:PREFIX_LEN-1]))
			break
		}
		tbuf := make([]byte, PREFIX_LEN-n)
		tn, err := conn.Read(tbuf)
		n += tn
		head = append(head, tbuf[:tn]...)
		if err != nil {
			log.Println("Recv tmp error: %v", err)
			return head, err
		} 

	}
	log.Printf("Recv.head: <%s>\n", string(head))
	
	content := make([]byte, length)
	buf := make([]byte, BUF_SIZE)
	for ; length > 0 ; {
		n, err := conn.Read(buf)
		length -= n
		content = append(content, buf[:n]...)
		if err != nil {
			log.Println("Recv error: %v", err)
			return content, err
		}
	}
	log.Printf("Recv.content: <%s>\n", string(content))
	return content, nil
}


func send(conn net.Conn, body []byte) {
	length := len(body)
	head_fmt := fmt.Sprintf("%%0%dd:", PREFIX_LEN-1)
	head := []byte(fmt.Sprintf(head_fmt, length))
	conn.Write(head[:PREFIX_LEN])
	conn.Write(body)
}


func receiving(conn net.Conn) {
	for ; running ; {
		body, err := recv(conn)
		if err != nil { running = false }
		print(string(body))
	}
}


func inputing(conn net.Conn) {
	reader := bufio.NewReader(os.Stdin)
	println(">> Connected!")
	for ; running ; {
		line, err := reader.ReadSlice('\n')
		if err != nil { running = false }
		send(conn, line)
	}
	println(">> Stopped!")
}


func main() {
	f, err := os.OpenFile(*logf, os.O_RDWR | os.O_CREATE | os.O_APPEND, 0666)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	log.SetOutput(f)
	
	conn, err := net.Dial("tcp", *addr)
	if err != nil {
		log.Println("Connect error: %v", err)
	}
	go receiving(conn)
	inputing(conn)
}
