MANPAGES = doc/gen-passphrase.1 doc/gen-password.1
PDF      = doc/gen-passphrase.pdf doc/gen-password.pdf 
MARKDOWN = doc/gen-passphrase.md doc/gen-password.md

default:        manpages

all:            manpages pdf markdown

manpages:       $(MANPAGES)

pdf:            $(PDF)

markdown:       $(MARKDOWN)

doc/gen-passphrase.1:	gen-passphrase
	pod2man $< > $@

doc/gen-password.1:	gen-password
	pod2man $< > $@

doc/gen-passphrase.pdf:	doc/gen-passphrase.1
	groff -man -Tps $< | ps2pdf - $@

doc/gen-password.pdf:	doc/gen-password.1
	groff -man -Tps $< | ps2pdf - $@

doc/gen-password.md:        gen-password
	pod2markdown $< > $@

doc/gen-passphrase.md:        gen-passphrase
	pod2markdown $< > $@

clean:
	rm -f $(MANPAGES) $(PDF) $(MARKDOWN)
