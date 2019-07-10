Return-Path: <SRS0=LlKa=VH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916D7C74A23
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jul 2019 13:35:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C9682064B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jul 2019 13:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="tDP7DaSq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C9682064B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EDE34A518;
	Wed, 10 Jul 2019 09:35:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2eGa0Nar57Hh; Wed, 10 Jul 2019 09:35:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 424D94A523;
	Wed, 10 Jul 2019 09:35:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C9354A506
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jul 2019 09:27:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gJ5x5Qfb1syG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jul 2019 09:27:34 -0400 (EDT)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC5C24A501
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jul 2019 09:27:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1562765254; x=1594301254;
 h=from:to:cc:subject:date:message-id:mime-version;
 bh=C2+YQiuoCjBnstmK/VhiivB1LX0/aC0xd7b/JjK3gww=;
 b=tDP7DaSqQd6NTGKqiLClrOHiKajbxJoAHSxbtydkpD7vCxk43XRrgvT/
 mRVAml236F7GAuPDXxnGrChYsvttH+24rZaBENgsRhgcc/fEO0oCMX1Km
 plevUVLxIlmSX8k6CVSC1Y4XN2SoVqmDyCLYny2cWs7fUiE7Or1ea61GO s=;
X-IronPort-AV: E=Sophos;i="5.62,474,1554768000"; d="scan'208";a="404349716"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP;
 10 Jul 2019 13:27:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
 by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS
 id 9B8D8C06D4; Wed, 10 Jul 2019 13:27:33 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 13:27:32 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.144) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 13:27:31 +0000
From: Alexander Graf <graf@amazon.com>
To: <kvm@vger.kernel.org>
Subject: [PATCH kvm-unit-tests] arm: Add PL031 test
Date: Wed, 10 Jul 2019 15:27:24 +0200
Message-ID: <20190710132724.28350-1-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D17UWC004.ant.amazon.com (10.43.162.195) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Precedence: Bulk
X-Mailman-Approved-At: Wed, 10 Jul 2019 09:35:11 -0400
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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

This patch adds a unit test for the PL031 RTC that is used in the virt machine.
It just pokes basic functionality. I've mostly written it to familiarize myself
with the device, but I suppose having the test around does not hurt, as it also
exercises the GIC SPI interrupt path.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arm/Makefile.common |   1 +
 arm/pl031.c         | 227 ++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h   |   1 +
 3 files changed, 229 insertions(+)
 create mode 100644 arm/pl031.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f0c4b5d..b8988f2 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
 tests-common += $(TEST_DIR)/gic.flat
 tests-common += $(TEST_DIR)/psci.flat
 tests-common += $(TEST_DIR)/sieve.flat
+tests-common += $(TEST_DIR)/pl031.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/pl031.c b/arm/pl031.c
new file mode 100644
index 0000000..a364a1a
--- /dev/null
+++ b/arm/pl031.c
@@ -0,0 +1,227 @@
+/*
+ * Verify PL031 functionality
+ *
+ * This test verifies whether the emulated PL031 behaves correctly.
+ *
+ * Copyright 2019 Amazon.com, Inc. or its affiliates.
+ * Author: Alexander Graf <graf@amazon.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <asm/processor.h>
+#include <asm/io.h>
+#include <asm/gic.h>
+
+static u32 cntfrq;
+
+#define PL031_BASE 0x09010000
+#define PL031_IRQ 2
+
+struct pl031_regs {
+	uint32_t dr;	/* Data Register */
+	uint32_t mr;	/* Match Register */
+	uint32_t lr;	/* Load Register */
+	union {
+		uint8_t cr;	/* Control Register */
+		uint32_t cr32;
+	};
+	union {
+		uint8_t imsc;	/* Interrupt Mask Set or Clear register */
+		uint32_t imsc32;
+	};
+	union {
+		uint8_t ris;	/* Raw Interrupt Status */
+		uint32_t ris32;
+	};
+	union {
+		uint8_t mis;	/* Masked Interrupt Status */
+		uint32_t mis32;
+	};
+	union {
+		uint8_t icr;	/* Interrupt Clear Register */
+		uint32_t icr32;
+	};
+	uint32_t reserved[1008];
+	uint32_t periph_id[4];
+	uint32_t pcell_id[4];
+};
+
+static struct pl031_regs *pl031 = (void*)PL031_BASE;
+static void *gic_ispendr;
+static void *gic_isenabler;
+static bool irq_triggered;
+
+static int check_id(void)
+{
+	uint32_t id[] = { 0x31, 0x10, 0x14, 0x00, 0x0d, 0xf0, 0x05, 0xb1 };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(id); i++)
+		if (id[i] != readl(&pl031->periph_id[i]))
+			return 1;
+
+	return 0;
+}
+
+static int check_ro(void)
+{
+	uint32_t offs[] = { offsetof(struct pl031_regs, ris),
+			    offsetof(struct pl031_regs, mis),
+			    offsetof(struct pl031_regs, periph_id[0]),
+			    offsetof(struct pl031_regs, periph_id[1]),
+			    offsetof(struct pl031_regs, periph_id[2]),
+			    offsetof(struct pl031_regs, periph_id[3]),
+			    offsetof(struct pl031_regs, pcell_id[0]),
+			    offsetof(struct pl031_regs, pcell_id[1]),
+			    offsetof(struct pl031_regs, pcell_id[2]),
+			    offsetof(struct pl031_regs, pcell_id[3]) };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(offs); i++) {
+		uint32_t before32;
+		uint16_t before16;
+		uint8_t before8;
+		void *addr = (void*)pl031 + offs[i];
+		uint32_t poison = 0xdeadbeefULL;
+
+		before8 = readb(addr);
+		before16 = readw(addr);
+		before32 = readl(addr);
+
+		writeb(poison, addr);
+		writew(poison, addr);
+		writel(poison, addr);
+
+		if (before8 != readb(addr))
+			return 1;
+		if (before16 != readw(addr))
+			return 1;
+		if (before32 != readl(addr))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int check_rtc_freq(void)
+{
+	uint32_t seconds_to_wait = 2;
+	uint32_t before = readl(&pl031->dr);
+	uint64_t before_tick = read_sysreg(cntpct_el0);
+	uint64_t target_tick = before_tick + (cntfrq * seconds_to_wait);
+
+	/* Wait for 2 seconds */
+	while (read_sysreg(cntpct_el0) < target_tick) ;
+
+	if (readl(&pl031->dr) != before + seconds_to_wait)
+		return 1;
+
+	return 0;
+}
+
+static bool gic_irq_pending(void)
+{
+	return readl(gic_ispendr + 4) & (1 << (SPI(PL031_IRQ) - 32));
+}
+
+static void gic_irq_unmask(void)
+{
+	writel(1 << (SPI(PL031_IRQ) - 32), gic_isenabler + 4);
+}
+
+static void irq_handler(struct pt_regs *regs)
+{
+	u32 irqstat = gic_read_iar();
+	u32 irqnr = gic_iar_irqnr(irqstat);
+
+	if (irqnr != GICC_INT_SPURIOUS)
+		gic_write_eoir(irqstat);
+
+	if (irqnr == SPI(PL031_IRQ)) {
+		report("  RTC RIS == 1", readl(&pl031->ris) == 1);
+		report("  RTC MIS == 1", readl(&pl031->mis) == 1);
+
+		/* Writing any value should clear IRQ status */
+		writel(0x80000000ULL, &pl031->icr);
+
+		report("  RTC RIS == 0", readl(&pl031->ris) == 0);
+		report("  RTC MIS == 0", readl(&pl031->mis) == 0);
+		irq_triggered = true;
+	} else {
+		report_info("Unexpected interrupt: %d\n", irqnr);
+		return;
+	}
+}
+
+static int check_rtc_irq(void)
+{
+	uint32_t seconds_to_wait = 1;
+	uint32_t before = readl(&pl031->dr);
+	uint64_t before_tick = read_sysreg(cntpct_el0);
+	uint64_t target_tick = before_tick + (cntfrq * (seconds_to_wait + 1));
+
+	report_info("Checking IRQ trigger (MR)");
+
+	irq_triggered = false;
+
+	/* Fire IRQ in 1 second */
+	writel(before + seconds_to_wait, &pl031->mr);
+
+	install_irq_handler(EL1H_IRQ, irq_handler);
+
+	/* Wait until 2 seconds are over */
+	while (read_sysreg(cntpct_el0) < target_tick) ;
+
+	report("  RTC IRQ not delivered without mask", !gic_irq_pending());
+
+	/* Mask the IRQ so that it gets delivered */
+	writel(1, &pl031->imsc);
+	report("  RTC IRQ pending now", gic_irq_pending());
+
+	/* Enable retrieval of IRQ */
+	gic_irq_unmask();
+	local_irq_enable();
+
+	report("  IRQ triggered", irq_triggered);
+	report("  RTC IRQ not pending anymore", !gic_irq_pending());
+	if (!irq_triggered) {
+		report_info("  RTC RIS: %x", readl(&pl031->ris));
+		report_info("  RTC MIS: %x", readl(&pl031->mis));
+		report_info("  RTC IMSC: %x", readl(&pl031->imsc));
+		report_info("  GIC IRQs pending: %08x %08x", readl(gic_ispendr), readl(gic_ispendr + 4));
+	}
+
+	local_irq_disable();
+	return 0;
+}
+
+static void rtc_irq_init(void)
+{
+	gic_enable_defaults();
+
+	switch (gic_version()) {
+	case 2:
+		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
+		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
+		break;
+	case 3:
+		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
+		gic_isenabler = gicv3_sgi_base() + GICD_ISENABLER;
+		break;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	cntfrq = get_cntfrq();
+	rtc_irq_init();
+
+	report("Periph/PCell IDs match", !check_id());
+	report("R/O fields are R/O", !check_ro());
+	report("RTC ticks at 1HZ", !check_rtc_freq());
+	report("RTC IRQ not pending yet", !gic_irq_pending());
+	check_rtc_irq();
+
+	return report_summary();
+}
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index f6dfb90..1fc10a0 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -41,6 +41,7 @@
 #include <asm/gic-v3.h>
 
 #define PPI(irq)			((irq) + 16)
+#define SPI(irq)			((irq) + GIC_FIRST_SPI)
 
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
