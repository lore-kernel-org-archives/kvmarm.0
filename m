From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 1/2] Makefile: allow overriding CFLAGS on the command line
Date: Fri, 30 Oct 2015 17:20:49 +0000
Message-ID: <1446225650-19710-2-git-send-email-andre.przywara@arm.com>
References: <1446225650-19710-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446225650-19710-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When a Makefile variable is set on the make command line, all
Makefile-internal assignments to that very variable are _ignored_.
Since we add quite some essential values to CFLAGS internally,
specifying some CFLAGS on the command line will usually break the
build (and not fix any include file problems you hoped to overcome
with that).
Somewhat against intuition GNU make provides the "override" directive
to change this behavior; with that assignments in the Makefile get
_appended_ to the value given on the command line. [1]

Change any internal assignments to use that directive, so that a user
can use:
$ make CFLAGS=/path/to/my/include/dir
to teach kvmtool about non-standard header file locations (helpful
for cross-compilation) or to tweak other compiler options.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

[1] https://www.gnu.org/software/make/manual/html_node/Override-Directive.html
---
 Makefile | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index f8f7cc4..77a7c9f 100644
--- a/Makefile
+++ b/Makefile
@@ -15,9 +15,7 @@ include config/utilities.mak
 include config/feature-tests.mak
 
 CC	:= $(CROSS_COMPILE)gcc
-CFLAGS	:=
 LD	:= $(CROSS_COMPILE)ld
-LDFLAGS	:=
 
 FIND	:= find
 CSCOPE	:= cscope
@@ -162,7 +160,7 @@ ifeq ($(ARCH), arm)
 	OBJS		+= arm/aarch32/kvm-cpu.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch32/include
-	CFLAGS		+= -march=armv7-a
+	override CFLAGS	+= -march=armv7-a
 
 	ARCH_WANT_LIBFDT := y
 endif
@@ -274,12 +272,12 @@ endif
 ifeq ($(LTO),1)
 	FLAGS_LTO := -flto
 	ifeq ($(call try-build,$(SOURCE_HELLO),$(CFLAGS),$(FLAGS_LTO)),y)
-		CFLAGS		+= $(FLAGS_LTO)
+		override CFLAGS	+= $(FLAGS_LTO)
 	endif
 endif
 
 ifeq ($(call try-build,$(SOURCE_STATIC),,-static),y)
-	CFLAGS		+= -DCONFIG_GUEST_INIT
+	override CFLAGS	+= -DCONFIG_GUEST_INIT
 	GUEST_INIT	:= guest/init
 	GUEST_OBJS	= guest/guest_init.o
 	ifeq ($(ARCH_PRE_INIT),)
@@ -331,7 +329,8 @@ DEFINES	+= -DKVMTOOLS_VERSION='"$(KVMTOOLS_VERSION)"'
 DEFINES	+= -DBUILD_ARCH='"$(ARCH)"'
 
 KVM_INCLUDE := include
-CFLAGS	+= $(CPPFLAGS) $(DEFINES) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
+override CFLAGS	+= $(CPPFLAGS) $(DEFINES) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE)
+override CFLAGS	+= -O2 -fno-strict-aliasing -g
 
 WARNINGS += -Wall
 WARNINGS += -Wformat=2
@@ -349,10 +348,10 @@ WARNINGS += -Wvolatile-register-var
 WARNINGS += -Wwrite-strings
 WARNINGS += -Wno-format-nonliteral
 
-CFLAGS	+= $(WARNINGS)
+override CFLAGS	+= $(WARNINGS)
 
 ifneq ($(WERROR),0)
-	CFLAGS += -Werror
+	override CFLAGS += -Werror
 endif
 
 all: $(PROGRAM) $(PROGRAM_ALIAS) $(GUEST_INIT) $(GUEST_PRE_INIT)
-- 
2.5.1

