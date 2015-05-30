CP ?= cp
MKDIR ?= mkdir -p
LN ?= ln -sf
RM ?= rm -f

prefix = $(DESTDIR)/usr
target_dir = $(prefix)/share/includer
bin_dir = $(prefix)/bin

TARGETS += include.sh
TARGETS += $(wildcard scripts/*.sed)
EXECUTABLES = include

INSTALL_TARGETS = $(addprefix $(target_dir)/,$(TARGETS))
INSTALL_EXECUTABLES = $(addprefix $(bin_dir)/,$(EXECUTABLES))

all:

install:: $(INSTALL_TARGETS) $(INSTALL_EXECUTABLES)

$(INSTALL_TARGETS): $(target_dir)/%: % FORCE
	@$(MKDIR) $(@D)
	$(CP) $< $@

$(INSTALL_EXECUTABLES): $(bin_dir)/%: $(target_dir)/%.sh FORCE
	@$(MKDIR) $(@D)
	$(LN) $< $@

FORCE:

uninstall:
	$(RM) -r $(INSTALL_EXECUTABLES)
	$(RM) -r $(INSTALL_TARGETS)
	$(RM) -r $(target_dir)

.PHONY: FORCE
