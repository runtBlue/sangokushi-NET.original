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
require 'suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;

if(!$ADMIN_SET) { &ERR2("管理ツールを使用する設定になっていません。"); }
	$adminid = "xxxx";
	$adminpass = "xxxx2";

if($mode eq 'CHANGE') { &CHANGE; }
elsif($mode eq 'MENTE') { &MENTE; }
elsif($mode eq 'MENTE2') { &MENTE2; }
elsif($mode eq 'CHANGE2') { &CHANGE2; }
elsif($mode eq 'BBS') { &BBS; }
elsif($mode eq 'DEL') { &DEL; }
elsif($mode eq 'DEL2') { &DEL2; }
elsif($mode eq 'DEL_LIST') { &DEL_LIST; }
elsif($mode eq 'ALL_DEL') { &ALL_DEL; }
elsif($mode eq 'INIT_DATA') { &INIT_DATA; }
else{&TOP;}


#_/_/_/_/_/_/_/_/_/#
#_/   MAIN画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub TOP {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}


	&HEADER;

	print <<"EOM";

<h2>管理ツール</h2>
<CENTER>
<table width=80% cellspacing=1 border=0 bgcolor=$TABLE_C><TBODY bgcolor=$TD_C4>
<TR><TH colspan=2>管理メニュー</TH></TR>
<form method="post" action="admin.cgi">
<TR><Th>
<input type=hidden name=mode value=MENTE>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='キャラ編集１'>
</Th></form><TD>
・登録者のデータを編集します。通常はこちらで編集してください。
参加者の数が増えると使えなくなる可\能\性があります。
</TD></TR>
<form method="post" action="admin.cgi">
<TR><Th>
<input type=hidden name=mode value=INIT_DATA>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='初期化'>
</Th></form><TD>
・すべてのデータを初期化します。
</TD></TD></TR>

</TBODY></TABLE>

<form method="post" action="admin.cgi">
<input type=hidden name=mode value=BBS>
MEMO:<input type=text name=message size=40>
NAME:<input type=text name=name size=10>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='メモ'>
<br></form>

<form method="post" action="index.cgi">
</select><input type=submit value='編集を終える'>
<br></form>
</CENTER>

EOM
	open(IN,"$ADMIN_BBS");
	@A_BBS = <IN>;
	close(IN);

	# 管理者メモ
	print "<center><table width=80% border=0 >@A_BBS</table></center>";

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/  MENTE画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub MENTE {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	$i=0;
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			$datames = "検索：$dir/$file<br>\n";
			if(!open(page,"$dir/$file")){
				$datames .= "$dir/$fileがみつかりません。<br>\n";
				return 1;
			}
			@page = <page>;
			close(page);
			$list[$i]="$file";
			($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/,$page[0]);

			if("$in{'serch'}" ne ""){
				if("$ename" =~ "$in{'serch'}"){
					$human_data[$i]="$ehost<>$ename<>$eid<>";
				}else{
					next;
				}
			}else{
				if($in{'no'} eq "2"){
					$human_data[$i]="$ename<>$ehost<>$eid<>";
				}elsif($in{'no'} eq "3"){
					$human_data[$i]="$eid<>$ehost<>$ename<>";
				}else{
					$human_data[$i]="$ehost<>$ename<>$eid<>";
				}
			}
			push(@newlist,"@page<br>");
			$i++;
		}
	}
	closedir(dirlist);

	@human_data = sort @human_data;

	$tt = time - (60 * 60 * 24 * 34);
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime($tt);
	$year += 1900;
	$mon++;
	$ww = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday];
	$daytime = sprintf("%4d\/%02d\/%02d\/(%s) %02d:%02d:%02d", $year,$mon,$mday,$ww,$hour,$min,$sec);

	&HEADER;
	print <<"EOM";
<h2>キャラ管理ツール</h2><br>
・IDはファイル名と同じになっているので変更しないで下さい。<br>
・ホスト名は随時更新しています。<br>
<form method="post" action="admin.cgi">
<input type=hidden name=mode value=CHANGE>編集するファイル：
<select name=fileno>
EOM
	$i=0;$w_host="";
	foreach(@human_data){
		if($in{'no'} eq "2"){
			($ename,$ehost,$eid) = split(/<>/);
		}elsif($in{'no'} eq "3"){
			($eid,$ehost,$ename) = split(/<>/);
		}else{
			($ehost,$ename,$eid) = split(/<>/);
		}
		print "<option value=$eid\.cgi>$eid $ename $ehost\n";
		if($in{'no'} eq "" || $in{'no'} eq "1"){
			if($w_host eq "$ehost"){
				$mess .= "$ename | $w_name<BR>\n";
			}
		}
		$w_host = "$ehost";
		$w_name = "$ename";
		$i++;
	}
print <<"EOM";
</select><input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='編集'>
<br></form>

<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value=MENTE>
<br><input type=radio name=no value="1">ホスト名順（<font color=red>2重登録チェック</font>）<br>
<input type=radio name=no value="2">名前順<br>
<input type=radio name=no value="3">ＩＤ順<br>
名前検索<input type=text name=serch size=20><br>
<input type=submit value='順変更'>
<br></form>

<h2>ファイル消去</h2>
・２重登録者を強制削除します。<BR>

<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value=DEL_LIST>
<input type=submit value='削除者リスト'>
<br></form>


２重登録疑惑者<p>
<font color=red>$mess</font>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='TOP'>
<br></form>

EOM
	open(IN,"$ADMIN_LIST");
	@A_LOG = <IN>;
	close(IN);
	print "@A_LOG";

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/#
#_/   DEL LIST画面   _/#
#_/_/_/_/_/_/_/_/_/_/_/#

sub DEL_LIST {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	$tt = time - (60 * 60 * 24 * 34);
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime($tt);
	$year += 1900;
	$mon++;
	$ww = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday];
	$daytime = sprintf("%4d\/%02d\/%02d\/(%s) %02d:%02d:%02d", $year,$mon,$mday,$ww,$hour,$min,$sec);

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	$i=0;
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			$datames = "検索：$dir/$file<br>\n";
			if(!open(page,"$dir/$file")){
				$datames .= "$dir/$fileがみつかりません。<br>\n";
				return 1;
			}
			@page = <page>;
			close(page);
			$list[$i]="$file";
			($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/,$page[0]);

			if($edate < $tt){
			$i++;
			($sec2,$min2,$hour2,$mday2,$mon2,$year2,$wday2,$yday2) = localtime($edate);
			$mon2++;
			$last_login = "$mon2月$mday2日$hour2時$min2分";
			$LIST .= "<TR><TD>$ename</TD><TD>$eid</TD><TD>$email</TD><TD>$last_login</TD></TR>";
			}
		}
	}
	closedir(dirlist);

	@human_data = sort @human_data;
	$a = "ss";
	$dir="./charalog/main";
	unlink("$dir/$a\.cgi");

	&HEADER;
	print <<"EOM";
<h2>キャラ管理ツール</h2>
<br>

<h2>ファイル消去</h2>
<TABLE><TBODY>
<TR><TD>名前</TD><TD>ID</TD><TD>MAIL</TD><TD>最終更新</TD></TR>
$LIST
</TBODY></TABLE>

＞＞以上の人を削除します。宜しいですか？<BR>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value=ALL_DEL>
<input type=submit value='削除'>
<br></form>

<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='戻る'>
<br></form>


EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/ ファイル削除 _/#
#_/_/_/_/_/_/_/_/_/#

sub ALL_DEL {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	$tt = time - (60 * 60 * 24 * 34);

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	$i=0;
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			$datames = "検索：$dir/$file<br>\n";
			if(!open(page,"$dir/$file")){
				$datames .= "$dir/$fileがみつかりません。<br>\n";
			}
			@page = <page>;
			close(page);
			$list[$i]="$file";
			($eid,$epass,$ename,$eurl,$echara,$esex,$ehp,$emaxhp,$emp,$emaxmp,$eele,$estr,$evit,$eint,$emen,$eagi,$ecom,$egold,$e_ex,$ecex,$eunit,$econ,$earm,$epro,$eacc,$esub1,$esub2,$etac,$esta,$epos,$emes,$ehost,$edate,$esyo,$eclass,$etotal,$ekati) = split(/<>/,$page[0]);
			if($edate < $tt){
				$dir2="./charalog/main";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/bank";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/arm";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/item";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/chara_max";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/map";
				unlink("$dir2/$eid\.cgi");

				$i++;
			}
		}
	}
	closedir(dirlist);


	&HOST_NAME;

	&TIME_DATA;

	unshift(@S_MOVE,"<font color=red><B>\[削除\]</B></font> ３４日以降ログインのない方を削除しました。($mday日$hour時$min分)<BR>\n");
	splice(@S_MOVE,20);

	open(OUT,">$MAP_LOG_LIST") or &ERR2('LOG 新しいデータを書き込めません。');
	print OUT @S_MOVE;
	close(OUT);

	&HEADER;
	print <<"EOM";
<center><h2><font color=red>３４日以降ログインのない方(<font color=red>$i名</font>)を削除しました。</font></h2><hr size=0>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='戻る'>
<br></form>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/  WRITE画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub BBS {

	&TIME_DATA;
	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	open(IN,"$ADMIN_BBS");
	@AD_DATA = <IN>;
	close(IN);

	if($in{'message'} eq "") { &ERR2("メッセージが記入されていません。"); }

	$bbs_num = @AD_DATA;
	if($bbs_num > 40) { pop(@AD_DATA); }

	unshift(@AD_DATA,"<font color=red>$in{'message'}</font> $in{'name'}より($mday日$hour時$min分)<BR><hr size=0>\n");

	open(OUT,">$ADMIN_BBS");
	print OUT @AD_DATA;
	close(OUT);

	&HEADER;
	print <<"EOM";
<h2>書き込みました。</h2>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
</select><input type=submit value='戻る'>
<br></form>
EOM
	&FOOTER;
	exit;
}


#_/_/_/_/_/_/_/_/_/#
#_/   編集画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub CHANGE {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	$dir="./charalog/main";
	if(!open(page,"$dir/$in{'fileno'}")){
		$datames .= "$dir/$fileがみつかりません。<br>\n";
		return 1;
	}
	@page = <page>;
	close(page);
	
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/,$page[0]);
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime($edate);
	$year += 1900;
	$mon++;
	$ww = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday];
	$daytime = sprintf("%4d\/%02d\/%02d\/(%s) %02d:%02d:%02d", $year,$mon,$mday,$ww,$hour,$min,$sec);
	
	&HEADER;
	print <<"EOM";
<form method="post" action="admin.cgi">
<h3><img src="$IMG/$echara.gif" width="$img_wid" height="$img_height" border=0> <font size=5 color=orange>$ename</font> ファイル</h3>
<table>
<tr>
<th>ID</th><td><input type=text name=eid value='$eid'></td>
<th>PASS</th><td><input type=text name=epass value='$epass'></td>
<th>NAME</th><td><input type=text name=ename value='$ename'></td>
<th>画像ID</th><td><input type=text name=echara value='$echara'></td>
<tr>
<th>武力</th><td><input type=text name=estr value='$estr'></td>
<th>知力</th><td><input type=text name=eint value='$eint'></td>
<th>統率力</th><td><input type=text name=elea value='$elea'></td>
<th>人望</th><td><input type=text name=echa value='$echa'></td>
</TR>
<tr>
<th>兵士数</th><td><input type=text name=esol value='$esol'></td>
<th>訓練</th><td><input type=text name=egat value='$egat'></td>
<th>国</th><td><input type=text name=econ value='$econ'></td>
<th>金</th><td><input type=text name=egold value='$egold'></td>
</TR>
<tr>
<th>米</th><td><input type=text name=erice value='$erice'></td>
<th>貢献</th><td><input type=text name=ecex value='$ecex'></td>
<th>階級値</th><td><input type=text name=eclass value='$eclass'></td>
<th>武器</th><td><input type=text name=earm value='$earm'></td>
</TR>
<tr>
<th>書籍</th><td><input type=text name=ebook value='$ebook'></td>
<th>忠誠</th><td><input type=text name=ebank value='$ebank'></td>
<th>サブ１</th><td><input type=text name=esub1 value='$esub1'></td>
<th>サブ２</th><td><input type=text name=esub2 value='$esub2'></td>
</TR>
<tr>
<th>現在位置</th><td><input type=text name=epos value='$epos'></td>
<th>メッセージ</th><td><input type=text name=emes value='$emes'></td>
<th>ホスト</th><td><input type=text name=ehost value='$ehost'></td>
<th>更新日時</th><td><input type=text name=edate value='$edate'></td>
</TR>
<tr>
<th>MAIL</th><td><input type=text name=email value='$email'></td>
<th>行動チェック</th><td><input type=text name=eos value='$eos'></td>
<th></th><td></td>
<th></th><td></td>
</TR>


</table>
<br>
<input type=hidden name=mode value=CHANGE2>
<input type=hidden name=fileno value=$in{'fileno'}>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='編集'>
<br></form>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='編集を止める'>
</form>
<br>
<br>
<br>
<br>
MAPログあり<br>
<form method="post" action="admin.cgi">
<input type=hidden name=filename value=$in{'fileno'}>
<input type=hidden name=mode value=DEL>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='このファイルを削除'>
</form>
<br>
<br>
<br>
MAPログなし<br>
<form method="post" action="admin.cgi">
<input type=hidden name=filename value=$in{'fileno'}>
<input type=hidden name=mode value=DEL2>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='このファイルを削除'>
</form>
<br>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/   編集画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub CHANGE2 {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	$dir="./charalog/main";
	
	$newdata = "$in{'eid'}<>$in{'epass'}<>$in{'ename'}<>$in{'echara'}<>$in{'estr'}<>$in{'eint'}<>$in{'elea'}<>$in{'echa'}<>$in{'esol'}<>$in{'egat'}<>$in{'econ'}<>$in{'egold'}<>$in{'erice'}<>$in{'ecex'}<>$in{'eclass'}<>$in{'earm'}<>$in{'ebook'}<>$in{'ebank'}<>$in{'esub1'}<>$in{'esub2'}<>$in{'epos'}<>$in{'emes'}<>$in{'ehost'}<>$in{'edate'}<>$in{'email'}<>$in{'eos'}<>\n";

	open(page,">$dir/$in{'fileno'}");
	print page $newdata;
	close(page);
	&HOST_NAME;
		
	&ADMIN_LOG("<font color=blue>$in{'ename'} $dir/$in{'fileno'}を更新しました。「$host」</font>");
	&HEADER;
	print <<"EOM";
<center><h2><font color=blue>$in{'ename'} のファイル$dir/$in{'fileno'}を更新しました。</font></h2><hr size=0>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='戻る'>
</form>
EOM

	&FOOTER;
	exit;
}


#_/_/_/_/_/_/_/_/_/#
#_/ ファイル削除 _/#
#_/_/_/_/_/_/_/_/_/#

sub DEL {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	&HOST_NAME;
	open(IN,"./charalog/main/$in{'filename'}") or &ERR2('ファイルを削除できませんでした。');
	@CN_DATA = <IN>;
	close(IN);
	($kid,$kpass,$kname) = split(/<>/,$CN_DATA[0]);

	$dir2="./charalog/main";
	unlink("$dir2/$in{'filename'}");
	$dir2="./charalog/log";
	unlink("$dir2/$in{'filename'}");
	$dir2="./charalog/command";
	unlink("$dir2/$in{'filename'}");

	&ADMIN_LOG("<font color=red>$knameを削除しました。「$host」 </font>");

	open(IN,"$MAP_LOG_LIST");
	@S_MOVE = <IN>;
	close(IN);
	&TIME_DATA;
	open(IN,"$DEF_LIST");
	@DEF_LIST = <IN>;
	close(IN);

	@NEW_DEF_LIST_DEL=();
	foreach(@DEF_LIST){
		($tid,$tname,$ttown_id,$ttown_flg,$tcon) = split(/<>/);
		if("$tid" eq "$kid"){
		}else{
			push(@NEW_DEF_LIST_DEL,"$_");
		}
	}
	open(OUT,">$DEF_LIST");
	print OUT @NEW_DEF_LIST_DEL;
	close(OUT);

	unshift(@S_MOVE,"<font color=red><B>\[削除\]</B></font> $knameは削除されました。($mday日$hour時$min分)<BR>\n");
	splice(@S_MOVE,20);

	open(OUT,">$MAP_LOG_LIST") or &ERR2('LOG 新しいデータを書き込めません。');
	print OUT @S_MOVE;
	close(OUT);

	&HEADER;
	print <<"EOM";
<center><h2><font color=red>$knameを削除しました。</font></h2><hr size=0>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='戻る'>
<br></form>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/ ファイル削除 _/#
#_/_/_/_/_/_/_/_/_/#

sub DEL2 {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
&HOST_NAME;
	open(IN,"./charalog/main/$in{'filename'}") or &ERR2('ファイルを削除できませんでした。');
	@CN_DATA = <IN>;
	close(IN);
	($kid,$kpass,$kname) = split(/<>/,$CN_DATA[0]);

	$dir2="./charalog/main";
	unlink("$dir2/$in{'filename'}");
	$dir2="./charalog/log";
	unlink("$dir2/$in{'filename'}");
	$dir2="./charalog/command";
	unlink("$dir2/$in{'filename'}");
	&ADMIN_LOG("<font color=red>$knameを削除しました。「$host」 </font>");

	open(IN,"$DEF_LIST");
	@DEF_LIST = <IN>;
	close(IN);

	@NEW_DEF_LIST_DEL=();
	foreach(@DEF_LIST){
		($tid,$tname,$ttown_id,$ttown_flg,$tcon) = split(/<>/);
		if("$tid" eq "$kid"){
		}else{
			push(@NEW_DEF_LIST_DEL,"$_");
		}
	}
	open(OUT,">$DEF_LIST");
	print OUT @NEW_DEF_LIST_DEL;
	close(OUT);

	&HEADER;
	print <<"EOM";
<center><h2><font color=red>$knameを削除しました。</font></h2><hr size=0>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='戻る'>
<br></form>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/ 管理者ログ   _/#
#_/_/_/_/_/_/_/_/_/#

sub ADMIN_LOG {

	open(IN,"$ADMIN_LIST");
	@A_LOG = <IN>;
	close(IN);
	&TIME_DATA;

	unshift(@A_LOG,"$_[0]($mday日$hour時$min分)<BR>\n");
	splice(@A_LOG,20);

	open(OUT,">$ADMIN_LIST") or &ERR2('LOG 新しいデータを書き込めません。');
	print OUT @A_LOG;
	close(OUT);

}

#_/_/_/_/_/_/_/_/_/#
#_/   初期化     _/#
#_/_/_/_/_/_/_/_/_/#

sub INIT_DATA {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	require "reset.cgi";
	&RESET_MODE;
	&HOST_NAME;

	&ADMIN_LOG("全データを初期化しました。[$host]");
	
	&HEADER;
	print <<"EOM";
<h2><font color=red>全データを初期化しました。</h2></font>
<br>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit value='戻る'>
</form>
<br>
EOM

	&FOOTER;
	exit;
}


1;
