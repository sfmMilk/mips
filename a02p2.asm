#include <iostream>
#using namespace std;

#int  a1[12],
#    a2[12],
#    a3[12];
		.data
a1:		.space 48
a2:		.space 48
a3:		.space


#int  found,
#    i2chk,
#    used1,
#    used2,
#    used3;
#int* hopPtr1;
#int* hopPtr2;
#int* hopPtr3;
#int* hopPtr11;
#int* hopPtr22;
#int* hopPtr23;
#int* endPtr1;
#int* endPtr2;
#int* endPtr3;

#char yesNo;
#char begA1Str[] = "\nbeginning a1: ";
#char proA1Str[] = "processed a1: ";
#char comA2Str[] = "********* a2: ";
#char comA3Str[] = "********* a3: ";
#char einStr[]   = "Enter integer #";
#char moStr[]    = "Max of ";
#char ieStr[]    = " ints entered...";
#char emiStr[]   = "Enter more ints? (n or N = no, others = yes) ";
#char dacStr[]   = "Do another case? (n or N = no, others = yes) ";
#char dlStr[]    = "================================";
#char byeStr[]   = "bye...";

begA1Str:		.asciiz "\nbeginning a1: "
proA1Str:		.asciiz "processed a1: "
comA2Str:		.asciiz "********* a2: "
comA3Str:		.asciiz "********* a3: "
einStr:			.asciiz "Enter integer #"
ieStr:			.asciiz " ints entered..."
emiStr:			.asciiz "Enter more ints? (n or N = no, others = yes) "
dacStr:			.asciiz "Do another case? (n or N = no, others = yes) "
dlStr:			.asciiz "================================"
byeStr:			.asciiz "bye..."

################################################
# Register usage:
#################
# $a1: endPtr1
# $a2: endPtr2
# $a3: endPtr3
# $t0: temp holder
# $t1: used1
# $t2: used2
# $t3: used3
# $t4: hopPtr1
# $t5: hopPtr2 or found (non-overlappingly)
# $t6: hopPtr11 or hopPtr22 (non-overlappingly)
# $t7: hopPtr3 or hopPtr23 (non-overlappingly)
# $t8: yesNo or i2chk (non-overlappingly)
# $t9: temp holder
# $v1: temp holder 
################################################

#int main()
			.globl main
main:

begDW1:
	#used1 = 0;
	#hopPtr1 = a1;
	li $t1, 0
	la $t4, a1
#//              do
begDW2:
#  cout << einStr;
#  cout << (used1 + 1);
#  cout << ':' << ' ';
#  cin >> *hopPtr1;
#  ++used1;
#  ++hopPtr1;

	li $v0, 4
	la $a0, einStr
	syscall
	
	add $t0, $t1, 1
	li $v0, 1
	add $a0, $t0, $zero
	syscall
	
	li $v0, 11
	li $a0, ':' #check if this is valid later
	syscall
	li $v0, 11
	li $a0, ' ' #check if this is valid later
	syscall
	
	li $v0, 5
	syscall
	sw $v0, 0($t4)
	
	addi $t1, $t1, 1
	addi $t4, $t4, 4
	
	
	
#  if (used1 != 12) goto else1;
	li $t0, 12
	bne $t1, $t0, else1
begI1:
#       cout << moStr;
#       cout << 12;
#       cout << ieStr;
#       cout << endl;
#       yesNo = 'n';

	li $v0, 4
	la $a0, moStr
	syscall
	
	li $v0, 1
	la $a0, 12
	syscall
	
	li $v0, 4
	la $a0, ieStr
	syscall
	
	li $v0, 4
	li $a0, "\n"
	syscall
	
	li $t8, 'n'
	
#	goto endI1;    
	j endI1

else1:
#  cout << emiStr;
#  cin >> yesNo;
	li $v0, 4
	la $a0, emiStr
	syscall
	
	li $v0, 12
	syscall
	add $t8, $v0, $zero
	
endI1:

DWTest2:
#//     while (yesNo != 'n' && yesNo != 'N');

#  if (yesNo == 'n') goto xitDW2;
#  if (yesNo != 'N')goto begDW2;
	li $t0, 'n'
	beq  $t8, $t0, xitDW2
	li $t0, 'N'
	bne $t8, $t0, begDW2

xitDW2:
#  cout << begA1Str;
#  hopPtr1 = a1;
#  endPtr1 = a1 + used1;
	
	li $v0, 4
	la $a0, begA1Str
	syscall
	
	la $t4, a1
	
	sll $t0, $t1, 2
	add $a1, $t4, $t0
	
	
#//     while (hopPtr1 < endPtr1)

#  goto WTest1;
	j WTest1
	
begW1:
#  if (hopPtr1 != endPtr1 - 1) goto else2;
	
	addi $t0, $a1, -4
	bne $t4, $t0, else2
	
begI2:
#  cout << *hopPtr1 << endl;
#  goto endI2;
	
	li $v0, 1
	lw $a0, 0($t4)
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	j endI2
	
else2:
#       cout << *hopPtr1 << ' ';
	li $v0, 1
	lw $a0, 0($t4)
	syscall
	
	li $v0, 11
	li $a0, ' '
	syscall
	
endI2:
#  ++hopPtr1;
	addi $t4, $t4, 4
WTest1:
#  if (hopPtr1 < endPtr1) goto begW1;
	slt $t0, $t4, $a1
	bne $t0, $zero begW1

#//              for (hopPtr1 = a1, hopPtr2 = a2, used2 = 0; // multiple initializations
#//                   hopPtr1 < endPtr1;                     // loop test
#//                   ++hopPtr1, ++hopPtr2, ++used2)         // multiple updates
#  hopPtr1 = a1;
#  hopPtr2 = a2;
#  used2 = 0; // multiple initializations
#  goto FTest1;
   la $t4, a1
   la $t5, a2
   li $t2, $zero
   j FTest1
begF1:

#  *hopPtr2 = *hopPtr1;
#  ++hopPtr1;
#  ++hopPtr2;
#  ++used2;         // multiple updates
   lw $t0, 0($t4)
   sw $t0, 0($t5)
   addi $t4, $t4, 4
   addi $t5, $t5, 4
   addi $t2, $t2, 1


FTest1:
#  if (hopPtr1 < endPtr1) goto begF1;                     // loop test
   slt $t0, $t4, $a1
   bne $t0, $zero, begF1
#  hopPtr2 = a2;
#  endPtr2 = a2 + used2;
   la $t5, a2
   sll $t0, $t2, 2
   add $a2, $t0, $t0

#//              while (hopPtr2 < endPtr2)
# goto WTest2;
j WTest2

begW2:
#  i2chk = *hopPtr2;
   lw $t8, 0($t5)
#  //                 for (hopPtr22 = hopPtr2 + 1; hopPtr22 < endPtr2; ++hopPtr22)
#  hopPtr22 = hopPtr2 + 1; 
#  goto FTest2;
   addi $t6, $t5, 4
   j FTest2
begF2:
#//                    if (*hopPtr22 == i2chk)
#  if (*hopPtr22 != i2chk) goto endI3;
   lw $t0, 0($t6)
   bne $t0, $t8, endI3
befI3:
#//                       for (hopPtr23 = hopPtr22 + 1; hopPtr23 < endPtr2; ++hopPtr23)
#  hopPtr23 = hopPtr22 + 1;
#  goto FTest3;
   addi $t7, $t6, 2
   j FTest3
begF3:
#  *(hopPtr23 - 1) = *hopPtr23;
#  ++hopPtr23;
addi $t9, $t7, -4
lw $t0, 0($t7)
sw $t0, 0($t9)
addi $t7, $t7, 4

FTest3:
#  if (hopPtr23 < endPtr2) goto begF3;
   slt $t0, $t7, $a2
   bne $t0, $zero, begF3

#  --used2;
#  --endPtr2;
#  --hopPtr22;
   addi $t2, $t2, -1
   addi $t5, $t5, -4
   addi $t6, $t6, -4
endI3://              }
                   ++hopPtr22;
//                 }
FTest2:
                   if (hopPtr22 < endPtr2) goto begF2;

                   ++hopPtr2;
//              }
WTest2:
                if (hopPtr2 < endPtr2) goto begW2;

                used3 = 0;
                hopPtr3 = a3;
                hopPtr1 = a1;
//              while (hopPtr1 < endPtr1)
                goto WTest3;
begW3://        {
                   *hopPtr3 = *hopPtr1;
                   ++used3;
                   ++hopPtr3;
                   i2chk = *hopPtr1;
                   found = 0;
//                 for (hopPtr11 = hopPtr1 + 1; hopPtr11 < endPtr1; ++hopPtr11)
                   hopPtr11 = hopPtr1 + 1;
                   goto FTest4;
begF4://           {
//                    if (*hopPtr11 == i2chk)
                      if (*hopPtr11 != i2chk) goto else4;
begI4://              {
                         ++found;
                      goto endI4;
//                    }
else4://              else
//                    {
                         *(hopPtr11 - found) = *hopPtr11;
endI4://              }
                   ++hopPtr11;
//                 }
FTest4:
                   if (hopPtr11 < endPtr1) goto begF4;

                   used1 -= found;
                   endPtr1 -= found;
                   ++hopPtr1;
//              }
WTest3:
                if (hopPtr1 < endPtr1) goto begW3;

                cout << proA1Str;
//              for (hopPtr1 = a1; hopPtr1 < endPtr1; ++hopPtr1)
                hopPtr1 = a1;
                goto FTest5;
begF5://         {
//                 if (hopPtr1 == endPtr1 - 1)
                   if (hopPtr1 != endPtr1 - 1) goto else5;
begI5://           {
                      cout << *hopPtr1 << endl;
                   goto endI5;
//                 }
else5://           else
//                 {
                      cout << *hopPtr1 << ' ';
endI5://           }
                ++hopPtr1;
//              }
FTest5:
                if (hopPtr1 < endPtr1) goto begF5;

                cout << comA2Str;
//              for (hopPtr2 = a2; hopPtr2 < endPtr2; ++hopPtr2)
                hopPtr2 = a2;
                goto FTest6;
begF6://        {
//                 if (hopPtr2 == endPtr2 - 1)
                   if (hopPtr2 != endPtr2 - 1) goto else6;
begI6://           {
                      cout << *hopPtr2 << endl;
                   goto endI6;
//                 }
else6://           else
//                 {
                      cout << *hopPtr2 << ' ';
endI6://           }
                ++hopPtr2;
//              }
FTest6:
                if (hopPtr2 < endPtr2) goto begF6;

                cout << comA3Str;
                hopPtr3 = a3;
                endPtr3 = a3 + used3;
//              while (hopPtr3 < endPtr3)
                goto WTest4;
begW4://        {
//                 if (hopPtr3 == endPtr3 - 1)
                   if (hopPtr3 != endPtr3 - 1) goto else7;
begI7://           {
                      cout << *hopPtr3 << endl;
                   goto endI7;
//                 }
else7://           else
//                 {
                      cout << *hopPtr3 << ' ';
endI7://           }
                   ++hopPtr3;
//              }
WTest4:
                if (hopPtr3 < endPtr3) goto begW4;

                cout << endl;
                cout << dacStr;
                cin >> yesNo;
                cout << endl;
//           }
DWTest1:
//           while (yesNo != 'n' && yesNo != 'N');
////         if (yesNo != 'n' && yesNo != 'N') goto begDW1;
             if (yesNo == 'n') goto xitDW1;
             if (yesNo != 'N') goto begDW1;
xitDW1:

             cout << dlStr;
             cout << '\n';
             cout << byeStr;
             cout << '\n';
             cout << dlStr;
             cout << '\n';

             return 0;
}