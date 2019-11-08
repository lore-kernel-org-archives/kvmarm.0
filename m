Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE726C5DF60
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:42:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B178D214DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:42:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B178D214DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59EA34AEE6;
	Fri,  8 Nov 2019 09:42:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IPGCdr2lgyjb; Fri,  8 Nov 2019 09:42:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87AFD4AECC;
	Fri,  8 Nov 2019 09:42:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C29C4AEC9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:42:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id woQCt9I4iK6o for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:42:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 871274ACEE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:42:53 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35203AB6;
 Fri,  8 Nov 2019 06:42:53 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 182873F719;
 Fri,  8 Nov 2019 06:42:51 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 02/17] arm: gic: Generalise function names
Date: Fri,  8 Nov 2019 14:42:25 +0000
Message-Id: <20191108144240.204202-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In preparation for adding functions to test SPI interrupts, generalise
some existing functions dealing with IPIs so far, since most of them
are actually generic for all kind of interrupts.
This also reformats the irq_handler() function, to later expand it
more easily.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 04b3337..a114009 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -135,28 +135,30 @@ static void check_ipi_sender(u32 irqstat)
 	}
 }
 
-static void check_irqnr(u32 irqnr)
+static void check_irqnr(u32 irqnr, int expected)
 {
-	if (irqnr != IPI_IRQ)
+	if (irqnr != expected)
 		bad_irq[smp_processor_id()] = irqnr;
 }
 
-static void ipi_handler(struct pt_regs *regs __unused)
+static void irq_handler(struct pt_regs *regs __unused)
 {
 	u32 irqstat = gic_read_iar();
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
-	if (irqnr != GICC_INT_SPURIOUS) {
-		gic_write_eoir(irqstat);
-		smp_rmb(); /* pairs with wmb in stats_reset */
-		++acked[smp_processor_id()];
-		check_ipi_sender(irqstat);
-		check_irqnr(irqnr);
-		smp_wmb(); /* pairs with rmb in check_acked */
-	} else {
+	if (irqnr == GICC_INT_SPURIOUS) {
 		++spurious[smp_processor_id()];
 		smp_wmb();
+		return;
 	}
+
+	gic_write_eoir(irqstat);
+
+	smp_rmb(); /* pairs with wmb in stats_reset */
+	++acked[smp_processor_id()];
+	check_ipi_sender(irqstat);
+	check_irqnr(irqnr, IPI_IRQ);
+	smp_wmb(); /* pairs with rmb in check_acked */
 }
 
 static void gicv2_ipi_send_self(void)
@@ -216,20 +218,20 @@ static void ipi_test_smp(void)
 	report_prefix_pop();
 }
 
-static void ipi_enable(void)
+static void irqs_enable(void)
 {
 	gic_enable_defaults();
 #ifdef __arm__
-	install_exception_handler(EXCPTN_IRQ, ipi_handler);
+	install_exception_handler(EXCPTN_IRQ, irq_handler);
 #else
-	install_irq_handler(EL1H_IRQ, ipi_handler);
+	install_irq_handler(EL1H_IRQ, irq_handler);
 #endif
 	local_irq_enable();
 }
 
 static void ipi_send(void)
 {
-	ipi_enable();
+	irqs_enable();
 	wait_on_ready();
 	ipi_test_self();
 	ipi_test_smp();
@@ -237,9 +239,9 @@ static void ipi_send(void)
 	exit(report_summary());
 }
 
-static void ipi_recv(void)
+static void irq_recv(void)
 {
-	ipi_enable();
+	irqs_enable();
 	cpumask_set_cpu(smp_processor_id(), &ready);
 	while (1)
 		wfi();
@@ -250,7 +252,7 @@ static void ipi_test(void *data __unused)
 	if (smp_processor_id() == IPI_SENDER)
 		ipi_send();
 	else
-		ipi_recv();
+		irq_recv();
 }
 
 static struct gic gicv2 = {
@@ -285,7 +287,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 
 		smp_rmb(); /* pairs with wmb in stats_reset */
 		++acked[smp_processor_id()];
-		check_irqnr(irqnr);
+		check_irqnr(irqnr, IPI_IRQ);
 		smp_wmb(); /* pairs with rmb in check_acked */
 	} else {
 		++spurious[smp_processor_id()];
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
