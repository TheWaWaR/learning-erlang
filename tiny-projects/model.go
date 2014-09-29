package main
import ( "time" )

const (
	// >> 4bits: 0x0...0xF
	// Room types
	T_ROOM_SYS	= uint64(0x0)
	T_ROOM_USER	= uint64(0x1)
	// Client types
	T_ADMIN         = uint64(0x0)
	T_USER		= uint64(0x1)
	T_VISITOR	= uint64(0x2)
)

/* ============================================================================
 *  1. `Room` can create/delete by `User` dynamically.
 *  2. There are system wide `Room`s, created by `Admin` or application.
 * ==========================================================================*/
type Room struct {
	id		uint64	// RoomType(4bits) + RoomId(60bits)
	name		string
	members		map[uint64]*Client // ClientId ==> Client
	mailbox		chan interface{}   // For receive messages
	history		[]*Message
}
////////////////////////////////////////////////////////////////////////////////
type Client struct {
	id		uint64 // ClientType(4bits) + ClientId(60bits)
	name		string // Just a tag.
	mailbox		chan interface{} // For receive messages
	rooms		map[uint64]*Room // Joined rooms
}

/* ============================================================================
 *  1. `User` must authenticate by `token` or `password`
 *  2. `User` can block/unblock his visitors.
 * ==========================================================================*/
type User struct {
	Client			// Subclass 
	passwd		string	// For auth (used for first time)
	token		string	// For auth too (for security)
}

/* ============================================================================
 *  1. `Admin` can create system wide `Room`s, like a forum.
 * ==========================================================================*/
type Admin struct {
	User			// `Admin` is a kind of super `User`
}

/* ============================================================================
 *  1. `Visitor` must relate to a `User`
 *  2. `Visitor` can only send message to its related `User`
 * ==========================================================================*/
type Visitor struct {
	Client			// Subclass
	uid		uint64	// Corresponding `User` id.
}
////////////////////////////////////////////////////////////////////////////////
type Message struct {
	from_id, to_id	uint64	// Example: client.id ==> room.id
	body		string
	created_at	time.Time
}
