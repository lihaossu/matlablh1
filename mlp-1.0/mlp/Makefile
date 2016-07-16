# Makefile for making MLP distributions

VERSION=1.0

MISC = Makefile README
COMMANDS = mlpf.m mlpdoodle.m
PRIVATE = $(wildcard private/*.m)
PRESENTATIONS = demo/mlp.mat demo/bo-002.jpg demo/graphic_demo_plot.m \
	demo/snake_change.m demo/rubiksnake.m demo/snake_plain.m
FILES = $(MISC) $(COMMANDS) $(PRIVATE) $(PRESENTATIONS)

DISTFILE = mlp-$(VERSION).zip

all:
	@

dist: $(FILES)
	rm -f ../$(DISTFILE)
	cd ..; zip $(DISTFILE) $(addprefix mlp/, $^)

# end