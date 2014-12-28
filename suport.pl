#_/_/_/_/_/_/_/_/_/_/_/_/#
#   CHARA MAIN OPEN      #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub CHARA_MAIN_OPEN {

	open(IN,"$CHARA_DATA/$in{'id'}.cgi") or &ERR2('IDとパスが正しくありません！');
	@CN_DATA = <IN>;
	close(IN);

	($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos) = split(/<>/,$CN_DATA[0]);

	if($in{'id'} ne "$kid" or $in{'pass'} ne "$kpass"){&ERR2("IDとパスが正しくありません！");}

}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#   CHARA MAIN INPUT     #
#_/_/_/_/_/_/_/_/_/_/_/_/#
sub CHARA_MAIN_INPUT {

	@NEW_DATA=();
	unshift(@NEW_DATA,"$kid<>$kpass<>$kname<>$kchara<>$kstr<>$kint<>$klea<>$kcha<>$ksol<>$kgat<>$kcon<>$kgold<>$krice<>$kcex<>$kclass<>$karm<>$kbook<>$kbank<>$ksub1<>$ksub2<>$kpos<>$kmes<>$khost<>$kdate<>$kmail<>$kos<>\n");

	&SAVE_DATA("$CHARA_DATA/$kid\.cgi",@NEW_DATA,1);

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#     ENEMY DATA ALL OPEN      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub ENEMY_OPEN {

	open(IN,"$CHARA_DATA/$in{'eid'}.cgi") or &ERR2('IDとPASSが正しくありません！');
	@E_DATA = <IN>;
	close(IN);
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/,$E_DATA[0]);
	if($in{'eid'} ne "$eid" ){&ERR2("IDとPASSが正しくありません！");}

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#    ENEMY DATA ALL INPUT      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
sub ENEMY_INPUT {

	@NEW_DATA=();
	unshift(@NEW_DATA,"$eid<>$epass<>$ename<>$echara<>$estr<>$eint<>$elea<>$echa<>$esol<>$egat<>$econ<>$egold<>$erice<>$ecex<>$eclass<>$earm<>$ebook<>$ebank<>$esub1<>$esub2<>$epos<>$emes<>$ehost<>$edate<>$email<>$eos<>\n");

	&SAVE_DATA("$CHARA_DATA/$eid\.cgi",@NEW_DATA,1);

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       LOGの書き込み      _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub MAP_LOG {

	open(IN,"$MAP_LOG_LIST");
	@S_MOVE = <IN>;
	close(IN);
	&TIME_DATA;

	unshift(@S_MOVE,"$_[0]($mday日$hour時$min分)\n");

	splice(@S_MOVE,20);

	open(OUT,">$MAP_LOG_LIST") or &ERR2('LOG 新しいデータを書き込めません。');
	print OUT @S_MOVE;
	close(OUT);

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       LOGの書き込み      _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub MAP_LOG2 {

	open(IN,"$MAP_LOG_LIST2");
	@S_MOVE = <IN>;
	close(IN);
	&TIME_DATA;

	unshift(@S_MOVE,"<b>$_[0]</b>($mday日$hour時$min分)\n");

	splice(@S_MOVE,20);

	open(OUT,">$MAP_LOG_LIST2") or &ERR2('LOG 新しいデータを書き込めません。');
	print OUT @S_MOVE;
	close(OUT);

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       LOGの書き込み      _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub K_LOG {

	open(IN,"./charalog/log/$kid.cgi");
	@K_LOG = <IN>;
	close(IN);

	unshift(@K_LOG,"$_[0]($mday日$hour時$min分)\n");

	splice(@K_LOG,20);

	open(OUT,">./charalog/log/$kid.cgi");
	print OUT @K_LOG;
	close(OUT);

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#    BATTLE ITEM ALL OPEN      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub CHARA_ITEM_OPEN {

	open(IN,"$ARM_LIST") or &ERR('ファイルを開けませんでした。');
	@ARM_DATA = <IN>;
	close(IN);
	open(IN,"$PRO_LIST") or &ERR('ファイルを開けませんでした。');
	@PRO_DATA = <IN>;
	close(IN);

	($karmname,$karmval,$karmdmg,$karmwei,$karmele,$karmsta,$karmclass,$karmtownid) = split(/<>/,$ARM_DATA[$karm]);
	($kproname,$kproval,$kprodmg,$kprowei,$kproele,$kprosta,$kproclass,$kprotownid) = split(/<>/,$PRO_DATA[$kbook]);

	if($eid){
		($earmname,$earmval,$earmdmg,$earmwei,$earmele,$earmsta,$earmclass,$earmtownid) = split(/<>/,$ARM_DATA[$earm]);
		($eproname,$eproval,$eprodmg,$eprowei,$eproele,$eprosta,$eproclass,$eprotownid) = split(/<>/,$PRO_DATA[$ebook]);
	}

}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#       時間 取得        #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub TIME_DATA {
	$tt = time ;
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime(time);
	$mon++;
	$ww = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday];
	$daytime = sprintf("%02d\/%02d\/(%s) %02d:%02d", $mon,$mday,$ww,$hour,$min);
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#        COUNTRY DATA OPEN       #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub COUNTRY_DATA_OPEN {

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);
	$country_no=0;$hit=0;
	foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
		if("$_[0]" eq "$xcid"){$hit=1;last;}
		$country_no++;
	}

	if(!$hit){
		$xcid=0;
		$xname="無所属";
		$xele=0;
		$xmark=0;
		$xking="";
		$xmes=0;
		$xsub=0;
		$xpri=0;
	}
	($xgunshi,$xdai,$xuma,$xgoei,$xyumi,$xhei,$xxsub1,$xxsub2)= split(/,/,$xsub);

	foreach(@COU_DATA){
		($x2cid,$x2name,$x2ele,$x2mark)=split(/<>/);
		$cou_name[$x2cid] = "$x2name";
		$cou_ele[$x2cid] = "$x2ele";
		$cou_mark[$x2cid] = "$x2mark";
	}
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#      COUNTRY DATA INPUT      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
sub COUNTRY_DATA_INPUT {

	splice(@COU_DATA,$country_no,1,"$xcid<>$xname<>$xele<>$xmark<>$xking<>$xmes<>$xsub<>$xpri<>\n");
	&SAVE_DATA($COUNTRY_LIST,@COU_DATA);

	$s_i = int(rand(5));
	if($s_i eq 0 && $xcid ne ""){
		&SAVE_DATA($COUNTRY_LIST2,@COU_DATA);
	}

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#        TOWN DATA OPEN          #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub TOWN_DATA_OPEN {

	open(IN,"$TOWN_LIST") or &ERR("指定されたファイルが開けません。");
	@TOWN_DATA = <IN>;
	close(IN);
	$zid = $_[0];
	($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/,$TOWN_DATA[$_[0]]);

	if($zname eq ""){&ERR("その街は存在しません。");}

	$zc=0;
	foreach(@TOWN_DATA){
		($z2name,$z2con,$z2num,$z2nou,$z2syo,$z2shiro)=split(/<>/);
		$town_name[$zc] = "$z2name";
		$town_cou[$zc] = "$z2con";
		$town_get[$z2con] += 1;
		$town_num[$z2con] += $z2num;
		$town_nou[$z2con] += $z2nou;
		$town_syo[$z2con] += $z2syo;
		$zc++;
	}

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#       TOWN DATA INPUT        #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
sub TOWN_DATA_INPUT {

	if("$zname" ne ""){
		splice(@TOWN_DATA,$zid,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		&SAVE_DATA($TOWN_LIST,@TOWN_DATA);
	}

	$s_it = int(rand(5));
	if($s_it == 0 && $zname ne ""){
		&SAVE_DATA($TOWN_LIST2,@TOWN_DATA);
	}
}

#_/_/_/_/_/_/_/_/#
#     DECODE     #
#_/_/_/_/_/_/_/_/#

sub DECODE {

	if ($ENV{'REQUEST_METHOD'} eq "POST") {
		if ($ENV{'CONTENT_LENGTH'} > 51200) { &ERR("投稿量が大きすぎます"); }
		read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
	} else { $buffer = $ENV{'QUERY_STRING'}; }
	@pairs = split(/&/, $buffer);

	$v=0;
	foreach (@pairs) {
		($name,$value) = split(/=/, $_);
		$value =~ tr/+/ /;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

		# 文字コードをシフトJIS変換
		&jcode'convert(*value, "sjis", "", "z");

		# タグ処理
		$value =~ s/</&lt;/g;
		$value =~ s/>/&gt;/g;
		$value =~ s/\"/&quot;/g;

		# 改行等処理
		if ($name eq "ins") {
			$value =~ s/\r\n/<br>/g;
			$value =~ s/\r/<br>/g;
			$value =~ s/\n/<br>/g;
		} else {
			$value =~ s/\r//g;
			$value =~ s/\n//g;
		}

		if($name eq 'no'){
			$no[$v] = $value;
			$v++;
			$in{$name} = $value;
		}else{
			$in{$name} = $value;
		}
	}
	$mode = $in{'mode'};
	$in{'url'} =~ s/^http\:\/\///;
	$cookie_pass = $in{'pass'};
	$cookie_id = $in{'id'};
}


#_/_/_/_/_/_/_/_/#
#   HOST NAME    #
#_/_/_/_/_/_/_/_/#

sub HOST_NAME {
	$host = $ENV{'REMOTE_HOST'};
	$addr = $ENV{'REMOTE_ADDR'};

	if ($get_remotehost) {
		if ($host eq "" || $host eq "$addr") {
			$host = gethostbyaddr(pack("C4", split(/\./, $addr)), 2);
		}
	}
	if ($host eq "") { $host = $addr; }

}

#_/_/_/_/_/_/_/_/#
#  ERROR PRINT   #
#_/_/_/_/_/_/_/_/#

sub ERR {

	&CHARA_MAIN_OPEN;
	&HEADER;
	print "<center><hr size=0><h3>ERROR !</h3>\n";
	print "<P><font color=red><B>$_[0]</B></font>\n";
	print "<form action=\"$FILE_STATUS\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit value=\"街へ戻る\"></form>";
	print "<P><hr size=0></center>\n</body></html>\n";
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#   ERROR PRINT2   #
#_/_/_/_/_/_/_/_/_/#

sub ERR2 {

	&HEADER;
	print "<center><hr size=0><h3>ERROR !</h3>\n";
	print "<P><font color=red><B>$_[0]</B></font>\n";
	print "<P><hr size=0></center>\n</body></html>\n";
	exit;
}


#_/_/_/_/_/_/_/_/_/_/_/_/#
#     SAVE_DATA          #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub SAVE_DATA (\$\@){

	local($datafile, @data) = @_;
	if($LOCK){
		if($_[2]){
			local($datadir) = $CHARA_DATA;
		}else{
			local($datadir) = $LOG_DIR;
		}
		local($tmpfile) = $datafile . '.tmp';
		local($tmp_dummy) = $datafile . '.dmy.tmp';
		local($file) = substr($datafile,length($datadir) + 1);
		opendir(DIR, $datadir) ;
		@list = readdir(DIR) ;
		closedir(DIR) ;
		foreach (@list) {
			if ($_ =~ /($file).*\.tmp$/) {
				local($mtime) = (stat($tmpfile))[9];
				my $at_last = time - 60 - $mtime;
				if ($mtime && 0 < $at_last) {
					&UNLOCK;
				}
				&ERR2("テンポラリファイルが存在します。<br>LOCK解除まで $at_last 秒");
			}
		}
		if(!open(TMP,">$tmpfile")){
			&UNLOCK;
			&ERR2("テンポラリファイルが作成出来ません。<br>");
		}elsif(!close(TMP)){
			&UNLOCK;
			&ERR2("テンポラリファイルがクローズ出来ません。<br>");
		}elsif(!open(DMY,">$tmp_dummy")){
			&UNLOCK;
			&ERR2("格納用一時ファイルが作成出来ません。<br>");
		}elsif(!close(DMY)){
			&UNLOCK;
			&ERR2("格納用一時ファイルがクローズ出来ません。<br>");
		}elsif(!chmod (0666,"$tmp_dummy")){
			&UNLOCK;
			&ERR2("格納用一時ファイルの属性が変更出来ません。<br>");
		}elsif(!open(DMY,">$tmp_dummy")){
			&UNLOCK;
			&ERR2("格納用一時ファイルがオープン出来ません。<br>");
		}
		print DMY @data;
		if (!close(DMY)){
			&UNLOCK;
			&ERR2("格納用一時ファイルが保存出来ません。<br>");
		}elsif(!rename("$tmp_dummy" , "$datafile")){
			&UNLOCK;
			&ERR2("格納用一時ファイルをデータファイルにリネーム出来ません。<br>");
		}elsif(!unlink ("$tmpfile")){
			&UNLOCK;
			&ERR2("テンポラリファイルが削除出来ません。<br>");
		}
	}else{
		open(OUT,">$datafile");
		print OUT @data;
		close(OUT);
	}
}
##########
# UNLOCK #
##########
sub UNLOCK{
	unlink ("$tmpfile");
	unlink ("$tmp_dummy");
}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#       HTML HEADER      #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub HEADER {

	print "Cache-Control: no-cache\n";
	print "Pragma: no-cache\n";
	print "Content-type: text/html\n\n";
	print <<"EOM";
<html>
<head>
<META HTTP-EQUIV="Content-type" CONTENT="text/html; charset=Shift_JIS">
EOM
	print <<"EOM";
<STYLE type="text/css">
<!--
BODY,TR,TD,TH{
font-family : "ＭＳ ゴシック";
font-size: $FONT_SIZE
}
A:HOVER{
 color: $ALINK
}
.S1 {color:#fff; border-style: double; border-width: 3px;BACKGROUND: #633;}
.dmg { color: #FF0000; font-size: 18pt }
.clit { color: #0000FF; font-size: 18pt }
.r { color: #FF4444; font-size: 10pt }
.b { color: #4444DD; font-size: 10pt }
.s { color: #44AAEE; font-size: 10pt }
.g { color: #44DD44; font-size: 10pt }
.o { color: #EEAA44; font-size: 10pt }
-->
</STYLE>
<title>$GAME_TITLE</title></head>
<body background="$BACKGROUND" bgcolor="$BGCOLOR" text="$TEXT" link="$LINK" vlink="$VLINK" alink="$ALINK" leftmargin="0" marginwidth="0" marginheight="0">
EOM


}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#       HTML FOOTER      #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub FOOTER {
	# 可変、削除禁止
	print "<CENTER><HR SIZE=0>\n";
	print "<font color=998877>三国志NET $VER <a href=\"http://www3.to/maccyu2/\" target=\"_top\">maccyu</a><br>\n";
	print "ADMINISTARTOR <a href=\"./index.cgi\" target=\"_top\">HOME</a><br>\n";
    print "</body></html>\n";
}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#    COOKIE 情報取得     #
#_/_/_/_/_/_/_/_/_/_/_/_/#
sub GET_COOKIE {
	@pairs = split(/;/, $ENV{'HTTP_COOKIE'});
	foreach (@pairs) {
		local($key,$val) = split(/=/);
		$key =~ s/\s//g;
		$GET{$key} = $val;
	}
	@pairs = split(/,/, $GET{'WOR'});
	foreach (@pairs) {
		local($key,$val) = split(/<>/);
		$COOK{$key} = $val;
	}
	$_id  = $COOK{'id'};
	$_pass = $COOK{'pass'};
}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#        SET COOKIE      #
#_/_/_/_/_/_/_/_/_/_/_/_/#
sub SET_COOKIE {

	local($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime(time+60*24*60*60);
	@month=('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	$gmt = sprintf("%s, %02d-%s-%04d %02d:%02d:%02d GMT",
			$week[$wday],$mday,$month[$mon],$year+1900,$hour,$min,$sec);
	$cook="id<>$cookie_id\,pass<>$cookie_pass";
	print "Set-Cookie: WOR=$cook; expires=$gmt\n";
}

#_/_/_/_/_/_/_/_/_/_/#
#   GUEST情報収集    #
#_/_/_/_/_/_/_/_/_/_/#

sub MAKE_GUEST_LIST {

	open(GUEST,"$GUEST_LIST") or &ERR2('ファイルを開けませんでした。');
	@GUEST=<GUEST>;close(GUEST);

	$times = time();@m_list = ();$hit=0;@New_guest_list=();

	foreach (@GUEST){($timer,$name,$con,$opos) = split(/<>/);
		if( $times - 180 > $timer){
			next;
		}elsif($kname eq $name){
			if( $times - 5 <= $timer && $SERVER_REDUCTION){
				&ERR("前回更新してから５秒以上経過していません。<BR>間隔をあけて実行してください。");
			}
			push (@New_guest_list,"$times<>$kname<>$kcon<>$kpos<>\n");
			$m_list .= "$kname\[$town_name[$kpos]\] ";
			$hit = 1;
		}else{
			push (@New_guest_list,"$timer<>$name<>$con<>$opos<>\n");
			if($kcon eq $con){
				$m_list .= "$name\[$town_name[$opos]\] ";
			}
		}
	}

	if(!$hit){
		push(@New_guest_list,"$times<>$kname<>$kcon<>$kpos<>\n");
		$m_list .= "$kname\[$town_name[$kpos]\] ";
	}

	open(GUEST,">$GUEST_LIST") or &ERR('ファイルを開けませんでした。');
	print GUEST @New_guest_list;close(GUEST);
}

#_/_/_/_/_/_/_/_/_/_/#
#   負荷防止機能     #
#_/_/_/_/_/_/_/_/_/_/#

sub SERVER_STOP {

	&HOST_NAME;
	open(GUEST,"$LOG_DIR/stop.cgi") or &ERR2('ファイルを開けませんでした。');
	@STOP=<GUEST>;close(GUEST);
if($host eq ""){&ERR("ホスト名を有効にしてください。");}
	$times = time();@m_list = ();$hit=0;@New_stop=();
	$phit=0;
	foreach (@STOP){
		($stimer,$shost) = split(/<>/);
		if( $times - 180 > $stimer){
			next;
		}elsif($shost eq $host){
			if( $times-5 <= $stimer){
				$phit = 1;
			}
			push (@New_stop,"$times<>$host<>\n");
			$hit = 1;
		}else{
			push (@New_stop,"$stimer<>$shost<>\n");
		}
	}


	if(!$hit){
		push(@New_stop,"$times<>$host<>\n");
	}

	open(GUEST,">$LOG_DIR/stop.cgi") or &ERR('ファイルを開けませんでした。');
	print GUEST @New_stop;close(GUEST);

	if($phit && $SERVER_REDUCTION){
		if($in{'id'} eq ""){
			&ERR2("サーバへの不可防止の為、更新してから<BR>5秒以上間隔をあけて実行してください。<BR>Your host name : $host"); 
		}else{
			&ERR("サーバへの不可防止の為、更新してから<BR>5秒以上間隔をあけて実行してください。<BR>Your host name : $host"); 
		}
	}

}


1;

