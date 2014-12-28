#_/_/_/_/_/_/_/_/_/_/#
#        ’¥•º‚Q      #
#_/_/_/_/_/_/_/_/_/_/#

sub KING_COM3 {

	if($in{'sel'} eq ""){&ERR("”C–½‘Šè‚ª“ü—Í‚³‚ê‚Ä‚¢‚Ü‚¹‚ñB");}
	if($in{'type'} eq ""){&ERR("‘ÎÛ‚ª“ü—Í‚³‚ê‚Ä‚¢‚Ü‚¹‚ñB");}
	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	open(IN,"./charalog/main/$in{'sel'}.cgi") || &ERR("‚»‚ÌID‚Í‘¶İ‚µ‚Ü‚¹‚ñB");
	@E_DATA = <IN>;
	close(IN);

	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/,$E_DATA[0]);

	if($econ ne $kcon){
		&ERR("‘‚ªˆá‚¢‚Ü‚·B");
	}

	if($in{'type'} eq "0"){
		$xgunshi = $eid;
		$tname = "ŒRt";
	}elsif($in{'type'} eq "1"){
		$xdai = $eid;
		$tname = "‘å«ŒR";
	}elsif($in{'type'} eq "2"){
		$xuma = $eid;
		$tname = "‹R”n«ŒR";
	}elsif($in{'type'} eq "3"){
		$xgoei = $eid;
		$tname = "Œì‰q«ŒR";
	}elsif($in{'type'} eq "4"){
		$xyumi = $eid;
		$tname = "‹|«ŒR";
	}elsif($in{'type'} eq "5"){
		$xhei = $eid;
		$tname = "«ŒR";
	}
	$xsub = "$xgunshi,$xdai,$xuma,$xgoei,$xyumi,$xhei,$xxsub1,$xxsub2,";

	&COUNTRY_DATA_INPUT;
	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$tname‚É$ename‚ğ”C–½‚µ‚Ü‚µ‚½B</h2><p>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="‚n‚j"></form></CENTER>
EOM

	&FOOTER;

	exit;

}
1;