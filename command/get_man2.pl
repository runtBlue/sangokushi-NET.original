#_/_/_/_/_/_/_/_/_/_/#
#        登用２      #
#_/_/_/_/_/_/_/_/_/_/#

sub GET_MAN2 {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if($in{'num'} eq ""){&ERR("相手が入力されていません。");}
	if(length($in{'mes'}) > 120) { &ERR("手紙は、全角６０文字以下で入力して下さい。"); }

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);
	if($kgold < 100){&ERR("金が足りません。");}
	require 'ini_file/com_list.ini';

	$num = $in{'num'};
	$hit=0;

	open(IN,"./charalog/main/$num\.cgi") or &ERR('そのキャラは登用できません。');
	@E_DATA = <IN>;
	close(IN);
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/,$E_DATA[0]);


	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	$mes_num = @COM_DATA;

	if($mes_num > $MAX_COM) { pop(@COM_DATA); }

	$add_mes = "$xname国の使者";

	@NEW_COM_DATA=();$i=0;
	if($in{'no'} eq "all"){
		while(@NEW_COM_DATA < $MAX_COM){
				push(@NEW_COM_DATA,"$in{'mode'}<>$ename<>$enameを登用<>9999<>$add_mes:$in{'mes'}<>$in{'num'}<>$kcon<>\n");
		}
		$no = $in{'no'};
	}else{
		foreach(@COM_DATA){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);
			$ahit=0;
			foreach(@no){
				if($i eq $_){
					$ahit=1;
					push(@NEW_COM_DATA,"$in{'mode'}<>$ename<>$enameを登用<>9999<>$add_mes:$in{'mes'}<>$in{'num'}<>$kcon<>\n");
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
<CENTER><hr size=0><h2>NO:$noに$enameを登用を入力しました。</h2><p>
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