#_/_/_/_/_/_/_/_/_/#
#      国変更      #
#_/_/_/_/_/_/_/_/_/#

sub KING_COM4 {

	if($in{'sel'} eq "") { &ERR("選択されていません"); }

	if($REFREE){
		$r_str = length("$SANGOKU_URL");
		$r_url = substr("$ENV{'HTTP_REFERER'}", 0, $r_str);
		if($r_url ne $SANGOKU_URL){ &ERR2("ERR No.002<BR>そのキャラクターは作れません。<BR>管理者に問い合わせて下さい。<BR>P1:$ROSER_URL <BR>P2:$r_url"); }
	}

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	if($xking ne $kid){&ERR("王でなければ実行できません。");}

	$sel = $in{'sel'};
	open(IN,"./charalog/main/$sel\.cgi") or &ERR2('IDとPASSが正しくありません！');
	@E_DATA = <IN>;
	close(IN);
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/,$E_DATA[0]);	if($kcon ne "$econ") { &ERR("不正な処理です。"); }
	if($kid eq "$eid") { &ERR("不正な処理です。"); }

	&TIME_DATA;

	if($sel){
		$econ = 0;
		$res_mes = "$enameは$xname国から解雇されました。";
		&MAP_LOG("<font color=880088><b>【解雇】</b></font>$enameは$xname国から解雇されました。");
	}

	open(IN,"$LOG_DIR/black_list.cgi");
	@B_LIST = <IN>;
	close(IN);

	@NEW_B_LIST=();
	$hit=0;
	foreach(@B_LIST){
		($bid,$bcon,$bname,$bsub) = split(/<>/);
		if($bid eq $eid && $bcon eq $econ){
			$hit=1;
			push(@NEW_B_LIST,"$eid<>$econ<>$ename<><>\n");
		}else{
			push(@NEW_B_LIST,"$_");
		}
	}

	if(!$hit){
		unshift(@NEW_B_LIST,"$eid<>$econ<>$ename<><>\n");
	}

	open(OUT,">$LOG_DIR/black_list.cgi");
	print OUT @NEW_B_LIST;
	close(OUT);
	&ENEMY_INPUT;

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$res_mes</h2><p>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;

	exit;

}
1;