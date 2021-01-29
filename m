Return-Path: <SRS0=WMPN=HA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F82C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 29 Jan 2021 16:37:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9006564DFB
	for <kvmarm@archiver.kernel.org>; Fri, 29 Jan 2021 16:37:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9006564DFB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA76B4B33C;
	Fri, 29 Jan 2021 11:37:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0uccF30xVokv; Fri, 29 Jan 2021 11:37:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7614C4B33A;
	Fri, 29 Jan 2021 11:37:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7E64B2F7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2021 11:37:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WwNwCUbOTrpr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jan 2021 11:37:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00FA24B20F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2021 11:37:10 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51AAE1424;
 Fri, 29 Jan 2021 08:37:10 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B78A3F71B;
 Fri, 29 Jan 2021 08:37:09 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v3 01/11] lib: arm/arm64: gicv3: Add missing
 barrier when sending IPIs
Date: Fri, 29 Jan 2021 16:36:37 +0000
Message-Id: <20210129163647.91564-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129163647.91564-1-alexandru.elisei@arm.com>
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
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

One common usage for IPIs is for one CPU to write to a shared memory
location, send the IPI to kick another CPU, and the receiver to read from
the same location. Proper synchronization is needed to make sure that the
IPI receiver reads the most recent value and not stale data (for example,
the write from the sender CPU might still be in a store buffer).

For GICv3, IPIs are generated with a write to the ICC_SGI1R_EL1 register.
To make sure the memory stores are observable by other CPUs, we need a
wmb() barrier (DSB ST), which waits for stores to complete.

From the definition of DSB from ARM DDI 0487F.b, page B2-139:

"In addition, no instruction that appears in program order after the DSB
instruction can alter any state of the system or perform any part of its
functionality until the DSB completes other than:

- Being fetched from memory and decoded.
- Reading the general-purpose, SIMD and floating-point, Special-purpose, or
System registers that are directly or indirectly read without causing
side-effects."

Similar definition for armv7 (ARM DDI 0406C.d, page A3-150).

The DSB instruction is enough to prevent reordering of the GIC register
write which comes in program order after the memory access.

This also matches what the Linux GICv3 irqchip driver does (commit
21ec30c0ef52 ("irqchip/gic-v3: Use wmb() instead of smb_wmb() in
gic_raise_softirq()")).

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/gic-v3.c | 6 ++++++
 arm/gic.c        | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index a7e2cb819746..2c067e4e9ba2 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -77,6 +77,12 @@ void gicv3_ipi_send_mask(int irq, const cpumask_t *dest)
 
 	assert(irq < 16);
 
+	/*
+	 * Ensure stores to Normal memory are visible to other CPUs before
+	 * sending the IPI.
+	 */
+	wmb();
+
 	/*
 	 * For each cpu in the mask collect its peers, which are also in
 	 * the mask, in order to form target lists.
diff --git a/arm/gic.c b/arm/gic.c
index acb060585fae..fee48f9b4ccb 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -275,6 +275,11 @@ static void gicv3_ipi_send_self(void)
 
 static void gicv3_ipi_send_broadcast(void)
 {
+	/*
+	 * Ensure stores to Normal memory are visible to other CPUs before
+	 * sending the IPI
+	 */
+	wmb();
 	gicv3_write_sgi1r(1ULL << 40 | IPI_IRQ << 24);
 	isb();
 }
-- 
2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
