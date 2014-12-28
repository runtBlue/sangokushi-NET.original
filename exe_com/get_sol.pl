#_/_/_/_/_/_/_/_/#
#      ’¥•º      #
#_/_/_/_/_/_/_/_/#

sub GET_SOL {

	$ksub2=0;
	if($ksol eq "$klea" && $csub eq $ksub1_ex){
		&K_LOG("$mmonthŒ:yŒR–zF•ºm”‚ªÅ‘å‚Å‚·B");
	}elsif($kgold < $cnum * $SOL_PRICE[$csub]){
		&K_LOG("$mmonthŒ:yŒR–zFŠ‹à‚ª‚½‚è‚Ü‚¹‚ñB");
	}elsif($znum < $cnum * 10){
		&K_LOG("$mmonthŒ:yŒR–zF”_–¯‚ª‚½‚è‚Ü‚¹‚ñB");
	}elsif($zpri < int($cnum / 10)){
		&K_LOG("$mmonthŒ:yŒR–zF”_–¯‚ª‹‘”Û‚µ‚Ü‚µ‚½B");
	}else{
		if($ksub1_ex eq $csub || $ksub1_ex eq "" && $csub eq 0){
			if($ksol + $cnum > $klea){
				$cnum = $klea - $ksol;
			}
			$ksol += $cnum;
		}else{
			if($cnum > $klea){
				$cnum = $ksol;
			}
			$ksol = $cnum;
		}
		$kgat -= $cnum;
		if($kgat < 0 ){
			$kgat = 0;
		}
		$ksub1_ex = $csub;
		$kcex += 10;
		$kgold -= $cnum * $SOL_PRICE[$csub];
		$znum -= $cnum * 5;
		$zpri -= int($cnum / 10);
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonthŒ:$SOL_TYPE[$ksub1_ex]‚ğ<font color=red>+$cnum</font>’¥•º‚µ‚Ü‚µ‚½B");
		$kstr_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;