From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] kvmtool: Makefile: allow overriding CC and LD
Date: Thu, 18 Jun 2015 16:50:47 +0100
Message-ID: <1434642647-3127-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com
Cc: Michael Ellerman <mpe@ellerman.id.au>, Matt Evans <matt@ozlabs.org>, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently we set CC unconditionally to ${CROSS_COMPILE}gcc, the same
for LD.
Allow people to override the compiler name by specifying it explicitly
on the command line or via the environment.
Beside calling a certain compiler binary this allows to pass in
options to the compiler, which lets us get rid of the PowerPC
overrides in the Makefile. Possible uses:
$ make CC="gcc -m64" LD="ld -melf64ppc"
(build kvmtool on a PowerPC toolchain defaulting to 32-bit)
$ make CC="gcc -m32" LD="ld -melf_i386"
(build a 32-bit binary on a multilib-enabled x86-64 compiler)

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 6110b8e..888bee5 100644
--- a/Makefile
+++ b/Makefile
@@ -14,9 +14,13 @@ export E Q
 include config/utilities.mak
 include config/feature-tests.mak
 
-CC	:= $(CROSS_COMPILE)gcc
+ifeq ($(origin CC), default)
+	CC	:= $(CROSS_COMPILE)gcc
+endif
 CFLAGS	:=
-LD	:= $(CROSS_COMPILE)ld
+ifeq ($(origin LD), default)
+	LD	:= $(CROSS_COMPILE)ld
+endif
 LDFLAGS	:=
 
 FIND	:= find
@@ -148,8 +152,6 @@ ifeq ($(ARCH), powerpc)
 	OBJS	+= powerpc/spapr_pci.o
 	OBJS	+= powerpc/xics.o
 	ARCH_INCLUDE := powerpc/include
-	CFLAGS 	+= -m64
-	LDFLAGS += -m elf64ppc
 
 	ARCH_WANT_LIBFDT := y
 endif
-- 
2.3.5

