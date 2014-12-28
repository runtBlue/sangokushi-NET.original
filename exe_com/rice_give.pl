#_/_/_/_/_/_/_/_/_/_/#
#      米 施 し      #
#_/_/_/_/_/_/_/_/_/_/#

sub RICE_GIVE {

	$ksub2=0;
	if($krice<50){
		&K_LOG("$mmonth月:米不足で実行できませんでした。");
	}else{
		$zpriadd = int($kcha/20 + rand($kcha) / 40);
		$zpri += $zpriadd;
		$krice -= 50;
		if($zpri > 100){
			$zpri = 100;
		}
		$kcex += 30;
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの民忠が<font color=red>+$zpriadd</font>上がりました。");
		$kcha_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;