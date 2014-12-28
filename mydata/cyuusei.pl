#_/_/_/_/_/_/_/_/_/#
#      国変更      #
#_/_/_/_/_/_/_/_/_/#

sub CYUUSEI {

	if($in{'cyuu'} eq "") { &ERR("入力されていません"); }
	if ($in{'cyuu'} =~ m/[^0-9]/){&ERR("数字以外の文字が含まれています。"); }
	if($in{'cyuu'} < 0 || $in{'cyuu'} > 100 ) { &ERR("0～100の間で入力してください。"); }


	$cyuu = $in{'cyuu'}+0;
	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kpos);

	&TIME_DATA;

	$kbank = $cyuu;
	$res_mes = "$knameは忠誠度を$cyuuに設定しました。";

	&CHARA_MAIN_INPUT;
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