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

INSTALL_FILE    = install -p -m 644
INSTALL_PROGRAM = install -p -m 755

prefix_is_defined:
ifeq ($(strip $(PREFIX)),)
	$(error PREFIX is not set)
endif

install: manpages prefix_is_defined
	$(info Installing in $(PREFIX))
	mkdir -p $(PREFIX)/bin $(PREFIX)/share/man/man1
	$(INSTALL_FILE) COPYING $(PREFIX)
	$(INSTALL_FILE) README.md $(PREFIX)
	$(INSTALL_PROGRAM) gen-passphrase $(PREFIX)/bin
	ln -s gen-passphrase $(PREFIX)/bin/gpw
	$(INSTALL_PROGRAM) gen-password $(PREFIX)/bin
	ln -s gen-password $(PREFIX)/bin/gpp
	$(INSTALL_FILE) doc/gen-passphrase.1 $(PREFIX)/share/man/man1//gen-passphrase.1 
	$(INSTALL_FILE) doc/gen-password.1 $(PREFIX)/share/man/man1//gen-password.1 

clean:
	rm -f $(MANPAGES) $(PDF) $(MARKDOWN)
