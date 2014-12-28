#_/_/_/_/_/_/_/_/_/_/#
#        購入２      #
#_/_/_/_/_/_/_/_/_/_/#

sub DEF_BUY2 {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if($in{'select'} eq ""){&ERR("商品が入力されていません。");}
	&CHARA_MAIN_OPEN;
	open(IN,"$PRO_LIST") or &ERR('ファイルを開けませんでした。');
	@DEF_DATA = <IN>;
	close(IN);

	$num = $in{'select'};
	($earmname,$earmval,$earmdmg,$earmwei,$earmele,$earmsta,$earmclass,$earmtownid) = split(/<>/,$DEF_DATA[$num]);
	$hit=0;
	if($earmval > $kgold){&ERR("お金が足りません。");}

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	$mes_num = @COM_DATA;

	if($mes_num > $MAX_COM) { pop(@COM_DATA); }

	@NEW_COM_DATA=();$i=0;
	if($in{'no'} eq "all"){
		while(@NEW_COM_DATA < $MAX_COM){
			push(@NEW_COM_DATA,"$in{'mode'}<><>書籍:$earmnameを購入<>$tt<><>$num<><>\n");
		}
		$no = $in{'no'};
	}else{
		foreach(@COM_DATA){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);

			$ahit=0;
			foreach(@no){
				if($i eq $_){
					$ahit=1;
					push(@NEW_COM_DATA,"$in{'mode'}<><>書籍:$earmnameを購入<>$tt<><>$num<><>\n");
					$lno = $_ + 1;
					$no .= "$lno,";
				}
			}
			if(!$ahit){
				push(@NEW_COM_DATA,"$_");
			}

			$i++;
		}
	}
	open(OUT,">./charalog/command/$kid.cgi") or &ERR('ファイルを開けませんでした。');
	print OUT @NEW_COM_DATA;
	close(OUT);

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>NO:$noに書籍:$earmnameを購入を入力しました。</h2><p>
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