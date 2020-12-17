Return-Path: <SRS0=/4+A=FV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0316C2BBCA
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 14:14:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D83D2360D
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 14:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D83D2360D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F05AA4B22D;
	Thu, 17 Dec 2020 09:14:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LfrE4YkfVj0x; Thu, 17 Dec 2020 09:14:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC3584B209;
	Thu, 17 Dec 2020 09:14:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C2A04B1FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 09:14:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IqpobZXcXWax for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Dec 2020 09:14:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4169C4B1E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 09:14:12 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 916A51042;
 Thu, 17 Dec 2020 06:14:11 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A34033F66B;
 Thu, 17 Dec 2020 06:14:10 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 02/12] lib: arm/arm64: gicv2: Add missing
 barrier when sending IPIs
Date: Thu, 17 Dec 2020 14:13:50 +0000
Message-Id: <20201217141400.106137-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217141400.106137-1-alexandru.elisei@arm.com>
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: andre.przywara@arm.com
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

GICv2 generates IPIs with a MMIO write to the GICD_SGIR register. A common
pattern for IPI usage is for the IPI receiver to read data written to
memory by the sender. The armv7 and armv8 architectures implement a
weakly-ordered memory model, which means that barriers are required to make
sure that the expected values are observed.

It turns out that because the receiver CPU must observe the write to memory
that generated the IPI when reading the GICC_IAR MMIO register, we only
need to ensure ordering of memory accesses, and not completion. Use a
smp_wmb (DMB ISHST) barrier before sending the IPI.

This also matches what the Linux GICv2 irqchip driver does (more details
in commit 8adbf57fc429 ("irqchip: gic: use dmb ishst instead of dsb when
raising a softirq")).

The gicv2_ipi_send_self() function sends an IPI from a CPU to itself.
The tests that use this function rely on the interrupt handler to record
information about the interrupt by using several arrays. It is possible
for the compiler to infer that the arrays won't be changed during normal
program flow and try to perform harmful optimizations (like stashing a
previous read in a register and reusing it). To prevent this, for GICv2,
a compile barrier is added to gicv2_ipi_send_self(). For GICv3, the
wmb() barrier in gic_ipi_send_single() (which is also used when a CPU
sends an IPI to itself) already implies a compiler barrier.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/gic-v2.c | 4 ++++
 arm/gic.c        | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
index dc6a97c600ec..da244c82de34 100644
--- a/lib/arm/gic-v2.c
+++ b/lib/arm/gic-v2.c
@@ -45,6 +45,8 @@ void gicv2_ipi_send_single(int irq, int cpu)
 {
 	assert(cpu < 8);
 	assert(irq < 16);
+
+	smp_wmb();
 	writel(1 << (cpu + 16) | irq, gicv2_dist_base() + GICD_SGIR);
 }
 
@@ -53,5 +55,7 @@ void gicv2_ipi_send_mask(int irq, const cpumask_t *dest)
 	u8 tlist = (u8)cpumask_bits(dest)[0];
 
 	assert(irq < 16);
+
+	smp_wmb();
 	writel(tlist << 16 | irq, gicv2_dist_base() + GICD_SGIR);
 }
diff --git a/arm/gic.c b/arm/gic.c
index fee48f9b4ccb..ca61dba2986c 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -13,6 +13,7 @@
  */
 #include <libcflat.h>
 #include <errata.h>
+#include <linux/compiler.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/delay.h>
@@ -260,11 +261,14 @@ static void check_lpi_hits(int *expected, const char *msg)
 
 static void gicv2_ipi_send_self(void)
 {
+	/* Prevent the compiler from optimizing memory accesses */
+	barrier();
 	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
 }
 
 static void gicv2_ipi_send_broadcast(void)
 {
+	smp_wmb();
 	writel(1 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
 }
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
