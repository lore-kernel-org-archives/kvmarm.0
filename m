From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH v2 3/4] arm/arm64: GICv2: add GICD_IPRIORITYR
 testing
Date: Fri, 20 Jul 2018 16:39:41 +0100
Message-ID: <20180720153942.26821-4-andre.przywara@arm.com>
References: <20180720153942.26821-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 733AD4A0EA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:26:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W3ax79tkRGuE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jul 2018 11:26:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2835940192
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:26:48 -0400 (EDT)
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

Some tests for the IPRIORITY registers. The significant number of bits
is IMPLEMENTATION DEFINED, but should be the same for every IRQ.
Also these registers must be byte-accessible.
Check that accesses beyond the implemented IRQ limit are actually
read-as-zero/write-ignore.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 23cb9a4..57a2995 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -354,6 +354,83 @@ static void test_typer_v2(uint32_t reg)
 	       nr_gic_cpus);
 }
 
+#define BYTE(reg32, byte) (((reg32) >> ((byte) * 8)) & 0xff)
+#define REPLACE_BYTE(reg32, byte, new) (((reg32) & ~(0xff << ((byte) * 8))) |\
+					((new) << ((byte) * 8)))
+
+/*
+ * Some registers are byte accessible, do a byte-wide read and write of known
+ * content to check for this.
+ * Apply a @mask to cater for special register properties.
+ * @pattern contains the value already in the register.
+ */
+static void test_byte_access(void *base_addr, u32 pattern, u32 mask)
+{
+	u32 reg = readb(base_addr + 1);
+
+	report("byte reads successful (0x%08x => 0x%02x)",
+	       reg == (BYTE(pattern, 1) & (mask >> 8)),
+	       pattern & mask, reg);
+
+	pattern = REPLACE_BYTE(pattern, 2, 0x1f);
+	writeb(BYTE(pattern, 2), base_addr + 2);
+	reg = readl(base_addr);
+	report("byte writes successful (0x%02x => 0x%08x)",
+	       reg == (pattern & mask), BYTE(pattern, 2), reg);
+}
+
+static void test_priorities(int nr_irqs, void *priptr)
+{
+	u32 orig_prio, reg, pri_bits;
+	u32 pri_mask, pattern;
+	void *first_spi = priptr + GIC_FIRST_SPI;
+
+	orig_prio = readl(first_spi);
+	report_prefix_push("IPRIORITYR");
+
+	/*
+	 * Determine implemented number of priority bits by writing all 1's
+	 * and checking the number of cleared bits in the value read back.
+	 */
+	writel(0xffffffff, first_spi);
+	pri_mask = readl(first_spi);
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
+	writel(pattern, first_spi);
+	report("clearing priorities", readl(first_spi) == pattern);
+
+	/* setting all priorities to their max valus was tested above */
+
+	report("accesses beyond limit RAZ/WI",
+	       test_readonly_32(priptr + nr_irqs, true));
+
+	writel(pattern, priptr + nr_irqs - 4);
+	report("accessing last SPIs",
+	       readl(priptr + nr_irqs - 4) == (pattern & pri_mask));
+
+	pattern = 0xff7fbf3f;
+	writel(pattern, first_spi);
+	report("priorities are preserved",
+	       readl(first_spi) == (pattern & pri_mask));
+
+	/* The PRIORITY registers are byte accessible. */
+	test_byte_access(first_spi, pattern, pri_mask);
+
+	report_prefix_pop();
+	writel(orig_prio, first_spi);
+}
+
 static void gic_test_mmio(void)
 {
 	u32 reg;
@@ -388,6 +465,8 @@ static void gic_test_mmio(void)
 	report("ICPIDR2 is read-only (0x%08x)",
 	       test_readonly_32(idreg, false),
 	       reg);
+
+	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
 }
 
 int main(int argc, char **argv)
-- 
2.14.4
