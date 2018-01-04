From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 18/19] arm64: KVM: Introduce EL2 VA randomisation
Date: Thu,  4 Jan 2018 18:43:33 +0000
Message-ID: <20180104184334.16571-19-marc.zyngier@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180104184334.16571-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
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
 arch/arm64/kvm/va_layout.c       | 68 +++++++++++++++++++++++++++++++++++++---
 virt/kvm/arm/mmu.c               |  2 +-
 3 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index cc882e890bb1..4fca6ddadccc 100644
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
 alternative_cb_end
 .endm
 
@@ -101,7 +105,11 @@ void kvm_update_va_mask(struct alt_instr *alt,
 
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
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 75bb1c6772b0..bf0d6bdf5f14 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -16,11 +16,15 @@
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
 
 static void compute_layout(void)
@@ -32,8 +36,31 @@ static void compute_layout(void)
 	region  = idmap_addr & BIT(VA_BITS - 1);
 	region ^= BIT(VA_BITS - 1);
 
-	va_mask  = BIT(VA_BITS - 1) - 1;
-	va_mask |= region;
+	tag_lsb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
+			(u64)(high_memory - 1));
+
+	if (tag_lsb == (VA_BITS - 1)) {
+		/*
+		 * No space in the address, let's compute the mask so
+		 * that it covers (VA_BITS - 1) bits, and the region
+		 * bit. The tag is set to zero.
+		 */
+		tag_lsb = tag_val = 0;
+		va_mask  = BIT(VA_BITS - 1) - 1;
+		va_mask |= region;
+	} else {
+		/*
+		 * We do have some free bits. Let's have the mask to
+		 * cover the low bits of the VA, and the tag to
+		 * contain the random stuff plus the region bit.
+		 */
+		u64 mask = GENMASK_ULL(VA_BITS - 2, tag_lsb);
+
+		va_mask = BIT(tag_lsb) - 1;
+		tag_val  = get_random_long() & mask;
+		tag_val |= region;
+		tag_val >>= tag_lsb;
+	}
 }
 
 static u32 compute_instruction(int n, u32 rd, u32 rn)
@@ -46,6 +73,33 @@ static u32 compute_instruction(int n, u32 rd, u32 rn)
 							  AARCH64_INSN_VARIANT_64BIT,
 							  rn, rd, va_mask);
 		break;
+
+	case 1:
+		/* ROR is a variant of EXTR with Rm = Rn */
+		insn = aarch64_insn_gen_extr(AARCH64_INSN_VARIANT_64BIT,
+					     rn, rn, rd,
+					     tag_lsb);
+		break;
+
+	case 2:
+		insn = aarch64_insn_gen_add_sub_imm(rd, rn,
+						    tag_val & (SZ_4K - 1),
+						    AARCH64_INSN_VARIANT_64BIT,
+						    AARCH64_INSN_ADSB_ADD);
+		break;
+
+	case 3:
+		insn = aarch64_insn_gen_add_sub_imm(rd, rn,
+						    tag_val & GENMASK(23, 12),
+						    AARCH64_INSN_VARIANT_64BIT,
+						    AARCH64_INSN_ADSB_ADD);
+		break;
+
+	case 4:
+		/* ROR is a variant of EXTR with Rm = Rn */
+		insn = aarch64_insn_gen_extr(AARCH64_INSN_VARIANT_64BIT,
+					     rn, rn, rd, 64 - tag_lsb);
+		break;
 	}
 
 	return insn;
@@ -56,8 +110,8 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
 {
 	int i;
 
-	/* We only expect a 1 instruction sequence */
-	BUG_ON(nr_inst != 1);
+	/* We only expect a 5 instruction sequence */
+	BUG_ON(nr_inst != 5);
 
 	if (!has_vhe() && !va_mask)
 		compute_layout();
@@ -68,8 +122,12 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
 		/*
 		 * VHE doesn't need any address translation, let's NOP
 		 * everything.
+		 *
+		 * Alternatively, if we don't have any spare bits in
+		 * the address, NOP everything after masking tha
+		 * kernel VA.
 		 */
-		if (has_vhe()) {
+		if (has_vhe() || (!tag_lsb && i > 1)) {
 			updptr[i] = aarch64_insn_gen_nop();
 			continue;
 		}
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 14c5e5534f2f..d01c7111b1f7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1811,7 +1811,7 @@ int kvm_mmu_init(void)
 		  kern_hyp_va((unsigned long)high_memory - 1));
 
 	if (hyp_idmap_start >= kern_hyp_va(PAGE_OFFSET) &&
-	    hyp_idmap_start <  kern_hyp_va(~0UL) &&
+	    hyp_idmap_start <  kern_hyp_va((unsigned long)high_memory - 1) &&
 	    hyp_idmap_start != (unsigned long)__hyp_idmap_text_start) {
 		/*
 		 * The idmap page is intersecting with the VA space,
-- 
2.14.2
