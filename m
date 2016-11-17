From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH 3/4] arm/arm64: GICv2: add GICD_ITARGETSR
 testing
Date: Thu, 17 Nov 2016 17:57:51 +0000
Message-ID: <20161117175752.16475-4-andre.przywara@arm.com>
References: <20161117175752.16475-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3398F402EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 12:56:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uFiLPQfyFPMs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 12:56:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E49E940460
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 12:56:48 -0500 (EST)
In-Reply-To: <20161117175752.16475-1-andre.przywara@arm.com>
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
 arm/gic.c         | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h |  1 +
 2 files changed, 55 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index a27da2c..02b1be1 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -397,6 +397,57 @@ static bool test_priorities(int nr_irqs, void *priptr)
 	return true;
 }
 
+static bool test_targets(int nr_irqs)
+{
+	void *targetsptr = gicv2_dist_base() + GICD_ITARGETSR;
+	u32 orig_targets;
+	u32 cpu_mask;
+	u32 pattern, reg;
+
+	orig_targets = readl(targetsptr + 32);
+	report_prefix_push("ITARGETSR");
+
+	cpu_mask = (1 << nr_cpus) - 1;
+	cpu_mask |= cpu_mask << 8;
+	cpu_mask |= cpu_mask << 16;
+
+	/* Check that bits for non implemented CPUs are RAZ/WI. */
+	if (nr_cpus < 8) {
+		writel(0xffffffff, targetsptr + 32);
+		report("bits for %d non-existent CPUs masked",
+		       !(readl(targetsptr + 32) & ~cpu_mask), 8 - nr_cpus);
+	} else {
+		report_skip("CPU masking (all CPUs implemented)");
+	}
+
+	report("accesses beyond limit RAZ/WI",
+	       test_readonly_32(targetsptr + nr_irqs, true));
+
+	pattern = 0x0103020f;
+	writel(pattern, targetsptr + 32);
+	reg = readl(targetsptr + 32);
+	report("register content preserved (%08x => %08x)",
+	       reg == (pattern & cpu_mask), pattern & cpu_mask, reg);
+
+	/*
+	 * The TARGETS registers are byte accessible, do a byte-wide
+	 * read and write of known content to check for this.
+	 */
+	reg = readb(targetsptr + 33);
+	report("byte reads successful (0x%08x => 0x%02x)",
+	       reg == (BYTE(pattern, 1) & cpu_mask),
+	       pattern & cpu_mask, reg);
+
+	pattern = REPLACE_BYTE(pattern, 2, 0x04);
+	writeb(BYTE(pattern, 2), targetsptr + 34);
+	reg = readl(targetsptr + 32);
+	report("byte writes successful (0x%02x => 0x%08x)",
+	       reg == (pattern & cpu_mask), BYTE(pattern, 2), reg);
+
+	writel(orig_targets, targetsptr + 32);
+	return true;
+}
+
 static int gic_test_mmio(int gic_version)
 {
 	u32 reg;
@@ -436,6 +487,9 @@ static int gic_test_mmio(int gic_version)
 
 	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
 
+	if (gic_version == 2)
+		test_targets(nr_irqs);
+
 	return 0;
 }
 
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index cef748d..6f170cb 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -14,6 +14,7 @@
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
 #define GICD_IPRIORITYR			0x0400
+#define GICD_ITARGETSR			0x0800
 #define GICD_SGIR			0x0f00
 #define GICD_ICPIDR2			0x0fe8
 
-- 
2.9.0
