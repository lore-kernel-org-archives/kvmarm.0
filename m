From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 17/19] arm64: KVM: Dynamically compute the HYP VA mask
Date: Mon, 18 Dec 2017 17:39:24 +0000
Message-ID: <20171218173926.16911-18-marc.zyngier@arm.com>
References: <20171218173926.16911-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171218173926.16911-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we're moving towards a much more dynamic way to compute our
HYP VA, let's express the mask in a slightly different way.

Instead of comparing the idmap position to the "low" VA mask,
we directly compute the mask by taking into account the idmap's
(VA_BIT-1) bit.

No functionnal change.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/haslr.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/haslr.c b/arch/arm64/kvm/haslr.c
index 94475ea9847b..2c865d1c1344 100644
--- a/arch/arm64/kvm/haslr.c
+++ b/arch/arm64/kvm/haslr.c
@@ -21,28 +21,11 @@
 #include <asm/insn.h>
 #include <asm/kvm_mmu.h>
 
-#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
-#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
-
-static unsigned long get_hyp_va_mask(void)
-{
-	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
-	unsigned long mask = HYP_PAGE_OFFSET_HIGH_MASK;
-
-	/*
-	 * Activate the lower HYP offset only if the idmap doesn't
-	 * clash with it,
-	 */
-	if (idmap_addr > HYP_PAGE_OFFSET_LOW_MASK)
-		mask = HYP_PAGE_OFFSET_HIGH_MASK;
-
-	return mask;
-}
+static u64 va_mask;
 
 u32 __init kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn)
 {
 	u32 rd, rn, insn;
-	u64 imm;
 
 	/* We only expect a 1 instruction sequence */
 	BUG_ON((alt->orig_len / sizeof(insn)) != 1);
@@ -51,6 +34,18 @@ u32 __init kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn)
 	if (has_vhe())
 		return aarch64_insn_gen_nop();
 
+	if (!va_mask) {
+		phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
+		u64 region;
+
+		/* Where is my RAM region? */
+		region  = idmap_addr & BIT(VA_BITS - 1);
+		region ^= BIT(VA_BITS - 1);
+
+		va_mask  = BIT(VA_BITS - 1) - 1;
+		va_mask |= region;
+	}
+
 	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
 	rn = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, oinsn);
 
@@ -61,10 +56,9 @@ u32 __init kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn)
 		break;
 
 	case 0:
-		imm = get_hyp_va_mask();
 		insn = aarch64_insn_gen_logical_immediate(AARCH64_INSN_LOGIC_AND,
 							  AARCH64_INSN_VARIANT_64BIT,
-							  rn, rd, imm);
+							  rn, rd, va_mask);
 		break;
 	}
 
-- 
2.14.2
