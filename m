Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A62FFC6199
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0128022487
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0128022487
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC05A4AECA;
	Fri,  8 Nov 2019 09:43:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YBST0SB++Niu; Fri,  8 Nov 2019 09:43:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 721484AF03;
	Fri,  8 Nov 2019 09:43:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FA24AEE3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yFqZXnSUUMdz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:43:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAAB14AEE7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:02 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88B927A7;
 Fri,  8 Nov 2019 06:43:02 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A5A73F719;
 Fri,  8 Nov 2019 06:43:01 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping
 GICD_CTLR.DS
Date: Fri,  8 Nov 2019 14:42:32 +0000
Message-Id: <20191108144240.204202-10-andre.przywara@arm.com>
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

The DS (Disable Security) bit in the GICv3 GICD_CTLR register controls
access to Group 0 interrupts from the non-secure side.
The KVM VGIC emulation provides a "GIC with a single security state",
so both groups should be accessible.
Provide a test to check this bit can be set to one. The current KVM
emulation should treat this is as RAO/WI (which we also check here). It
would be architecturally compliant though to have this bit at 0 as well,
so we refrain from treating different behaviour as a FAIL.
However we use this as a gateway for further Group 0 IRQ tests.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c            | 62 ++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic-v3.h |  1 +
 2 files changed, 63 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 304b7b9..c882a24 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -531,6 +531,8 @@ static void gic_test_mmio(void)
 	reg = readl(gic_dist_base + GICD_TYPER);
 	nr_irqs = GICD_TYPER_IRQS(reg);
 	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
+	report_info("GIC %s security extension",
+		reg & (1U << 10) ? "has" : "does not have");
 
 	if (gic_version() == 0x2)
 		test_typer_v2(reg);
@@ -638,6 +640,60 @@ static void spi_test_smp(void)
 	report("SPI delievered on all cores", cores == nr_cpus);
 }
 
+/*
+ * Check the security state configuration of the GIC.
+ * Test whether we can switch to a single security state, to test both
+ * group 0 and group 1 interrupts.
+ * Architecturally a GIC can be configured in different ways, so we don't
+ * insist on the current way KVM emulates the GIC.
+ */
+static bool gicv3_check_security(void *gicd_base)
+{
+	u32 ctlr = readl(gicd_base + GICD_CTLR);
+
+	if (ctlr & GICD_CTLR_DS) {
+		writel(ctlr & ~GICD_CTLR_DS, gicd_base + GICD_CTLR);
+		ctlr = readl(gicd_base + GICD_CTLR);
+		if (!(ctlr & GICD_CTLR_DS))
+			report_info("GIC allowing two security states");
+		else
+			report_info("GIC is one security state only");
+	} else {
+		report_info("GIC resets to two security states");
+	}
+
+	writel(ctlr | GICD_CTLR_DS, gicd_base + GICD_CTLR);
+	ctlr = readl(gicd_base + GICD_CTLR);
+	report("switching to single security state", ctlr & GICD_CTLR_DS);
+
+	/* Group0 delivery only works in single security state. */
+	return ctlr & GICD_CTLR_DS;
+}
+
+/*
+ * The GIC architecture describes two interrupt groups, group 0 and group 1.
+ * On bare-metal systems, running in non-secure world on a GIC with the
+ * security extensions, there is only one group available: group 1.
+ * However in the kernel KVM emulates a GIC with only one security state,
+ * so both groups are available to guests.
+ * Check whether this works as expected (as Linux will not use this feature).
+ * We can only verify this state on a GICv3, so we check it there and silently
+ * assume it's valid for GICv2.
+ */
+static void test_irq_group(void *gicd_base)
+{
+	bool is_gicv3 = (gic_version() == 3);
+
+	report_prefix_push("GROUP");
+	gic_enable_defaults();
+
+	if (is_gicv3) {
+		/* GICv3 features a bit to read and set the security state. */
+		if (!gicv3_check_security(gicd_base))
+			return;
+	}
+}
+
 static void spi_send(void)
 {
 	irqs_enable();
@@ -647,6 +703,12 @@ static void spi_send(void)
 	if (nr_cpus > 1)
 		spi_test_smp();
 
+	if (gic_version() == 3)
+		test_irq_group(gicv3_dist_base());
+
+	if (gic_version() == 2)
+		test_irq_group(gicv2_dist_base());
+
 	check_spurious();
 	exit(report_summary());
 }
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 8cfaed1..2eaf944 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -19,6 +19,7 @@
  * group1 enable bits with respect to that view.
  */
 #define GICD_CTLR_RWP			(1U << 31)
+#define GICD_CTLR_DS			(1U << 6)
 #define GICD_CTLR_ARE_NS		(1U << 4)
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
