#SRLV��λ����    revise date:2021/1/24 tiger
#�������  0x87600000 0x08760000 0x00876000 0x00087600 0x00008760 0x00000876 0x00000087 0x00000008 0x00000000
.text

addi t0,zero,1     #sllv ��λ����
addi t1,zero,3     #sllv ��λ����
addi s1,zero,  0x8
slli s1,s1,8
addi s1,s1,0x76     

slli s1,s1,20     #

add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print

addi t3,zero,8

srl_branch:
srl s1,s1,t0     #����1λ
srl s1,s1,t1     #����3λ
add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall                  # print
addi t3,t3, -1    
bne t3,zero,srl_branch   #ѭ��8��

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   
