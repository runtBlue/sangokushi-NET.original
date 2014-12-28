#_/_/_/_/_/_/_/_/#
#      ˆÚ“®      #
#_/_/_/_/_/_/_/_/#

sub MOVE {

	if($in{'no'} eq ""){&ERR("NO:‚ª“ü—Í‚³‚ê‚Ä‚¢‚Ü‚¹‚ñB");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN($kcon);
	&TIME_DATA;
	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>"
	}

	&HEADER;
	$no = $in{'no'} + 1;


	$get_sol = $klea - $ksol;
	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - ˆÚ “® - </font>
</TH></TR>
EOM
	if("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/status.cgi"){ 

print <<"EOM";

<TR><TD>
<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>•—Í</TD><TH>$kstr</TH><TD>’m—Í</TD><TH>$kint</TH><TD>“—¦—Í</TD><TH>$klea</TH></TR>
<TR><TD>‹à</TD><TH>$kgold</TH><TD>•Ä</TD><TH>$krice</TH><TD>vŒ£</TD><TH>$kcex</TH></TR>
<TR><TD>Š‘®‘</TD><TH colspan=2>$cou_name[$kcon]‘</TH><TD>•ºm</TD><TH>$ksol</TH><TD>ŒP—û</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
EOM
	}
print <<"EOM";

<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>‘¼‚ÌŠX‚ÖˆÚ“®‚µ‚Ü‚·B<BR></font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
‰½ˆ‚ÖˆÚ“®‚µ‚Ü‚·‚©H
<form action="$COMMAND" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<select name=num>
EOM

	$xx=0;
	foreach(@town_name){
		print "<option value=$xx>$town_name[$xx]";
		$xx++;
	}

	foreach(@z){
		if("$_" ne ""){
			$move_list .= "$town_name[$_]<BR>";
		}
	}
print <<"EOM";
</select>
<p>y$zname‚©‚çˆÚ“®\‰Â\”\\‚ÈŠXz<BR>$move_list
$no_list
<input type=hidden name=mode value=20>
<input type=submit value=\"ˆÚ“®\"></form>


<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="–ß‚é"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;

}
1;