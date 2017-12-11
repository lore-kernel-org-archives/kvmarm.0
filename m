From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 18/19] arm64: KVM: Introduce EL2 VA randomisation
Date: Mon, 11 Dec 2017 14:49:36 +0000
Message-ID: <20171211144937.4537-19-marc.zyngier@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0308B49DD4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HTSCV5dwK4CH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 09:46:57 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A399349DD3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:55 -0500 (EST)
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

The main idea behind randomising the EL2 VA is that we usually have
a few spare bits between the most significant bit of the VA mask
and the most significant bit of the linear mapping.

Those bits could be a bunch of zeroes, and could be useful
to move things around a bit. Of course, the more memory you have,
the less randomisation you get...

Alternatively, these bits could be the result of KASLR, in which
case they are already random. But it would be nice to have a
*different* randomization, just to make the job of a potential
attacker a bit more difficult.

Inserting these random bits is a bit involved. We don't have a spare
register (short of rewriting all the kern_hyp_va call sites), and
the immediate we want to insert is too random to be used with the
ORR instruction. The best option I could come up with is the following
sequence:

	and x0, x0, #va_mask
	ror x0, x0, #first_random_bit
	add x0, x0, #(random & 0xfff)
	add x0, x0, #(random >> 12), lsl #12
	ror x0, x0, #(63 - first_random_bit)

making it a fairly long sequence, but one that a decent CPU should
be able to execute without breaking a sweat. It is of course NOPed
out on VHE. The last 4 instructions can also be turned into NOPs
if it appears that there is no free bits to use.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 10 +++++-
 arch/arm64/kvm/haslr.c           | 75 +++++++++++++++++++++++++++++++++++++---
 virt/kvm/arm/mmu.c               |  2 +-
 3 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index d30e83df5ccb..160444b78505 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -85,6 +85,10 @@
 .macro kern_hyp_va	reg
 alternative_cb kvm_update_va_mask
 	and     \reg, \reg, #1
+	ror	\reg, \reg, #1
+	add	\reg, \reg, #0
+	add	\reg, \reg, #0
+	ror	\reg, \reg, #63
 alternative_else_nop_endif
 .endm
 
@@ -100,7 +104,11 @@ u32 kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn);
 
 static inline unsigned long __kern_hyp_va(unsigned long v)
 {
-	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n",
+	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
+				    "ror %0, %0, #1\n"
+				    "add %0, %0, #0\n"
+				    "add %0, %0, #0\n"
+				    "ror %0, %0, #63\n",
 				    kvm_update_va_mask)
 		     : "+r" (v));
 	return v;
diff --git a/arch/arm64/kvm/haslr.c b/arch/arm64/kvm/haslr.c
index 2314bebe4883..111d8499166f 100644
--- a/arch/arm64/kvm/haslr.c
+++ b/arch/arm64/kvm/haslr.c
@@ -16,19 +16,23 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/random.h>
+#include <linux/memblock.h>
 #include <asm/alternative.h>
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
 #include <asm/kvm_mmu.h>
 
+static u8 tag_lsb;
+static u64 tag_val;
 static u64 va_mask;
 
 u32 __init kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn)
 {
 	u32 rd, rn, insn;
 
-	/* We only expect a 1 instruction sequence */
-	BUG_ON((alt->alt_len / sizeof(insn)) != 1);
+	/* We only expect a 5 instruction sequence */
+	BUG_ON((alt->alt_len / sizeof(insn)) != 5);
 
 	/* VHE doesn't need any address translation, let's NOP everything */
 	if (has_vhe())
@@ -42,8 +46,32 @@ u32 __init kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn)
 		region  = idmap_addr & BIT(VA_BITS - 1);
 		region ^= BIT(VA_BITS - 1);
 
-		va_mask  = BIT(VA_BITS - 1) - 1;
-		va_mask |= region;
+		tag_lsb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
+				(u64)(high_memory - 1));
+
+		if (tag_lsb == (VA_BITS - 1)) {
+			/*
+			 * No space in the address, let's compute the
+			 * mask so that it covers (VA_BITS - 1) bits,
+			 * and the region bit. The tag is set to zero.
+			 */
+			tag_lsb = tag_val = 0;
+			va_mask  = BIT(VA_BITS - 1) - 1;
+			va_mask |= region;
+		} else {
+			/*
+			 * We do have some free bits. Let's have the
+			 * mask to cover the low bits of the VA, and
+			 * the tag to contain the random stuff plus
+			 * the region bit.
+			 */
+			u64 mask = GENMASK_ULL(VA_BITS - 2, tag_lsb);
+
+			va_mask = BIT(tag_lsb) - 1;
+			tag_val  = get_random_long() & mask;
+			tag_val |= region;
+			tag_val >>= tag_lsb;
+		}
 	}
 
 	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
@@ -60,6 +88,45 @@ u32 __init kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn)
 							  AARCH64_INSN_VARIANT_64BIT,
 							  rn, rd, va_mask);
 		break;
+
+	case 1:
+		if (!tag_lsb)
+			return aarch64_insn_gen_nop();
+
+		/* ROR is a variant of EXTR with Rm = Rn */
+		insn = aarch64_insn_gen_extr(AARCH64_INSN_VARIANT_64BIT,
+					     rn, rn, rd,
+					     tag_lsb);
+		break;
+
+	case 2:
+		if (!tag_lsb)
+			return aarch64_insn_gen_nop();
+
+		insn = aarch64_insn_gen_add_sub_imm(rd, rn,
+						    tag_val & (SZ_4K - 1),
+						    AARCH64_INSN_VARIANT_64BIT,
+						    AARCH64_INSN_ADSB_ADD);
+		break;
+
+	case 3:
+		if (!tag_lsb)
+			return aarch64_insn_gen_nop();
+
+		insn = aarch64_insn_gen_add_sub_imm(rd, rn,
+						    tag_val & GENMASK(23, 12),
+						    AARCH64_INSN_VARIANT_64BIT,
+						    AARCH64_INSN_ADSB_ADD);
+		break;
+
+	case 4:
+		if (!tag_lsb)
+			return aarch64_insn_gen_nop();
+
+		/* ROR is a variant of EXTR with Rm = Rn */
+		insn = aarch64_insn_gen_extr(AARCH64_INSN_VARIANT_64BIT,
+					     rn, rn, rd, 64 - tag_lsb);
+		break;
 	}
 
 	BUG_ON(insn == AARCH64_BREAK_FAULT);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0597c9846f1a..6633f5f07200 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1797,7 +1797,7 @@ int kvm_mmu_init(void)
 		  kern_hyp_va((unsigned long)high_memory - 1));
 
 	if (hyp_idmap_start >= kern_hyp_va(PAGE_OFFSET) &&
-	    hyp_idmap_start <  kern_hyp_va(~0UL) &&
+	    hyp_idmap_start <  kern_hyp_va((unsigned long)high_memory - 1) &&
 	    hyp_idmap_start != (unsigned long)__hyp_idmap_text_start) {
 		/*
 		 * The idmap page is intersecting with the VA space,
-- 
2.14.2
