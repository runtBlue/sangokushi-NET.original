#_/_/_/_/_/_/_/_/#
#      書籍      #
#_/_/_/_/_/_/_/_/#

sub DEF_BUY {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&TIME_DATA;

	open(IN,"$PRO_LIST");
	@PRO_DATA = <IN>;
	close(IN);
	($proname2,$proval2) = split(/<>/,$PRO_DATA[$kbook]);
	$proval2 = int($proval2 * 0.6);
	if($kvsub2 eq 0){$proval2 = int($proval2 / 10);}
	&HEADER;
	$no = $in{'no'} + 1;

	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>"
	}

	$get_sol = $klea - $ksol;
	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 書 庫 - </font>
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
<font color=white>いらっしゃい。<BR>ここではめったにお目にかかれない貴重な書籍を売ってるよ。<BR>現在$knameが装備している$proname2は金<font color=red>$proval2</font>で下取るよ。<BR>是非手にとって見ておくれ。<BR></font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
<form action="$COMMAND" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<TABLE bgcolor=$TABLE_C>
EOM

	open(IN,"$PRO_LIST") or &ERR('ファイルを開けませんでした。');
	@PRO_DATA = <IN>;
	close(IN);

	$list = "<TR><TD bgcolor=$TD_C1>選択</TD><TD bgcolor=$TD_C2>名称</TD><TD align=right bgcolor=$TD_C3>値段</TD><TD bgcolor=$TD_C2>効果</TD></TR>";
	$s_i=0;
	foreach(@PRO_DATA){
		($armname,$armval,$armdmg,$armwei,$armele,$armsta,$armclass,$armtownid) = split(/<>/);
		if($kvsub2 eq 0){$armval = int($armval / 10);}
		if($armtownid eq 0){
			$list .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=$s_i></TD><TD bgcolor=$TD_C2>$armname</TD><TD align=right bgcolor=$TD_C3>金 $armval</TD><TD bgcolor=$TD_C2>$armdmg</TD></TR>";
		}
		$s_i++;
	}


print <<"EOM";
$list
</TABLE>
$no_list
<input type=hidden name=mode value=23>
<input type=submit value=\"購入\"></form>


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