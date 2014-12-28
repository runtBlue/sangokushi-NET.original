#_/_/_/_/_/_/_/_/#
#      ìoóp      #
#_/_/_/_/_/_/_/_/#

sub GET_MAN {

	$ksub2=0;
	if($kgold < 100){
		&K_LOG("$mmonthåé:ã‡Ç™ë´ÇËÇ‹ÇπÇÒÅB");
	}else{

		$kgold-=100;
		$kcex += 30;
		open(IN,"$MESSAGE_LIST2");
		@MES_REG2 = <IN>;
		close(IN);
		$mes_num = @MES_REG2;
		if($mes_num > $MES_MAX) { pop(@MES_REG2); }
		unshift(@MES_REG2,"$cnum<>$kid<>$kpos<>$kname<>$csub<>$cno<>$ctime<>$kchara<>$cend<>\n");
		open(OUT,">$MESSAGE_LIST2");
		print OUT @MES_REG2;
		close(OUT);
		&K_LOG("$mmonthåé:$cnoÇ…ñßèëÇëóÇËÇ‹ÇµÇΩÅB");
		$kcha_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;