
LD_FLAG = -lfl -lm

# TARGET_FLEX_BISON = ex_calc_ast
TARGET_FLEX_BISON = ex_adv_calc

$(TARGET_FLEX_BISON): $(TARGET_FLEX_BISON).y $(TARGET_FLEX_BISON).l $(TARGET_FLEX_BISON).h $(TARGET_FLEX_BISON).c
	bison -d $(TARGET_FLEX_BISON).y # *.tab.h, *.tab.c
	flex -o $(TARGET_FLEX_BISON).lex.c $(TARGET_FLEX_BISON).l # *.lex.c
	cc -o $@ $(TARGET_FLEX_BISON).tab.c $(TARGET_FLEX_BISON).lex.c $(TARGET_FLEX_BISON).c $(LD_FLAG)

clean:
	# rm $(TARGET_FLEX).c $(TARGET_FLEX) 
	rm $(TARGET_FLEX_BISON) $(TARGET_FLEX_BISON).lex.c $(TARGET_FLEX_BISON).tab.*
