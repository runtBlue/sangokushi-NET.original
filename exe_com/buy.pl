#_/_/_/_/_/_/_/_/#
#    •Ä”„”ƒ      #
#_/_/_/_/_/_/_/_/#

sub BUY {

	$ksub2=0;
	if($csub){
		if($cnum > 3000){
			$cnum = 3000;
		}
		if(!$cno){
			if($kgold >= $cnum){
				if($cnum * $csub){
					$kadd = int((2-$csub) * $cnum);
				}else{
					$kadd = 0;
				}
				$kgold -= $cnum;
				$krice += $kadd;
				&K_LOG("$mmonthŒ:y¤lzF‹à$cnum‚ğx•¥‚Á‚Ä$kadd‚Ì•Ä‚ğ”ƒ‚¢‚Ü‚µ‚½B");
				$kint_ex++;
				$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,$ktec1,$ktec2,$ktec3,$kvsub1,$kvsub2,";
			}else{
				&K_LOG("$mmonthŒ:y¤lzFŠ‹à‚ª‚½‚è‚Ü‚¹‚ñB");
			}
		}else{
			if($krice > $cnum){
				$kadd = int($cnum * $csub);
				$krice -= $cnum;
				$kgold += $kadd;
				&K_LOG("$mmonthŒ:y¤lzF$cnum‚Ì•Ä‚ğ”„‚Á‚Ä$kadd‚Ì‹à‚ğ”ƒ‚¢‚Ü‚µ‚½B");
				$kint_ex++;
				$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,$ktec1,$ktec2,$ktec3,$kvsub1,$kvsub2,";
			}else{
				&K_LOG("$mmonthŒ:y¤lzF•Ä‚ª‚½‚è‚Ü‚¹‚ñB");
			}
		}
	}

}
1;