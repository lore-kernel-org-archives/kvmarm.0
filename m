Return-Path: <SRS0=JhWI=QC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50ABBC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01A9E61B72
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 01A9E61B72
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6664B14C;
	Mon, 15 Nov 2021 11:55:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U+IAOSu3q62g; Mon, 15 Nov 2021 11:55:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 480174B1AD;
	Mon, 15 Nov 2021 11:55:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEE204B150
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cp0mHJ1Mbobv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Nov 2021 11:55:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E53384B195
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:32 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C5F91FB;
 Mon, 15 Nov 2021 08:55:32 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 193713F766;
 Mon, 15 Nov 2021 08:55:30 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com
Subject: [PATCH kvmtool 4/9] arm: Make the PMUv3 emulation code arm64 specific
Date: Mon, 15 Nov 2021 16:57:00 +0000
Message-Id: <20211115165705.195736-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165705.195736-1-alexandru.elisei@arm.com>
References: <20211115165705.195736-1-alexandru.elisei@arm.com>
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
index bb7ad3ecf66e..c7820e6a5200 100644
--- a/Makefile
+++ b/Makefile
@@ -157,8 +157,7 @@ endif
 
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
-			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o
+			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
@@ -180,6 +179,7 @@ ifeq ($(ARCH), arm64)
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
