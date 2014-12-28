#_/_/_/_/_/_/_/_/_/#
#_/    会議室    _/#
#_/_/_/_/_/_/_/_/_/#

sub COUNTRY_TALK {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
    if($xcid eq 0){&ERR("無所属国は使用できません。");}
	$sno = $kclass / 500;
	if($sno > 20){$sno = 20;}

	open(IN,"$BBS_LIST") or &ERR('ファイルを開けませんでした。err no :country_bbs');
	@BBS_DATA = <IN>;
	close(IN);


	&HEADER;

	print <<"EOM";
<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=STATUS>
<input type=hidden name=pass value=$kpass>
<input type=submit value="戻る"></form>

<form action="./i-command.cgi" method="post">
題名<input type=text name=title size=40><BR>
内容<input type=text name=ins size=40><p>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=COUNTRY_WRITE>
<input type=submit value="掲示">
</form>
EOM
	$BBS_NEXT_NUM = 2;

	if($in{'bbs_no'} eq ""){
		$bbs_no = 0;
	}else{
		$bbs_no = $in{'bbs_no'};
	}

	$s_n = 0;
	$n = 0;
	foreach(@BBS_DATA){
		($bbid,$bbtitle,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype,$bbno,$bbheap)=split(/<>/);
		if($kcon eq "$bbcon" && $bbtype eq "0"){
			if(!$bbheap){
				if($s_n >= $bbs_no && $s_n < $bbs_no + $BBS_NEXT_NUM){
				$bno = $s_n+1;
				$bb_id[$n] = $bbno;
				$n++;
				$c_mes[$bbno] = "- $bbtitle -<BR>$bbmes<BR>$bbname<HR>";
				}
			$s_n++;
			}
		}
	}

	foreach(@BBS_DATA){
		($bbid,$bbtitle,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype,$bbno,$bbheap)=split(/<>/);
		if($kcon eq "$bbcon" && $bbtype eq "0"){
			if($bbheap){
				$l=0;
				foreach(@bb_id){
					if($bbheap eq $bb_id[$l]){
					$c_mes[$bbheap] .= ">$bbmes<BR>$bbname<HR>";
					}
					$l++;
				}
			}
		}
	}

	$s=@c_mes;
	$d=0;
	foreach(@c_mes){
		$new_c_mes[$s] = $c_mes[$d];
		$s--;
		$d++;
	}

	foreach(@new_c_mes){
		if($_ ne ""){
			print "$_";
		}
	}

	$q=0;
	$n_bbs = $bbs_no + $BBS_NEXT_NUM;
	if($s_n >= $n_bbs){
	print " <form action=\"./i-command.cgi\" method=\"post\">
<input type=hidden name=mode value=COUNTRY_TALK>
<input type=hidden name=bbs_no value=$n_bbs>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit value=\"次の$BBS_NEXT_NUM件\">
</form>";
	}
print <<"EOM";
</CENTER>
</TD>
</TR>
</TBODY></TABLE>
EOM

	&FOOTER;
	exit;
}
1;