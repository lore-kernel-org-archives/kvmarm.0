From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH v2 4/4] arm/arm64: GICv2: add GICD_ITARGETSR
 testing
Date: Fri, 20 Jul 2018 16:39:42 +0100
Message-ID: <20180720153942.26821-5-andre.przywara@arm.com>
References: <20180720153942.26821-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6759D40196
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:26:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bDr2IjaUQr-B for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jul 2018 11:26:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B6014A0D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:26:50 -0400 (EDT)
In-Reply-To: <20180720153942.26821-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Some tests for the ITARGETS registers.
Bits corresponding to non-existent CPUs must be RAZ/WI.
These registers must be byte-accessible, also check that accesses beyond
the implemented IRQ limit are actually read-as-zero/write-ignore.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c         | 43 +++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h |  1 +
 2 files changed, 44 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 57a2995..ed5642e 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -431,6 +431,46 @@ static void test_priorities(int nr_irqs, void *priptr)
 	writel(orig_prio, first_spi);
 }
 
+/* GICD_ITARGETSR is only used by GICv2. */
+static void test_targets(int nr_irqs)
+{
+	void *targetsptr = gicv2_dist_base() + GICD_ITARGETSR;
+	u32 orig_targets;
+	u32 cpu_mask;
+	u32 pattern, reg;
+
+	orig_targets = readl(targetsptr + GIC_FIRST_SPI);
+	report_prefix_push("ITARGETSR");
+
+	cpu_mask = (1 << nr_cpus) - 1;
+	cpu_mask |= cpu_mask << 8;
+	cpu_mask |= cpu_mask << 16;
+
+	/* Check that bits for non implemented CPUs are RAZ/WI. */
+	if (nr_cpus < 8) {
+		writel(0xffffffff, targetsptr + GIC_FIRST_SPI);
+		report("bits for %d non-existent CPUs masked",
+		       !(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask),
+		       8 - nr_cpus);
+	} else {
+		report_skip("CPU masking (all CPUs implemented)");
+	}
+
+	report("accesses beyond limit RAZ/WI",
+	       test_readonly_32(targetsptr + nr_irqs, true));
+
+	pattern = 0x0103020f;
+	writel(pattern, targetsptr + GIC_FIRST_SPI);
+	reg = readl(targetsptr + GIC_FIRST_SPI);
+	report("register content preserved (%08x => %08x)",
+	       reg == (pattern & cpu_mask), pattern & cpu_mask, reg);
+
+	/* The TARGETS registers are byte accessible. */
+	test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
+
+	writel(orig_targets, targetsptr + GIC_FIRST_SPI);
+}
+
 static void gic_test_mmio(void)
 {
 	u32 reg;
@@ -467,6 +507,9 @@ static void gic_test_mmio(void)
 	       reg);
 
 	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
+
+	if (gic_version() == 2)
+		test_targets(nr_irqs);
 }
 
 int main(int argc, char **argv)
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index a469645..f6dfb90 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -20,6 +20,7 @@
 #define GICD_ISACTIVER			0x0300
 #define GICD_ICACTIVER			0x0380
 #define GICD_IPRIORITYR			0x0400
+#define GICD_ITARGETSR			0x0800
 #define GICD_SGIR			0x0f00
 #define GICD_ICPIDR2			0x0fe8
 
-- 
2.14.4
