SHELL := /bin/bash

# tool macros
CC := cosmocc # FILL: the compiler
CXX ?= # FILL: the compiler
CFLAGS := # FILL: compile flags
CXXFLAGS := # FILL: compile flags
DBGFLAGS := -g
COBJFLAGS := $(CFLAGS) -c

ZIPOBJ := zipobj

# path macros
BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
DBG_PATH := debug
RES_PATH := res

# compile macros
TARGET_NAME := istanbul.com
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)

# src files & obj files
RES := $(shell find $(RES_PATH) -type f)
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))

OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_RES := $(addprefix $(OBJ_PATH)/, $(addsuffix .zip.o, ${RES}))

OBJ_ARM := $(foreach obj,$(OBJ),$(dir ${obj}).aarch64/$(notdir ${obj}))
OBJ_DEBUG_ARM := $(foreach obj,$(OBJ_DEBUG),$(dir ${obj}).aarch64/$(notdir ${obj}))
OBJ_RES_ARM := $(foreach obj,$(OBJ_RES),$(dir ${obj}).aarch64/$(notdir ${obj}))

# clean files list
DISTCLEAN_LIST := $(OBJ) \
                  $(OBJ_DEBUG) \
                  $(OBJ_RES) \
                  $(OBJ_ARM) \
                  $(OBJ_DEBUG_ARM) \
                  $(OBJ_RES_ARM) \

CLEAN_LIST := $(TARGET) \
                          $(TARGET).dbg \
                          $(basename $(TARGET)).aarch64.elf \
                          $(TARGET_DEBUG).dbg \
                          $(basename $(TARGET_DEBUG)).aarch64.elf \
			  $(TARGET_DEBUG) \
			  $(DISTCLEAN_LIST)

# default rule
default: makedir all

# non-phony targets
$(TARGET): $(OBJ) $(OBJ_RES)
	$(CC) $(CFLAGS) $(OBJ) $(OBJ_RES) -o $@

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(COBJFLAGS) -o $@ $<

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(COBJFLAGS) $(DBGFLAGS) -o $@ $<

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CC) $(CFLAGS) $(DBGFLAGS) $(OBJ_DEBUG) $(OBJ_RES) -o $@

$(OBJ_PATH)/res/%.zip.o: $(RES_PATH)/%
	@mkdir -p $(sort $(dir $@))
	@mkdir -p $(sort $(dir $@).aarch64/)

	$(ZIPOBJ) -C 1 -o $@ $<
	$(ZIPOBJ) -C 1 -a aarch64 -o $(dir $@).aarch64/$(notdir $@) $<

# phony rules
.PHONY: makedir
makedir:
	@mkdir -p $(BIN_PATH) $(OBJ_PATH) $(DBG_PATH) $(RES_PATH) $(SRC_PATH)

.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(DISTCLEAN_LIST)
	@rm -f $(DISTCLEAN_LIST)

.PHONY: run
run: $(TARGET)
	./$(TARGET)
