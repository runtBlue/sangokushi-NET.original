#_/_/_/_/_/_/_/_/_/#
#_/    部隊作成  _/#
#_/_/_/_/_/_/_/_/_/#

sub MAKE_UNIT {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	if($xcid eq "0"){&ERR("無所属国は実行できません。");}
	if($in{"name"} eq "無所属" || $in{"name"} eq ""){&ERR("その名前は付けられません。");}
	elsif($in{'name'} eq "" || length($in{'name'}) < 4 || length($in{'name'}) > 16) { &ERR("部隊名は、２文字以上、８文字以下で入力して下さい。"); }
	elsif(length($in{'mes'}) > 40) { &ERR("部隊募集コメントは、２０文字以下で入力して下さい。"); }
	if($kclass < 500){&ERR("貢献値が足りません。");}

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg)=split(/<>/);
		if($in{"name"} eq "$uunit_name"){&ERR("その名前は既に存在します。");}
		if("$unit_id" eq "$kid"){&ERR("部隊長は部隊を作成できません。<BR>1度部隊を解散させて下さい。");}
		if("$uid" eq "$kid"){&ERR("部隊に所属している場合は部隊を作成できません。部隊から脱退してください。");}
	}

	if($kcex < ($READER_POINT * 10)){$pass = 0;}else{$pass = int($kcex / 10);}
	unshift(@UNI_DATA,"$kid<>$in{'name'}<>$kcon<>1<>$kid<>$kname<>$kchara<>$in{'mes'}<>0<>0<>\n");
	open(OUT,">$UNIT_LIST") or &ERR('UNIT1 新しいデータを書き込めません。');
	print OUT @UNI_DATA;
	close(OUT);
	&CHARA_MAIN_INPUT;

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$in{"name"}部隊を作成しました。</h2><p>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="街に戻る"></form></CENTER>
EOM
	&FOOTER;
	exit;
}
1;