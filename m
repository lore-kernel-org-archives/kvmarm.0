From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] kvmtool: arm: move PMU support into arm64 only
Date: Fri, 11 Mar 2016 06:28:12 +0000
Message-ID: <1457677692-23009-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Riku Voipoi <riku.voipio@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We only support the PMU emulation for arm64 at the moment, so lets
only compile the support there.
This fixes compilation for arm.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reported-by: Riku Voipoi <riku.voipio@linaro.org>
---
Hi Will,

this is one solution of the problem, not sure we should rather fix
this probably by making it work for arm too.

Cheers,
Andre

 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1f0196f..8f3477a 100644
--- a/Makefile
+++ b/Makefile
@@ -153,8 +153,7 @@ endif
 
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/ioport.o arm/irq.o \
-			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o
+			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
@@ -174,6 +173,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= $(OBJS_ARM_COMMON)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
+	OBJS		+= arm/pmu.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
-- 
2.6.4

