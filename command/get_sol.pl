#_/_/_/_/_/_/_/_/#
#      徴兵      #
#_/_/_/_/_/_/_/_/#

sub GET_SOL {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
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
<font color=ffffff> - 徴 兵 - </font>
</TH></TR>
<TR><TD>
$no_list
<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>兵士を徴兵します。<BR>種類の違う兵を雇うと以前まで雇っていた兵は解雇されます。<BR>毎月維持費として兵１人につき米１を消費します。</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
何名雇いますか？(※最大$klea人)
<TABLE bgcolor=$TABLE_C><TBODY bgcolor=$TD_C3>
<TR><TH>種類</TH><TH>攻撃力</TH><TH>防御力</TH><TH>雇用金</TH><TH>人数</TH><TD></TD></TR>
<TR><TH>$SOL_TYPE[0]</TD><TH>△</TH><TH>△</TH><TH>金 $SOL_PRICE[0]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=0>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>
EOM

	if($zsub1 > 100){
print <<"EOM";
<TR><TH>$SOL_TYPE[1]</TD><TH>○</TH><TH>△</TH><TH>金 $SOL_PRICE[1]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=1>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>
EOM
	}
	if($zsub1 > 200){

print <<"EOM";
<TR><TH>$SOL_TYPE[2]</TD><TH>△</TH><TH>◎</TH><TH>金 $SOL_PRICE[2]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=2>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>
EOM
	}
	if($zsub1 > 300){

print <<"EOM";
<TR><TH>$SOL_TYPE[3]</TD><TH>◎</TH><TH>○</TH><TH>金 $SOL_PRICE[3]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=3>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>
EOM
	}

	if($zsub1 > 400){
print <<"EOM";
<TR><TH>$SOL_TYPE[4]</TD><TH>●</TH><TH>△</TH><TH>金 $SOL_PRICE[4]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=4>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>
EOM
	}
	if($zsub1 > 500){

print <<"EOM";
<TR><TH>$SOL_TYPE[5]</TD><TH colspan=2>知力が武力に加算</TH><TH>金 $SOL_PRICE[5]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=5>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>
EOM
	}

print <<"EOM";
</TABLE>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM
	}else{
print <<"EOM";
<h3>- 徴 兵 - </h3>
[$kname]<BR>
金:$kgold<BR>
米:$krice<BR>
兵士:$ksol<BR>
訓練:$kgat<BR>
<p>
何名雇いますか？(※最大$klea人)<BR><BR>
種類:攻撃力:防御力:雇用金:人数<BR><BR>
$SOL_TYPE[0]:△:△:金 $SOL_PRICE[0]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=0>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>
EOM

	if($zsub1 > 100){
print <<"EOM";

$SOL_TYPE[1]:○:△:金 $SOL_PRICE[1]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=1>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>
EOM
	}
	if($zsub1 > 200){
print <<"EOM";

$SOL_TYPE[2]:△:◎:金 $SOL_PRICE[2]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=2>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>
EOM
	}
	if($zsub1 > 300){
print <<"EOM";

$SOL_TYPE[3]:◎:○:金 $SOL_PRICE[3]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=3>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>
EOM
	}
	if($zsub1 > 400){
print <<"EOM";

$SOL_TYPE[4]:●:△:金 $SOL_PRICE[4]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=4>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>
EOM
	}
	if($zsub1 > 500){
print <<"EOM";

$SOL_TYPE[5]:知力が武力に加算:金 $SOL_PRICE[5]:<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
<input type=hidden name=no value=$in{'no'}>
<input type=hidden name=type value=5>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>
EOM
	}
print <<"EOM";

<BR>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>

EOM
	}
	&FOOTER;

	exit;

}
1;