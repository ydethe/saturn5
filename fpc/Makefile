Q=@
COMP?=fpc
SRC=$(shell find src -name *.pas)

default: apollo

test: apollo
	$(Q)src/apollo

apollo: $(SRC)
	$(Q)cd src && $(COMP) apollo.pas
