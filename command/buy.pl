#_/_/_/_/_/_/_/_/#
#      売買      #
#_/_/_/_/_/_/_/_/#

sub BUY {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN($kcon);

	&HEADER;
	$no = $in{'no'} + 1;

	$get_sol1 = $kgold;
	$get_sol2 = $krice;
	if($get_sol1 > 3000){
		$get_sol1 = 3000;
	}
	if($get_sol2 > 3000){
		$get_sol2 = 3000;
	}
	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>"
	}

	$sou1 = $zsouba*100;
	$sou2 = int((2.0-$zsouba)*100);


	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 米・金取引 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>いらっしゃいませ。<BR>ここは米と金を交換する場所です。<BR>現在の相場は<BR>
米100に対して金<font color=red>$sou1</font><BR>
金100に対して米<font color=red>$sou2</font><BR>

で買い取ります。<BR>１回の取引で売り買いできるのは最大で３０００までです。<BR>いかほど交換致しましょうか？</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
<form action="$COMMAND" method="POST"><B>\[米を売る\]</B><BR>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
米<input type=text name=num value=$get_sol2 size=4>
$no_list
<input type=hidden name=mode value=19>
<input type=hidden name=type value=1>
<input type=submit value=\"米を売る\"></form>

<form action="$COMMAND" method="POST"><B>\[金を売る\]</B><BR>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
金<input type=text name=num value=$get_sol1 size=4>
$no_list
<input type=hidden name=mode value=19>
<input type=hidden name=type value=0>
<input type=submit value=\"金を売る\"></form>


<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;

}
1;