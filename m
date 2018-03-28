From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 68/85] arm64: KVM: Dynamically compute the HYP VA mask
Date: Wed, 28 Mar 2018 13:52:37 +0100
Message-ID: <20180328125254.31380-69-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B884D4A0C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:59:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jKuhUpQfSho1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:59:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7444A0E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:37 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we're moving towards a much more dynamic way to compute our
HYP VA, let's express the mask in a slightly different way.

Instead of comparing the idmap position to the "low" VA mask,
we directly compute the mask by taking into account the idmap's
(VA_BIT-1) bit.

No functionnal change.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/va_layout.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 0d7bf8319894..7998d1a60916 100644
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
+	u64 hyp_va_msb;
 
-	/*
-	 * Activate the lower HYP offset only if the idmap doesn't
-	 * clash with it,
-	 */
-	if (idmap_addr > HYP_PAGE_OFFSET_LOW_MASK)
-		mask = HYP_PAGE_OFFSET_LOW_MASK;
+	/* Where is my RAM region? */
+	hyp_va_msb  = idmap_addr & BIT(VA_BITS - 1);
+	hyp_va_msb ^= BIT(VA_BITS - 1);
 
-	va_mask = mask;
+	va_mask  = GENMASK_ULL(VA_BITS - 2, 0);
+	va_mask |= hyp_va_msb;
 }
 
 static u32 compute_instruction(int n, u32 rd, u32 rn)
-- 
2.14.2
