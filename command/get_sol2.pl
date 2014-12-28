#_/_/_/_/_/_/_/_/_/_/#
#        徴兵２      #
#_/_/_/_/_/_/_/_/_/_/#

sub GET_SOL2 {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if($in{'num'} eq ""){&ERR("徴兵する人数が入力されていません。");}
	if($in{'type'} eq ""){&ERR("徴兵する種類が入力されていません。");}
	if($in{'num'} =~ m/[^0-9]/){&ERR("徴兵する人数に数字以外の文字が含まれています。"); }
	&CHARA_MAIN_OPEN;
	&TIME_DATA;

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	$mes_num = @COM_DATA;

	if($mes_num > $MAX_COM) { pop(@COM_DATA); }

	@NEW_COM_DATA=();$i=0;
	if($in{'no'} eq "all"){
		while(@NEW_COM_DATA < $MAX_COM){
			push(@NEW_COM_DATA,"10<><>$SOL_TYPE[$in{'type'}]徴兵（$in{'num'}人）<>$tt<>$in{'type'}<>$in{'num'}<>$in{'gat'}<>\n");
		}
		$no = $in{'no'};
	}else{
		foreach(@COM_DATA){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);
			$ahit=0;
			foreach(@no){
				if($i eq $_){
					$ahit=1;
					push(@NEW_COM_DATA,"10<><>$SOL_TYPE[$in{'type'}]徴兵（$in{'num'}人）<>$tt<>$in{'type'}<>$in{'num'}<>$in{'gat'}<>\n");
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
<CENTER><hr size=0><h2>NO:$noに$mes$SOL_TYPE[$in{'type'}]（$in{'num'}人）徴兵を入力しました。</h2><p>
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