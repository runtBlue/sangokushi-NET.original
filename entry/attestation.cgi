sub ATTESTATION {

	&HEADER;
print <<NEW;
◆ メールに添付された認証キーとＩＤとパスを入力してください。<BR>
◆ 認証キーが登録されますとゲームを開始することができます。<p>

<center><form method=$method action=$FILE_ENTRY>
<table bgcolor=$TABLE_C><tbody bgcolor=$TD_C3>
<TR><TH bgcolor=$TD_C2 colspan=2>認 証</TH></TR>
<TR><TH>ID</TH><TD>
<input type=text name=id class=text size=10></TD></TR>
<TR><TH>パスワード</TH><TD>
<input type=password name=pass class=text size=10></TD></TR>
<TR><TH>認証キー</TH><TD>
<input type=password name=key class=text size=10></TD></TR>
</TD></TR>
<input type=hidden name=mode value="SET_ENTRY">
<TR><TD bgcolor=$TD_C4 colspan=2 align=center><input type=submit value="認証"></TD></TR>
</TBODY></TABLE>
</form>

NEW
	&FOOTER;
	exit;
}

# Sub Set Regist #
sub SET_ENTRY {

	&HOST_NAME;
	&CHARA_MAIN_OPEN;
	$akey = crypt("$kpass",$ATTESTATION_ID);

	if($akey ne $in{'key'}){&ERR2("暗証キーが違います！\n");}
	if(($kos & 1) eq 1){&ERR2("既に認証済みです。");}

	&MAP_LOG("<font color=blue><B>[認証]</B></font>$knameが新たに登録されました！");
	$kos|=1;

	&CHARA_MAIN_INPUT;
	&HEADER;

	print qq|認証が完了しました<br>\n|;
	print qq|IDは$kidです。<br>\n|;
	print qq|パスワードは$kpassです。<br><br>\n|;

	print qq|登録手続きはこれで完了です。<br>\n|;
	print qq|ＴＯＰページからログインできます。<br>\n|;

	print qq|<a href="$FILE_TOP">\[戻る\]</a>\n|;
	&FOOTER;
	exit;
}

1;