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
require 'i-suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
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
	for($i=0;$i<$MAX_COM;$i++){
		($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
		$no = $i+1;
		if($cid eq ""){
		$com_list .= "$no: - <BR>";
		}else{
		$com_list .= "$no: $cname<BR>";
		}
	}

	open(IN,"$DEF_LIST") or &ERR("指定されたファイルが開けません。");
	@DEF_DATA = <IN>;
	close(IN);

	foreach(@DEF_DATA){
		($did,$dname,$dtown_id,$dtown_flg,$dcon)=split(/<>/);
		if($kpos eq $dtown_id){
			$def_list .= "$dname,";
		}
	}
	chop($def_list);
	$next_time = int(($kdate + $TIME_REMAKE - $tt) / 60);
	if($next_time < 0){
		$next_time = 0;
	}
	$del_out = $DEL_TURN - $ksub2;

	$dilect_mes = "";$m_hit=0;$i=1;$h=1;$j=1;$k=1;
	open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
	while (<IN>){
		my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon) = split(/<>/);
		if($MES_MAN < $i && $MES_ALL < $h) { last; }
		if(111 eq "$pid" && $kpos eq $hpos){
			if($MES_ALL < $h ) { next; }
			$all_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=#FFFFFF><b>$hnameから</b><BR>「<b>$hmessage</b>」<BR>$htime</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$hname\"></TD></TR>\n";
			$h++;
		}elsif($kid eq "$pid"){
			if($MES_MAN < $i ) { next; }
			$man_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=#FFFFFF><b><font color=orange>$hname</font>から$pnameへ</b> <BR>「<b>$hmessage</b>」</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$hname\"></TD></TR>\n";
			$dilect_mes .= "<option value=\"$hid\">$hnameさんへ";
			$i++;
		}elsif($kid eq "$hid"){
			if($MES_MAN < $i ) { next; }
			$man_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=skyblue><b>$knameさんから$pnameへ</b></font><BR><font size=2 color=#FFFFFF>  「<b>$hmessage</b>」</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$i++;
		}
	}
	close(IN);
	$klank = int($kclass / $LANK);
	if($klank > 20){
		$klank=20;
	}
	&HEADER;
print <<"EOM";
指令:$xmes<HR>
$new_date<BR><BR>
<B>\[$zname\]</B><BR>
支配国:$cou_name[$zcon]国<BR>
農民:$znum人 | 民忠:$zpri<BR>
農業:$znou/$znou_max<BR>
商業:$zsyo/$zsyo_max<BR>
技術:$zsub1/999<BR>
城壁:$zshiro/$zshiro_max<BR>
城壁耐久力:$zdef_att/999<BR>
相場:$zsouba
<BR>
<B>\[コマンドリスト\]</B><BR>
<HR>$com_list<HR>
<form action="./i-command.cgi" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<B>\[コマンド\]</B><BR>
No:<select name=no size=4 MULTIPLE>
<option value=all>ALL
EOM
	for($i=0;$i<$MAX_COM;$i++){
		$no = $i+1;
		print "<option value=\"$i\">$no";
	}
print <<"EOM";
</select>
<select name=mode>
<option value="0">何もしない
<option value="">== 内政 ==
<option value="1">農業開発(50G)
<option value="2">商業発展(50G)
<option value="29">技術開発(50G)
<option value="3">城壁強化(50G)
<option value="30">城壁耐久力強化(50G)
<option value="8">米施し(50R)
<option value="">== 軍事 ==
<option value="9">徴兵
<option value="11">兵士訓練
<option value="12">城の守備
<option value="13">戦争
<option value="">== 諜略 ==
<option value="24">登用(100G)
<option value="">== 鍛錬 ==
<option value="26">\能\力強化(50G)
<option value="">== 商人 ==
<option value="14">米売買
<option value="15">武器購入
<option value="16">書物購入
<option value="">== 移動 ==
<option value="17">移動
<option value="21">仕官
$add_com
</select><input type=submit value=\"実行\"></form>
次のターンまで$next_time分<BR><BR>
$kname\[$uunit_name部隊\]<BR>
金:$kgold/米:$krice:貢献:$kcex<BR>
<p>
$znameの守備:$def_list<BR>
$log_list
<form action="./i-command.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=COUNTRY_TALK>
<input type=hidden name=pass value=$kpass>
<input type=submit value="会議室">
</form>

<form action="./i-mylog.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit value="過去ログ">
</TD></TR></form>
</TABLE>
</TD></TR></TABLE>
EOM
	&FOOTER;
	exit;
}

