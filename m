From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH 2/4] arm/arm64: GICv2: add GICD_IPRIORITYR
 testing
Date: Thu, 17 Nov 2016 17:57:50 +0000
Message-ID: <20161117175752.16475-3-andre.przywara@arm.com>
References: <20161117175752.16475-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABCBB401E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 12:56:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W8wiiXFn5vUq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 12:56:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 860E6401F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 12:56:47 -0500 (EST)
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

Some tests for the IPRIORITY registers. The significant number of bits
is IMPLEMENTATION DEFINED, but should be the same for every IRQ.
Also these registers must be byte-accessible.
Check that accesses beyond the implemented IRQ limit are actually
read-as-zero/write-ignore.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index ba2585b..a27da2c 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -327,6 +327,76 @@ static bool test_typer_v2(uint32_t reg)
 	return true;
 }
 
+#define BYTE(reg32, byte) (((reg32) >> ((byte) * 8)) & 0xff)
+#define REPLACE_BYTE(reg32, byte, new) (((reg32) & ~(0xff << ((byte) * 8))) |\
+					((new) << ((byte) * 8)))
+
+static bool test_priorities(int nr_irqs, void *priptr)
+{
+	u32 orig_prio, reg, pri_bits;
+	u32 pri_mask, pattern;
+
+	orig_prio = readl(priptr + 32);
+	report_prefix_push("IPRIORITYR");
+
+	/*
+	 * Determine implemented number of priority bits by writing all 1's
+	 * and checking the number of cleared bits in the value read back.
+	 */
+	writel(0xffffffff, priptr + 32);
+	pri_mask = readl(priptr + 32);
+
+	reg = ~pri_mask;
+	report("consistent priority masking (0x%08x)",
+	       (((reg >> 16) == (reg & 0xffff)) &&
+	        ((reg & 0xff) == ((reg >> 8) & 0xff))), pri_mask);
+
+	reg = reg & 0xff;
+	for (pri_bits = 8; reg & 1; reg >>= 1, pri_bits--)
+		;
+	report("implements at least 4 priority bits (%d)",
+	       pri_bits >= 4, pri_bits);
+
+	pattern = 0;
+	writel(pattern, priptr + 32);
+	report("clearing priorities", readl(priptr + 32) == pattern);
+
+	pattern = 0xffffffff;
+	writel(pattern, priptr + 32);
+	report("filling priorities",
+	       readl(priptr + 32) == (pattern & pri_mask));
+
+	report("accesses beyond limit RAZ/WI",
+	       test_readonly_32(priptr + nr_irqs, true));
+
+	writel(pattern, priptr + nr_irqs - 4);
+	report("accessing last SPIs",
+	       readl(priptr + nr_irqs - 4) == (pattern & pri_mask));
+
+	pattern = 0xff7fbf3f;
+	writel(pattern, priptr + 32);
+	report("priorities are preserved",
+	       readl(priptr + 32) == (pattern & pri_mask));
+
+	/*
+	 * The PRIORITY registers are byte accessible, do a byte-wide
+	 * read and write of known content to check for this.
+	 */
+	reg = readb(priptr + 33);
+	report("byte reads successful (0x%08x => 0x%02x)",
+	       reg == (BYTE(pattern, 1) & pri_mask), pattern & pri_mask, reg);
+
+	pattern = REPLACE_BYTE(pattern, 2, 0x1f);
+	writeb(BYTE(pattern, 2), priptr + 34);
+	reg = readl(priptr + 32);
+	report("byte writes successful (0x%02x => 0x%08x)",
+	       reg == (pattern & pri_mask), BYTE(pattern, 2) & pri_mask, reg);
+
+	report_prefix_pop();
+	writel(orig_prio, priptr + 32);
+	return true;
+}
+
 static int gic_test_mmio(int gic_version)
 {
 	u32 reg;
@@ -364,6 +434,8 @@ static int gic_test_mmio(int gic_version)
 	       test_readonly_32(idreg, false),
 	       reg);
 
+	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
+
 	return 0;
 }
 
-- 
2.9.0
