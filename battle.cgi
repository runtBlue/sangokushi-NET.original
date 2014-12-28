
# 戦闘処理 #

sub BATTLE {
	open(IN,"$COUNTRY_LIST");
	@COU_DATA = <IN>;
	close(IN);
	@NEW_COU_DATA=();
	$zvhit=0;
	foreach(@COU_DATA){
		($xvcid,$xvname,$xvele,$xvmark,$xvking,$xvmes,$xvsub,$xvpri)=split(/<>/);
		if($xvcid eq $zcon){$zvhit=1;last;}
	}
	if($zvhit && $xvmark < $BATTLE_STOP){
		&K_LOG("$mmonth月:$xvname国にはまだ攻められません。（$xvmarkターン）");
	}else{
		&COUNTRY_DATA_OPEN("$kcon");
		if($xmark < $BATTLE_STOP){
			&K_LOG("$mmonth月:$xname国はまだ攻められません。（$xmarkターン）");
		}else{
			open(IN,"$DEF_LIST");
			@DEF_LIST3 = <IN>;
			close(IN);
			$d_hit=0;
			foreach(@DEF_LIST3){
				($mdid,$mdname,$mdtown_id,$mdtown_flg,$mdcon) = split(/<>/);
				if($cnum eq $mdtown_id){
					$d_hit=1;last;
				}
			}
			$katt_add2 = 0;
			if("$xdai" eq "$kid"){
				$katt_add2 = 10;
			}elsif("$xuma" eq "$kid"){
				if($ksub1_ex eq "3"){
					$katt_add2 = 10;
				}
			}elsif("$xgoei" eq "$kid"){
				if($ksub1_ex eq "2"){
					$katt_add2 = 10;
				}
			}elsif("$xyumi" eq "$kid"){
				if($ksub1_ex eq "1"){
					$katt_add2 = 10;
				}
			}elsif("$xhei" eq "$kid"){
				if($ksub1_ex eq "0"){
					$katt_add2 = 10;
				}
			}

			$kcex += 20;
			&MAP_LOG("$xname国の$knameは$znameへ攻め込みました！");
			$eid="";
			if($d_hit){
				open(IN,"./charalog/main/$mdid\.cgi");
				@E_DATA = <IN>;
				close(IN);
				($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/,$E_DATA[0]);
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
				$last_battle=0;
			}else{
				$ename = "城壁";
				$esol = $zshiro;
				$estr = int($zdef_att/15)+30;
				$egat = 60;
				$last_battle=1;
				$esub1_ex="";
			}

			&K_LOG2("$mmonth月:$xname国の$knameは$znameへ攻め込みました！");
			&E_LOG2("$mmonth月:$xname国の$knameは$enameと戦闘しました！");

			&CHARA_ITEM_OPEN;

			if($ksub1_ex eq "1"){
				$katt_add = 10;
				$katt_def = 0;
			}elsif($ksub1_ex eq "2"){
				$katt_add = 0;
				$katt_def = 15;
			}elsif($ksub1_ex eq "3"){
				$katt_add = 20;
				$katt_def = 10;
			}elsif($ksub1_ex eq "4"){
				$katt_add = 40;
				$katt_def = 0;
			}elsif($ksub1_ex eq "5"){
				$katt_add = $kint;
				$katt_def = 0;
			}else{
				$katt_add = 0;
				$katt_def = 0;
			}
			if($esub1_ex eq "1"){
				$eatt_add = 10;
				$eatt_def = 0;
			}elsif($esub1_ex eq "2"){
				$eatt_add = 0;
				$eatt_def = 15;
			}elsif($esub1_ex eq "3"){
				$eatt_add = 20;
				$eatt_def = 10;
			}elsif($esub1_ex eq "4"){
				$eatt_add = 40;
				$eatt_def = 0;
			}elsif($esub1_ex eq "5"){
				$eatt_add = $eint;
				$eatt_def = 0;
			}else{
				$eatt_add = 0;
				$eatt_def = 0;
			}

			$katt = int(($kstr + $karmdmg + $katt_add + $katt_add2 - $eatt_def - int($egat / 2.5))/8);
			if($katt < 0){$katt = 0;}
			$eatt = int(($estr + $earmdmg + $eatt_add - $katt_def - int($kgat / 2.5))/8);
			$kex_add=0;
			$eex_add=0;
			if($eatt < 0){$eatt = 0;}
			$win=0;
			for($count=0;$count<50;$count++){
				$kdmg=0;
				$edmg=0;
				if($ksol <= 0){last;}
				$kdmg = int(rand($katt));
				if($kdmg <= 0){$kdmg=1;}
				$wsol = $esol;
				$esol -= $kdmg;
				
				$kex_add += ($wsol - $esol);
				if($esol <= 0){
					$esol=0;
					&K_LOG2("ターン<font color=red>$count</font>:$kname $SOL_TYPE[$ksub1_ex] $ksol人 ↓\(-$edmg\) |$ename $SOL_TYPE[$esub1_ex] $esol人 ↓\(-$kdmg\)");
					&E_LOG2("ターン<font color=red>$count</font>:$kname $SOL_TYPE[$ksub1_ex] $ksol人 ↓\(-$edmg\) |$ename $SOL_TYPE[$esub1_ex] $esol人 ↓\(-$kdmg\)");
					$win = 1;last;
				}

				$edmg = int(rand($eatt));
				if($edmg <= 0){$edmg=1;}
				$wsol = $ksol;
				$ksol -= $edmg;
				$eex_add += ($wsol - $ksol);
				if($ksol <= 0){
					$ksol=0;
					&K_LOG2("ターン<font color=red>$count</font>:$kname $SOL_TYPE[$ksub1_ex] $ksol人 ↓\(-$edmg\) |$ename $SOL_TYPE[$esub1_ex] $esol人 ↓\(-$kdmg\)");
					&E_LOG2("ターン<font color=red>$count</font>:$kname $SOL_TYPE[$ksub1_ex] $ksol人 ↓\(-$edmg\) |$ename $SOL_TYPE[$esub1_ex] $esol人 ↓\(-$kdmg\)");
					last;
				}
				&K_LOG2("ターン<font color=red>$count</font>:$kname $SOL_TYPE[$ksub1_ex] $ksol人 ↓\(-$edmg\) |$ename $SOL_TYPE[$esub1_ex] $esol人 ↓\(-$kdmg\)");
			}

			$eex_add = int($eex_add/2);
			$kex_add = int($kex_add/2);
			if($win){
				$ksub2_ex++;
				if($last_battle){
					if($town_get[$zcon] <= 1){
						@NEW_COU=();
						foreach(@COU_DATA){
							($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
							if("$zcon" eq "$xcid"){
							}else{
								push(@NEW_COU,"$_");
							}
						}
						open(OUT,">$COUNTRY_LIST");
						print OUT @NEW_COU;
						close(OUT);
						&MAP_LOG2("<font color=red>【滅亡】</font>\[$old_date\]$cou_name[$zcon]国は滅亡しました。。");
						&MAP_LOG("<font color=red>【滅亡】</font>\[$old_date\]$cou_name[$zcon]国は滅亡しました。。");
					}
						$zcon = $kcon;
						$znou = int($znou*0.8);
						$zsyo = int($zsyo*0.8);
						$znum = int($znum*0.8);
						$zsub1 = int($zsub1*0.8);
						$zdef_att = 0;
						$zpri = int($zpri*0.8);
						$kex_add += 50;
						$kcex += $kex_add;
						$kpos = $cnum;
					@NEW_DEF_LIST3=();
					$pphit=0;
					foreach(@DEF_LIST3){
						($did,$dname,$dtown_id,$dtown_flg,$dcon) = split(/<>/);
						if("$did" eq "$kid"){
							$pphit=1;
							unshift(@NEW_DEF_LIST3,"$kid<>$kname<>$kpos<>0<>$kcon<>\n");
						}else{
							push(@NEW_DEF_LIST3,"$_");
						}
					}

					if(!$pphit){
						unshift(@NEW_DEF_LIST3,"$kid<>$kname<>$kpos<>0<>$kcon<>\n");
					}
					&SAVE_DATA($DEF_LIST,@NEW_DEF_LIST3);

					&K_LOG2("<font color=blue>$zname</font>を手に入れた！<font color=red>$kex_add</font>の貢献値を得ました！");
					&MAP_LOG2("<font color=blue>【支配】</font>\[$old_date\]$cou_name[$kcon]国の$knameは$znameを支配しました。");
					&MAP_LOG("<font color=blue>【支配】</font>\[$old_date\]$cou_name[$kcon]国の$knameは$znameを支配しました。");
				}else{
					@NEW_DEF_LIST3=();
					foreach(@DEF_LIST3){
						($did,$dname,$dtown_id,$dtown_flg,$dcon) = split(/<>/);
						if("$mdid" ne "$did"){
							push(@NEW_DEF_LIST3,"$_");
						}
					}
					open(OUT,">$DEF_LIST");
					print OUT @NEW_DEF_LIST3;
					close(OUT);
					$kex_add += 30;
					$kcex += $kex_add;
					$ecex += $eex_add;
					&K_LOG2("$knameは$enameを倒した！<font color=blue>$kex_add</font>の貢献を得ました。");
					&E_LOG2("$enameは$knameに敗北した。。<font color=red>$eex_add</font>の貢献を得ました。");
					&MAP_LOG("<font color=blue>【勝利】</font>$knameは$enameを倒しました！");
				}
			}else{
				$eex_add += 30;
				$ecex += $eex_add;
				$kcex += $kex_add;
				&K_LOG2("$knameは$enameに敗北した。。<font color=red>$kex_add</font>の貢献を得ました。");
				&E_LOG2("$enameは$knameを倒した！<font color=blue>$eex_add</font>の貢献を得ました。");
			}

			if(!$last_battle){
				if($eid ne ""){
					&ENEMY_INPUT;
				}
			}else{
				$zshiro = $esol;
				$zdef_att -= $kex_add;
				if($zdef_att < 0){
					$zdef_att=0;
				}
				if("$zname" ne ""){
					splice(@TOWN_DATA,$cnum,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");

				}
			}

			$kstr_ex++;
			$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		}
	}
}

1;