NAME = exe

SHELL := /bin/bash
CXX = clang++
CXXFLAGS = -Wall -Werror -Wextra -Wshadow -MMD -MP -std=c++98 -I$(INCLUDES) -g

INCLUDES = ./includes
SRCDIR = srcs
OBJDIR = objs
SRCS = $(shell find $(SRCDIR) -name "*.cpp" -type f)
OBJS = $(SRCFILE:$(SRCDIR)%.cpp=$(OBJDIR)%.o)
DEPS = $(SRCFILE:$(SRCDIR)%.cpp=$(OBJDIR)%.d)

# === path of googletest dir === #
GTESTDIR := googletest

# ==== Align length to format compile message ==== #
ALIGN := $(shell tr ' ' '\n' <<<"$(SRCS)" | while read line; do echo \
	$$((`echo $$line | wc -m`)); done | awk 'm<$$1{ m=$$1} END{print m}')

all: $(NAME)
-include $(DEPS)

$(NAME): $(OBJS)
	@$(CXX) $(CXXFLAGS) $^ -o $(NAME)
	@echo -e "flags  : $(YLW)$(CXXFLAGS)$(NC)\nbuild  : $(GRN)$^$(NC)\n=> $(BLU)$@$(NC)" 

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(OBJDIR)/$(*D)
	@$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo -e "compile: $(MGN)$<$(NC)\
	$$(yes ' ' | head -n $$(expr $(ALIGN) - $$((`echo $< | wc -m` - 1))) | tr -d '\n') -> \
	$(GRN)$@$(NC)"

test:
	$(MAKE) -C $(GTESTDIR) run

cav: $(OBJS)
	$(MAKE) -C $(GTESTDIR) cav

clean:
	$(RM) $(OBJS) $(DEPS)
	$(RM) -r $(OBJDIR)
	$(MAKE) -C $(GTESTDIR) clean

fclean: clean
	$(RM) $(NAME)
	$(MAKE) -C $(GTESTDIR) fclean

re: fclean all

.PHONY: all test cav clean fclean re

# ==== Color define ==== #
YLW := \033[33m
GRN := \033[32m
YLW := \033[33m
BLU := \033[34m
MGN := \033[35m
CYN := \033[36m
NC := \033[m
