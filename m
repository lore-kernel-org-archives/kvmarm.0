From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v1 02/16] irqchip: gicv3-its: Add helpers for handling 52bit
 address
Date: Tue,  9 Jan 2018 19:03:57 +0000
Message-ID: <20180109190414.4017-3-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BFCA49DAD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L1yAR+vl3c6S for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 14:00:10 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0335049DB9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:10 -0500 (EST)
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add helpers for encoding/decoding 52bit address in GICv3 ITS BASER
register. When ITS uses 64K page size, the 52bits of physical address
are encoded in BASER[47:12] as follows :

 Bits[47:16] of the register => bits[47:16] of the physical address
 Bits[15:12] of the register => bits[51:48] of the physical address
                                bits[15:0] of the physical address are 0.

Also adds a mask for CBASER address. This will be used for adding 52bit
support for VGIC ITS. More importantly ignore the upper bits if 52bit
support is not enabled.

Cc: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   |  2 +-
 include/linux/irqchip/arm-gic-v3.h | 32 ++++++++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4039e64cd342..e6aa84f806f7 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1615,7 +1615,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		}
 
 		/* Convert 52bit PA to 48bit field */
-		baser_phys = GITS_BASER_PHYS_52_to_48(baser_phys);
+		baser_phys = GITS_BASER_ADDR64K_FROM_PHYS(baser_phys);
 	}
 
 retry_baser:
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c00c4c33e432..b880b6682fa6 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -320,6 +320,15 @@
 #define GITS_IIDR_REV(r)		(((r) >> GITS_IIDR_REV_SHIFT) & 0xf)
 #define GITS_IIDR_PRODUCTID_SHIFT	24
 
+#ifdef CONFIG_ARM64_PA_BITS_52
+#define GITS_PA_HI_MASK			(0xfULL)
+#define GITS_PA_SHIFT			52
+#else
+/* Do not use the bits [51-48] if we don't support 52bit */
+#define GITS_PA_HI_MASK			0
+#define GITS_PA_SHIFT			48
+#endif
+
 #define GITS_CBASER_VALID			(1ULL << 63)
 #define GITS_CBASER_SHAREABILITY_SHIFT		(10)
 #define GITS_CBASER_INNER_CACHEABILITY_SHIFT	(59)
@@ -343,6 +352,7 @@
 #define GITS_CBASER_WaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWb)
 #define GITS_CBASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
 #define GITS_CBASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWb)
+#define GITS_CBASER_ADDRESS(x)	((x) & GENMASK_ULL(GITS_PA_SHIFT, 12))
 
 #define GITS_BASER_NR_REGS		8
 
@@ -373,8 +383,26 @@
 #define GITS_BASER_ENTRY_SIZE_SHIFT		(48)
 #define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
 #define GITS_BASER_ENTRY_SIZE_MASK	GENMASK_ULL(52, 48)
-#define GITS_BASER_PHYS_52_to_48(phys)					\
-	(((phys) & GENMASK_ULL(47, 16)) | (((phys) >> 48) & 0xf) << 12)
+
+/*
+ * With 64K page size, the physical address can be upto 52bit and
+ * uses the following encoding in the GITS_BASER[47:12]:
+ *
+ * Bits[47:16] of the register => bits[47:16] of the base physical address.
+ * Bits[15:12] of the register => bits[51:48] of the base physical address.
+ *                                bits[15:0] of the base physical address are 0.
+ * Clear the upper bits if the kernel doesn't support 52bits.
+ */
+#define GITS_BASER_ADDR64K_LO_MASK	GENMASK_ULL(47, 16)
+#define GITS_BASER_ADDR64K_HI_SHIFT	12
+#define GITS_BASER_ADDR64K_HI_MOVE	(48 - GITS_BASER_ADDR64K_HI_SHIFT)
+#define GITS_BASER_ADDR64K_HI_MASK	(GITS_PA_HI_MASK << GITS_BASER_ADDR64K_HI_SHIFT)
+#define GITS_BASER_ADDR64K_TO_PHYS(x)					\
+	(((x) & GITS_BASER_ADDR64K_LO_MASK) | 				\
+	 (((x) & GITS_BASER_ADDR64K_HI_MASK) << GITS_BASER_ADDR64K_HI_MOVE))
+#define GITS_BASER_ADDR64K_FROM_PHYS(p)					\
+	(((p) & GITS_BASER_ADDR64K_LO_MASK) | 				\
+	 (((p) >> GITS_BASER_ADDR64K_HI_MOVE) & GITS_BASER_ADDR64K_HI_MASK))
 #define GITS_BASER_SHAREABILITY_SHIFT	(10)
 #define GITS_BASER_InnerShareable					\
 	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
-- 
2.13.6
