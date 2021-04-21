Program SP5H25;

uses crt;

const max=101;      {The maximum participants the program can hold}
      bottom=2000;  {The lower boundary of the year of graduation, assume year 2000 is the first F6 student graduate}
      top=2008;     {The higher boundary of the year of graduation}
      maxtb=100;    {the maximum table can be set up in the program}
      delaytime=600;{the time for delay function, for making the UI}

type
   participantsinfo = record
                         name:string[25];
                         sex:string[1];    {participants' gender}
                         grad:integer;     {participants' year of graduation}
                         seats:integer;    {participants' seat employed}
                      end;

var
   info:array[-1..max]of participantsinfo;
   maxseats,i,j,count,index,tbid,seat,sum,code,ptr:integer;
   key:char;
   test:string;
   run:boolean;
   pass:array[1..max]of boolean;
   table:array[1..maxtb,1..max]of integer;
   doc:text;



Procedure Cover;  {This procedure use to make the title page of the program}
Begin
   gotoxy(24,3);
   textcolor(12);
   writeln('     _______. _______      ___   .___________. __  .__   __.   _______ ');
   gotoxy(24,4);
   textcolor(14);
   writeln('    /       ||   ____|    /   \  |           ||  | |  \ |  |  /  _____|');
   gotoxy(24,5);
   textcolor(9);
   writeln('   |   (----`|  |__      /  ^  \ `---|  |----`|  | |   \|  | |  |  __  ');
   gotoxy(24,6);
   textcolor(10);
   writeln('    \   \    |   __|    /  /_\  \    |  |     |  | |  . `  | |  | |_ | ');
   gotoxy(24,7);
   textcolor(11);
   writeln('.----)   |   |  |____  /  _____  \   |  |     |  | |  |\   | |  |__| | ');
   gotoxy(24,8);
   textcolor(13);
   writeln('|_______/    |_______|/__/     \__\  |__|     |__| |__| \__|  \______| ');
   gotoxy(39,10);
   textcolor(12);
   writeln('.______    __           ___      .__   __.');
   gotoxy(39,11);
   textcolor(14);
   writeln('|   _  \  |  |         /   \     |  \ |  |');
   gotoxy(39,12);
   textcolor(9);
   writeln('|  |_)  | |  |        /  ^  \    |   \|  |');
   gotoxy(39,13);
   textcolor(10);
   writeln('|   ___/  |  |       /  /_\  \   |  . `  |');
   gotoxy(39,14);
   textcolor(11);
   writeln('|  |      |  `----. /  _____  \  |  |\   |');
   gotoxy(39,15);
   textcolor(13);
   writeln('| _|      |_______|/__/     \__\ |__| \__|');
   writeln;
   writeln;
   delay(delaytime);
   textcolor(14);
   writeln('Allocation Rule');  {The allocation rule which are going to be performed by the program}
   delay(delaytime);
   textcolor(11);
   writeln('1.The program will group employed participants together');
   delay(delaytime);
   writeln('2.The program will group the same year of graduation participants');
   delay(delaytime);
   writeln('3.The program will group the same sex participants');
   delay(delaytime);
   writeln('4.The program may not export a perfect seating plan');
   delay(delaytime);
   gotoxy(42,25);
   textcolor(7);
   writeln('<Click anywhere to start the program>');
   readkey;
   clrscr;
end;
   
Procedure Viewinfo;   {This procedure is mainly use in code and debug the program, won't use in normal time}
Begin
   textcolor(white);
   writeln('Name':20,'sex':25,'Year of graduation':30,'Seat employment':30);
   for i:=1 to max do
   Begin
      with info[i]do
      Begin
         writeln(name:25,sex:20,grad:25,seats:25);    {Display all the information that the program have received}
      end;
   end;
   readln;
end;


Procedure Checkblank;    {It use to see where is the blank in the participants list}
Begin
   i:=0;
   repeat
   i:=i+1;
   until info[i].name='';
   index:=i;
end;


Procedure validate;    {This procedure validate the input data, to see if it is pass or not, and cooperate with the other procedure}
Begin
   i:=1;
   while info[i].name <> ''do
   Begin
      if (info[i].sex ='M') or (info[i].sex ='m') or (info[i].sex ='F') or (info[i].sex ='f')
      then pass[i]:=true        {only allow 'M','m','F'and'f' input}
      else pass[i]:=false;
      If ((info[i].grad>=bottom-1) and (info[i].grad<=top))
      then pass[i]:=true        {only allow the year between 1999 and 2017}
      else pass[i]:=false;      {Bottom-1 is allowed because teacher and other staff is count as 1999}
      i:=i+1;
   end;
end;


Procedure import;    {This procedure is responsible for inputting data}
var
   strtemp:string;
   code:integer;
   wholedata:array[1..max]of string;

Begin
   writeln('Importing data');
   assign(doc, 'partinfo.txt');
   reset(doc);
   info[0].name:='--';
   count:=0;
   while not eof(doc) do
   Begin
      count:=count+1;       {First, the procedure will store each row of the data in the variable}
      readln(doc, wholedata[count]);
   end;
   close(doc);
   maxseats:=0;
   For i:=1 to count do     {Second, the procedure will sort the data into different information}
   Begin
      with info[i] do
      Begin
         j:=pos(',',wholedata[i]);
         name:=copy(wholedata[i],1,j-1);   {sort the name out}
         sex:=copy(wholedata[i],j+1,1);    {sort the gender out}
         strtemp:=copy(wholedata[i],j+3,4);
         val(strtemp,grad,code);           {sort the year of graduation out}
         strtemp:=copy(wholedata[i],j+8,1);
         val(strtemp,seats,code);
         If seats>=maxseats
         then maxseats:=seats;        {sort the seats employed by the participants out}
      end;
   end;
   textcolor(yellow);
   writeln('Job done!');
end;


Procedure viewname;     {This responsible for display the name of participants in the left column}
Begin
   validate;
   clrscr;
   Window(5,2,50,max+4);     {The place where the name will display out}
   textcolor(yellow);
   writeln('Name List:':4);
   i:=1;
   while info[i].name <> '' do     {Here will cooperate with 'validate'}
   Begin
      If pass[i]=true
      then Begin
              TextColor(white);    {white is no problem}
              writeln(i,'. ',info[i].name)
           end
      else Begin
              TextColor(Red);      {red is mean there is something wrong with this participants}
              writeln(i,'. ',info[i].name);
           end;
      delay(10);
      i:=i+1;
   end;
   TextColor(white);
end;



Procedure save;    {It is use to save the info after users edit the info of participants}
Begin
   i:=1;
   assign(doc, 'partinfo.txt');
   rewrite(doc);
   While info[i].name <> '' do
   Begin
      with info[i] do
      writeln(doc, name,',',sex,',',grad,',',seats);
      i:=i+1;
   end;
   close(doc);
end;

Procedure remove;      {This is use to remove the participants in list}
Begin
   clrscr;
   viewname;
   window(36,2,100,100);
   writeln('Which particiaants you want to remove?');
   writeln;
   textcolor(13);
   repeat
   write('(Input the ID of participants) ');   {Type the ID to remove}
   textcolor(white);
   readln(test);
   val(test,index,code);
   until (code=0)and (index<=count);
   for i:=index to max do      {sort up the participants, to ensure there is no blank info in between}
   Begin
      info[i].name:=info[i+1].name;
      info[i].sex:=info[i+1].sex;
      info[i].grad:=info[i+1].grad;
      info[i].seats:=info[i+1].seats;
   end;
   save;
end;

Procedure edit;    {It is use to edit the info of participants}
var ttemp:string;
Begin
   clrscr;
   viewname;
   window(36,2,100,100);
   write('Which participants you want to edit?');   {Input the ID of participants to edit}
   writeln;
   textcolor(13);
   repeat
   write('(Input the ID of participants) ');
   textcolor(white);
   readln(test);
   val(test,index,code);
   until (index>0) and (index<count) and (code=0);
   writeln;
   with info[index] do
   Begin
   writeln('Click ENTER for no change the name');
   writeln('Click ENTER for no change the name');
   writeln('Click ENTER for no change the name');
   delay(delaytime);
   ttemp:=name;
   write('Current name: ',name,'  New name: ');
   readln(name);
   If name=''    {no change the name for convenient the user}
   then name:=ttemp;
   Repeat
      write('Current sex: ',sex,'  New sex(M/F): ');      {update the gender of participants}
      readln(sex);
   until (sex = 'M') or (sex = 'F') or (sex = 'm') or (sex = 'f');
   Repeat
   write('Current year of graduation: ',info[index].grad,'  New year of graduation: ');    {update the year of graduation of participants}
   readln(test);
   val(test,grad,code);

   until ((grad<=top) and (grad>=bottom-1))and(code=0);

   Repeat
   write('Current seat employment: ',info[index].seats,'  New seat employment: ');    {update the no.of seat employed of participants}
   readln(seats);
   val(test,seats,code);
   until (seats<>0) and (code=0);
   end;
   save;
   writeln('Saved');
   writeln('Click any key to continue');
   readln;
   clrscr;
end;

Procedure add(last:integer);    {This procedure is use to add the new participants}
Begin

   clrscr;
   viewname;
   run:=true;
   While run=true do
   Begin
      window(36,2,100,100);
      with info[last] do
      Begin
         Repeat
            write('Name of the participants: ');
            readln(name);
         until name<>'';
         Repeat
            write('Sex(M/F): ');
            readln(sex);
         until (sex ='M') or (sex ='F') or (sex ='m') or (sex ='f') ;




         write('Year of graduation: ');
         readln(test);
         val(test,grad,code);
         While (grad>top) or (grad<bottom-1) or (code <>0)do
         Begin
            textcolor(red);      {notice user}
            writeln('You must input the year in the range between ',bottom-1,' and ',top,'!!!');
            textcolor(white);
            write('Year of graduation: ');
            readln(test);
            val(test,grad,code);
         end;


         write('No. of seat to book: ');
         readln(test);
         val(test,seats,code);
         While (seats<=0 )or (code<>0)do
         Begin
            textcolor(red);      {notice user}
            writeln('The value must bigger than ''1''');
            textcolor(white);
            write('No. of seat to book: ');
            readln(test);
            val(test,seats,code);
         end;
         save;
         textcolor(yellow);
         writeln('Action Done!');
         readln;
         textcolor(white);
         writeln('Do you want to add next?(Y/N)');
         key:=readkey;
         case key of
         'Y','y':add(bottom+1);   {repeat the same procedure to add participants}
         'N','n':run:=false;      {if false then leave the procedure}
         end;
      end;
   end;
end;
Procedure Firststep;   {Give user 2 method to input the participants list}
Begin
   gotoxy(5,4);
   textcolor(14);
   writeln('First Step:');
   gotoxy(15,8);
   delay(delaytime);
   textcolor(white);
   writeln('You can...');
   window(30,10,80,25);
   textcolor(white);
   writeln('------------------------------');
   writeln('1. Create a particiapant list');
   writeln;
   writeln('or');
   writeln;
   writeln('2. Import participant list');
   writeln('------------------------------');
   Repeat
   key:=readkey;
   If key = '2'
      then import
      else if key = '1'
           then Begin
                   checkblank;
                   clrscr;
                   viewname;
                   add(index);
                end;
   until (key='1') or (key='2') ;
   clrscr;
end;


Procedure Secondstep;      {The main function for user to add, remove, edit participants}
Begin
   clrscr;
   viewname;
   window(36,2,100,100);
   writeln;
   textcolor(cyan);
   writeln('Choose your action');
   writeln;
   delay(delaytime);
   textcolor(white);
   writeln('Add participants(A), Remove participants(R), Edit participants(E)');
   delay(delaytime);
   writeln('or Go to the next step(N)');
   delay(delaytime);
   writeln;
   write('Your choice: ');
   key:=readkey;
   delay(delaytime);
   writeln(key);
   delay(delaytime);
   Begin
      case key of      {it handle the user's choice}
      'A','a':Begin
                 checkblank;
                 add(index);
                 Secondstep;
              end;
      'R','r':Begin
                 remove;
                 Secondstep;
              end;
      'E','e':Begin
                 edit;
                 Secondstep;
              end;
      'N','n':Begin

              end;
      else Secondstep;
      end;
   end;
end;


Procedure sex;     {it allocate the seating plan by gender}
var MF:array[0..1,1..max]of integer;
    PTR0,PTR1:integer;
Begin
   clrscr;
   viewname;
   window(36,2,100,100);
   writeln;
   repeat
   writeln('How many seat you prefer in one table?   Your choice:    seat(s)');
   textcolor(13);
   writeln('(We recommend the value is within [30])');
   gotoxy(55,2);
   textcolor(white);
   readln(test);
   val(test,seat,code);
   until (seat>=maxseats) and (code=0) and (seat<50);
   clrscr;
   writeln('The number of seats per table is ',seat);     {Notice user}
   i:=1;
   PTR0:=1;
   PTR1:=1;
   ptr:=1;
   sum:=0;
   While info[i].name <> '' do
   Begin
      with info[i] do        {sort the information by gender, male participants in 0, female in 1}
      Begin
         If sex='F'
         then Begin
                 MF[0,PTR0]:=i;
                 PTR0:=PTR0+1;
              end
         else if sex='M'
              then Begin
                      MF[1,PTR1]:=i;
                      PTR1:=PTR1+1;
                   end;
      i:=i+1;
      end;
   end;
   PTR0:=1;PTR1:=1;tbid:=1;
   While MF[0,PTR0]<>0 do   {Handle the female participants}
   Begin
      sum:=sum+info[MF[0,PTR0]].seats;   {sum use to check whether the table is overflow or not}
      If sum < seat     {it is no problem if sum < seat}
      then Begin
              for i:=1 to info[MF[0,PTR0]].seats do
              Begin
                 table[tbid,ptr]:=MF[0,PTR0];     {Simply put the particiapnts in the table}
                 ptr:=ptr+1;       {pointer of seat go to the next one}
              end;
              PTR0:=PTR0+1;      {pointer of female go to the next one}
           end
      else If sum>seat    {There is a problem}
           then Begin
                   for i:=ptr to seat do {program know there is a overflow}
                   table[tbid,ptr]:=0;   {The remain seat will become empty}
                   tbid:=tbid+1;         {This participants will sit in a new table}
                   ptr:=1;
                   For i:=1 to info[MF[0,PTR0]].seats do
                   Begin
                      table[tbid,ptr]:=MF[0,PTR0];   {Simply put the particiapnts in the table}
                      ptr:=ptr+1;      {pointer of seat go to the next one}
                   end;
                   sum:=info[MF[0,PTR0]].seats;      {initial the 'sum' for next turn}
                   PTR0:=PTR0+1;    {pointer of female go to the next one}
                end
           else if sum=seat   {there isn't a problem}
                 then Begin
                         For i:=1 to info[MF[0,PTR0]].seats do
                         Begin
                            table[tbid,ptr]:=MF[0,PTR0];   {Simply put the particiapnts in the table}
                            ptr:=ptr+1;    {pointer of seat go to the next one}
                         end;
                         ptr:=1;    {initial back to 1 since the last table is full}
                         PTR0:=PTR0+1;    {pointer of female go to the next one}
                         tbid:=tbid+1;    {open a new table}
                         sum:=0;       {inital to 0 for the next turn}
                      end;
   end;
   While MF[1,PTR1]<>0 do    {Handle the male participants}
   Begin
      sum:=sum+info[MF[1,PTR1]].seats;    {sum use to check whether the table is overflow or not}
      If sum < seat     {it is no problem if sum < seat}
      then Begin
              for i:=1 to info[MF[1,PTR1]].seats do
              Begin
                 table[tbid,ptr]:=MF[1,PTR1];    {Simply put the particiapnts in the table}
                 ptr:=ptr+1;    {pointer of seat go to the next one}
              end;
              PTR1:=PTR1+1;    {pointer of male go to the next one}
           end
      else If sum>seat    {There is a problem}
           then Begin
                   for i:=ptr to seat do    {program know there is a overflow}
                   table[tbid,ptr]:=0;      {The remain seat in that table will become empty}
                   tbid:=tbid+1;            {This participants will sit in a new table}
                   ptr:=1;
                   For i:=1 to info[MF[1,PTR1]].seats do
                   Begin
                      table[tbid,ptr]:=MF[1,PTR1];    {Simply put the particiapnts in the table}
                      ptr:=ptr+1;     {pointer of seat go to the next one}
                   end;
                   sum:=info[MF[1,PTR1]].seats;    {initial the 'sum' for next turn}
                   PTR1:=PTR1+1;      {pointer of male go to the next one}
                end
           else if sum=seat    {there isn't a problem}
                 then Begin
                         For i:=1 to info[MF[1,PTR1]].seats do
                         Begin
                            table[tbid,ptr]:=MF[1,PTR1];     {Simply put the particiapnts in the table}
                            ptr:=ptr+1;       {pointer of seat go to the next one}
                         end;
                         ptr:=1;       {initial back to 1 since the last table is full}
                         PTR1:=PTR1+1;     {pointer of female go to the next one}
                         tbid:=tbid+1;     {open a new table}
                         sum:=0;       {inital to 0 for the next turn}
                      end;
   end;
   tbid:=1;
   writeln('---------------------');      {display the result of seat allocation}
   While table[tbid,1]<> 0 do
   Begin
      TextColor(yellow);
      writeln('Table ',tbid);       {show the table name}
      for I:=1 to seat do
      Begin
         TextColor(white);
         writeln(info[table[tbid,i]].name);   {show who is in that table}
      end;
      writeln('---------------------');
      readln;
      tbid:=tbid+1;
   end;
end;


Procedure grad;     {it allocate the seating by year of graduation}
var stack:array[bottom-1..top,1..max+1]of integer;      {sort year by year}
    year:integer;
Begin
   clrscr;
   viewname;
   window(36,2,100,100);
   writeln;
   repeat
   writeln('How many seat you prefer in one table?   Your choice:    seat(s)');
   textcolor(13);
   writeln('(We recommend the value is within [30])');
   gotoxy(55,2);
   textcolor(white);
   readln(test);
   val(test,seat,code);
   until (seat>=maxseats) and (code=0) and (seat<50);
   clrscr;
   writeln('The number of seats per table is ',seat);
   for year:=bottom to top do
   For i:=1 to max do
   stack[year,i]:=0;       {initial all the array}
   year:=bottom-1;
   While year<=top do         {sort participants and store in the array year by year}
   Begin
      index:=1;
      For i:=1 to max do
      If info[i].grad = year
      then Begin
              stack[year,index]:=i;
              index:=index+1;
           end;
      year:=year+1;
   end;

   tbid:=1;   {inital}
   sum:=0;
   ptr:=1;
   For year := bottom to top do
   Begin
      index:=1;
      Begin
         While stack[year,index]<>0 do   {not going to do the empty}
         Begin
            sum:=sum+info[stack[year,index]].seats;    {check if there is a overflow}
            If sum<seat     {no problem}
            then Begin
                    For i:=1 to info[stack[year,index]].seats do
                    Begin
                       table[tbid,ptr]:=stack[year,index];    {simply put the participants in the table}
                       ptr:=ptr+1;        {pointer of seat set to next one}
                    end;
                    index:=index+1;      {do the next participants}
                 end
            else If sum>seat      {there is a problem}
                 then Begin
                         for i:=ptr to seat do
                         table[tbid,ptr]:=0;  {The remain seat in that table will become empty}
                         tbid:=tbid+1;    {the participants will sit at the next table}
                         ptr:=1;   {the pointer of seat back to 1}
                         For i:=1 to info[stack[year,index]].seats do
                         Begin
                            table[tbid,ptr]:=stack[year,index];   {simply put the participants in the table}
                            ptr:=ptr+1;     {pointer of seat set to next one}
                         end;
                         sum:=info[stack[year,index]].seats;    {initial the 'sum' for next turn}
                         index:=index+1;     {pointer of the participants go to the next one}
                   end
            else if sum=seat   {no problem}
                 then Begin
                         For i:=1 to info[stack[year,index]].seats do
                         Begin
                            table[tbid,ptr]:=stack[year,index];   {simply put the participants in the table}
                            ptr:=ptr+1;    {pointer of seat set to next one}
                         end;
                         ptr:=1;    {the pointer of seat back to 1}
                         index:=index+1;    {pointer of the participants go to the next one}
                         tbid:=tbid+1;     {open a new table since the last one is fulled}
                         sum:=0;      {inital to 0 for the next turn}
                      end;
      end;
   end;
   end;
   tbid:=1;
   writeln('---------------------');       {show the participant in every table}
   While table[tbid,1]<> 0 do
   Begin
      TextColor(yellow);
      writeln('Table ',tbid);
      for I:=1 to seat do
      Begin
         TextColor(white);
         writeln(info[table[tbid,i]].name);
      end;
      writeln('---------------------');
      readln;
      tbid:=tbid+1;
   end;
end;


Procedure output;       {output the seating plan}
var txt:text;
    temp:integer;
Begin
   assign(txt, 'report.txt');
   rewrite(txt);
   tbid:=1;
   writeln(txt,'The number of seats per table is ',seat);   {the content of the file}
   writeln(txt, '**********************');
   Begin
      While table[tbid,1]<> 0 do
      Begin
         writeln(txt, 'Table ',tbid);
         for I:=1 to seat do
            writeln(txt, info[table[tbid,i]].name);     {the content of the file}
         writeln(txt, '***********************');
         tbid:=tbid+1;
      end;
      writeln(seat);
      close(txt);
   end;
   clrscr;
   writeln('Report is created!');
   delay(delaytime);
   writeln('Click anywhere to continue');
   readln;
   writeln;
   textcolor(cyan);
   writeln('Choose your action');     {allow user to see again the table}
   writeln;
   delay(delaytime);
   textcolor(white);
   writeln('1.View the specific table');
   writeln;
   delay(delaytime);
   writeln('2.View the whole list again');
   writeln;
   delay(delaytime);
   writeln('Or Click any key Go to the previous step');     {or go back to the second step}
   writeln;
   delay(delaytime);
   write('Your choice: ');
   key:=readkey;
   writeln(key);
      If key='1'
      then Begin
              Repeat
              write('Which table you want to see? ');      {choose the table user want to see}
              readln(test);
              val(test,temp,code);
              until (temp<tbid)and(temp>0)and(code=0);
              If table[temp,1]<> 0
              then Begin
                      writeln('---------------------');
                      TextColor(yellow);
                      writeln('Table ',temp);
                      for i:=1 to seat do
                      Begin
                         TextColor(white);
                         writeln(info[table[temp,i]].name);
                      end;
                      writeln('---------------------');
                      readln;
                   end
           end
              else If key='2'
                   then Begin                                        {see the whole table}
                           tbid:=1;
                           writeln('---------------------');
                           While table[tbid,1]<> 0 do
                           Begin
                              TextColor(yellow);
                              writeln('Table ',tbid);
                              for i:=1 to seat do
                              Begin
                                 TextColor(white);
                                 writeln(info[table[tbid,i]].name);
                              end;
                              writeln('---------------------');
                              tbid:=tbid+1;
                              readln;
                           end;
                        end;



end;


{main program}

Begin
   Cover;
   Firststep;
   validate;
   repeat
   Secondstep;
   clrscr;
   writeln('Here is two allocation method');
   writeln;
   delay(delaytime);
   writeln('1.By year of graduation');
   writeln;
   delay(delaytime);
   writeln('2.By gender');
   writeln;
   delay(delaytime);
   write('Your choice: ');
   writeln;
   delay(delaytime);
   key:=readkey;
   writeln(key);
   If key='1'
   then grad
   else if key='2'
        then sex;
   output;
   writeln('Click anywhere to continue');
   readln;
   until 2<1;
End.

