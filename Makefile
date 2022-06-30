NAME = exe

SHELL := /bin/bash
CXX = clang++
CXXFLAGS = -Wall -Werror -Wextra -Wshadow -MMD -MP -std=c++98 -I$(includes) -g

includes = ./includes
srcdir = srcs
objdir = objs
srcs = $(shell find $(srcdir) -name "*.cpp" -type f)
objs = $(srcs:$(srcdir)%.cpp=$(objdir)%.o)
deps = $(srcs:$(srcdir)%.cpp=$(objdir)%.d)

# === path of googletest dir === #
gtestdir := googletest

# ==== Align length to format compile message ==== #
ALIGN := $(shell tr ' ' '\n' <<<"$(srcs)" | while read line; do echo \
	$$((`echo $$line | wc -m`)); done | awk 'm<$$1{ m=$$1} END{print m}')

all: $(NAME)
-include $(deps)

$(NAME): $(objs)
	@$(CXX) $(CXXFLAGS) $^ -o $(NAME)
	@echo -e "flags  : $(ylw)$(CXXFLAGS)$(nc)\nbuild  : $(grn)$^$(nc)\n=> $(blu)$@$(nc)" 

$(objdir)/%.o: $(srcdir)/%.cpp
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo -e "compile: $(mgn
)$<$(nc)\
	$$(yes ' ' | head -n $$(expr $(ALIGN) - $$((`echo $< | wc -m` - 1))) | tr -d '\n') -> \
	$(grn)$@$(nc)"

test:
	$(MAKE) -C $(gtestdir) run

cav: $(objs)
	$(MAKE) -C $(gtestdir) cav

clean:
	$(RM) $(objs) $(deps)
	$(RM) -r $(objdir)
	$(MAKE) -C $(gtestdir) clean

fclean: clean
	$(RM) $(NAME)
	$(MAKE) -C $(gtestdir) fclean

re: fclean all

.PHONY: all test cav clean fclean re

# ==== Color define ==== #
ylw := \033[33m
grn := \033[32m
blu := \033[34m
mgn := \033[35m
cyn := \033[36m
nc := \033[m
