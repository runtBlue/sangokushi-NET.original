#_/_/_/_/_/_/_/_/_/#
#_/   入隊拒否  _/#
#_/_/_/_/_/_/_/_/_/#

sub UNIT_CHANGE {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	if($xcid eq "0"){&ERR("無所属国は実行できません。");}

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	$mhit=0;$hit=0;@NEW_UNI_DATA=();
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg)=split(/<>/);
		if("$uid" eq "$kid"){
			$hit=1;
			$uni_name = $uunit_name;
			if($uflg){
				$uflg = 0;
				$mess = "ＯＫ";
			}else{
				$uflg = 1;
				$mess = "拒否";
			}
			push(@NEW_UNI_DATA,"$unit_id<>$uunit_name<>$ucon<>$ureader<>$uid<>$uname<>$uchara<>$umes<>$uflg<>\n");
		}else{
			push(@NEW_UNI_DATA,"$_");
		}
	}

	if(!$hit){
		&ERR("隊長以外は実行できません。");
	}

	open(OUT,">$UNIT_LIST") or &ERR('UNIT2 新しいデータを書き込めません。');
	print OUT @NEW_UNI_DATA;
	close(OUT);

	&CHARA_MAIN_INPUT;
	&HEADER;
	print <<"EOM";
<CENTER><hr size=0><h2>$uni_name部隊を入隊$messにしました。</h2><p>

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