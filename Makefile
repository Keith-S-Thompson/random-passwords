MANPAGES = gen-passphrase.1 gen-password.1
PDF      = gen-passphrase.pdf gen-password.pdf 
MARKDOWN = gen-passphrase.md gen-password.md

default:        manpages

all:            manpages pdf markdown

manpages:       $(MANPAGES)

pdf:            $(PDF)

markdown:       $(MARKDOWN)

gen-passphrase.1:	gen-passphrase
	pod2man $< > $@

gen-password.1:	gen-password
	pod2man $< > $@

gen-passphrase.pdf:	gen-passphrase.1
	groff -man -Tps $< | ps2pdf - $@

gen-password.pdf:	gen-password.1
	groff -man -Tps $< | ps2pdf - $@

gen-password.md:        gen-password
	pod2markdown $< > $@

gen-passphrase.md:        gen-passphrase
	pod2markdown $< > $@

clean:
	rm -f $(MANPAGES) $(PDF) $(MARKDOWN)
