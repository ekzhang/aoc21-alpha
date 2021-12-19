    .data
.Lstr:
    .asciz "0"

    .text
    .globl _soln
_soln:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movq %rdi, -8(%rbp)  // pointer to buffer
    movq $0, -16(%rbp)   // horizontal position
    movq $0, -24(%rbp)   // depth
.Lloop:
    movq -8(%rbp), %rax
    cmpb $0x66, (%rax)   // [f]orward
    je .Lforward
    cmpb $0x75, (%rax)   // [u]p
    je .Lup
    cmpb $0x64, (%rax)   // [d]own
    je .Ldown
    movq $1, %rdi        // unknown command, call exit(1)
    callq _exit
.Lforward:
    addq $8, -8(%rbp)
    movq -8(%rbp), %rax
    leaq .Lstr(%rip), %rdi
    movq (%rax), %rax
    movq %rax, (%rdi)
    callq _atoi
    addq %rax, -16(%rbp)
    incq -8(%rbp)
    jmp .Lnext
.Lup:
    addq $3, -8(%rbp)
    movq -8(%rbp), %rax
    leaq .Lstr(%rip), %rdi
    movq (%rax), %rax
    movq %rax, (%rdi)
    callq _atoi
    subq %rax, -24(%rbp)
    incq -8(%rbp)
    jmp .Lnext
.Ldown:
    addq $5, -8(%rbp)
    movq -8(%rbp), %rax
    leaq .Lstr(%rip), %rdi
    movq (%rax), %rax
    movq %rax, (%rdi)
    callq _atoi
    addq %rax, -24(%rbp)
    incq -8(%rbp)
    jmp .Lnext
.Lnext:
    incq -8(%rbp)
    movq -8(%rbp), %rax
    cmpq $0, (%rax)
    jnz .Lloop
.Lend:
    movq -16(%rbp), %rax
    movq -24(%rbp), %rcx
    imulq %rcx, %rax
    movq %rbp, %rsp
    popq %rbp
    retq

    .text
    .globl _soln2
_soln2:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movq %rdi, -8(%rbp)  // pointer to buffer
    movq $0, -16(%rbp)   // horizontal position
    movq $0, -24(%rbp)   // depth
    movq $0, -32(%rbp)   // aim
.Lloop2:
    movq -8(%rbp), %rax
    cmpb $0x66, (%rax)   // [f]orward
    je .Lforward2
    cmpb $0x75, (%rax)   // [u]p
    je .Lup2
    cmpb $0x64, (%rax)   // [d]own
    je .Ldown2
    movq $1, %rdi        // unknown command, call exit(1)
    callq _exit
.Lforward2:
    addq $8, -8(%rbp)
    movq -8(%rbp), %rax
    leaq .Lstr(%rip), %rdi
    movq (%rax), %rax
    movq %rax, (%rdi)
    callq _atoi
    addq %rax, -16(%rbp)
    imulq -32(%rbp), %rax
    addq %rax, -24(%rbp)
    incq -8(%rbp)
    jmp .Lnext2
.Lup2:
    addq $3, -8(%rbp)
    movq -8(%rbp), %rax
    leaq .Lstr(%rip), %rdi
    movq (%rax), %rax
    movq %rax, (%rdi)
    callq _atoi
    subq %rax, -32(%rbp)
    incq -8(%rbp)
    jmp .Lnext2
.Ldown2:
    addq $5, -8(%rbp)
    movq -8(%rbp), %rax
    leaq .Lstr(%rip), %rdi
    movq (%rax), %rax
    movq %rax, (%rdi)
    callq _atoi
    addq %rax, -32(%rbp)
    incq -8(%rbp)
    jmp .Lnext2
.Lnext2:
    incq -8(%rbp)
    movq -8(%rbp), %rax
    cmpq $0, (%rax)
    jnz .Lloop2
.Lend2:
    movq -16(%rbp), %rax
    movq -24(%rbp), %rcx
    imulq %rcx, %rax
    movq %rbp, %rsp
    popq %rbp
    retq
