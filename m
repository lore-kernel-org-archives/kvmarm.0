From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 17/19] arm64: KVM: Dynamically compute the HYP VA mask
Date: Thu,  4 Jan 2018 18:43:32 +0000
Message-ID: <20180104184334.16571-18-marc.zyngier@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0175D49DB7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:39:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VvuFPmln-9r3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jan 2018 13:39:55 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F04CE49D9D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:39:54 -0500 (EST)
In-Reply-To: <20180104184334.16571-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we're moving towards a much more dynamic way to compute our
HYP VA, let's express the mask in a slightly different way.

Instead of comparing the idmap position to the "low" VA mask,
we directly compute the mask by taking into account the idmap's
(VA_BIT-1) bit.

No functionnal change.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/va_layout.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index aee758574e61..75bb1c6772b0 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -21,24 +21,19 @@
 #include <asm/insn.h>
 #include <asm/kvm_mmu.h>
 
-#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
-#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
-
 static u64 va_mask;
 
 static void compute_layout(void)
 {
 	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
-	unsigned long mask = HYP_PAGE_OFFSET_HIGH_MASK;
+	u64 region;
 
-	/*
-	 * Activate the lower HYP offset only if the idmap doesn't
-	 * clash with it,
-	 */
-	if (idmap_addr > HYP_PAGE_OFFSET_LOW_MASK)
-		mask = HYP_PAGE_OFFSET_HIGH_MASK;
+	/* Where is my RAM region? */
+	region  = idmap_addr & BIT(VA_BITS - 1);
+	region ^= BIT(VA_BITS - 1);
 
-	va_mask = mask;
+	va_mask  = BIT(VA_BITS - 1) - 1;
+	va_mask |= region;
 }
 
 static u32 compute_instruction(int n, u32 rd, u32 rn)
-- 
2.14.2
