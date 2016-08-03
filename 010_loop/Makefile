NAME=loop

$(NAME).agc.bin: $(NAME).agc
	yaYUL $< > $(NAME).lst

run: $(NAME).agc.bin
	yaAGC $<

clean:
	rm -f *~ *.lst *.bin *.symtab

.PHONY: run clean
