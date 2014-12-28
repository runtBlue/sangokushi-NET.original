#_/_/_/_/_/_/_/_/_/#
#_/     説 明    _/#
#_/_/_/_/_/_/_/_/_/#

sub RESISDENTS {

	&CHARA_MAIN_OPEN;

# ゲームを開始する時に始まる説明
$P_MES[0] = "三国志NETの世界へようこそ！<br>ここでは基本的なゲームの流れとプレイヤーの目的について説明していきますね。";
$P_MES[1] = "まず、武将に実行させたいコマンドを入力していきます。<BR>最大で２０まで指令を出すことが\可\能\です。";
$P_MES[2] = "このゲームは２時間ごとに更新していきます。<BR>2時間たつと次のターンへ進みます。";
$P_MES[3] = "ターンが進むと武将は次の行動を起こします。<BR>行動が止まらないように先を読んで次へと命令を出していってください。";
$P_MES[4] = "慣れないうちは内政コマンドを実行するといいかと思います。<BR>内政には商業と農地と城があります。";
$P_MES[5] = "農地は７月の米の収穫に、商業は１月の金の収入に影響してきます。<BR>他国に隣接していて攻められそうな場合は最初に城を強化するのも手です。";
$P_MES[6] = "内政である程度潤ってきたら他国へ戦争しましょう。<BR>単独で攻めるよりも自国の人と相談して攻め込んだほうが落としやすいです。";
$P_MES[7] = "それでは早速プレイしてみましょう！";
	&HEADER;

	print <<"EOM";
<TABLE WIDTH="100%" height=100%>
<TBODY><TR>
<TD WIDTH=100% height=5>　<font size=4>　　　＜＜<B> * ゲームの説明 *</B>＞＞</font></TD>
</TR><TR>
<TD bgcolor=$TD_C4 height=5>
<TABLE border="0"><TBODY>
<TR>
<TD bgcolor=$TD_C1><img src="$IMG/$kchara.gif"></TD>
<TD bgcolor=$TD_C2>$simg</TD>
<TD bgcolor=$TD_C3>$timg</TD>
<TD bgcolor=$TD_C4 WIDTH=100% align=center>
<TABLE bgcolor=$TABLE_C border="0">
<TBODY>
<TR>
<TD bgcolor=$TD_C2>名前</TD>
<TD bgcolor=$TD_C3>ＬＶ</TD>
<TD bgcolor=$TD_C2>属性</TD>
<TD bgcolor=$TD_C3>職業</TD>
</TR>
<TR>
<TD bgcolor=$TD_C2>$kname</TD>
<TD bgcolor=$TD_C3 align=right>$klv</TD>
<TD bgcolor=$TD_C2>$ELE[$kele]属</TD>
<TD bgcolor=$TD_C3>$SYOKU[$kclass]</TD>
</TR>
<TR>
<TD bgcolor=$TD_C2>所持金</TD>
<TD bgcolor=$TD_C1 colspan=3 align=right>$kgold GOLD</TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD height="5">
<TABLE  border="0"><TBODY>
<TR><TD bgcolor=$TD_C4><img src="$IMG/wiz.gif" title="セラフ"></TD><TD width="100%" height=100 bgcolor=$TALK_BG><font size=3 color=$TALK_FONT>$P_MES[$in{'num'}]</font></TD>

</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD>
EOM
	$new_num = $in{'num'}+1;
if($new_num < @P_MES){
print "<form action=\"$FILE_ENTRY\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=num value=$new_num>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=RESISDENTS>
<input type=submit value=\"次へ\"></form>";
}
print<<"EOM";
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="ゲームを始める"></form>

</TD>
</TR>
</TBODY></TABLE>
EOM

	&FOOTER;
	exit;
}
1;