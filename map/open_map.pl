#_/_/_/_/_/_/_/_/_/_/_/#
#_/    F MAP 画面    _/#
#_/_/_/_/_/_/_/_/_/_/_/#

sub OPEN_MAP {


	open(IN,"$MAP_LOG_LIST");
	@S_MOVE = <IN>;
	close(IN);

	$p=0;
	while($p<15){
		$S_MES .= "・$S_MOVE[$p]<BR>";
		$p++;
	}

	open(IN,"$MAP_LOG_LIST2");
	@S_MOVE = <IN>;
	close(IN);

	$p=0;
	while($p<20){
		$D_MES .= "・$S_MOVE[$p]<BR>";
		$p++;
	}

	&TIME_DATA;
	if($hour < 6){$time_img = 2;$table_font = "#FFFFFF";$table_color = "#000000";
	}elsif($hour > 18){$time_img = 2;$table_font = "#FFFFFF";$table_color = "#000000";
	}elsif($hour > 15){$time_img = 2;$table_font = "#FFFFFF";$table_color = "#804020";
	}elsif($hour > 12){$time_img = 1;$table_font = "#000000";$table_color = "#FFFFDC";
	}else{$time_img = 0;$table_font = "#000000";$table_color = "#FFEFCC";}

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);
	foreach(@COU_DATA){
		($x2cid,$x2name,$x2ele,$x2mark)=split(/<>/);
		$cou_name[$x2cid] = "$x2name";
		$cou_ele[$x2cid] = "$x2ele";
		$cou_mark[$x2cid] = "$x2mark";
	}

	$zmes="";

	&HEADER;
print <<"EOM";
<TABLE bgcolor=$TABLE_C width=100% border="0">
  <TBODY>
    <TR>
      <TD bgcolor=$TD_C4 width=40%>
      <TABLE width=70% border="0">
        <TBODY>
          <TR>
            <TH><font color=$table_font><font size=4>$GAME_TITLE</font> <BR>- 大 陸 地 図 -</font></TH>
          </TR>
        </TBODY>
      </TABLE>
      <TABLE bgcolor=$TD_C2 background="$IMG/mapbg.gif" width=100% height=5 border="0" cellspacing=1>
        <TBODY>
          <TR>
            <TD width=20 bgcolor=$TD_C2>-</TD>
EOM
	open(IN,"$TOWN_LIST") or &ERR("指定されたファイルが開けません。");
	@TOWN_DATA = <IN>;
	close(IN);

    for($i=1;$i<11;$i++){
		print "<TD width=20 bgcolor=$TD_C1>$i</TD>";
	}
	print "</TR>";
     for($i=0;$i<10;$i++){
		$n = $i+1;
		print "<TR><TD bgcolor=$TD_C3>$n</td>";
		for($j=0;$j<10;$j++){
				$m_hit=0;
				foreach(@TOWN_DATA){
					($zzname,$zzcon,$zznum,$zznou,$zzsyo,$zzshiro,$zznou_max,$zzsyo_max,$zzshiro_max,$zzpri,$zzx,$zzy)=split(/<>/);
					if("$zzx" eq "$j" && "$zzy" eq "$i"){$m_hit=1;last;}
				}
				if($m_hit){
					if($zzname eq "洛陽" || $zzname eq "建業" || $zzname eq "成都" || $zzname eq "業" ){
						print "<TH bgcolor=$ELE_BG[$cou_ele[$zzcon]]><img src=$IMG/m_1.gif width=16 height=16 border=0 alt=$zzname【$cou_name[$zzcon]】></TH>";
					}else{
						print "<TH bgcolor=$ELE_BG[$cou_ele[$zzcon]]><img src=$IMG/m_4.gif width=16 height=16 border=0 alt=$zzname【$cou_name[$zzcon]】></TH>";
					}
				}else{
					print "<TH>&nbsp;</TH>";
				}
		}
		print "</TR>";
	}

print <<"EOM";
        </TBODY>
      </TABLE>
      </TD>
      <TD bgcolor=$TD_C3>
      <TABLE width=100% border="0">
        <TBODY>
          <TR>
            <TH bgcolor=$TD_C4>MAP LOG</TH></TR><TR>
<TD bgcolor=$TD_1>$S_MES</TD>
          </TR>
        </TBODY>
      </TABLE>
</TD>
    </TR>
<TR>      <TD colspan=2 bgcolor=$TD_C3>
      <TABLE width=100% border="0">
        <TBODY>
          <TR>
            <TH bgcolor=$TD_C4>史記</TH></TR><TR>
<TD bgcolor=$TD_1>$D_MES</TD>
          </TR>
        </TBODY>
      </TABLE>
</TD>
    </TR>
  </TBODY>
</TABLE>
※街にカ\ー\ソ\ル\を\合わせると街の名前が\表\示されます。
<p>
$daytime
EOM
	&FOOTER;
	exit;

}
1;