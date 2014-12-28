#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

require 'jcode.pl';
require './ini_file/index.ini';
require 'i-suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
&TOP;

#_/_/_/_/_/_/_/_/_/#
#_/    TOP画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub TOP {

	$date = time();
	$month_read = "$LOG_DIR/date_count.cgi";
	open(IN,"$month_read") or &ERR2('ファイルを開けませんでした。');
	@MONTH_DATA = <IN>;
	close(IN);

	open(IN,"$MAP_LOG_LIST");
	@S_MOVE = <IN>;
	close(IN);
	$p=0;
	while($p<5){$S_MES .= "<font color=008800>●</font>$S_MOVE[$p]<BR>";$p++;}

	$hit = 0;
	@month_new=();

	($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);


	$MESS1 = "<A href=\"$FILE_CONTNUE\">【CONTNUE】</a>";
	$MESS2 = "<A href=\"$FILE_ENTRY\">【NEW GAME】</a>";
	&roses_counter;
	$new_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);
	$next_time = int(($mtime + $TIME_REMAKE - $date) / 60);

	&HEADER;
	print <<"EOM";
<CENTER>
【  $GAME_TITLE  】<BR>
[$new_date]<BR>
次回の更新まで $next_time 分<BR>
<form action="./i-status.cgi" method="POST"><input type="hidden" name="mode" value="STATUS">USER ID<input type="text" size="10" name="id" value="$_id"><BR>
PASS WORD<input type="password" size="10" name="pass" value="$_pass"><BR>
<input type="submit" value="ログイン"></form>
TOTAL ACCESS $total_count HIT.<p>
$S_MES
EOM

	&FOOTER;
	exit;

}

sub roses_counter {

	$file_read = "$LOG_DIR/counter.cgi";
	open(IN,"$file_read") or &ERR2('ファイルを開けませんでした。');
	@reading = <IN>;
	close(IN);

	($total_count) = split(/<>/,$reading[0]);
	$total_count++;

	open(OUT,">$file_read");
	print OUT "$total_count\n";
	close(OUT);

}


