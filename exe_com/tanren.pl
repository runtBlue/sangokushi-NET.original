#_/_/_/_/_/_/_/_/#
#      ’b˜B      #
#_/_/_/_/_/_/_/_/#

sub TANREN {

	$ksub2=0;
	if($kgold < 50){
		&K_LOG("$mmonthŒŽ:‹à‚ª‘«‚è‚Ü‚¹‚ñB");
	}else{
		if($cnum eq "1"){
			$kstr_ex +=2;
			$a_mes = "•—Í";
		}elsif($cnum eq "2"){
			$kint_ex +=2;
			$a_mes = "’m—Í";
		}else{
			$klea_ex +=2;
			$a_mes = "“—¦—Í";
		}
		$kgold-=50;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		&K_LOG("$mmonthŒŽ:$a_mes‚ð‹­‰»‚µ‚Ü‚µ‚½B");
	}

}
1;