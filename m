From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 08/19] arm64: KVM: Dynamically patch the kernel/hyp VA mask
Date: Mon, 18 Dec 2017 17:39:15 +0000
Message-ID: <20171218173926.16911-9-marc.zyngier@arm.com>
References: <20171218173926.16911-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171218173926.16911-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

So far, we're using a complicated sequence of alternatives to
patch the kernel/hyp VA mask on non-VHE, and NOP out the
masking altogether when on VHE.

THe newly introduced dynamic patching gives us the opportunity
to simplify that code by patching a single instruction with
the correct mask (instead of the mind bending cummulative masking
we have at the moment) or even a single NOP on VHE.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 44 ++++++------------------
 arch/arm64/kvm/Makefile          |  2 +-
 arch/arm64/kvm/haslr.c           | 74 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 34 deletions(-)
 create mode 100644 arch/arm64/kvm/haslr.c

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 672c8684d5c2..9545d12ce822 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -69,9 +69,6 @@
  * mappings, and none of this applies in that case.
  */
 
-#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
-#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
-
 #ifdef __ASSEMBLY__
 
 #include <asm/alternative.h>
@@ -81,28 +78,14 @@
  * Convert a kernel VA into a HYP VA.
  * reg: VA to be converted.
  *
- * This generates the following sequences:
- * - High mask:
- *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
- *		nop
- * - Low mask:
- *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
- *		and x0, x0, #HYP_PAGE_OFFSET_LOW_MASK
- * - VHE:
- *		nop
- *		nop
- *
- * The "low mask" version works because the mask is a strict subset of
- * the "high mask", hence performing the first mask for nothing.
- * Should be completely invisible on any viable CPU.
+ * The actual code generation takes place in kvm_update_va_mask, and
+ * the instructions below are only there to reserve the space and
+ * perform the register allocation.
  */
 .macro kern_hyp_va	reg
-alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	and     \reg, \reg, #HYP_PAGE_OFFSET_HIGH_MASK
-alternative_else_nop_endif
-alternative_if ARM64_HYP_OFFSET_LOW
-	and     \reg, \reg, #HYP_PAGE_OFFSET_LOW_MASK
-alternative_else_nop_endif
+alternative_cb kvm_update_va_mask
+	and     \reg, \reg, #1
+alternative_cb_end
 .endm
 
 #else
@@ -113,18 +96,13 @@ alternative_else_nop_endif
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 
+u32 kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn);
+
 static inline unsigned long __kern_hyp_va(unsigned long v)
 {
-	asm volatile(ALTERNATIVE("and %0, %0, %1",
-				 "nop",
-				 ARM64_HAS_VIRT_HOST_EXTN)
-		     : "+r" (v)
-		     : "i" (HYP_PAGE_OFFSET_HIGH_MASK));
-	asm volatile(ALTERNATIVE("nop",
-				 "and %0, %0, %1",
-				 ARM64_HYP_OFFSET_LOW)
-		     : "+r" (v)
-		     : "i" (HYP_PAGE_OFFSET_LOW_MASK));
+	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n",
+				    kvm_update_va_mask)
+		     : "+r" (v));
 	return v;
 }
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 87c4f7ae24de..baba030ee29e 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/e
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o
+kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o haslr.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
 kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o
diff --git a/arch/arm64/kvm/haslr.c b/arch/arm64/kvm/haslr.c
new file mode 100644
index 000000000000..94475ea9847b
--- /dev/null
+++ b/arch/arm64/kvm/haslr.c
@@ -0,0 +1,74 @@
+/*
+ * Copyright (C) 2017 ARM Ltd.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/alternative.h>
+#include <asm/debug-monitors.h>
+#include <asm/insn.h>
+#include <asm/kvm_mmu.h>
+
+#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
+#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
+
+static unsigned long get_hyp_va_mask(void)
+{
+	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
+	unsigned long mask = HYP_PAGE_OFFSET_HIGH_MASK;
+
+	/*
+	 * Activate the lower HYP offset only if the idmap doesn't
+	 * clash with it,
+	 */
+	if (idmap_addr > HYP_PAGE_OFFSET_LOW_MASK)
+		mask = HYP_PAGE_OFFSET_HIGH_MASK;
+
+	return mask;
+}
+
+u32 __init kvm_update_va_mask(struct alt_instr *alt, int index, u32 oinsn)
+{
+	u32 rd, rn, insn;
+	u64 imm;
+
+	/* We only expect a 1 instruction sequence */
+	BUG_ON((alt->orig_len / sizeof(insn)) != 1);
+
+	/* VHE doesn't need any address translation, let's NOP everything */
+	if (has_vhe())
+		return aarch64_insn_gen_nop();
+
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
+	rn = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, oinsn);
+
+	switch (index) {
+	default:
+		/* Something went wrong... */
+		insn = AARCH64_BREAK_FAULT;
+		break;
+
+	case 0:
+		imm = get_hyp_va_mask();
+		insn = aarch64_insn_gen_logical_immediate(AARCH64_INSN_LOGIC_AND,
+							  AARCH64_INSN_VARIANT_64BIT,
+							  rn, rd, imm);
+		break;
+	}
+
+	BUG_ON(insn == AARCH64_BREAK_FAULT);
+
+	return insn;
+}
-- 
2.14.2
