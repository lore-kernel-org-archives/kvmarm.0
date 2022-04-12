Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D2FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:32:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B42B64B2A0;
	Tue, 12 Apr 2022 09:32:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 47kISk2LZJMw; Tue, 12 Apr 2022 09:32:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0044B2CD;
	Tue, 12 Apr 2022 09:32:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C26634B2AE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tBgzTu79mtXS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:32:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D0814B2A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 068C11516;
 Tue, 12 Apr 2022 06:32:47 -0700 (PDT)
Received: from e121798.arm.com (unknown [10.57.11.98])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 96E1C3F70D;
 Tue, 12 Apr 2022 06:32:45 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 06/11] arm: Make the PMUv3 emulation code arm64
 specific
Date: Tue, 12 Apr 2022 14:32:26 +0100
Message-Id: <20220412133231.35355-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412133231.35355-1-alexandru.elisei@arm.com>
References: <20220412133231.35355-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM for aarch32 does not exist anymore, PMUv3 is a hardware feature
present only on aarch64 CPUs, the command line option to enable the
feature for a VCPU is aarch64 specific, the PMU code is called only from
an aarch64 function and it compiles to an empty stub when ARCH=arm.
There is no reason to have the PMUv3 emulation code in the common code
area for arm and arm64, so move it to the arm64 directory, where it can
be expanded in the future without fear of breaking aarch32 support.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile                                              | 6 +++---
 arm/aarch64/arm-cpu.c                                 | 3 ++-
 arm/{include/arm-common => aarch64/include/asm}/pmu.h | 6 +++---
 arm/{ => aarch64}/pmu.c                               | 7 ++-----
 4 files changed, 10 insertions(+), 12 deletions(-)
 rename arm/{include/arm-common => aarch64/include/asm}/pmu.h (52%)
 rename arm/{ => aarch64}/pmu.c (93%)

diff --git a/Makefile b/Makefile
index e9121dc39d02..31274353656d 100644
--- a/Makefile
+++ b/Makefile
@@ -159,8 +159,7 @@ endif
 
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
-			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o
+			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
@@ -183,6 +182,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
 	OBJS		+= arm/aarch64/pvtime.o
+	OBJS		+= arm/aarch64/pmu.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
@@ -583,4 +583,4 @@ ifneq ($(MAKECMDGOALS),clean)
 
 KVMTOOLS-VERSION-FILE:
 	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
-endif
\ No newline at end of file
+endif
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index 7e4a3c17c38f..f5c8e1e7a06b 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -5,7 +5,8 @@
 
 #include "arm-common/gic.h"
 #include "arm-common/timer.h"
-#include "arm-common/pmu.h"
+
+#include "asm/pmu.h"
 
 #include <linux/byteorder.h>
 #include <linux/types.h>
diff --git a/arm/include/arm-common/pmu.h b/arm/aarch64/include/asm/pmu.h
similarity index 52%
rename from arm/include/arm-common/pmu.h
rename to arm/aarch64/include/asm/pmu.h
index 0085f2545553..38e3154b11b7 100644
--- a/arm/include/arm-common/pmu.h
+++ b/arm/aarch64/include/asm/pmu.h
@@ -1,8 +1,8 @@
-#ifndef ARM_COMMON__PMU_H
-#define ARM_COMMON__PMU_H
+#ifndef __ARM_PMU_H__
+#define __ARM_PMU_H__
 
 #define KVM_ARM_PMUv3_PPI			23
 
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 
-#endif /* ARM_COMMON__PMU_H */
+#endif /* __ARM_PMU_H__ */
diff --git a/arm/pmu.c b/arm/aarch64/pmu.c
similarity index 93%
rename from arm/pmu.c
rename to arm/aarch64/pmu.c
index 5b058eabb49d..6b190c5e2ae5 100644
--- a/arm/pmu.c
+++ b/arm/aarch64/pmu.c
@@ -4,9 +4,9 @@
 #include "kvm/util.h"
 
 #include "arm-common/gic.h"
-#include "arm-common/pmu.h"
 
-#ifdef CONFIG_ARM64
+#include "asm/pmu.h"
+
 static int set_pmu_attr(struct kvm *kvm, int vcpu_idx,
 			struct kvm_device_attr *attr)
 {
@@ -71,6 +71,3 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
 	_FDT(fdt_end_node(fdt));
 }
-#else
-void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm) { }
-#endif
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
