// Load a big-endian u32, consisting of 4 bytes (c_3, c_2, c_1, c_0).
%macro mload_u32
    // stack: context, segment, offset
    DUP3
    DUP3
    DUP3
    MLOAD_GENERAL
    // stack: c_3, context, segment, offset
    %shl_const(8)
    // stack: c_3 << 8, context, segment, offset
    DUP4
    %increment
    DUP4
    DUP4
    MLOAD_GENERAL
    ADD // OR
    // stack: (c_3 << 8) | c_2, context, segment, offset
    %shl_const(8)
    // stack: ((c_3 << 8) | c_2) << 8, context, segment, offset
    DUP4
    %add_const(2)
    DUP4
    DUP4
    MLOAD_GENERAL
    ADD // OR
    // stack: (((c_3 << 8) | c_2) << 8) | c_1, context, segment, offset
    %shl_const(8)
    // stack: ((((c_3 << 8) | c_2) << 8) | c_1) << 8, context, segment, offset
    SWAP3
    %add_const(3)
    SWAP2
    SWAP1
    MLOAD_GENERAL
    ADD // OR
    // stack: (((((c_3 << 8) | c_2) << 8) | c_1) << 8) | c_0
%endmacro

// Load a little-endian u32, consisting of 4 bytes (c_0, c_1, c_2, c_3).
%macro mload_u32_LE
    // stack: context, segment, offset
    DUP3
    DUP3
    DUP3
    MLOAD_GENERAL
    // stack: c0, context, segment, offset
    DUP4
    %increment
    DUP4
    DUP4
    MLOAD_GENERAL
    %shl_const(8)
    ADD
    // stack: c0 | (c1 << 8), context, segment, offset
    DUP4
    %add_const(2)
    DUP4
    DUP4
    MLOAD_GENERAL
    %shl_const(16)
    ADD
    // stack: c0 | (c1 << 8) | (c2 << 16), context, segment, offset
    SWAP3
    %add_const(3)
    SWAP2
    SWAP1
    MLOAD_GENERAL
    %shl_const(24)
    ADD // OR
    // stack: c0 | (c1 << 8) | (c2 << 16) | (c3 << 24)
%endmacro

// Load a little-endian u64, consisting of 8 bytes (c_0, ..., c_7).
%macro mload_u64_LE
    // stack: context, segment, offset
    DUP3
    DUP3
    DUP3
    %mload_u32_LE
    // stack: lo, context, segment, offset
    SWAP3
    %add_const(4)
    SWAP2
    SWAP1
    %mload_u32_LE
    // stack: hi, lo
    %shl_const(32)
    // stack: hi << 32, lo
    ADD // OR
    // stack: (hi << 32) | lo
%endmacro

// Load a u256 (big-endian).
%macro mload_u256
    // stack: context, segment, offset
    DUP3
    DUP3
    DUP3
    %mload_u32
    // stack: c_7, context, segment, offset
    %shl_const(32)
    // stack: c7 << 32, context, segment, offset
    DUP4
    %add_const(4)
    DUP4
    DUP4
    %mload_u32
    ADD // OR
    // stack: (c_7 << 32) | c_6, context, segment, offset
    %shl_const(32)
    // stack: ((c_7 << 32) | c_6) << 32, context, segment, offset
    DUP4
    %add_const(8)
    DUP4
    DUP4
    %mload_u32
    ADD // OR
    // stack: (c_7 << 64) | (c_6 << 32) | c_5, context, segment, offset
    %shl_const(32)
    // stack: ((c_7 << 64) | (c_6 << 32) | c_5) << 32, context, segment, offset
    DUP4
    %add_const(12)
    DUP4
    DUP4
    %mload_u32
    ADD // OR
    // stack: (c_7 << 96) | (c_6 << 64) | (c_5 << 32) | c_4, context, segment, offset
    %shl_const(32)
    // stack: ((c_7 << 96) | (c_6 << 64) | (c_5 << 32) | c_4) << 32, context, segment, offset
    DUP4
    %add_const(16)
    DUP4
    DUP4
    %mload_u32
    ADD // OR
    // stack: (c_7 << 128) | (c_6 << 96) | (c_5 << 64) | (c_4 << 32) | c_3, context, segment, offset
    %shl_const(32)
    // stack: ((c_7 << 128) | (c_6 << 96) | (c_5 << 64) | (c_4 << 32) | c_3) << 32, context, segment, offset
    DUP4
    %add_const(20)
    DUP4
    DUP4
    %mload_u32
    ADD // OR
    // stack: (c_7 << 160) | (c_6 << 128) | (c_5 << 96) | (c_4 << 64) | (c_3 << 32) | c_2, context, segment, offset
    %shl_const(32)
    // stack: ((c_7 << 160) | (c_6 << 128) | (c_5 << 96) | (c_4 << 64) | (c_3 << 32) | c_2) << 32, context, segment, offset
    DUP4
    %add_const(24)
    DUP4
    DUP4
    %mload_u32
    ADD // OR
    // stack: (c_7 << 192) | (c_6 << 160) | (c_5 << 128) | (c_4 << 96) | (c_3 << 64) | (c_2 << 32) | c_1, context, segment, offset
    %shl_const(32)
    // stack: ((c_7 << 192) | (c_6 << 160) | (c_5 << 128) | (c_4 << 96) | (c_3 << 64) | (c_2 << 32) | c_1) << 32, context, segment, offset
    SWAP3
    %add_const(28)
    SWAP2
    SWAP1
    %mload_u32
    ADD // OR
    // stack: (c_7 << 224) | (c_6 << 192) | (c_5 << 160) | (c_4 << 128) | (c_3 << 96) | (c_2 << 64) | (c_1 << 32) | c_0
%endmacro

// Store a big-endian u32, consisting of 4 bytes (c_3, c_2, c_1, c_0).
%macro mstore_u32
    // stack: context, segment, offset, value
    SWAP3
    // stack: value, segment, offset, context
    DUP1
    // stack: value, value, segment, offset, context
    %and_const(0xff)
    // stack: c_0 = value % (1 << 8), value, segment, offset, context
    SWAP1
    // stack: value, c_0, segment, offset, context
    %shr_const(8)
    // stack: value >> 8, c_0, segment, offset, context
    DUP1
    // stack: value >> 8, value >> 8, c_0, segment, offset, context
    %and_const(0xff)
    // stack: c_1 = (value >> 8) % (1 << 8), value >> 8, c_0, segment, offset, context
    SWAP1
    // stack: value >> 8, c_1, c_0, segment, offset, context
    %shr_const(8)
    // stack: value >> 16, c_1, c_0, segment, offset, context
    DUP1
    // stack: value >> 16, value >> 16, c_1, c_0, segment, offset, context
    %and_const(0xff)
    // stack: c_2 = (value >> 16) % (1 << 8), value >> 16, c_1, c_0, segment, offset, context
    SWAP1
    // stack: value >> 16, c_2, c_1, c_0, segment, offset, context
    %shr_const(8)
    // stack: value >> 24, c_2, c_1, c_0, segment, offset, context
    %and_const(0xff)
    // stack: c_3 = (value >> 24) % (1 << 8), c_2, c_1, c_0, segment, offset, context
    DUP6
    DUP6
    DUP9
    // stack: context, segment, offset, c_3, c_2, c_1, c_0, segment, offset, context
    MSTORE_GENERAL
    // stack: c_2, c_1, c_0, segment, offset, context
    DUP5
    %increment
    DUP5
    DUP8
    MSTORE_GENERAL
    // stack: c_1, c_0, segment, offset, context
    DUP4
    %add_const(2)
    DUP4
    DUP7
    MSTORE_GENERAL
    // stack: c_0, segment, offset, context
    SWAP2
    %add_const(3)
    SWAP2
    SWAP3
    MSTORE_GENERAL
%endmacro

// Load a value from the given segment of the current context's memory space.
// Note that main memory values are one byte each, but in general memory values
// can be 256 bits. This macro deals with a single address (unlike MLOAD), so
// if it is used with main memory, it will load a single byte.
%macro mload_current(segment)
    // stack: offset
    PUSH $segment
    // stack: segment, offset
    GET_CONTEXT
    // stack: context, segment, offset
    MLOAD_GENERAL
    // stack: value
%endmacro

// Store a value to the given segment of the current context's memory space.
// Note that main memory values are one byte each, but in general memory values
// can be 256 bits. This macro deals with a single address (unlike MSTORE), so
// if it is used with main memory, it will store a single byte.
%macro mstore_current(segment)
    // stack: offset, value
    PUSH $segment
    // stack: segment, offset, value
    GET_CONTEXT
    // stack: context, segment, offset, value
    MSTORE_GENERAL
    // stack: (empty)
%endmacro

// Load a single byte from user code.
%macro mload_current_code
    // stack: offset
    %mload_current(@SEGMENT_CODE)
    // stack: value
%endmacro

// Load a single byte from user general memory.
%macro mload_current_memory
    // stack: offset
    %mload_current(@SEGMENT_MEMORY)
    // stack: value
%endmacro

// Load a single byte from the kernel general memory, in the current context (not the kernel's context).
%macro mload_current_general
    // stack: offset
    %mload_current(@SEGMENT_KERNEL_GENERAL)
    // stack: value
%endmacro

// Load a big-endian u32 from kernel general memory in the current context.
%macro mload_current_general_u32
    // stack: offset
    PUSH @SEGMENT_KERNEL_GENERAL
    // stack: segment, offset
    GET_CONTEXT
    // stack: context, segment, offset
    %mload_u32
    // stack: value
%endmacro

// Load a little-endian u32 from kernel general memory in the current context.
%macro mload_current_general_u32_LE
    // stack: offset
    PUSH @SEGMENT_KERNEL_GENERAL
    // stack: segment, offset
    GET_CONTEXT
    // stack: context, segment, offset
    %mload_u32_LE
    // stack: value
%endmacro

// Load a little-endian u64 from kernel general memory in the current context.
%macro mload_current_general_u64_LE
    // stack: offset
    PUSH @SEGMENT_KERNEL_GENERAL
    // stack: segment, offset
    GET_CONTEXT
    // stack: context, segment, offset
    %mload_u64_LE
    // stack: value
%endmacro

// Load a u256 from kernel general memory in the current context.
%macro mload_current_general_u256
    // stack: offset
    PUSH @SEGMENT_KERNEL_GENERAL
    // stack: segment, offset
    GET_CONTEXT
    // stack: context, segment, offset
    %mload_u256
    // stack: value
%endmacro

// Store a single byte to kernel general memory in the current context.
%macro mstore_current_general
    // stack: offset, value
    PUSH @SEGMENT_KERNEL_GENERAL
    // stack: segment, offset, value
    GET_CONTEXT
    // stack: context, segment, offset, value
    MSTORE_GENERAL
    // stack: (empty)
%endmacro

// Store a big-endian u32 to kernel general memory in the current context.
%macro mstore_current_general_u32
    // stack: offset, value
    PUSH @SEGMENT_KERNEL_GENERAL
    // stack: segment, offset, value
    GET_CONTEXT
    // stack: context, segment, offset, value
    %mstore_u32
    // stack: (empty)
%endmacro

// Load a single value from the given segment of kernel (context 0) memory.
%macro mload_kernel(segment)
    // stack: offset
    PUSH $segment
    // stack: segment, offset
    PUSH 0 // kernel has context 0
    // stack: context, segment, offset
    MLOAD_GENERAL
    // stack: value
%endmacro

// Store a single value from the given segment of kernel (context 0) memory.
%macro mstore_kernel(segment)
    // stack: offset, value
    PUSH $segment
    // stack: segment, offset, value
    PUSH 0 // kernel has context 0
    // stack: context, segment, offset, value
    MSTORE_GENERAL
    // stack: (empty)
%endmacro

// Store a single value from the given segment of kernel (context 0) memory.
%macro mstore_kernel(segment, offset)
    // stack: value
    PUSH $offset
    // stack: offset, value
    PUSH $segment
    // stack: segment, offset, value
    PUSH 0 // kernel has context 0
    // stack: context, segment, offset, value
    MSTORE_GENERAL
    // stack: (empty)
%endmacro

// Load from the kernel a big-endian u32, consisting of 4 bytes (c_3, c_2, c_1, c_0)
%macro mload_kernel_u32(segment)
    // stack: offset
    PUSH $segment
    // stack: segment, offset
    PUSH 0 // kernel has context 0
    // stack: context, segment, offset
    %mload_u32
%endmacro

// Load from the kernel a little-endian u32, consisting of 4 bytes (c_0, c_1, c_2, c_3).
%macro mload_kernel_u32_LE(segment)
    // stack: offset
    PUSH $segment
    // stack: segment, offset
    PUSH 0 // kernel has context 0
    // stack: context, segment, offset
    %mload_u32_LE
%endmacro

// Load from the kernel a little-endian u64, consisting of 8 bytes (c_0, ..., c_7).
%macro mload_kernel_u64_LE(segment)
    // stack: offset
    PUSH $segment
    // stack: segment, offset
    PUSH 0 // kernel has context 0
    // stack: context, segment, offset
    %mload_u64_LE
%endmacro

// Load a u256 (big-endian) from the kernel.
%macro mload_kernel_u256(segment)
    // stack: offset
    PUSH $segment
    // stack: segment, offset
    PUSH 0 // kernel has context 0
    // stack: context, segment, offset
    %mload_u256
%endmacro

// Store a big-endian u32, consisting of 4 bytes (c_3, c_2, c_1, c_0),
// to the kernel.
%macro mstore_kernel_u32(segment)
    // stack: offset, value
    PUSH $segment
    // stack: segment, offset, value
    PUSH 0 // kernel has context 0
    // stack: context, segment, offset, value
    %mstore_u32
%endmacro

// Load a single byte from kernel code.
%macro mload_kernel_code
    // stack: offset
    %mload_kernel(@SEGMENT_CODE)
    // stack: value
%endmacro

%macro mload_kernel_code(label)
    // stack: shift
    PUSH $label  
    ADD
    // stack: label + shift
    %mload_kernel_code
    // stack: byte
%endmacro

// Load a big-endian u32, consisting of 4 bytes (c_3, c_2, c_1, c_0),
// from kernel code.
%macro mload_kernel_code_u32
    // stack: offset
    %mload_kernel_u32(@SEGMENT_CODE)
    // stack: value
%endmacro

%macro mload_kernel_code_u32(label)
    // stack: u32_shift
    %mul_const(4)
    // stack: byte_shift
    PUSH $label
    ADD
    // stack: offset
    %mload_kernel_u32(@SEGMENT_CODE)
    // stack: value
%endmacro

// Load a single value from kernel general memory.
%macro mload_kernel_general
    // stack: offset
    %mload_kernel(@SEGMENT_KERNEL_GENERAL)
    // stack: value
%endmacro

// Load a single value from kernel general memory.
%macro mload_kernel_general(offset)
    PUSH $offset
    %mload_kernel(@SEGMENT_KERNEL_GENERAL)
    // stack: value
%endmacro

// Load a big-endian u32, consisting of 4 bytes (c_3, c_2, c_1, c_0),
// from kernel general memory.
%macro mload_kernel_general_u32
    // stack: offset
    %mload_kernel_u32(@SEGMENT_KERNEL_GENERAL)
    // stack: value
%endmacro

// Load a little-endian u32, consisting of 4 bytes (c_0, c_1, c_2, c_3),
// from kernel general memory.
%macro mload_kernel_general_u32_LE
    // stack: offset
    %mload_kernel_u32_LE(@SEGMENT_KERNEL_GENERAL)
    // stack: value
%endmacro

// Load a little-endian u64, consisting of 8 bytes
// (c_0, c_1, c_2, c_3, c_4, c_5, c_6, c_7), from kernel general memory.
%macro mload_kernel_general_u64_LE
    // stack: offset
    %mload_kernel_u64_LE(@SEGMENT_KERNEL_GENERAL)
    // stack: value
%endmacro

// Load a u256 (big-endian) from kernel code.
%macro mload_kernel_code_u256
    // stack: offset
    %mload_kernel_u256(@SEGMENT_CODE)
    // stack: value
%endmacro

// Load a u256 (big-endian) from kernel general memory.
%macro mload_kernel_general_u256
    // stack: offset
    %mload_kernel_u256(@SEGMENT_KERNEL_GENERAL)
    // stack: value
%endmacro

// Store a single byte to kernel code.
%macro mstore_kernel_code
    // stack: offset, value
    %mstore_kernel(@SEGMENT_CODE)
    // stack: (empty)
%endmacro

// Store a big-endian u32, consisting of 4 bytes (c_3, c_2, c_1, c_0),
// to kernel code.
%macro mstore_kernel_code_u32
    // stack: offset, value
    %mstore_kernel_u32(@SEGMENT_CODE)
%endmacro

// Store a single byte to @SEGMENT_RLP_RAW.
%macro mstore_rlp
    // stack: offset, value
    %mstore_kernel(@SEGMENT_RLP_RAW)
    // stack: (empty)
%endmacro

%macro mstore_kernel_general
    // stack: offset, value 
    %mstore_kernel(@SEGMENT_KERNEL_GENERAL)
    // stack: (empty)
%endmacro

%macro mstore_kernel_general(offset)
    // stack:         value 
    PUSH $offset
    // stack: offset, value 
    %mstore_kernel_general
    // stack: (empty)
%endmacro

// Store a big-endian u32, consisting of 4 bytes (c_3, c_2, c_1, c_0),
// to kernel general memory.
%macro mstore_kernel_general_u32
    // stack: offset, value
    %mstore_kernel_u32(@SEGMENT_KERNEL_GENERAL)
%endmacro

// set offset i to offset j in kernel general
%macro mupdate_kernel_general
    // stack: j, i
    %mload_kernel_general
    // stack: x, i
    SWAP1
    %mstore_kernel_general
    // stack: (empty)
%endmacro

// Load a single value from kernel general 2 memory.
%macro mload_kernel_general_2
    // stack: offset
    %mload_kernel(@SEGMENT_KERNEL_GENERAL_2)
    // stack: value
%endmacro

// Load a single value from kernel general memory.
%macro mload_kernel_general_2(offset)
    PUSH $offset
    %mload_kernel(@SEGMENT_KERNEL_GENERAL_2)
    // stack: value
%endmacro

%macro mstore_kernel_general_2
    // stack: offset, value
    %mstore_kernel(@SEGMENT_KERNEL_GENERAL_2)
    // stack: (empty)
%endmacro

%macro mstore_kernel_general_2(offset)
    // stack:         value
    PUSH $offset
    // stack: offset, value
    %mstore_kernel_general_2
    // stack: (empty)
%endmacro
