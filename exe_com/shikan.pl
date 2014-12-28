#_/_/_/_/_/_/_/_/_/_/#
#       仕  官       #
#_/_/_/_/_/_/_/_/_/_/#

sub SHIKAN {

	$ksub2=0;
	&COUNTRY_DATA_OPEN($kcon);
	if($xcid eq 0){
		if($cou_name[$cnum] eq ""){
			&K_LOG("$mmonth月:その国へは仕官できません。");
		}else{
			if(@B_LIST eq "0"){
				open(IN,"$LOG_DIR/black_list.cgi");
				@B_LIST = <IN>;
				close(IN);
			}
			$b_hit=0;
			foreach(@B_LIST){
				($bid,$bcon,$bname,$bsub) = split(/<>/);
				if($bid eq $kid && $bcon eq $kcon){
					$b_hit=1;
				}
			}
			if($b_hit){
				&K_LOG("$mmonth月:$cou_name[$cnum]へ仕官は拒否されました");
			}else{
				$kcon = $cnum;
				&K_LOG("$mmonth月:$cou_name[$cnum]へ仕官しました。");
				&MAP_LOG("$mmonth月:$knameは$cou_name[$cnum]へ仕官しました。");
			}
		}
	}else{
		&K_LOG("$mmonth月:無所属国でなければ仕官できません。");
	}

}
1;