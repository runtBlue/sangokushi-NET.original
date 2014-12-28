#_/_/_/_/_/_/_/_/_/_/#
#      商業発展      #
#_/_/_/_/_/_/_/_/_/_/#

sub SYOUGYOU {

	$ksub2=0;
	if($kgold<50){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$zsyoadd = int(($kint+$kprodmg)/20 + rand(($kint+$kprodmg)) / 40);
		$zsyo += $zsyoadd;
		$kgold -= 50;
		if($zsyo > $zsyo_max){
			$zsyo = $zsyo_max;
		}
		$kcex += 30;
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの商業を<font color=red>+$zsyoadd</font>発展させました。");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;