#_/_/_/_/_/_/_/_/_/_/#
#      ‹ZpŠJ”­      #
#_/_/_/_/_/_/_/_/_/_/#

sub TEC {

	$ksub2=0;
	if($kgold<50){
		&K_LOG("$mmonthŒ:‘‹à•s‘«‚ÅÀs‚Å‚«‚Ü‚¹‚ñ‚Å‚µ‚½B");
	}else{
		$ztecadd = int(($kint+$kprodmg)/20 + rand(($kint+$kprodmg)) / 40);
		$zsub1 += $ztecadd;
		$kgold -= 50;
		if($zsub1 > 999){
			$zsub1 = 999;
		}
		$kcex += 30;
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonthŒ:$zname‚Ì‹Zp‚ğ<font color=red>+$ztecadd</font>ŠJ”­‚µ‚Ü‚µ‚½B");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;