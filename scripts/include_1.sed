#!/bin/sed -nf

/^\s*#include\s*"\(.*\)"/{
	=;
	s/^\s*#include\s*"/{\nr/;
	s/".*$//p;
	ad;}
}
