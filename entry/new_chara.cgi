#_/_/_/_/_/_/_/_/_/_/_/_/#
#        NEW_CHARA       #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub NEW_CHARA {

	&CHEACKER;
	if ($CHARA_STOP) { &ERR2("現在新規登録は受け付けておりません"); }
	if ($in{'id'} =~ m/[^0-9a-zA-Z]/) { &E_ERR("IDに半角英数字以外の文字が含まれています。"); }
	if ($in{'pass'} =~ m/[^0-9a-zA-Z]/) { &E_ERR("パスワードに半角英数字以外の文字が含まれています。"); }
	if ($in{'mail'} =~ /yahoo/ || $in{'mail'} =~ /hotmail/) { &E_ERR("そのメールアドレスは使用できません。"); }
	if ($in{'mail'} eq "" || $in{'mail'} !~ /(.*)\@(.*)\.(.*)/){ &E_ERR("メールの入力が不正です。");}
	if ($in{'id'} eq "" or length($in{'id'}) < 4 or length($in{'id'}) > 8) { &E_ERR("IDは、4文字以上、8文字以下で入力して下さい。"); }
	elsif($in{'pass'} eq "" || length($in{'pass'}) < 4 || length($in{'pass'}) > 8) { &E_ERR("パスワードは、4文字以上、8文字以下で入力して下さい。"); }
	elsif($in{'con'} eq "") { &E_ERR("初期位置が選択されていません。"); }
	elsif($in{'mail'} eq "\@" || $in{'mail'} eq "") { &E_ERR("メールの入力が不正です"); }
	elsif($in{'pass'} eq "" || length($in{'pass'}) < 4 || length($in{'pass'}) > 16) { &E_ERR("キャラクターのパスワードが正しく入力されていません。"); }
	elsif($in{'chara_name'} eq "" || length($in{'chara_name'}) < 4 || length($in{'chara_name'}) > 12) { &E_ERR("キャラクターの名前が正しく入力されていません。"); }
	elsif($in{'id'} eq $in{'pass'}) { &E_ERR("IDとパスワードが同じ場合、登録はできません"); }
	if ($in{'str'} =~ m/[^0-9]/) { &E_ERR("力に数字以外の文字が含まれています。"); }
	if ($in{'str'} eq "" || $in{'str'} < 5 || $in{'str'} > 100) { &E_ERR("力が正しく入力されていません。");}
	if ($in{'int'} =~ m/[^0-9]/) { &E_ERR("知力に数字以外の文字が含まれています。"); }
	if ($in{'int'} eq "" || $in{'int'} < 5 || $in{'int'} > 100) { &E_ERR("知力が正しく入力されていません。");}
	if ($in{'tou'} =~ m/[^0-9]/) { &E_ERR("統率力に数字以外の文字が含まれています。"); }
	if ($in{'chara'} =~ m/[^0-9]/) { &E_ERR("不正です。"); }
	if($in{'tou'} eq "" || $in{'tou'} < 5 || $in{'tou'} > 100) { &E_ERR("統率力が正しく入力されていません。");}

	$max = $in{'str'} + $in{'int'} + $in{'tou'};
	if($max ne "150"){
		&E_ERR("合計の\能\力が１５０ではありません。（計：$max）");
	}

	open(IN,"$TOWN_LIST") or &E_ERR("指定されたファイルが開けません。");
	@TOWN_DATA = <IN>;
	close(IN);

	open(IN,"$COUNTRY_LIST") or &E_ERR('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);

	open(IN,"$COUNTRY_NO_LIST") or &E_ERR('ファイルを開けませんでした。err no :country no');
	@COU_NO_DATA = <IN>;
	close(IN);

	$zc=0;$m_hit=0;
	($z2name,$z2con)=split(/<>/,$TOWN_DATA[$in{'con'}]);
	if($z2con eq ""){
		if($in{'ele'} eq ""){
			&E_ERR("君主の場合国の色を選択してください。");
		}elsif($in{'cou_name'} eq "" || length($in{'cou_name'}) < 2 || length($in{'cou_name'}) > 8) {
			&E_ERR("国の名前が正しく入力されていません。");
		}
		$m_hit = 1;
		$cou_name = $in{'cou_name'};
		$new_cou_no = @COU_NO_DATA + 1;
		$hit = 1;
	}else{
		foreach(@COU_DATA){
			($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
			if($xcid eq $z2con){
				$cou_name = $xname;
				$kcon = $xcid;
				$hit = 1;
			}
		}
	}

	if(!$hit){
		&E_ERR("その国は存在しません。");
	}

	&SET_COOKIE;
	&HOST_NAME;

	$date = time();
	$pos = 2;
	open(IN,"./charalog/main/$in{'id'}.cgi");
	@NEWCHARA = <IN>;
	close(IN);

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&E_ERR("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@REGIST_VI,"@page<br>");
		}
	}
	closedir(dirlist);

	$hit=0;@new_chara=();
	($rkid,$rkpass,$rkname,$rkchara,$rkstr,$rkint,$rklea,$rkcha,$rksol,$rkgat,$rkcon,$rkgold,$rkrice,$rkcex,$rkclass,$rkarm,$rkbook,$rkbank,$rksub1,$rksub2,$rkpos,$rkmes,$rkhost,$rkdate,$rkmail,$rkos) = split(/<>/,$NEWCHARA[0]);

	if($rkid eq "$in{'id'}") {&E_ERR("そのIDは登録済みです。違うIDを選択してください。");}

	if($REFREE){
		if($ENV{'HTTP_REFERER'} ne "$SANGOKU_URL/$FILE_ENTRY" && $ENV{'HTTP_REFERER'} ne "$SANGOKU_URL/$FILE_TOP" && $ENV{'HTTP_REFERER'} ne "$SANGOKU_URL/"){ &E_ERR("ERR No.001<BR>そのキャラクターは作れません。<BR>管理者に問い合わせて下さい。<BR>P1:$ROSER_URL/$FILE_ENTRY<BR>P2$ENV{'HTTP_REFERER'}"); }
	}
	foreach(@REGIST_VI){
		($rkid,$rkpass,$rkname,$rkchara,$rkstr,$rkint,$rklea,$rkcha,$rksol,$rkgat,$rkcon,$rkgold,$rkrice,$rkcex,$rkclass,$rkarm,$rkbook,$rkbank,$rksub1,$rksub2,$rkpos,$rkmes,$rkhost,$rkdate,$rkmail,$rkos) = split(/<>/);
		if($ACCESS){
			if($host eq $rkhost ){
				&E_ERR("一人につき１キャラクターです。もしくは同じIPの方が既に登録しています。");
			}
		}
		if($rkname eq "$in{'chara_name'}"){
			&E_ERR("その名前は既に登録されています。違う名前で登録してください。");
		}
		if($rkmail eq "$in{'mail'}"){
			&E_ERR("そのメールアドレスは既に登録されています。");
		}
		if($kcon eq $rkcon){
			$con_num++;
		}
	}

	if($xmark < $BATTLE_STOP && $con_num >= $CON_ENTRY_MAX){
		&E_ERR("その国は定員を超えているので入国できません。");
	}
	if($m_hit){
		$kcon = $new_cou_no;
		$month_read = "$LOG_DIR/date_count.cgi";
		open(IN,"$month_read") or &E_ERR('ファイルを開けませんでした。');
		@MONTH_DATA = <IN>;
		close(IN);
		($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
		$old_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);

		push(@COU_DATA,"$new_cou_no<>$in{'cou_name'}<>$in{'ele'}<>1<>$in{'id'}<><>$in{'chara_name'}<>1<>\n");
		open(OUT,">$COUNTRY_LIST") or &E_ERR('COUNTRY データを書き込めません。');
		print OUT @COU_DATA;
		close(OUT);

		push(@COU_NO_DATA,"$new_cou_no<>$in{'cou_name'}<>$in{'ele'}<>1<>$in{'id'}<><><>1<>\n");
		open(OUT,">$COUNTRY_NO_LIST") or &E_ERR('COUNTRY データを書き込めません。');
		print OUT @COU_NO_DATA;
		close(OUT);

		&TOWN_DATA_OPEN("$in{'con'}");
		$zcon = $new_cou_no;
		&TOWN_DATA_INPUT;
		&MAP_LOG2("<font color=000088><B>【建国】</B></font>\[$old_date\]新しく$in{'chara_name'}が$cou_name国を建国しました。");
		&MAP_LOG("<font color=000088><B>【建国】</B></font>新しく$in{'chara_name'}が$cou_name国を建国しました。");

	}else{
		&MAP_LOG("<font color=0088CC><B>\[仕官\]</B></font>新しく$in{'chara_name'}が$cou_name国に仕官しました。");
	}

	@NEW_COM=();
	for($i=0;$i<$MAX_COM;$i++){
		push(@NEW_COM,"<><><>$tt<><><>50<>\n");
	}

	open(OUT,">./charalog/command/$in{'id'}.cgi");
	print OUT @NEW_COM;
	close(OUT);

	if($ATTESTATION){
		&mail_to;
		$os = 0;
	}else{
		$os = 1;
	}

	$kcha = int(rand(101));
	$ksol = 0;
	$kgat = 0;
	$kgold = 1000;
	$krice = 500;
	$kcex = 0;
	$kclass = 0;
	$karm = 0;
	$kbook = 0;
	$kbank = "";
	$ksub1 = "";
	$ksub2 = $DEL_TURN - 10;
	$kstr = $in{'str'}+0;
	$kint = $in{'int'}+0;
	$ktou = $in{'tou'}+0;

	unshift(@new_chara,"$in{'id'}<>$in{'pass'}<>$in{'chara_name'}<>$in{'chara'}<>$kstr<>$kint<>$ktou<>$kcha<>$ksol<>$kgat<>$kcon<>$kgold<>$krice<>$kcex<>$kclass<>$karm<>$kbook<>$kbank<>$ksub1<>$ksub2<>$in{'con'}<>$in{'mes'}<>$host<>$date<>$in{'mail'}<>$os<>\n");
	open(OUT,">./charalog/main/$in{'id'}.cgi");
	print OUT @new_chara;
	close(OUT);

	&DATA_SEND;
	exit;
}


#------------------#
#  メール送信処理  #
#------------------#
sub mail_to {
	unless (-e $SENDMAIL) { &E_ERR("sendmailのパスが不正です"); }

	# メールタイトル
	$mail_sub = " 登録完了通知";
	&TIME_DATA;

	$a_pass = crypt("$in{'pass'}", $ATTESTATION_ID);
	# メール本文
	$mail_msg = <<"EOM";
$in{'chara_name'} 様

この度は、$GAME_TITLE への登録をありがとうございました。
登録内容は以下のとおりですので、ご確認ください。

■登録日時：$daytime
■ホスト名：$host
■参加者名：$in{'chara_name'}
■Ｅメール：$in{'mail'}
■ＩＤ    ：$in{'id'}
■ＰＡＳＳ：$in{'pass'}
■認証キー：$a_pass

認証キーを登録することによってゲームに参加することがで
きます。

[認証キーの設定]
$SANGOKU_URL/entry.cgi?mode=ATTESTATION
(※こちらから登録が出来ます。)

よく参加規約をよく読んでからゲームを開始してください。
また、パスワード、ＩＤ等の再発行は致しませんので大切に
保管しておいて下さい。

_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
$GAME_TITLE管理人
  Home:   $HOME_URL
EOM
	# JISコードへ変換
    	&jcode'convert(*mail_sub,'jis');
    	&jcode'convert(*mail_msg,'jis');

	# コメント内の改行とタグを復元
	$mail_msg =~ s/<br>/\n/ig;

	# メール処理
	open(MAIL,"| $SENDMAIL -t") || &E_ERR("メール送信に失敗しました");
	print MAIL "To: $in{'mail'}\n";
	print MAIL "Subject: $mail_sub\n";
	print MAIL "MIME-Version: 1.0\n";
	print MAIL "Content-type: text/plain; charset=ISO-2022-JP\n";
	print MAIL "Content-Transfer-Encoding: 7bit\n";
	print MAIL "X-Mailer: $ver\n\n";
	print MAIL "$mail_msg\n";
	close(MAIL);

}
#_/_/_/_/_/_/_/_/#
#  ERROR PRINT   #
#_/_/_/_/_/_/_/_/#

sub E_ERR {

	&HEADER;
	if (-e $lockfile) { unlink($lockfile); }
	print "<center><hr size=0><h3>ERROR !</h3>\n";
	print "<P><font color=red><B>$_[0]</B></font>\n";
	print "<form action=\"$FILE_ENTRY\" method=\"post\"><input type=hidden name=id value=$in{'id'}><input type=hidden name=pass value=$in{'pass'}><input type=hidden name=mail value=$in{'mail'}><input type=hidden name=url value=$in{'url'}><input type=hidden name=chara_name value=$in{'chara_name'}><input type=hidden name=mes value=$in{'mes'}><input type=hidden name=mode value=entry><input type=submit value=\"入力に戻る\"></form>";
	print "<P><hr size=0></center>\n</body></html>\n";
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