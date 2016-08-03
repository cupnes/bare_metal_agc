NAME=move_value_into_regA

$(NAME).agc.bin: $(NAME).agc
	yaYUL $< > $(NAME).lst

run: $(NAME).agc.bin
	yaAGC $<

clean:
	rm -f *~ *.lst *.bin *.symtab core

.PHONY: run clean
