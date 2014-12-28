package jcode;
;; $rcsid = q$Id: jcode.pl,v 2.0 1996/10/02 16:02:38 utashiro Rel $;
&init unless defined $version;

sub init {
    $version = $rcsid =~ /,v ([\d.]+)/ ? $1 : 'unkown';

    $re_bin  = '[\000-\006\177\377]';

    $re_jp   = '\e\$[\@B]';
    $re_asc  = '\e\([BJ]';
    $re_kana = '\e\(I';
    ($esc_jp, $esc_asc, $esc_kana) = ("\e\$B", "\e(B", "\e(I");

    $re_sjis_c = '[\201-\237\340-\374][\100-\176\200-\374]';
    $re_sjis_kana = '[\241-\337]';

    $re_euc_c = '[\241-\376][\241-\376]';
    $re_euc_kana = '\216[\241-\337]';

    # These variables are retained only for backward compatibility.
    $re_euc_s = "($re_euc_c)+";
    $re_sjis_s = "($re_sjis_c)+";

    $cache = 1;

    # X0201 -> X0208 KANA conversion table.  Looks weird?  Not that
    # much.  This is simply JIS text without escape sequences.
    ($h2z_high = $h2z = <<'__TABLE_END__') =~ tr/\021-\176/\221-\376/;
!	!#	$	!"	%	!&	"	!V	#	!W
^	!+	_	!,	0	!<
'	%!	(	%#	)	%%	*	%'	+	%)
,	%c	-	%e	.	%g	/	%C
1	%"	2	%$	3	%&	4	%(	5	%*
6	%+	7	%-	8	%/	9	%1	:	%3
6^	%,	7^	%.	8^	%0	9^	%2	:^	%4
;	%5	<	%7	=	%9	>	%;	?	%=
;^	%6	<^	%8	=^	%:	>^	%<	?^	%>
@	%?	A	%A	B	%D	C	%F	D	%H
@^	%@	A^	%B	B^	%E	C^	%G	D^	%I
E	%J	F	%K	G	%L	H	%M	I	%N
J	%O	K	%R	L	%U	M	%X	N	%[
J^	%P	K^	%S	L^	%V	M^	%Y	N^	%\
J_	%Q	K_	%T	L_	%W	M_	%Z	N_	%]
O	%^	P	%_	Q	%`	R	%a	S	%b
T	%d			U	%f			V	%h
W	%i	X	%j	Y	%k	Z	%l	[	%m
\	%o	]	%s	&	%r	3^	%t
__TABLE_END__
    %h2z = split(/\s+/, $h2z . $h2z_high);
    %z2h = reverse %h2z;

    $_ = '';
    for $f ('jis', 'sjis', 'euc') {
	for $t ('jis', 'sjis', 'euc') {
	    $_ .= "\$convf{'$f', '$t'} = *${f}2${t};\n";
	}
	$_ .= "\$h2zf{'$f'} = *h2z_${f};\n\$z2hf{'$f'} = *z2h_${f};\n";
    }
    eval $_;
}

sub jis_inout {
    $esc_jp = shift || $esc_jp;
    $esc_jp = "\e\$$esc_jp" if length($esc_jp) == 1;
    $esc_asc = shift || $esc_asc;
    $esc_asc = "\e\($esc_asc" if length($esc_asc) == 1;
    ($esc_jp, $esc_asc);
}

sub get_inout {
    local($esc_jp, $esc_asc);
    $_[$[] =~ /$re_jp/o && ($esc_jp = $&);
    $_[$[] =~ /$re_asc/o && ($esc_asc = $&);
    ($esc_jp, $esc_asc);
}

sub getcode {
    local(*_) = @_;
    return undef unless /[\e\200-\377]/;
    return 'jis' if /$re_jp|$re_asc|$re_kana/o;
    return 'binary' if /$re_bin/o;

    local($sjis, $euc);
    $sjis += length($&) while /($re_sjis_c)+/go;
    $euc  += length($&) while /($re_euc_c)+/go;
    (&max($sjis, $euc), ('euc', undef, 'sjis')[($sjis<=>$euc) + $[ + 1]);
}
sub max { $_[ $[ + ($_[$[] < $_[$[+1]) ]; }

sub convert {
    local(*_, $ocode, $icode, $opt) = @_;
    return (undef, undef) unless $icode = $icode || &getcode(*_);
    return (undef, $icode) if $icode eq 'binary';
    $ocode = 'jis' unless $ocode;
    $ocode = $icode if $ocode eq 'noconv';
    local(*convf) = $convf{$icode, $ocode};
    do convf(*_, $opt);
    (*convf, $icode);
}

sub jis  { &to('jis',  @_); }
sub euc  { &to('euc',  @_); }
sub sjis { &to('sjis', @_); }
sub to {
    local($ocode, $_, $icode, $opt) = @_;
    &convert(*_, $ocode, $icode, $opt);
    $_;
}
sub what {
    local($_) = @_;
    &getcode(*_);
}
sub trans {
    local($_) = shift;
    &tr(*_, @_);
    $_;
}

sub jis2sjis {
    local(*_, $opt, $n) = @_;
    &jis2jis(*_, $opt) if $opt;
    s/($re_jp|$re_asc|$re_kana)([^\e]*)/&_jis2sjis($1,$2)/geo;
    $n;
}
sub _jis2sjis {
    local($esc, $_) = @_;
    if ($esc !~ /$re_asc/o) {
	$n += tr/\041-\176/\241-\376/;
	s/$re_euc_c/$e2s{$&}||&e2s($&)/geo if $esc =~ /$re_jp/o;
    }
    $_;
}

sub euc2sjis {
    local(*_, $opt,$n) = @_;
    &euc2euc(*_, $opt) if $opt;
    $n = s/$re_euc_c|$re_euc_kana/$e2s{$&}||&e2s($&)/geo;
}
sub e2s {
    local($c1, $c2, $code);
    ($c1, $c2) = unpack('CC', $code = shift);

    if ($c1 == 0x8e) {
	return substr($code, 1, 1);
    } elsif ($c1 % 2) {
	$c1 = ($c1>>1) + ($c1 < 0xdf ? 0x31 : 0x71);
	$c2 -= 0x60 + ($c2 < 0xe0);
    } else {
	$c1 = ($c1>>1) + ($c1 < 0xdf ? 0x30 : 0x70);
	$c2 -= 2;
    }
    if ($cache) {
	$e2s{$code} = pack('CC', $c1, $c2);
    } else {
	pack('CC', $c1, $c2);
    }
}

sub sjis2jis {
    local(*_, $opt, $n) = @_;
    &sjis2sjis(*_, $opt) if $opt;
    if (s/($re_sjis_kana)+|($re_sjis_c)+/&_sjis2jis($&)/geo) {
	s/$re_asc($re_jp|$re_kana)/$1/go;
    }
    $n;
}
sub _sjis2jis {
    local($_) = @_;
    if (/^$re_sjis_kana/o) {
	$n += tr/\241-\337/\041-\137/;
	$esc_kana . $_ . $esc_asc;
    } else {
	$n += s/$re_sjis_c/$s2e{$&}||&s2e($&)/geo;
	tr/\241-\376/\041-\176/;
	$esc_jp . $_ . $esc_asc;
    }
}

sub euc2jis {
    local(*_, $opt, $n) = @_;
    &euc2euc(*_, $opt) if $opt;
    if (s/($re_euc_kana)+|($re_euc_c)+/&_euc2jis($&)/geo) {
	s/$re_asc($re_jp|$re_kana)/$1/go;
    }
    $n;
}
sub _euc2jis {
    local($_) = @_;
    local($esc) = tr/\216//d ? $esc_kana : $esc_jp;
    $n += tr/\241-\376/\041-\176/;
    $esc . $_ . $esc_asc;
}

sub jis2euc {
    local(*_, $opt, $n) = @_;
    s/($re_jp|$re_asc|$re_kana)([^\e]*)/&_jis2euc($1,$2)/geo;
    &euc2euc(*_, $opt) if $opt;
    $n;
}
sub _jis2euc {
    local($esc, $_) = @_;
    if ($esc !~ /$re_asc/o) {
	$n += tr/\041-\176/\241-\376/;
	s/[\241-\337]/\216$&/g if $esc =~ /$re_kana/o;
    }
    $_;
}

sub sjis2euc {
    local(*_, $opt,$n) = @_;
    $n = s/$re_sjis_kana|$re_sjis_c/$s2e{$&}||&s2e($&)/geo;
    &euc2euc(*_, $opt) if $opt;
    $n;
}
sub s2e {
    local($c1, $c2, $code);
    ($c1, $c2) = unpack('CC', $code = shift);

    if (0xa1 <= $c1 && $c1 <= 0xdf) {
	$c2 = $c1;
	$c1 = 0x8e;
    } elsif (0x9f <= $c2) {
	$c1 = $c1 * 2 - ($c1 >= 0xe0 ? 0xe0 : 0x60);
	$c2 += 2;
    } else {
	$c1 = $c1 * 2 - ($c1 >= 0xe0 ? 0xe1 : 0x61);
	$c2 += 0x60 + ($c2 < 0x7f);
    }
    if ($cache) {
	$s2e{$code} = pack('CC', $c1, $c2);
    } else {
	pack('CC', $c1, $c2);
    }
}

;#
;# JIS to JIS, SJIS to SJIS, EUC to EUC
;#
sub jis2jis {
    local(*_, $opt) = @_;
    s/$re_jp/$esc_jp/go;
    s/$re_asc/$esc_asc/go;
    &h2z_jis(*_) if $opt =~ /z/;
    &z2h_jis(*_) if $opt =~ /h/;
}
sub sjis2sjis {
    local(*_, $opt) = @_;
    &h2z_sjis(*_) if $opt =~ /z/;
    &z2h_sjis(*_) if $opt =~ /h/;
}
sub euc2euc {
    local(*_, $opt) = @_;
    &h2z_euc(*_) if $opt =~ /z/;
    &z2h_euc(*_) if $opt =~ /h/;
}

;#
;# Cache control functions
;#
sub cache {
    ($cache, $cache = 1)[$[];
}
sub nocache {
    ($cache, $cache = 0)[$[];
}
sub flushcache {
    undef %e2s;
    undef %s2e;
}

;#
;# X0201 -> X0208 KANA conversion routine
;#
sub h2z_jis {
    local(*_, $n) = @_;
    if (s/$re_kana([^\e]*)/$esc_jp . &_h2z_jis($1)/geo) {
	1 while s/($re_jp[^\e]*)$re_jp/$1/o;
    }
    $n;
}
sub _h2z_jis {
    local($_) = @_;
    $n += s/[\41-\137]([\136\137])?/$h2z{$&}/g;
    $_;
}

sub h2z_euc {
    local(*_) = @_;
    s/\216([\241-\337])(\216([\336\337]))?/$h2z{"$1$3"}/g;
}

sub h2z_sjis {
    local(*_, $n) = @_;
    s/(($re_sjis_c)+)|(([\241-\337])([\336\337])?)/
	$1 || ($n++, $e2s{$h2z{$3}} || &e2s($h2z{$3}))/geo;
    $n;
}

;#
;# X0208 -> X0201 KANA conversion routine
;#
sub z2h_jis {
    local(*_, $n) = @_;
    s/$re_jp([^\e]+)/&_z2h_jis($1)/geo;
    $n;
}
sub _z2h_jis {
    local($_) = @_;
    s/(\%[!-~]|![\#\"&VW+,<])+|([^!%][!-~]|![^\#\"&VW+,<])+/&__z2h_jis($&)/ge;
    $_;
}
sub __z2h_jis {
    local($_) = @_;
    return $esc_jp . $_ unless /^%/ || /^![\#\"&VW+,<]/;
    $n += length($_) / 2;
    s/../$z2h{$&}/g;
    $esc_kana . $_;
}

sub z2h_euc {
    local(*_, $n) = @_;
    &init_z2h_euc unless defined %z2h_euc;
    s/$re_euc_c|$re_euc_kana/$z2h_euc{$&} ? ($n++, $z2h_euc{$&}) : $&/geo;
    $n;
}

sub z2h_sjis {
    local(*_, $n) = @_;
    &init_z2h_sjis unless defined %z2h_sjis;
    s/$re_sjis_c/$z2h_sjis{$&} ? ($n++, $z2h_sjis{$&}) : $&/geo;
    $n;
}

;#
;# Initializing JIS X0208 to X0201 KANA table for EUC and SJIS.  This
;# can be done in &init but it's not worth doing.  Similarly,
;# precalculated table is not worth to occupy the file space and
;# reduce the readability.  The author personnaly discourages to use
;# X0201 Kana character in the any situation.
;#
sub init_z2h_euc {
    local($k, $_);
    s/[\241-\337]/\216$&/g && ($z2h_euc{$k} = $_) while ($k, $_) = each %z2h;
}
sub init_z2h_sjis {
    local($_, $v);
    /[\200-\377]/ && ($z2h_sjis{&e2s($_)} = $v) while ($_, $v) = each %z2h;
}

;#
;# TR function for 2-byte code
;#
sub tr {
    local(*_, $from, $to, $opt) = @_;
    local(@from, @to, %table);
    local($jis, $n) = (0, 0);
    local($ascii) = '(\\\\[\\-\\\\]|[\0-\133\135-\177])';
    
    &jis2euc(*_),   $jis++ if $_    =~ /$re_jp/o;
    &jis2euc(*to),  $jis++ if $to   =~ /$re_jp/o;
    &jis2euc(*from)	   if $from =~ /$re_jp/o;

    grep(s/([\200-\377])[\200-\377]-\1[\200-\377]/&_expnd2($&)/ge, $from, $to);
    grep(s/$ascii-$ascii/&_expnd1($&)/geo, $from, $to);

    @to   = $to   =~ /[\200-\377][\000-\377]|[\000-\377]/g;
    @from = $from =~ /[\200-\377][\000-\377]|[\000-\377]/g;
    push(@to, ($opt =~ /d/ ? '' : $to[$#to]) x (@from - @to)) if @to < @from;
    @table{@from} = @to;

    s/[\200-\377][\000-\377]|[\000-\377]/
	defined($table{$&}) && ++$n ? $table{$&} : $&/ge;

    &euc2jis(*_) if $jis;

    $n;
}

sub _expnd1 {
    local($_) = @_;
    s/\\(.)/$1/g;
    local($c1, $c2) = unpack('CxC', $_);
    if ($c1 <= $c2) {
	for ($_ = ''; $c1 <= $c2; $c1++) {
	    $_ .= pack('C', $c1);
	}
    }
    $_;
}

sub _expnd2 {
    local($_) = @_;
    local($c1, $c2, $c3, $c4) = unpack('CCxCC', $_);
    if ($c1 == $c3 && $c2 <= $c4) {
	for ($_ = ''; $c2 <= $c4; $c2++) {
	    $_ .= pack('CC', $c1, $c2);
	}
    }
    $_;
}

1;
