#_/_/_/_/_/_/_/_/#
#      ����      #
#_/_/_/_/_/_/_/_/#

sub GET_SOL {

	if($in{'no'} eq ""){&ERR("NO:�����͂���Ă��܂���B");}
	require 'ini_file/com_list.ini';

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN($kpos);
	&TIME_DATA;

	&HEADER;
	$no = $in{'no'} + 1;

	$get_sol = $klea - $ksol;

	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>"
	}
	if("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/status.cgi"){ 
	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - �� �� - </font>
</TH></TR>
<TR><TD>
$no_list
<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>����</TD><TH>$kstr</TH><TD>�m��</TD><TH>$kint</TH><TD>������</TD><TH>$klea</TH></TR>
<TR><TD>��</TD><TH>$kgold</TH><TD>��</TD><TH>$krice</TH><TD>�v��</TD><TH>$kcex</TH></TR>
<TR><TD>������</TD><TH colspan=2>$cou_name[$kcon]��</TH><TD>���m</TD><TH>$ksol</TH><TD>�P��</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>���m�𒥕����܂��B<BR>��ނ̈Ⴄ�����ق��ƈȑO�܂Ōق��Ă������͉��ق���܂��B<BR>�����ێ���Ƃ��ĕ��P�l�ɂ��ĂP������܂��B</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
�����ق��܂����H(���ő�$klea�l)
<TABLE bgcolor=$TABLE_C><TBODY bgcolor=$TD_C3>
<TR><TH>���</TH><TH>�U����</TH><TH>�h���</TH><TH>�ٗp��</TH><TH>�l��</TH><TD></TD></TR>
<TR><TH>$SOL_TYPE[0]</TD><TH>��</TH><TH>��</TH><TH>�� $SOL_PRICE[0]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
$no_list
<input type=hidden name=type value=0>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"�ق�\"></TD></form></TR>
EOM

	if($zsub1 > 100){
print <<"EOM";
<TR><TH>$SOL_TYPE[1]</TD><TH>��</TH><TH>��</TH><TH>�� $SOL_PRICE[1]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
$no_list
<input type=hidden name=type value=1>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"�ق�\"></TD></form></TR>
EOM
	}
	if($zsub1 > 200){

print <<"EOM";
<TR><TH>$SOL_TYPE[2]</TD><TH>��</TH><TH>��</TH><TH>�� $SOL_PRICE[2]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
$no_list
<input type=hidden name=type value=2>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"�ق�\"></TD></form></TR>
EOM
	}
	if($zsub1 > 300){

print <<"EOM";
<TR><TH>$SOL_TYPE[3]</TD><TH>��</TH><TH>��</TH><TH>�� $SOL_PRICE[3]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
$no_list
<input type=hidden name=type value=3>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"�ق�\"></TD></form></TR>
EOM
	}

	if($zsub1 > 400){
print <<"EOM";
<TR><TH>$SOL_TYPE[4]</TD><TH>��</TH><TH>��</TH><TH>�� $SOL_PRICE[4]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
$no_list
<input type=hidden name=type value=4>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"�ق�\"></TD></form></TR>
EOM
	}
	if($zsub1 > 500){

print <<"EOM";
<TR><TH>$SOL_TYPE[5]</TD><TH colspan=2>�m�͂����͂ɉ��Z</TH><TH>�� $SOL_PRICE[5]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
$no_list
<input type=hidden name=type value=5>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"�ق�\"></TD></form></TR>
EOM
	}

print <<"EOM";
</TABLE>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="�߂�"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM
	}else{
print <<"EOM";
<h3>- �� �� - </h3>
[$kname]<BR>
��:$kgold<BR>
��:$krice<BR>
���m:$ksol<BR>
�P��:$kgat<BR>
<p>
�����ق��܂����H(���ő�$klea�l)<BR><BR>
���:�U����:�h���:�ٗp��:�l��<BR><BR>
$SOL_TYPE[0]:��:��:�� $SOL_PRICE[0]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=0>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"�ق�\"></form>
EOM

	if($zsub1 > 100){
print <<"EOM";

$SOL_TYPE[1]:��:��:�� $SOL_PRICE[1]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=1>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"�ق�\"></form>
EOM
	}
	if($zsub1 > 200){
print <<"EOM";

$SOL_TYPE[2]:��:��:�� $SOL_PRICE[2]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=2>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"�ق�\"></form>
EOM
	}
	if($zsub1 > 300){
print <<"EOM";

$SOL_TYPE[3]:��:��:�� $SOL_PRICE[3]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=3>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"�ق�\"></form>
EOM
	}
	if($zsub1 > 400){
print <<"EOM";

$SOL_TYPE[4]:��:��:�� $SOL_PRICE[4]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=4>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"�ق�\"></form>
EOM
	}
	if($zsub1 > 500){
print <<"EOM";

$SOL_TYPE[5]:�m�͂����͂ɉ��Z:�� $SOL_PRICE[5]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>�l
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=5>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"�ق�\"></form>
EOM
	}
print <<"EOM";

<BR>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="�߂�"></form>

EOM
	}
	&FOOTER;

	exit;

}
1;