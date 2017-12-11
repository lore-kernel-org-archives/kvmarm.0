From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 17/19] arm64: KVM: Dynamically compute the HYP VA mask
Date: Mon, 11 Dec 2017 14:49:35 +0000
Message-ID: <20171211144937.4537-18-marc.zyngier@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 342EA49DD8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:47:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ud+6TReak77i for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 09:46:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB32C49DE6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:53 -0500 (EST)
In-Reply-To: <20171211144937.4537-1-marc.zyngier@arm.com>
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
 arch/arm64/kvm/haslr.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/haslr.c b/arch/arm64/kvm/haslr.c
index 5e1643a4e7bf..2314bebe4883 100644
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
 	BUG_ON((alt->alt_len / sizeof(insn)) != 1);
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
