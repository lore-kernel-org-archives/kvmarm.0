From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 19/23] arm64: KVM: Allow far branches from vector slots to
 the main vectors
Date: Thu,  1 Mar 2018 15:55:34 +0000
Message-ID: <20180301155538.26860-20-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 495C949E95
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:51:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4NfsgSqdw+nv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:51:13 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 109C949F73
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:26 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
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

So far, the branch from the vector slots to the main vectors can at
most be 4GB from the main vectors (the reach of ADRP), and this
distance is known at compile time. If we were to remap the slots
to an unrelated VA, things would break badly.

A way to achieve VA independence would be to load the absolute
address of the vectors (__kvm_hyp_vector), either using a constant
pool or a series of movs, followed by an indirect branch.

This patches implements the latter solution, using another instance
of a patching callback.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/bpi.S    | 11 ++++++++++-
 arch/arm64/kvm/va_layout.c | 27 +++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index e000cb390618..e8d997788ad0 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -19,6 +19,9 @@
 #include <linux/linkage.h>
 #include <linux/arm-smccc.h>
 
+#include <asm/alternative.h>
+#include <asm/kvm_mmu.h>
+
 .macro hyp_ventry offset
 	.align 7
 	.rept 29
@@ -64,9 +67,15 @@ ENTRY(__bp_harden_hyp_vecs_start)
 	.endr
 
 __kvm_enter_vectors:
+alternative_cb	kvm_patch_vector_branch
+	movz	x1, #0
+	movk	x1, #0, lsl #16
+	movk	x1, #0, lsl #32
+	movk	x1, #0, lsl #48
+alternative_cb_end
 
-	adr_l	x1, __kvm_hyp_vector
 	add	x0, x1, x0
+	kern_hyp_va x0
 	br	x0
 ENTRY(__bp_harden_hyp_vecs_end)
 
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index a73e47804972..7ef3d920c8d4 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -152,3 +152,30 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
 		updptr[i] = cpu_to_le32(insn);
 	}
 }
+
+void kvm_patch_vector_branch(struct alt_instr *alt,
+			     __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	enum aarch64_insn_movewide_type type;
+	u64 addr;
+	u32 oinsn, rd;
+	int s;
+
+	BUG_ON(nr_inst != 4);
+
+	addr = (uintptr_t)kvm_ksym_ref(__kvm_hyp_vector);
+	oinsn = le32_to_cpu(origptr[0]);
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
+
+	type = AARCH64_INSN_MOVEWIDE_ZERO;
+	for (s = 0; nr_inst--; s += 16) {
+		u32 insn = aarch64_insn_gen_movewide(rd,
+						     (u16)(addr >> s),
+						     s,
+						     AARCH64_INSN_VARIANT_64BIT,
+						     type);
+		*updptr++ = cpu_to_le32(insn);
+		type = AARCH64_INSN_MOVEWIDE_KEEP;
+	}
+
+}
-- 
2.14.2
