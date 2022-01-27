Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7A2C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:20:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F87349F56;
	Thu, 27 Jan 2022 11:20:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rw+2hU8zFcdP; Thu, 27 Jan 2022 11:20:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9ED4B129;
	Thu, 27 Jan 2022 11:20:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A852C49F56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wbBciE8Feqin for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:20:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E8D44B0ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DA5E113E;
 Thu, 27 Jan 2022 08:20:36 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76AB53F766;
 Thu, 27 Jan 2022 08:20:34 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v2 kvmtool 05/10] arm: Make the PMUv3 emulation code arm64
 specific
Date: Thu, 27 Jan 2022 16:20:28 +0000
Message-Id: <20220127162033.54290-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127162033.54290-1-alexandru.elisei@arm.com>
References: <20220127162033.54290-1-alexandru.elisei@arm.com>
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
 Makefile                                              | 4 ++--
 arm/aarch64/arm-cpu.c                                 | 3 ++-
 arm/{include/arm-common => aarch64/include/asm}/pmu.h | 0
 arm/{ => aarch64}/pmu.c                               | 7 ++-----
 4 files changed, 6 insertions(+), 8 deletions(-)
 rename arm/{include/arm-common => aarch64/include/asm}/pmu.h (100%)
 rename arm/{ => aarch64}/pmu.c (93%)

diff --git a/Makefile b/Makefile
index f25114755701..2fe5fb0fba62 100644
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
@@ -182,6 +181,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
+	OBJS		+= arm/aarch64/pmu.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7790b1..1ec37fa60c50 100644
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
similarity index 100%
rename from arm/include/arm-common/pmu.h
rename to arm/aarch64/include/asm/pmu.h
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
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
