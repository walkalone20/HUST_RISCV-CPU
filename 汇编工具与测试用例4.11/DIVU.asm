#divu mflo����   11110000 /2/2/2  ....  revise date:2021/1/24 tiger
#�������0x11110000 0x08888000 0x04444000 0x02222000 0x01111000 0x00888800 0x00444400 0x00222200 0x00111100 0x00088880 0x00044440 0x00022220 0x00011110 0x00008888 0x00004444 0x00002222 0x00001111 0x00000888 0x00000444 0x00000222 0x00000111 0x00000088 0x00000044 0x00000022 0x00000011 0x00000008 0x00000004 0x00000002 0x00000001
.text

addi t0,zero,2     # /2
addi s1,zero,  0x11
slli s1,s1,8
addi s1,s1,0x11 
slli s1,s1,16

add a0,zero,s1           
addi a7,zero,34         
ecall                  
addi t3,zero,28         #ѭ������

divu_branch:
 divu s1,s1,t0             #����ָ��
 add a0,zero,s1          
 addi a7,zero,34         
 ecall                  #�����ǰֵ
 addi t3,t3, -1    
 bne t3,zero,divu_branch   #ѭ��


addi   a7,zero,10         
ecall                  # ��ͣ���˳�
