#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#      メッセージ送信処理      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub MES_SEND {

	if($in{'message'} eq "") { &ERR("メッセージが記入されていません"); }
	if($in{'mes_id'} eq "") { &ERR("相手が指定されていません"); }
	if(length($in{'message'}) > 200) { &ERR("手紙は、全角１００文字以下で入力して下さい。"); }
	&CHARA_MAIN_OPEN;
	if($in{'mes_id'} eq "$kid") { &ERR("自分には送れません。"); }
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN($kcon);

	$mes_id = $in{'mes_id'};

	&TIME_DATA;

	$bum = length($mes_id);

	open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
	@MES_REG = <IN>;
	close(IN);

	if($in{'mes_id'} eq "111"){
		$jname = "$zname";
	}elsif($in{'mes_id'} eq "333"){

		open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
		@UNI_DATA = <IN>;
		close(IN);

		$uhit=0;
		foreach(@UNI_DATA){
			($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg)=split(/<>/);
			if("$uid" eq "$kid"){$uhit=1;last;}
		}
		if(!$uhit || "$xcid" eq "0"){&ERR("無所属は部隊へ送れません。");}
		$jname = "$uunit_name部隊";
		$hunit = $unit_id;
		if($unit_id eq $kid){
		$u_add ="<font color=FFCC33><B>[隊長]</b></font>";
		}else{
		$u_add ="<font color=33CCFF><B>[隊員]</b></font>";
		}
	}elsif($bum < 4){
		$jname = "$cou_name[$mes_id]国";
	}else{
		open(IN,"./charalog/main/$in{'mes_id'}.cgi");
		@C_DATA = <IN>;
		close(IN);
		($jid,$jpass,$jname) = split(/<>/,$C_DATA[0]);
	}

	$mes_num = @MES_REG;

	if($mes_num > $MES_MAX) { pop(@MES_REG); }

	unshift(@MES_REG,"$in{'mes_id'}<>$kid<>$kpos<>$kname<>$u_add$in{'message'}<>$jname<>$daytime<>$kchara<>$kcon<>$hunit<>\n");

	&SAVE_DATA($MESSAGE_LIST,@MES_REG);

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$jnameへ手紙を送りました。</h2><p>
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