Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D3AC433E6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08FBD64EC0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08FBD64EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ECB24B2D3;
	Fri, 19 Feb 2021 07:13:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LVrI+tvxRgqi; Fri, 19 Feb 2021 07:13:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A3E4B2EB;
	Fri, 19 Feb 2021 07:13:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 701394B2D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2SQxf3EDWjWn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 07:13:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 173284B284
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C234111FB;
 Fri, 19 Feb 2021 04:13:35 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4B2A3F73B;
 Fri, 19 Feb 2021 04:13:34 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v4 02/11] lib: arm/arm64: gicv2: Document
 existing barriers when sending IPIs
Date: Fri, 19 Feb 2021 12:13:28 +0000
Message-Id: <20210219121337.76533-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210219121337.76533-1-alexandru.elisei@arm.com>
References: <20210219121337.76533-1-alexandru.elisei@arm.com>
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

Because the receiver CPU must observe the write to memory that generated
the IPI when reading the GICC_IAR MMIO register, we only need to ensure
ordering of memory accesses, and not completion. The same pattern can be
observed in the Linux GICv2 irqchip driver (more details in commit
8adbf57fc429 ("irqchip: gic: use dmb ishst instead of dsb when raising a
softirq")).

However, it turns out that no changes are needed to the way GICv2 sends
IPIs because of the implicit barriers in the MMIO writel and readl
functions. Writel executes a wmb() (DST ST) before the MMIO write, and
readl executes a rmb() (DST LD) after the MMIO read. According to  ARM DDI
0406C.d and ARM DDI 0487F.b, the DSB instruction:

"[..] acts as a stronger barrier than a DMB and all ordering that is
created by a DMB with specific options is also generated by a DSB with the
same options."

which means that the correct memory ordering is enforced.

It's not immediately obvious that the proper barriers are in place, so add
a comment explaining that correct memory synchronization is implemented.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/gic-v2.c | 6 ++++++
 arm/gic.c        | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
index dc6a97c600ec..786d6a4e4c6e 100644
--- a/lib/arm/gic-v2.c
+++ b/lib/arm/gic-v2.c
@@ -45,6 +45,11 @@ void gicv2_ipi_send_single(int irq, int cpu)
 {
 	assert(cpu < 8);
 	assert(irq < 16);
+	/*
+	 * The wmb() in writel and rmb() in readl() from gicv2_read_iar() are
+	 * sufficient for ensuring that stores that happen in program order
+	 * before the IPI will be visible after the interrupt is acknowledged.
+	 */
 	writel(1 << (cpu + 16) | irq, gicv2_dist_base() + GICD_SGIR);
 }
 
@@ -53,5 +58,6 @@ void gicv2_ipi_send_mask(int irq, const cpumask_t *dest)
 	u8 tlist = (u8)cpumask_bits(dest)[0];
 
 	assert(irq < 16);
+	/* No barriers needed, same situation as gicv2_ipi_send_single() */
 	writel(tlist << 16 | irq, gicv2_dist_base() + GICD_SGIR);
 }
diff --git a/arm/gic.c b/arm/gic.c
index fee48f9b4ccb..e2e053aeb823 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -260,11 +260,18 @@ static void check_lpi_hits(int *expected, const char *msg)
 
 static void gicv2_ipi_send_self(void)
 {
+	/*
+	 * The wmb() in writel and rmb() when acknowledging the interrupt are
+	 * sufficient for ensuring that writes that happen in program order
+	 * before the interrupt are observed in the interrupt handler after
+	 * acknowledging the interrupt.
+	 */
 	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
 }
 
 static void gicv2_ipi_send_broadcast(void)
 {
+	/* No barriers are needed, same situation as gicv2_ipi_send_self() */
 	writel(1 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
 }
 
-- 
2.30.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
