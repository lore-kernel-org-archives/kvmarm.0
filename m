From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 05/95] ARM: KVM: Move CP15 array into the CPU context structure
Date: Wed,  9 Mar 2016 07:29:59 +0000
Message-ID: <1457508689-19672-6-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A248412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YvrK-FxyYKVv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:31:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 972914998D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:31:59 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Continuing our rework of the CPU context, we now move the CP15
array into the CPU context structure. As this causes quite a bit
of churn, we introduce the vcpu_cp15() macro that abstract the
location of the actual array. This will probably help next time
we have to revisit that code.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h |  2 +-
 arch/arm/include/asm/kvm_host.h    |  6 +++---
 arch/arm/include/asm/kvm_mmu.h     |  2 +-
 arch/arm/kernel/asm-offsets.c      |  2 +-
 arch/arm/kvm/coproc.c              | 32 ++++++++++++++++----------------
 arch/arm/kvm/coproc.h              | 16 ++++++++--------
 arch/arm/kvm/emulate.c             | 22 +++++++++++-----------
 arch/arm/kvm/interrupts_head.S     |  3 ++-
 8 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 3095df0..32bb52a 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -192,7 +192,7 @@ static inline u32 kvm_vcpu_hvc_get_imm(struct kvm_vcpu *vcpu)
 
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.cp15[c0_MPIDR] & MPIDR_HWID_BITMASK;
+	return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK;
 }
 
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index b64ac8e..4203701 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -90,6 +90,7 @@ struct kvm_vcpu_fault_info {
 
 struct kvm_cpu_context {
 	struct vfp_hard_struct vfp;
+	u32 cp15[NR_CP15_REGS];
 };
 
 typedef struct kvm_cpu_context kvm_cpu_context_t;
@@ -102,9 +103,6 @@ struct kvm_vcpu_arch {
 	int target; /* Processor target */
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
 
-	/* System control coprocessor (cp15) */
-	u32 cp15[NR_CP15_REGS];
-
 	/* The CPU type we expose to the VM */
 	u32 midr;
 
@@ -161,6 +159,8 @@ struct kvm_vcpu_stat {
 	u64 exits;
 };
 
+#define vcpu_cp15(v,r)	(v)->arch.ctxt.cp15[r]
+
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index a520b79..da44be9 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -179,7 +179,7 @@ struct kvm;
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
-	return (vcpu->arch.cp15[c1_SCTLR] & 0b101) == 0b101;
+	return (vcpu_cp15(vcpu, c1_SCTLR) & 0b101) == 0b101;
 }
 
 static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 346bfca..43f8b01 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -172,10 +172,10 @@ int main(void)
 #ifdef CONFIG_KVM_ARM_HOST
   DEFINE(VCPU_KVM,		offsetof(struct kvm_vcpu, kvm));
   DEFINE(VCPU_MIDR,		offsetof(struct kvm_vcpu, arch.midr));
-  DEFINE(VCPU_CP15,		offsetof(struct kvm_vcpu, arch.cp15));
   DEFINE(VCPU_GUEST_CTXT,	offsetof(struct kvm_vcpu, arch.ctxt));
   DEFINE(VCPU_HOST_CTXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
   DEFINE(CPU_CTXT_VFP,		offsetof(struct kvm_cpu_context, vfp));
+  DEFINE(CPU_CTXT_CP15,		offsetof(struct kvm_cpu_context, cp15));
   DEFINE(VCPU_REGS,		offsetof(struct kvm_vcpu, arch.regs));
   DEFINE(VCPU_USR_REGS,		offsetof(struct kvm_vcpu, arch.regs.usr_regs));
   DEFINE(VCPU_SVC_REGS,		offsetof(struct kvm_vcpu, arch.regs.svc_regs));
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 1a643f3..e3e86c4 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -54,8 +54,8 @@ static inline void vcpu_cp15_reg64_set(struct kvm_vcpu *vcpu,
 				       const struct coproc_reg *r,
 				       u64 val)
 {
-	vcpu->arch.cp15[r->reg] = val & 0xffffffff;
-	vcpu->arch.cp15[r->reg + 1] = val >> 32;
+	vcpu_cp15(vcpu, r->reg) = val & 0xffffffff;
+	vcpu_cp15(vcpu, r->reg + 1) = val >> 32;
 }
 
 static inline u64 vcpu_cp15_reg64_get(struct kvm_vcpu *vcpu,
@@ -63,9 +63,9 @@ static inline u64 vcpu_cp15_reg64_get(struct kvm_vcpu *vcpu,
 {
 	u64 val;
 
-	val = vcpu->arch.cp15[r->reg + 1];
+	val = vcpu_cp15(vcpu, r->reg + 1);
 	val = val << 32;
-	val = val | vcpu->arch.cp15[r->reg];
+	val = val | vcpu_cp15(vcpu, r->reg);
 	return val;
 }
 
@@ -104,7 +104,7 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
 	 * vcpu_id, but we read the 'U' bit from the underlying
 	 * hardware directly.
 	 */
-	vcpu->arch.cp15[c0_MPIDR] = ((read_cpuid_mpidr() & MPIDR_SMP_BITMASK) |
+	vcpu_cp15(vcpu, c0_MPIDR) = ((read_cpuid_mpidr() & MPIDR_SMP_BITMASK) |
 				     ((vcpu->vcpu_id >> 2) << MPIDR_LEVEL_BITS) |
 				     (vcpu->vcpu_id & 3));
 }
@@ -117,7 +117,7 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
-	*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp15[c1_ACTLR];
+	*vcpu_reg(vcpu, p->Rt1) = vcpu_cp15(vcpu, c1_ACTLR);
 	return true;
 }
 
@@ -139,7 +139,7 @@ static bool access_l2ctlr(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
-	*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp15[c9_L2CTLR];
+	*vcpu_reg(vcpu, p->Rt1) = vcpu_cp15(vcpu, c9_L2CTLR);
 	return true;
 }
 
@@ -156,7 +156,7 @@ static void reset_l2ctlr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
 	ncores = min(ncores, 3U);
 	l2ctlr |= (ncores & 3) << 24;
 
-	vcpu->arch.cp15[c9_L2CTLR] = l2ctlr;
+	vcpu_cp15(vcpu, c9_L2CTLR) = l2ctlr;
 }
 
 static void reset_actlr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
@@ -171,7 +171,7 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
 	else
 		actlr &= ~(1U << 6);
 
-	vcpu->arch.cp15[c1_ACTLR] = actlr;
+	vcpu_cp15(vcpu, c1_ACTLR) = actlr;
 }
 
 /*
@@ -218,9 +218,9 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
 
 	BUG_ON(!p->is_write);
 
-	vcpu->arch.cp15[r->reg] = *vcpu_reg(vcpu, p->Rt1);
+	vcpu_cp15(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt1);
 	if (p->is_64bit)
-		vcpu->arch.cp15[r->reg + 1] = *vcpu_reg(vcpu, p->Rt2);
+		vcpu_cp15(vcpu, r->reg + 1) = *vcpu_reg(vcpu, p->Rt2);
 
 	kvm_toggle_cache(vcpu, was_enabled);
 	return true;
@@ -1030,7 +1030,7 @@ int kvm_arm_coproc_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		val = vcpu_cp15_reg64_get(vcpu, r);
 		ret = reg_to_user(uaddr, &val, reg->id);
 	} else if (KVM_REG_SIZE(reg->id) == 4) {
-		ret = reg_to_user(uaddr, &vcpu->arch.cp15[r->reg], reg->id);
+		ret = reg_to_user(uaddr, &vcpu_cp15(vcpu, r->reg), reg->id);
 	}
 
 	return ret;
@@ -1060,7 +1060,7 @@ int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (!ret)
 			vcpu_cp15_reg64_set(vcpu, r, val);
 	} else if (KVM_REG_SIZE(reg->id) == 4) {
-		ret = reg_from_user(&vcpu->arch.cp15[r->reg], uaddr, reg->id);
+		ret = reg_from_user(&vcpu_cp15(vcpu, r->reg), uaddr, reg->id);
 	}
 
 	return ret;
@@ -1248,7 +1248,7 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
 	const struct coproc_reg *table;
 
 	/* Catch someone adding a register without putting in reset entry. */
-	memset(vcpu->arch.cp15, 0x42, sizeof(vcpu->arch.cp15));
+	memset(vcpu->arch.ctxt.cp15, 0x42, sizeof(vcpu->arch.ctxt.cp15));
 
 	/* Generic chip reset first (so target could override). */
 	reset_coproc_regs(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
@@ -1257,6 +1257,6 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
 	reset_coproc_regs(vcpu, table, num);
 
 	for (num = 1; num < NR_CP15_REGS; num++)
-		if (vcpu->arch.cp15[num] == 0x42424242)
-			panic("Didn't reset vcpu->arch.cp15[%zi]", num);
+		if (vcpu_cp15(vcpu, num) == 0x42424242)
+			panic("Didn't reset vcpu_cp15(vcpu, %zi)", num);
 }
diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
index 88d24a3..2735132 100644
--- a/arch/arm/kvm/coproc.h
+++ b/arch/arm/kvm/coproc.h
@@ -47,7 +47,7 @@ struct coproc_reg {
 	/* Initialization for vcpu. */
 	void (*reset)(struct kvm_vcpu *, const struct coproc_reg *);
 
-	/* Index into vcpu->arch.cp15[], or 0 if we don't need to save it. */
+	/* Index into vcpu_cp15(vcpu, ...), or 0 if we don't need to save it. */
 	unsigned long reg;
 
 	/* Value (usually reset value) */
@@ -104,25 +104,25 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
 				 const struct coproc_reg *r)
 {
 	BUG_ON(!r->reg);
-	BUG_ON(r->reg >= ARRAY_SIZE(vcpu->arch.cp15));
-	vcpu->arch.cp15[r->reg] = 0xdecafbad;
+	BUG_ON(r->reg >= ARRAY_SIZE(vcpu->arch.ctxt.cp15));
+	vcpu_cp15(vcpu, r->reg) = 0xdecafbad;
 }
 
 static inline void reset_val(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
 {
 	BUG_ON(!r->reg);
-	BUG_ON(r->reg >= ARRAY_SIZE(vcpu->arch.cp15));
-	vcpu->arch.cp15[r->reg] = r->val;
+	BUG_ON(r->reg >= ARRAY_SIZE(vcpu->arch.ctxt.cp15));
+	vcpu_cp15(vcpu, r->reg) = r->val;
 }
 
 static inline void reset_unknown64(struct kvm_vcpu *vcpu,
 				   const struct coproc_reg *r)
 {
 	BUG_ON(!r->reg);
-	BUG_ON(r->reg + 1 >= ARRAY_SIZE(vcpu->arch.cp15));
+	BUG_ON(r->reg + 1 >= ARRAY_SIZE(vcpu->arch.ctxt.cp15));
 
-	vcpu->arch.cp15[r->reg] = 0xdecafbad;
-	vcpu->arch.cp15[r->reg+1] = 0xd0c0ffee;
+	vcpu_cp15(vcpu, r->reg) = 0xdecafbad;
+	vcpu_cp15(vcpu, r->reg+1) = 0xd0c0ffee;
 }
 
 static inline int cmp_reg(const struct coproc_reg *i1,
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index dc99159..ee161b1 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -266,8 +266,8 @@ void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_instr)
 
 static u32 exc_vector_base(struct kvm_vcpu *vcpu)
 {
-	u32 sctlr = vcpu->arch.cp15[c1_SCTLR];
-	u32 vbar = vcpu->arch.cp15[c12_VBAR];
+	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
+	u32 vbar = vcpu_cp15(vcpu, c12_VBAR);
 
 	if (sctlr & SCTLR_V)
 		return 0xffff0000;
@@ -282,7 +282,7 @@ static u32 exc_vector_base(struct kvm_vcpu *vcpu)
 static void kvm_update_psr(struct kvm_vcpu *vcpu, unsigned long mode)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
-	u32 sctlr = vcpu->arch.cp15[c1_SCTLR];
+	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
 
 	*vcpu_cpsr(vcpu) = (cpsr & ~MODE_MASK) | mode;
 
@@ -357,22 +357,22 @@ static void inject_abt(struct kvm_vcpu *vcpu, bool is_pabt, unsigned long addr)
 
 	if (is_pabt) {
 		/* Set IFAR and IFSR */
-		vcpu->arch.cp15[c6_IFAR] = addr;
-		is_lpae = (vcpu->arch.cp15[c2_TTBCR] >> 31);
+		vcpu_cp15(vcpu, c6_IFAR) = addr;
+		is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
 		/* Always give debug fault for now - should give guest a clue */
 		if (is_lpae)
-			vcpu->arch.cp15[c5_IFSR] = 1 << 9 | 0x22;
+			vcpu_cp15(vcpu, c5_IFSR) = 1 << 9 | 0x22;
 		else
-			vcpu->arch.cp15[c5_IFSR] = 2;
+			vcpu_cp15(vcpu, c5_IFSR) = 2;
 	} else { /* !iabt */
 		/* Set DFAR and DFSR */
-		vcpu->arch.cp15[c6_DFAR] = addr;
-		is_lpae = (vcpu->arch.cp15[c2_TTBCR] >> 31);
+		vcpu_cp15(vcpu, c6_DFAR) = addr;
+		is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
 		/* Always give debug fault for now - should give guest a clue */
 		if (is_lpae)
-			vcpu->arch.cp15[c5_DFSR] = 1 << 9 | 0x22;
+			vcpu_cp15(vcpu, c5_DFSR) = 1 << 9 | 0x22;
 		else
-			vcpu->arch.cp15[c5_DFSR] = 2;
+			vcpu_cp15(vcpu, c5_DFSR) = 2;
 	}
 
 }
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 51a5950..b9d9531 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -4,7 +4,8 @@
 #define VCPU_USR_REG(_reg_nr)	(VCPU_USR_REGS + (_reg_nr * 4))
 #define VCPU_USR_SP		(VCPU_USR_REG(13))
 #define VCPU_USR_LR		(VCPU_USR_REG(14))
-#define CP15_OFFSET(_cp15_reg_idx) (VCPU_CP15 + (_cp15_reg_idx * 4))
+#define VCPU_CP15_BASE		(VCPU_GUEST_CTXT + CPU_CTXT_CP15)
+#define CP15_OFFSET(_cp15_reg_idx) (VCPU_CP15_BASE + (_cp15_reg_idx * 4))
 
 /*
  * Many of these macros need to access the VCPU structure, which is always
-- 
2.1.4
