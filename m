From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 75/85] arm64: KVM: Allow far branches from vector slots to the
 main vectors
Date: Wed, 28 Mar 2018 13:52:44 +0100
Message-ID: <20180328125254.31380-76-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4465940357
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:01:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OsewYW9vZocc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 09:00:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 738064A079
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:06 -0400 (EDT)
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

So far, the branch from the vector slots to the main vectors can at
most be 4GB from the main vectors (the reach of ADRP), and this
distance is known at compile time. If we were to remap the slots
to an unrelated VA, things would break badly.

A way to achieve VA independence would be to load the absolute
address of the vectors (__kvm_hyp_vector), either using a constant
pool or a series of movs, followed by an indirect branch.

This patches implements the latter solution, using another instance
of a patching callback. Note that since we have to save a register
pair on the stack, we branch to the *second* instruction in the
vectors in order to compensate for it. This also results in having
to adjust this balance in the invalid vector entry point.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  2 +-
 arch/arm64/kernel/bpi.S          | 21 ++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S   |  2 ++
 arch/arm64/kvm/va_layout.c       | 72 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 76a43a17449a..d4cc54ed0656 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -32,7 +32,7 @@
 #define ARM64_HAS_VIRT_HOST_EXTN		11
 #define ARM64_WORKAROUND_CAVIUM_27456		12
 #define ARM64_HAS_32BIT_EL0			13
-/* #define ARM64_UNALLOCATED_ENTRY			14 */
+#define ARM64_HARDEN_EL2_VECTORS		14
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
 #define ARM64_HAS_NO_FPSIMD			16
 #define ARM64_WORKAROUND_REPEAT_TLBI		17
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index ce1cfe3b24e6..dc51ef2ce98a 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -19,16 +19,37 @@
 #include <linux/linkage.h>
 #include <linux/arm-smccc.h>
 
+#include <asm/alternative.h>
+
 .macro hyp_ventry
 	.align 7
 1:	.rept 27
 	nop
 	.endr
+/*
+ * The default sequence is to directly branch to the KVM vectors,
+ * using the computed offset. This applies for VHE as well as
+ * !ARM64_HARDEN_EL2_VECTORS.
+ *
+ * For ARM64_HARDEN_EL2_VECTORS configurations, this gets replaced
+ * with:
+ *
+ * stp	x0, x1, [sp, #-16]!
+ * movz	x0, #(addr & 0xffff)
+ * movk	x0, #((addr >> 16) & 0xffff), lsl #16
+ * movk	x0, #((addr >> 32) & 0xffff), lsl #32
+ * br	x0
+ *
+ * Where addr = kern_hyp_va(__kvm_hyp_vector) + vector-offset + 4.
+ * See kvm_patch_vector_branch for details.
+ */
+alternative_cb	kvm_patch_vector_branch
 	b	__kvm_hyp_vector + (1b - 0b)
 	nop
 	nop
 	nop
 	nop
+alternative_cb_end
 .endm
 
 .macro generate_vectors
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 8359fed89098..87dfecce82b1 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -212,6 +212,8 @@ ENDPROC(\label)
 .macro invalid_vect target
 	.align 7
 	b	\target
+	ldp	x0, x1, [sp], #16
+	b	\target
 .endm
 
 ENTRY(__kvm_hyp_vector)
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 3d41a480b6a5..2deb6e9874c9 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -150,3 +150,75 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
 		updptr[i] = cpu_to_le32(insn);
 	}
 }
+
+void kvm_patch_vector_branch(struct alt_instr *alt,
+			     __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u64 addr;
+	u32 insn;
+
+	BUG_ON(nr_inst != 5);
+
+	if (has_vhe() || !cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
+		WARN_ON_ONCE(cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS));
+		return;
+	}
+
+	if (!va_mask)
+		compute_layout();
+
+	/*
+	 * Compute HYP VA by using the same computation as kern_hyp_va()
+	 */
+	addr = (uintptr_t)kvm_ksym_ref(__kvm_hyp_vector);
+	addr &= va_mask;
+	addr |= tag_val << tag_lsb;
+
+	/* Use PC[10:7] to branch to the same vector in KVM */
+	addr |= ((u64)origptr & GENMASK_ULL(10, 7));
+
+	/*
+	 * Branch to the second instruction in the vectors in order to
+	 * avoid the initial store on the stack (which we already
+	 * perform in the hardening vectors).
+	 */
+	addr += AARCH64_INSN_SIZE;
+
+	/* stp x0, x1, [sp, #-16]! */
+	insn = aarch64_insn_gen_load_store_pair(AARCH64_INSN_REG_0,
+						AARCH64_INSN_REG_1,
+						AARCH64_INSN_REG_SP,
+						-16,
+						AARCH64_INSN_VARIANT_64BIT,
+						AARCH64_INSN_LDST_STORE_PAIR_PRE_INDEX);
+	*updptr++ = cpu_to_le32(insn);
+
+	/* movz x0, #(addr & 0xffff) */
+	insn = aarch64_insn_gen_movewide(AARCH64_INSN_REG_0,
+					 (u16)addr,
+					 0,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_ZERO);
+	*updptr++ = cpu_to_le32(insn);
+
+	/* movk x0, #((addr >> 16) & 0xffff), lsl #16 */
+	insn = aarch64_insn_gen_movewide(AARCH64_INSN_REG_0,
+					 (u16)(addr >> 16),
+					 16,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_KEEP);
+	*updptr++ = cpu_to_le32(insn);
+
+	/* movk x0, #((addr >> 32) & 0xffff), lsl #32 */
+	insn = aarch64_insn_gen_movewide(AARCH64_INSN_REG_0,
+					 (u16)(addr >> 32),
+					 32,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_KEEP);
+	*updptr++ = cpu_to_le32(insn);
+
+	/* br x0 */
+	insn = aarch64_insn_gen_branch_reg(AARCH64_INSN_REG_0,
+					   AARCH64_INSN_BRANCH_NOLINK);
+	*updptr++ = cpu_to_le32(insn);
+}
-- 
2.14.2
