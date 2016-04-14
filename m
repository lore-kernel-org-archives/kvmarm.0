From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 01/17] arm64: Reuse TCR field definitions for EL1 and EL2
Date: Thu, 14 Apr 2016 14:20:49 +0100
Message-ID: <1460640065-27658-2-git-send-email-suzuki.poulose@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C700D49B8E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:19:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M+8klgXk52dv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 09:19:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80D6649B88
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:19:50 -0400 (EDT)
In-Reply-To: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

TCR_EL1, TCR_EL2 and VTCR_EL2, all share some field positions
(TG0, ORGN0, IRGN0 and SH0) and their corresponding value definitions.

This patch makes the TCR_EL1 definitions reusable and uses them for TCR_EL2
and VTCR_EL2 fields.

This also fixes a bug where we assume TG0 in {V}TCR_EL2 is 1bit field.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h       |   48 ++++++++++---------
 arch/arm64/include/asm/pgtable-hwdef.h |   80 +++++++++++++++++++++++++-------
 2 files changed, 88 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3f29887..a46b39f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -96,32 +96,34 @@
 			 SCTLR_EL2_SA | SCTLR_EL2_I)
 
 /* TCR_EL2 Registers bits */
-#define TCR_EL2_RES1	((1 << 31) | (1 << 23))
-#define TCR_EL2_TBI	(1 << 20)
-#define TCR_EL2_PS	(7 << 16)
-#define TCR_EL2_PS_40B	(2 << 16)
-#define TCR_EL2_TG0	(1 << 14)
-#define TCR_EL2_SH0	(3 << 12)
-#define TCR_EL2_ORGN0	(3 << 10)
-#define TCR_EL2_IRGN0	(3 << 8)
-#define TCR_EL2_T0SZ	0x3f
-#define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
-			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
+#define TCR_EL2_RES1		((1 << 31) | (1 << 23))
+#define TCR_EL2_TBI		(1 << 20)
+#define TCR_EL2_PS_SHIFT	16
+#define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
+#define TCR_EL2_PS_40B		(2 << TCR_EL2_PS_SHIFT)
+#define TCR_EL2_TG0_MASK	TCR_TG0_MASK
+#define TCR_EL2_SH0_MASK	TCR_SH0_MASK
+#define TCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
+#define TCR_EL2_IRGN0_MASK	TCR_IRGN0_MASK
+#define TCR_EL2_T0SZ_MASK	0x3f
+#define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
+			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK | TCR_EL2_T0SZ_MASK)
 
 /* VTCR_EL2 Registers bits */
 #define VTCR_EL2_RES1		(1 << 31)
-#define VTCR_EL2_PS_MASK	(7 << 16)
-#define VTCR_EL2_TG0_MASK	(1 << 14)
-#define VTCR_EL2_TG0_4K		(0 << 14)
-#define VTCR_EL2_TG0_64K	(1 << 14)
-#define VTCR_EL2_SH0_MASK	(3 << 12)
-#define VTCR_EL2_SH0_INNER	(3 << 12)
-#define VTCR_EL2_ORGN0_MASK	(3 << 10)
-#define VTCR_EL2_ORGN0_WBWA	(1 << 10)
-#define VTCR_EL2_IRGN0_MASK	(3 << 8)
-#define VTCR_EL2_IRGN0_WBWA	(1 << 8)
-#define VTCR_EL2_SL0_MASK	(3 << 6)
-#define VTCR_EL2_SL0_LVL1	(1 << 6)
+#define VTCR_EL2_PS_MASK	TCR_EL2_PS_MASK
+#define VTCR_EL2_TG0_MASK	TCR_TG0_MASK
+#define VTCR_EL2_TG0_4K		TCR_TG0_4K
+#define VTCR_EL2_TG0_64K	TCR_TG0_64K
+#define VTCR_EL2_SH0_MASK	TCR_SH0_MASK
+#define VTCR_EL2_SH0_INNER	TCR_SH0_INNER
+#define VTCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
+#define VTCR_EL2_ORGN0_WBWA	TCR_ORGN0_WBWA
+#define VTCR_EL2_IRGN0_MASK	TCR_IRGN0_MASK
+#define VTCR_EL2_IRGN0_WBWA	TCR_IRGN0_WBWA
+#define VTCR_EL2_SL0_SHIFT	6
+#define VTCR_EL2_SL0_MASK	(3 << VTCR_EL2_SL0_SHIFT)
+#define VTCR_EL2_SL0_LVL1	(1 << VTCR_EL2_SL0_SHIFT)
 #define VTCR_EL2_T0SZ_MASK	0x3f
 #define VTCR_EL2_T0SZ_40B	24
 #define VTCR_EL2_VS_SHIFT	19
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 5c25b83..936f173 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -208,23 +208,69 @@
 #define TCR_T1SZ(x)		((UL(64) - (x)) << TCR_T1SZ_OFFSET)
 #define TCR_TxSZ(x)		(TCR_T0SZ(x) | TCR_T1SZ(x))
 #define TCR_TxSZ_WIDTH		6
-#define TCR_IRGN_NC		((UL(0) << 8) | (UL(0) << 24))
-#define TCR_IRGN_WBWA		((UL(1) << 8) | (UL(1) << 24))
-#define TCR_IRGN_WT		((UL(2) << 8) | (UL(2) << 24))
-#define TCR_IRGN_WBnWA		((UL(3) << 8) | (UL(3) << 24))
-#define TCR_IRGN_MASK		((UL(3) << 8) | (UL(3) << 24))
-#define TCR_ORGN_NC		((UL(0) << 10) | (UL(0) << 26))
-#define TCR_ORGN_WBWA		((UL(1) << 10) | (UL(1) << 26))
-#define TCR_ORGN_WT		((UL(2) << 10) | (UL(2) << 26))
-#define TCR_ORGN_WBnWA		((UL(3) << 10) | (UL(3) << 26))
-#define TCR_ORGN_MASK		((UL(3) << 10) | (UL(3) << 26))
-#define TCR_SHARED		((UL(3) << 12) | (UL(3) << 28))
-#define TCR_TG0_4K		(UL(0) << 14)
-#define TCR_TG0_64K		(UL(1) << 14)
-#define TCR_TG0_16K		(UL(2) << 14)
-#define TCR_TG1_16K		(UL(1) << 30)
-#define TCR_TG1_4K		(UL(2) << 30)
-#define TCR_TG1_64K		(UL(3) << 30)
+
+#define TCR_IRGN0_SHIFT		8
+#define TCR_IRGN0_MASK		(UL(3) << TCR_IRGN0_SHIFT)
+#define TCR_IRGN0_NC		(UL(0) << TCR_IRGN0_SHIFT)
+#define TCR_IRGN0_WBWA		(UL(1) << TCR_IRGN0_SHIFT)
+#define TCR_IRGN0_WT		(UL(2) << TCR_IRGN0_SHIFT)
+#define TCR_IRGN0_WBnWA		(UL(3) << TCR_IRGN0_SHIFT)
+
+#define TCR_IRGN1_SHIFT		24
+#define TCR_IRGN1_MASK		(UL(3) << TCR_IRGN1_SHIFT)
+#define TCR_IRGN1_NC		(UL(0) << TCR_IRGN1_SHIFT)
+#define TCR_IRGN1_WBWA		(UL(1) << TCR_IRGN1_SHIFT)
+#define TCR_IRGN1_WT		(UL(2) << TCR_IRGN1_SHIFT)
+#define TCR_IRGN1_WBnWA		(UL(3) << TCR_IRGN1_SHIFT)
+
+#define TCR_IRGN_NC		(TCR_IRGN0_NC | TCR_IRGN1_NC)
+#define TCR_IRGN_WBWA		(TCR_IRGN0_WBWA | TCR_IRGN1_WBWA)
+#define TCR_IRGN_WT		(TCR_IRGN0_WT | TCR_IRGN1_WT)
+#define TCR_IRGN_WBnWA		(TCR_IRGN0_WBnWA | TCR_IRGN1_WBnWA)
+#define TCR_IRGN_MASK		(TCR_IRGN0_MASK | TCR_IRGN1_MASK)
+
+
+#define TCR_ORGN0_SHIFT		10
+#define TCR_ORGN0_MASK		(UL(3) << TCR_ORGN0_SHIFT)
+#define TCR_ORGN0_NC		(UL(0) << TCR_ORGN0_SHIFT)
+#define TCR_ORGN0_WBWA		(UL(1) << TCR_ORGN0_SHIFT)
+#define TCR_ORGN0_WT		(UL(2) << TCR_ORGN0_SHIFT)
+#define TCR_ORGN0_WBnWA		(UL(3) << TCR_ORGN0_SHIFT)
+
+#define TCR_ORGN1_SHIFT		26
+#define TCR_ORGN1_MASK		(UL(3) << TCR_ORGN1_SHIFT)
+#define TCR_ORGN1_NC		(UL(0) << TCR_ORGN1_SHIFT)
+#define TCR_ORGN1_WBWA		(UL(1) << TCR_ORGN1_SHIFT)
+#define TCR_ORGN1_WT		(UL(2) << TCR_ORGN1_SHIFT)
+#define TCR_ORGN1_WBnWA		(UL(3) << TCR_ORGN1_SHIFT)
+
+#define TCR_ORGN_NC		(TCR_ORGN0_NC | TCR_ORGN1_NC)
+#define TCR_ORGN_WBWA		(TCR_ORGN0_WBWA | TCR_ORGN1_WBWA)
+#define TCR_ORGN_WT		(TCR_ORGN0_WT | TCR_ORGN1_WT)
+#define TCR_ORGN_WBnWA		(TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)
+#define TCR_ORGN_MASK		(TCR_ORGN0_MASK | TCR_ORGN1_MASK)
+
+#define TCR_SH0_SHIFT		12
+#define TCR_SH0_MASK		(UL(3) << TCR_SH0_SHIFT)
+#define TCR_SH0_INNER		(UL(3) << TCR_SH0_SHIFT)
+
+#define TCR_SH1_SHIFT		28
+#define TCR_SH1_MASK		(UL(3) << TCR_SH1_SHIFT)
+#define TCR_SH1_INNER		(UL(3) << TCR_SH1_SHIFT)
+#define TCR_SHARED		(TCR_SH0_INNER | TCR_SH1_INNER)
+
+#define TCR_TG0_SHIFT		14
+#define TCR_TG0_MASK		(UL(3) << TCR_TG0_SHIFT)
+#define TCR_TG0_4K		(UL(0) << TCR_TG0_SHIFT)
+#define TCR_TG0_64K		(UL(1) << TCR_TG0_SHIFT)
+#define TCR_TG0_16K		(UL(2) << TCR_TG0_SHIFT)
+
+#define TCR_TG1_SHIFT		30
+#define TCR_TG1_MASK		(UL(3) << TCR_TG1_SHIFT)
+#define TCR_TG1_16K		(UL(1) << TCR_TG1_SHIFT)
+#define TCR_TG1_4K		(UL(2) << TCR_TG1_SHIFT)
+#define TCR_TG1_64K		(UL(3) << TCR_TG1_SHIFT)
+
 #define TCR_ASID16		(UL(1) << 36)
 #define TCR_TBI0		(UL(1) << 37)
 #define TCR_HA			(UL(1) << 39)
-- 
1.7.9.5
