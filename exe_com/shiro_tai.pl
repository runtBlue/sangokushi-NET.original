#_/_/_/_/_/_/_/_/_/_/#
#  城耐久力開発      #
#_/_/_/_/_/_/_/_/_/_/#

sub SHIRO_TAI {

	$ksub2=0;
	if($kgold<50){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$zdef_att_add = int(($kint+$kprodmg)/20 + rand(($kint+$kprodmg)) / 40);
		$zdef_att += $zdef_att_add;
		$kgold -= 50;
		if($zdef_att > 999){
			$zdef_att = 999;
		}
		$kcex += 30;
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの城壁耐久力を<font color=red>+$zdef_att_add</font>強化しました。");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;