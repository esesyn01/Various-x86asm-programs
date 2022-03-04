public suma_siedmiu_liczb
.code
suma_siedmiu_liczb PROC
push rbp
mov rbp,rsp
add rcx,rdx
add rcx,r8
add rcx,r9
mov rdx,[rbp+48]
mov r8,[rbp+56]
mov r9,[rbp+64]
add rcx,rdx
add rcx,r8
add rcx,r9
mov rax,rcx
pop rbp
ret
suma_siedmiu_liczb ENDP
END