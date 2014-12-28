#_/_/_/_/_/_/_/_/_/#
#_/   新規登録   _/#
#_/_/_/_/_/_/_/_/_/#

sub ENTRY {

	&CHEACKER;
	&HEADER;

	open(IN,"$COUNTRY_MES") or &ERR("指定されたファイルが開けません。");
	@MES_DATA = <IN>;
	close(IN);

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);
	foreach(@COU_DATA){
		($x2cid,$x2name,$x2ele,$x2mark)=split(/<>/);
		$cou_name[$x2cid] = "$x2name";
		$cou_ele[$x2cid] = "$x2ele";
		$cou_mark[$x2cid] = "$x2mark";
	}

	$mess .= "<TR><TD BGCOLOR=$TD_C1 colspan=2>各国の新規参入者へのメッセージ</TD></TR>";
	foreach(@MES_DATA){
		($cmes,$cid)=split(/<>/);
		$mess .= "<TR><TD bgcolor=$ELE_C[$cou_ele[$cid]]>$cou_name[$cid]国</TD><TD bgcolor=$ELE_C[$cou_ele[$cid]]>$cmes</TD></TR>";
	}



	open(IN,"$TOWN_LIST") or &ERR("指定されたファイルが開けません。");
	@TOWN_DATA = <IN>;
	close(IN);

	$zc=0;
	foreach(@TOWN_DATA){
		($z2name,$z2con)=split(/<>/);
		$town_name[$zc] = "$z2name";
		$town_cou[$zc] = "$z2con";
		$t_list .= "<option value=\"$zc\">$z2name【$cou_name[$z2con]】";
		$zc++;
	}
	if($in{'url'} eq ""){$nurl = "http://";}else{$nurl = "$in{'url'}";}
	if($in{'mail'} eq ""){$nmail = "\@";}else{$nmail = "$in{'mail'}";}
	if(ATTESTATION){$emes = "・<font color=red>認証ID付きの確認メールを送りますので正しく入力してください。</font><BR>(※このメールアドレスはゲーム内でのみ使用します。スパムメールやその他への利用は一切しません。)";}
	print <<"EOM";
	<script language="JavaScript">
		function changeImg(){
			num=document.para.chara.selectedIndex;
			document.Img.src="$IMG/"+ num +".gif";
		}
	</script>
<hr size=0><CENTER><font size=4><b>-- 武将登録 --</b></font><hr size=0><form action="$FILE_ENTRY" method="post" name=para><input type="hidden" name="mode" value="NEW_CHARA">
<table bgcolor=$TABLE_C width=80% border=0 cellpadding="1" cellspacing="1">$mess</table>

<table bgcolor=$TABLE_C border=0 cellpadding="3" cellspacong="1"><tr><TD colspan=2 bgcolor=$TD_C1>
* IDとPASSが同じ場合登録出来ません。<BR>
* ２重登録は出来ません<BR>
* 最大登録人数は$ENTRY_MAX名です。（現在登録者$num名）<BR>
* すべての項目を記入してください。<BR>
* <a href="./manual.html" TARGET="_blank">ゲーム説明</a>をよく読んでから参加してください。<BR>
* メールアドレスは正しく入力してください。登録されたメールアドレスに認証IDを送信します。確認がとれた時点で参加が可\能\になります。（hotmail yahoomailの使用不可）<BR>
*初期位置に何処の支配もうけていない都市（【】空欄の都市）を選択すると君主として参加\可\能\です。それ以外はその街の所有者の配下になります。<a href="./ranking.cgi" TARGET="_blank">街一覧</a> <BR>
</TD></tr><tr bgcolor=$TD_C2><TD width=100>名 前</tD><tD bgcolor=$TD_C3><input type="text" name="chara_name" size="30" value="$in{'chara_name'}"><br>・武将の名前を入力してください。<BR>[全角大文字で２～６文字以内]</tD></tr><tr><TD bgcolor=$TD_C2>イメージ</TD><TD bgcolor=$TD_C3><TABLE bgcolor=$TABLE_C border=2><TR><TD><img src=\"$IMG/0.gif\" name=\"Img\">
</TD></TR></TABLE><select name=chara onChange=\"changeImg()\">
EOM
	foreach (0..$CHARA_IMAGE){print "<option value=\"$_\">イメージ[$_]\n";}
	print <<"EOM";
</select><br>・武将のイメージを選んでください。</TH></tr>

<tr bgcolor=$TD_C2><TD>初期位置</TD><TD bgcolor=$TD_C3><select name="con">
<option value=""> 選択してください
$t_list
</select><br>・所属する国を選んでください。（【】は建国可\能\)</TD></tr><tr><TD bgcolor=$TD_C2>ID</TD><TD bgcolor=$TD_C3><input type="text" name="id" size="10" value="$in{'id'}"><br>・参加する希望IDを記入してください。<BR>[半角英数字で４～８文字以内]</TD></tr><tr><TD bgcolor=$TD_C2>パスワード</TD><TD bgcolor=$TD_C3><input type="password" name="pass" size="10"  value="$in{'pass'}"><br>・パスワードを登録してください。<BR>[半角英数字で４～８文字以内]</TD></tr>
<tr><TD bgcolor=$TD_C2>\能\力</TD><TD bgcolor=$TD_C3><table><TR><TD>武力</TD><TD><input type="text" name="str" size="5">[5～100]</TD></TR><TR><TD>知力</TD><TD><input type="text" name="int" size="5">[5～100]</TD></TR><TR><TD>統率力</TD><TD><input type="text" name="tou" size="5">[5～100]</TD></TR></TABLE>・\能\力を指定して下さい。。<BR>[全部の合計が150になるようにして下さい。]</TD></tr>

<tr><TD bgcolor=$TD_C2>メールアドレス</TD><TD bgcolor=$TD_C3><input type="text" name="mail" size="35" value="$nmail"><br> $emes</TD></tr>
</table>
<BR>
<TABLE width=80% bgcolor=$TABLE_C>
<tr><TH bgcolor=$TD_C3 colspan=2>君主</TH></TR>
<tr><TD bgcolor=$TD_C1 colspan=2>
・所属位置に*がついている場合はこちらも登録してください。
</TD></TR>
<tr bgcolor=$TD_C1><TD width=100>国名</tD><tD bgcolor=$TD_C3><input type="text" name="cou_name" size="30" value="$in{'cou_name'}"><br>・新国家の名称を決めてください。<BR>[全角大文字で１～４文字以内]</tD></tr>
<tr><TD bgcolor=$TD_C1>国色</TD><TD bgcolor=$TD_C3>
EOM
	$i=0;
	foreach(@ELE_BG){print "<input type=radio name=ele value=\"$i\"><font color=$ELE_BG[$i]>■</font> \n";$i++;}
	print <<"EOM";
<br>・国の色を決めてください。</TD></tr>
</TABLE>

</table>
</td></tr>
<tr><TH align="center" bgcolor=$TABLE_C><input type="submit" value="登録"></TH></tr></table></form></CENTER>

EOM

	# フッター表示
	&FOOTER;

	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/   参加登録者上限チェック   _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub CHEACKER {

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR2("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);


	$num = @CL_DATA;

	if($ENTRY_MAX){
		if($num > $ENTRY_MAX){
			&ERR2("最大登録数\[$ENTRY_MAX\]を超えています。現在新規登録出来ません。");
		}
	}
}
1;