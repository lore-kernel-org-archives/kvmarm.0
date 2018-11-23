From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 4/8] arm64: Add TCR_EPD{0,1} definitions
Date: Fri, 23 Nov 2018 18:41:03 +0000
Message-ID: <20181123184107.39334-5-marc.zyngier@arm.com>
References: <20181123184107.39334-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7C44A323
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 13:41:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zsDQ4O8JwOsK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Nov 2018 13:41:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC4334A332
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 13:41:23 -0500 (EST)
In-Reply-To: <20181123184107.39334-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We are soon going to play with TCR_EL1.EPD{0,1}, so let's add the
relevant definitions.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 1d7d8da2ef9b..a7d5d6e459eb 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -224,6 +224,8 @@
 #define TCR_TxSZ_WIDTH		6
 #define TCR_T0SZ_MASK		(((UL(1) << TCR_TxSZ_WIDTH) - 1) << TCR_T0SZ_OFFSET)
 
+#define TCR_EPD0_SHIFT		7
+#define TCR_EPD0_MASK		(UL(1) << TCR_EPD0_SHIFT)
 #define TCR_IRGN0_SHIFT		8
 #define TCR_IRGN0_MASK		(UL(3) << TCR_IRGN0_SHIFT)
 #define TCR_IRGN0_NC		(UL(0) << TCR_IRGN0_SHIFT)
@@ -231,6 +233,8 @@
 #define TCR_IRGN0_WT		(UL(2) << TCR_IRGN0_SHIFT)
 #define TCR_IRGN0_WBnWA		(UL(3) << TCR_IRGN0_SHIFT)
 
+#define TCR_EPD1_SHIFT		23
+#define TCR_EPD1_MASK		(UL(1) << TCR_EPD1_SHIFT)
 #define TCR_IRGN1_SHIFT		24
 #define TCR_IRGN1_MASK		(UL(3) << TCR_IRGN1_SHIFT)
 #define TCR_IRGN1_NC		(UL(0) << TCR_IRGN1_SHIFT)
-- 
2.19.1
