From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 23/33] irqchip/gic-v3-its: Add VPENDBASER/VPROPBASER
 accessors
Date: Tue, 17 Jan 2017 10:20:44 +0000
Message-ID: <1484648454-21216-24-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE80440839
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yAoSXNDCFjKe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7944407F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:55 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

V{PEND,PROP}BASER being 64bit registers, they need some ad-hoc
accessors on 32bit, specially given that VPENDBASER contains
a Valid bit, making the access a bit convoluted.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/arch_gicv3.h   | 28 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/arch_gicv3.h |  5 +++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index 2747590..3f18832 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -291,5 +291,33 @@ static inline u64 __gic_readq_nonatomic(const volatile void __iomem *addr)
  */
 #define gits_write_cwriter(v, c)	__gic_writeq_nonatomic(v, c)
 
+/*
+ * GITS_VPROPBASER - hi and lo bits may be accessed independently.
+ */
+#define gits_write_vpropbaser(v, c)	__gic_writeq_nonatomic(v, c)
+
+/*
+ * GITS_VPENDBASER - the Valid bit must be cleared before changing
+ * anything else.
+ */
+static inline void gits_write_vpendbaser(u64 val, void * __iomem addr)
+{
+	u32 tmp;
+
+	tmp = readl_relaxed(addr + 4);
+	if (tmp & GICR_PENDBASER_Valid) {
+		tmp &= ~GICR_PENDBASER_Valid;
+		writel_relaxed(tmp, addr + 4);
+	}
+
+	/*
+	 * Use the fact that __gic_writeq_nonatomic writes the second
+	 * half of the 64bit quantity after the first.
+	 */
+	__gic_writeq_nonatomic(val, addr);
+}
+
+#define gits_read_vpendbaser(c)		__gic_readq_nonatomic(c)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* !__ASM_ARCH_GICV3_H */
diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index f37e3a2..9420b7a 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -188,5 +188,10 @@ static inline void gic_write_bpr1(u32 val)
 #define gicr_write_pendbaser(v, c)	writeq_relaxed(v, c)
 #define gicr_read_pendbaser(c)		readq_relaxed(c)
 
+#define gits_write_vpropbaser(v, c)	writeq_relaxed(v, c)
+
+#define gits_write_vpendbaser(v, c)	writeq_relaxed(v, c)
+#define gits_read_vpendbaser(c)		readq_relaxed(c)
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_ARCH_GICV3_H */
-- 
2.1.4
