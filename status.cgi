#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

require 'jcode.pl';
require './ini_file/index.ini';
require './ini_file/com_list.ini';
require 'suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
if($mode eq 'STATUS') { &STATUS; }
else { &ERR("不正なアクセスです。"); }


#_/_/_/_/_/_/_/_/_/_/_/#
#_/  ステータス画面  _/#
#_/_/_/_/_/_/_/_/_/_/_/#

sub STATUS {

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&CHARA_ITEM_OPEN;
	&MAKE_GUEST_LIST;
	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	if($kos ne 1){
		&ERR2("認証が済んでいません。登録したメールアドレスに認証IDが添付されているので登録してください。");
	}
	open(IN,"$LOG_DIR/date_count.cgi") or &ERR('ファイルを開けませんでした。');
	@MONTH_DATA = <IN>;
	close(IN);

	($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
	$new_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);

	if($mmonth < 4){
		$bg_c = "#FFFFFF";
	}elsif($mmonth < 7){
		$bg_c = "#FFE0E0";
	}elsif($mmonth < 10){
		$bg_c = "#60AF60";
	}else{
		$bg_c = "#884422";
	}

	foreach(@TOWN_DATA){
		($z2name,$z2con,$z2num,$z2nou,$z2syo,$z2shiro)=split(/<>/);
		if($z2con eq $kcon){
				$zsyo_sal += int($z2syo * 8 * $z2num / 10000);
				$znou_sal += int($z2nou * 8 * $z2num / 10000);
		}
	}
	if($xking eq "$kid"){
		$rank_mes = "【君主】";
	}elsif($xgunshi eq "$kid"){
		$rank_mes = "【軍師】";
	}elsif($xdai eq "$kid"){
		$rank_mes = "【大将軍】";
	}elsif($xuma eq "$kid"){
		$rank_mes = "【騎馬将軍】";
	}elsif($xgoei eq "$kid"){
		$rank_mes = "【護衛将軍】";
	}elsif($xyumi eq "$kid"){
		$rank_mes = "【弓将軍】";
	}elsif($xhei eq "$kid"){
		$rank_mes = "【将軍】";
	}
	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	$uhit=0;
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg)=split(/<>/);
		if("$uid" eq "$kid"){$uhit=1;last;}
	}
	if(!$uhit){
		$unit_id="";
		$uunit_name="無所属";
	}
	if($unit_id eq $kid){
		$add_com = "<option value=28>集合";
	}
	open(IN,"$MAP_LOG_LIST");
	@S_MOVE = <IN>;
	close(IN);
	$p=0;
	while($p<5){$S_MES .= "<font color=green>●</font>$S_MOVE[$p]<BR>";$p++;}

	&TIME_DATA;

	open(IN,"./charalog/log/$kid.cgi");
	@LOG_DATA = <IN>;
	close(IN);
	$p=0;
	while($p<5){$log_list .= "<font color=navy>●</font>$LOG_DATA[$p]<BR>";$p++;}

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	$wyear = $myear+$F_YEAR;
	if($mtime > $kdate){
		$wmonth = $mmonth+1;
		if($wmonth > 12){
			$wyear++;
			$wmonth = 1;
		}
	}else{
		$wmonth = $mmonth;
	}

	for($i=0;$i<$MAX_COM;$i++){
		($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
		$no = $i+1;
		if($cid eq ""){
			$com_list .= "<TR><TH>[$wyear年$wmonth月]</TH><TH> - </TH></TR>";
		}else{
			$com_list .= "<TR><TH>[$wyear年$wmonth月]</TH><TH>$cname</TH></TR>";
		}
		$wmonth++;
		if($wmonth > 12){
			$wyear++;
			$wmonth = 1;
		}
	}

	open(IN,"$DEF_LIST") or &ERR("指定されたファイルが開けません。");
	@DEF_DATA = <IN>;
	close(IN);

	foreach(@DEF_DATA){
		($did,$dname,$dtown_id,$dtown_flg,$dcon)=split(/<>/);
		if($kpos eq $dtown_id){
			$def_list .= "$dname ";
		}
	}

	open(IN,"./charalog/main/$xking.cgi");
	@E_DATA = <IN>;
	close(IN);
	($eid,$epass,$ename) = split(/<>/,$E_DATA[0]);
	$king_name=$ename;
	open(IN,"./charalog/main/$xgunshi.cgi");
	@S_DATA = <IN>;
	close(IN);
	($sid,$spass,$sname) = split(/<>/,$S_DATA[0]);
	$sub_name=$sname;

	$next_time = int(($kdate + $TIME_REMAKE - $tt) / 60);
	if($next_time < 0){
		$next_time = 0;
	}
	$del_out = $DEL_TURN - $ksub2;

	$dilect_mes = "";$m_hit=0;$i=1;$h=1;$j=1;$k=1;
	open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
	while (<IN>){
		my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon,$hunit) = split(/<>/);
		if($MES_MAN < $i && $MES_ALL < $h && $MES_COU < $j && $MES_UNI < $k) { last; }
		if(111 eq "$pid" && $kpos eq $hpos){
			if($MES_ALL < $h ) { next; }
			$all_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=#FFFFFF><b>$hname\@$town_name[$hpos]から</b><BR>「<b>$hmessage</b>」<BR>$htime</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$hname\"></TD></TR>\n";
			$h++;
		}elsif($kcon eq "$pid"){
			if($MES_COU < $j ) { next; }
			$cou_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=FFCC33><b>	$hname\@$town_name[$hpos]から$pnameへ</b></font><BR><font size=2 color=#FFFFFF>  「<b>$hmessage</b>」</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$j++;
		}elsif($kid eq "$pid"){
			if($MES_MAN < $i ) { next; }
			$add_mes = "<b><font color=orange>$hname\@$town_name[$hpos]</font>から$pnameへ</b> <BR>";
			$man_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=#FFFFFF>$add_mes「<b>$hmessage</b>」</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$hname\"></TD></TR>\n";
			$dilect_mes .= "<option value=\"$hid\">$hnameさんへ";
			$i++;
		}elsif(333 eq "$pid" && "$hunit" eq "$unit_id" && "$hcon" eq "$kcon" && "$xcid" ne "0"){
			if($MES_UNI < $k ) { next; }
			$unit_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=orange><b>$knameから$pnameへ</b></font><BR><font size=2 color=#FFFFFF>  「<b>$hmessage</b>」</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$k++;
		}elsif($kid eq "$hid"){
			if($MES_MAN < $i ) { next; }
			$man_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=skyblue><b>$knameから$pnameへ</b></font><BR><font size=2 color=#FFFFFF>  「<b>$hmessage</b>」</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$i++;
		}
	}
	close(IN);

	$m_hit=0;$i=1;$h=1;$j=1;$k=1;
	open(IN,"$MESSAGE_LIST2") or &ERR('ファイルを開けませんでした。');
	while (<IN>){
		my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon) = split(/<>/);
		if($MES_MAN < $i) { last; }
		if($kid eq "$pid"){
			$add_mes="";
			$add_sel="";
			$add_form1="";
			$add_form2="";
			if($htime eq "9999"){
			$add_mes = "<B><font color=skyblue>$hnameが$cou_name[$hcon]国への仕官を勧めています。</font><BR></B>";
			$add_sel = "<BR><input type=radio name=sel value=1>承諾する<input type=radio name=sel value=0>断る<input type=submit value=\"返事\">";
			$add_form1="<form action=\"./mydata.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=hcon value=$hcon><input type=hidden name=hid value=$hid><input type=hidden name=hpos value=$hpos><input type=hidden name=mode value=COU_CHANGE>";
			$add_form2="</form>";
			}else{
			$add_mes = "<B><font color=skyblue>$hnameから$pnameへ</font><BR></B>";
			}
			$man_mes2 .= "$add_form1<TR><TD width=100% bgcolor=#000000><font size=2 color=#FFFFFF>$add_mes「<b>$hmessage</b>」$add_sel</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$hname\"></TD></TR>$add_form2\n";
			$dilect_mes .= "<option value=\"$hid\">$hnameさんへ";
			$i++;
		}elsif($kid eq "$hid"){
			$man_mes2 .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=skyblue><b>$knameさんから$pnameへ</b></font><BR><font size=2 color=#FFFFFF>  「<b>$hmessage</b>」</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$i++;
		}
	}
	close(IN);

	if($xking eq $kid || $xgunshi eq $kid){
		$king_com = "<form action=\"./mydata.cgi\" method=\"post\"><TR><TH colspan=8><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM><input type=submit value=\"指令部\"></TH></TR></form>";
		foreach(@COU_DATA){
			($xvcid,$xvname)=split(/<>/);
			$dilect_mes .= "<option value=\"$xvcid\">$xvname国へ";
		}
	}

	if($xmark < $BATTLE_STOP){
		$xc = $BATTLE_STOP - $xmark;
		$xaddmes = "<BR>戦闘解除まで残り <font color=red>$xc</font> ターン";
	}

	$klank = int($kclass / $LANK);
	if($klank > 20){
		$klank=20;
	}

	$nou_bar1 = int($znou/$znou_max*100);
	$nou_bar2 = 100 - $nou_bar1;
	$syo_bar1 = int($zsyo/$zsyo_max*100);
	$syo_bar2 = 100 - $syo_bar1;
	$tec_bar1 = int($zsub1/999*100);
	$tec_bar2 = 100 - $tec_bar1;
	$shiro_bar1 = int($zshiro/$zshiro_max*100);
	$shiro_bar2 = 100 - $shiro_bar1;
	$Tshiro_bar1 = int($zdef_att/999*100);
	$Tshiro_bar2 = 100 - $Tshiro_bar1;

	&HEADER;
print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD>
[<a href=$BBS1_URL>$BBS1</a>]
<TABLE border=0 width=100%>
<TR><TD bgcolor=$ELE_BG[$cou_ele[$zcon]] colspan=2><font color=$ELE_C[$cou_ele[$zcon]] size=2>$xname国指令:$xmes</font></TD></TR><TR><TD width=50%>
<TABLE width=100%><TR><TD width=50%>
<font color=AA8866><B>- 大陸地図 -</B></font>
<TABLE bgcolor=$bg_c width=100% height=5 border="0" cellspacing=1><TBODY>
<TR><TH colspan= 11 bgcolor=442200><font color=FFFFFF>$new_date</TH></TR>
          <TR>
            <TD width=20 bgcolor=$TD_C2>-</TD>
EOM
    for($i=1;$i<11;$i++){
		print "<TD width=20 bgcolor=$TD_C1>$i</TD>";
	}
	print "</TR>";
     for($i=0;$i<10;$i++){
		$n = $i+1;
		print "<TR><TD bgcolor=$TD_C3>$n</td>";
		for($j=0;$j<10;$j++){
				$m_hit=0;$zx=0;
				foreach(@TOWN_DATA){
					($zzname,$zzcon,$zznum,$zznou,$zzsyo,$zzshiro,$zznou_max,$zzsyo_max,$zzshiro_max,$zzpri,$zzx,$zzy)=split(/<>/);
					if("$zzx" eq "$j" && "$zzy" eq "$i"){$m_hit=1;last;}
					$zx++;
				}
				$col="";
				if($m_hit){
					if($zx eq $kpos){
						$col = $ELE_C[$cou_ele[$zzcon]];
					}else{
						$col = $ELE_BG[$cou_ele[$zzcon]];
					}
					if($zzname eq "洛陽" || $zzname eq "建業" || $zzname eq "成都" || $zzname eq "業" ){
						print "<TH bgcolor=$col><img src=\"$IMG/m_1.gif\" title=\"$zzname【$cou_name[$zzcon]】\"></TH>";
					}else{
						print "<TH bgcolor=$col><img src=\"$IMG/m_4.gif\" title=\"$zzname【$cou_name[$zzcon]】\"></TH>";
					}
				}else{
					print "<TH> </TH>";
				}
		}
		print "</TR>";
	}
print <<"EOM";
</TBODY></TABLE>
</TD></TR>
<TR><TD>

<TABLE width=100% bgcolor=$ELE_BG[$cou_ele[$zcon]] cellspacing=2><TBODY bgcolor=$ELE_C[$cou_ele[$zcon]]>
<TR><TH bgcolor=$ELE_BG[$xele] colspan=2><font color=$ELE_C[$xele]>$zname</font></TH></TR>
<TR><TD>支配国</TD><TH bgcolor$TD_C1>$cou_name[$zcon]国</Th></TR>
<TR><TD>農民</TD><TD align=right>$znum</TD></TR>
<TR><TD>民忠</TD><TD align=right>$zpri</TD></TR>
<TR><TD>農業</TD><TD align=right NOWRAP><img src=$IMG/img/bar1.gif width=$nou_bar1\% height=5><img src=$IMG/img/bar2.gif width=$nou_bar2\% height=5><BR>$znou/$znou_max</TD></TR>
<TR><TD>商業</TD><TD align=right NOWRAP><img src=$IMG/img/bar1.gif width=$syo_bar1\% height=5><img src=$IMG/img/bar2.gif width=$syo_bar2\% height=5><BR>$zsyo/$zsyo_max</TD></TR>
<TR><TD>技術力</TD><TD align=right NOWRAP><img src=$IMG/img/bar1.gif width=$tec_bar1\% height=5><img src=$IMG/img/bar2.gif width=$tec_bar2\% height=5><BR>$zsub1/999</TD></TR>
<TR><TD>城壁</TD><TD align=right NOWRAP><img src=$IMG/img/bar1.gif width=$shiro_bar1\% height=5><img src=$IMG/img/bar2.gif width=$shiro_bar2\% height=5><BR>$zshiro/$zshiro_max</TD></TR>
<TR><TD>城壁耐久力</TD><TD align=right NOWRAP><img src=$IMG/img/bar1.gif width=$Tshiro_bar1\% height=5><img src=$IMG/img/bar2.gif width=$Tshiro_bar2\% height=5><BR>$zdef_att/999</TD></TR>
</TBODY></TABLE>

<TABLE width=100% bgcolor=$ELE_BG[$cou_ele[$zcon]] cellspacing=1><TBODY bgcolor=$ELE_C[$cou_ele[$zcon]]>
<TR><TD>Online</TD><TD>$m_list</TD></TR>
</TBODY></TABLE>

</TD></TR><TR><TD>
<TABLE width=100% bgcolor=$ELE_BG[$xele] cellspacing=1><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=$ELE_BG[$xele] colspan=8><font color=$ELE_C[$xele]>$xname国$xaddmes</font></TH></TR>
<TR><TD>君主</TD><TH colspan=2>$king_name</TH><TD>軍師</TD><TH colspan=2>$sub_name</TH></TR>
<TD>支配都市</TD><TD align=right>$town_get[$kcon]</TD><TD>収穫</TD><TD align=right>$znou_sal</TD>
<TD>税金</TD><TD align=right>$zsyo_sal</TD></TR>

<form action="./mydata.cgi" method="post"><TR><TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=COUNTRY_TALK>
<input type=submit value="会議室">
</TH></form>
<form action="./mydata.cgi" method="post"><TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=LOCAL_RULE>
<input type=submit value="国法">
</TH></TR></form>
$king_com
</TBODY></TABLE>
</TD></TR>
<TR><TD>

<form action="./command.cgi" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<TABLE bgcolor=$ELE_BG[$xele] cellspacing=1><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>コマンド</font></TH></TR>
<TR><TD>
No:<select name=no size=4 MULTIPLE>
<option value="all">ALL
EOM
	for($i=0;$i<$MAX_COM;$i++){
		$no = $i+1;
		if($i eq "0"){
		print "<option value=\"$i\" SELECTED>$no";
		}else{
		print "<option value=\"$i\">$no";
		}
	}

print <<"EOM";
</select>

<select name=mode>
<option value=$NONE>何もしない
<option value="">== 内政 ==
<option value=$NOUGYOU>農業開発(50G)
<option value=$SYOUGYOU>商業発展(50G)
<option value=$TEC>技術開発(50G)
<option value=$SHIRO>城壁強化(50G)
<option value=$SHIRO_TAI>城壁耐久力強化(50G)
<option value=$RICE_GIVE>米施し(50R)
<option value="">== 軍事 ==
<option value=$GET_SOL>徴兵
<option value=$KUNREN>兵士訓練
<option value=$TOWN_DEF>城の守備
<option value=$BATTLE>戦争
<option value="">== 諜略 ==
<option value=$GET_MAN>登用(100G)
<option value="">== 鍛錬 ==
<option value=$TANREN>\能\力強化(50G)
<option value="">== 商人 ==
<option value=$BUY>米売買
<option value=$ARM_BUY>武器購入
<option value=$DEF_BUY>書物購入
<option value="">== 移動 ==
<option value=$MOVE>移動
$add_com
<option value=$SHIKAN>仕官
</select><input type=submit value=\"実行\">
<BR>※Noはctrlキーを押しながらクリックすると複数選択できます。
</TD></form></TR>
<TR><TH>次のターンまで$next_time分</TH></TR>
<TR><TH>放置削除ターンまで<font color=red>$del_out</font>ターン</TH></TR>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<TR><TH><input type=submit value="画面RELODE">
</TH></TR></form>
</TBODY></TABLE><CENTER>
</TD></TR>
</TABLE>

</TD><TD width=100%>

<TABLE width=100%><TR><TD width=100%>
<TABLE width=100% bgcolor=$TABLE_C cellspacing=1><TBODY BGCOLOR=$TD_C2>
<TR><TH bgcolor=#000000 colspan=2><font color=#FFFFFF>コマンドリスト</font></TH></TR>
$com_list
</TABLE>

</TD></TR>
<TR><TD>

<TABLE width=100% bgcolor=$ELE_BG[$xele] cellspacing=1><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname$rank_mes</font></TH></TR>

<TR><TD rowspan=4 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>武EX</TD><TH>$kstr_ex</TH><TD>知EX</TD><TH>$kint_ex</TH><TD>統EX</TD><TH>$klea_ex</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>人望</TD><TH>$kcha</TH></TR>
<TR><TD>階級</TD><TH>$LANK[$klank]</TH><TD>貢献</TD><TH>$kcex</TH><TD>階級値</TD><TH>$kclass</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>部隊</TD><TH colspan=3>$uunit_name</TH></TR>
<TR><TD>兵種</TD><TH colspan=2>$SOL_TYPE[$ksub1_ex]</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
<TR><TD>武器</TD><TH colspan=5>$karmname</TH><TH>$karmdmg</TH></TR>
<TR><TD>書物</TD><TH colspan=5>$kproname</TH><TH>$kprodmg</TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD>忠誠度</TD><TH>$kbank</TH><TH colspan=5>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=CYUUSEI>
<input type=text name=cyuu size=5>
<input type=submit value="忠誠">
</TH></TR></form>
<form action="./mydata.cgi" method="post"><TR><TH colspan=7>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<select name=mode>
<option value=LETTER>個人当て手紙
<option value=UNIT_SELECT>部隊編成
<input type=submit value="実行">

</TH></TR></form>
</TBODY></TABLE>

</TD></TR>
</TABLE>
</TD></TR>

<TR><TD colspan=2>
<TABLE width=100% bgcolor=$ELE_BG[$cou_ele[$zcon]] cellspacing=1><TR><TD bgcolor=$ELE_C[$cou_ele[$zcon]]><font color=$ELE_BG[$cou_ele[$zcon]]>$znameの守備:$def_list</TD></TR></TABLE>
</TD></TR>
<TR><TD colspan=2>
<TABLE width=100% bgcolor=$TABLE_C><TR><TD bgcolor=$TD_C1>$S_MES</TD></TR></TABLE>
<form action="$FILE_MYDATA" method="post">
手紙：<input type="text" name=message size=60>
 <select name=mes_id><option value="$xcid">$xname国へ<option value="111">$znameの人へ<option value="333">$uunit_name部隊の人へ$dilect_mes</select>
 <input type=hidden name=id value=$kid>
 <input type=hidden name=name value=$kname>
 <input type=hidden name=pass value=$kpass>
 <input type=hidden name=mode value=MES_SEND>
 <input type=submit value="送信"></form>
<TABLE width=100%><TBODY>
<TR><TD width=50%>
	$znameの人々へ:($MES_ALL件)
	<TABLE width=100% bgcolor=880000><TBODY>
	$all_mes
	</TBODY></TABLE>

	$kname宛て:($MES_MAN件)
	<TABLE width=100% bgcolor=008800><TBODY>
	$man_mes
	</TBODY></TABLE>

	$kname宛て密書:($MES_MAN件)
	<TABLE width=100% bgcolor=008800><TBODY>
	$man_mes2
	</TBODY></TABLE>
</TD><TD>
	$xname国宛て:($MES_COU件)
	<TABLE width=100% bgcolor=000088><TBODY>
	$cou_mes
	</TBODY></TABLE>

	$uunit_name部隊宛て:($MES_UNI件)
	<TABLE width=100% bgcolor=AA8833><TBODY>
	$unit_mes
	</TBODY></TABLE>

</TD></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD colspan=2>
<TABLE width=100% bgcolor=$ELE_BG[$cou_ele[$kcon]]><TR><TD colspan=2 bgcolor=$ELE_C[$cou_ele[$kcon]]>$log_list</TD></TR><form action="./mylog.cgi" method="post">
<TR><TD bgcolor=$ELE_C[$cou_ele[$kcon]]><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=submit value="都市情報"></TD></form><form action="./mycou.cgi" method="post">
<TD bgcolor=$ELE_C[$cou_ele[$kcon]]><input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit value="国データ">
</TD></TR>
</TABLE></form>

</TD></TR>
</TABLE>
</TD></TR></TABLE>
EOM
	&FOOTER;
	exit;
}

