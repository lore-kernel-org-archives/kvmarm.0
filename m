Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA7AC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F87F64EC0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F87F64EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D75934B2D1;
	Fri, 19 Feb 2021 07:13:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7mYucD39xUil; Fri, 19 Feb 2021 07:13:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B3B4B2F8;
	Fri, 19 Feb 2021 07:13:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DD294B283
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zyU5x8Tffh1E for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 07:13:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DB574B307
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:40 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D19813D5;
 Fri, 19 Feb 2021 04:13:40 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F9C93F73B;
 Fri, 19 Feb 2021 04:13:39 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v4 06/11] arm/arm64: gic: Check spurious and
 bad_sender in the active test
Date: Fri, 19 Feb 2021 12:13:32 +0000
Message-Id: <20210219121337.76533-7-alexandru.elisei@arm.com>
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

The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
checks that the interrupt has been received as expected. The
ipi_clear_active_handler() clears the active state of the interrupt with a
write to the GICD_ICACTIVER register instead of writing the to EOI
register.

When acknowledging the interrupt it is possible to get back an spurious
interrupt ID (ID 1023), and the interrupt handler increments the number of
spurious interrupts received on the current processor. However, this is not
checked at the end of the test. Let's also check for spurious interrupts,
like the IPI test does.

For IPIs on GICv2, the value returned by a read of the GICC_IAR register
performed when acknowledging the interrupt also contains the sender CPU
ID. Add a check for that too.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index c1b6c94a5f5e..982c96681cf9 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -125,12 +125,12 @@ static void check_spurious(void)
 	}
 }
 
-static void check_ipi_sender(u32 irqstat)
+static void check_ipi_sender(u32 irqstat, int sender)
 {
 	if (gic_version() == 2) {
 		int src = (irqstat >> 10) & 7;
 
-		if (src != IPI_SENDER)
+		if (src != sender)
 			bad_sender[smp_processor_id()] = src;
 	}
 }
@@ -148,7 +148,7 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 	if (irqnr != GICC_INT_SPURIOUS) {
 		gic_write_eoir(irqstat);
-		check_ipi_sender(irqstat);
+		check_ipi_sender(irqstat, IPI_SENDER);
 		check_irqnr(irqnr);
 		smp_wmb(); /* pairs with smp_rmb in check_acked */
 		++acked[smp_processor_id()];
@@ -382,6 +382,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 
 		writel(val, base + GICD_ICACTIVER);
 
+		check_ipi_sender(irqstat, smp_processor_id());
 		check_irqnr(irqnr);
 		++acked[smp_processor_id()];
 	} else {
@@ -394,6 +395,7 @@ static void run_active_clear_test(void)
 	report_prefix_push("active");
 	setup_irq(ipi_clear_active_handler);
 	ipi_test_self();
+	check_spurious();
 	report_prefix_pop();
 }
 
-- 
2.30.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
