# Copyright (C) 2008-2016, Marvell International Ltd.
# All Rights Reserved.
#
# Description:
# ------------
# This file, extended_rules.mk contains rules/functions for:
#
# 	.axf file 	--> .bin file 		(create_sdk_prog)
# 	.ftfs generation 			(create_ftfs)

##################### Non-secure Program (.bin) creation

ifeq ($(b-secboot-y),n)
define create_sdk_prog
  $(1).app: $($(1)-output-dir-y)/$(1).bin

  $($(1)-output-dir-y)/$(1).bin: $($(1)-output-dir-y)/$(1).axf $$(t_axf2fw)
	$$(AT)$$(t_rm) -f $$(wildcard $($(1)-output-dir-y)/$(1)*.bin)
	$$(AT)$$(t_axf2fw) $$< $$@
	@echo " [bin] $$(call b-abspath,$$@)"

  .PHONY: $(1).app.clean_bin

  $(1).app.clean: $(1).app.clean_bin

  $(1).app.clean_bin:
	$$(AT)$$(t_rm) -f $$(wildcard $($(1)-output-dir-y)/$(1)*.bin)
endef

$(foreach p,$(filter-out $(b-axf-only),$(b-exec-y)), $(eval $(call create_sdk_prog,$(p))))
endif

$(foreach p,$(b-exec-y),$(eval $(foreach f,$($(p)-ftfs-y),$(call create_ftfs,$(p),$(basename $(f))))))

#---------------------End of FTFS generation rul--------#

help: app-help

app-help:
	@echo ""
	@echo "Build an application"
	@echo "--------------------------"
	@echo "Build a sample application"
	@echo "   $$ make <application-name>.app"
	@echo "   for e.g: $$ make hello_world.app"
	@echo "Clean a sample application"
	@echo "   $$ make <application-name>.app.clean"
	@echo "   for e.g: $$ make hello_world.app.clean"
	@echo "Build a custom  application"
	@echo "   $$ make APP=<path to application> [BOARD=<board_name>]"
	@echo "   where APP is relative path of application with respect to,"
	@echo "   wmsdk_bundle-3.x.y/ e.g: sample_apps/wlan/wm_demo"
	@echo "Clean a custom  application"
	@echo "   $$ make APP=<path to application> [BOARD=<board_name>] <application name>.app.clean"
	@echo ""
