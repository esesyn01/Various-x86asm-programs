public dood
.code
dood proc
push rbp
mov rbp,rsp
push rbx
mov rbx,48
mov rax,0
cmp rcx,0
je koniec
ptl:
add rax,rdx
mov rdx,r8
mov r8,r9
mov r9,[rbp][rbx]
add rbx,8
loop ptl
koniec:
pop rbx
pop rbp
ret
dood endp
end