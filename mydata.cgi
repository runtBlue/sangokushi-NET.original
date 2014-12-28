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
require 'suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
if($mode eq 'MES_SEND') { require 'mydata/mes_send.pl';&MES_SEND; }
elsif($mode eq 'COUNTRY_TALK') { require 'mydata/country_talk.pl';&COUNTRY_TALK; }
elsif($mode eq 'COUNTRY_WRITE') { require 'mydata/country_write.pl';&COUNTRY_WRITE; }
elsif($mode eq 'LOCAL_RULE') { require 'mydata/local_rule.pl';&LOCAL_RULE; }
elsif($mode eq 'L_RULE_WRITE') { require 'mydata/l_rule_write.pl';&L_RULE_WRITE; }
elsif($mode eq 'L_RULE_DEL') { require 'mydata/l_rule_del.pl';&L_RULE_DEL; }


elsif($mode eq 'COU_CHANGE') { require 'mydata/cou_change.pl';&COU_CHANGE; }
elsif($mode eq 'CYUUSEI') { require 'mydata/cyuusei.pl';&CYUUSEI; }
elsif($mode eq 'LETTER') { require 'mydata/letter.pl';&LETTER; }
elsif($mode eq 'KING_COM') { require 'mydata/king_com.pl';&KING_COM; }
elsif($mode eq 'KING_COM2') { require 'mydata/king_com2.pl';&KING_COM2; }
elsif($mode eq 'KING_COM3') { require 'mydata/king_com3.pl';&KING_COM3; }
elsif($mode eq 'KING_COM4') { require 'mydata/king_com4.pl';&KING_COM4; }
elsif($mode eq 'KING_COM5') { require 'mydata/king_com5.pl';&KING_COM5; }

elsif($mode eq 'UNIT_ENTRY') { require 'mydata/unit_entry.pl';&UNIT_ENTRY; }
elsif($mode eq 'UNIT_SELECT') { require 'mydata/unit_select.pl';&UNIT_SELECT; }
elsif($mode eq 'UNIT_OUT') { require 'mydata/unit_out.pl';&UNIT_OUT; }
elsif($mode eq 'MAKE_UNIT') { require 'mydata/make_unit.pl';&MAKE_UNIT; }
elsif($mode eq 'UNIT_DELETE') { require 'mydata/unit_delete.pl';&UNIT_DELETE; }
elsif($mode eq 'UNIT_CHANGE') { require 'mydata/unit_change.pl';&UNIT_CHANGE; }

else{&ERR('正しく選択されていません。');}

