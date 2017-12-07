From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 24/36] KVM: arm64: Prepare to handle traps on remaining
 deferred EL1 sysregs
Date: Thu,  7 Dec 2017 18:06:18 +0100
Message-ID: <20171207170630.592-25-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 450D749D74
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id THlgTxYAk8ov for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:04:06 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D53BC49DCE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:03 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id 9so14262662wme.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:20 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Handle accesses during traps to any remaining EL1 registers which can be
deferred to vcpu_load and vcpu_put, by either accessing them directly on
the physical CPU when the latest version is stored there, or by
synchronizing the memory representation with the CPU state.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_emulate.h   | 16 ++++++++++++
 arch/arm/include/asm/kvm_host.h      |  2 ++
 arch/arm64/include/asm/kvm_emulate.h | 49 +++++++++++++++++++++++++-----------
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/kvm/inject_fault.c        | 19 ++++++++++----
 arch/arm64/kvm/sys_regs.c            |  6 ++++-
 virt/kvm/arm/aarch32.c               | 22 +++++++++++++---
 7 files changed, 93 insertions(+), 23 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index d5e1b8bf6422..47efa953460a 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -55,6 +55,22 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 	*vcpu_reg(vcpu, reg_num) = val;
 }
 
+/* Set the SPSR for the current mode */
+static inline void vcpu_set_spsr(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	*vcpu_spsr(vcpu) = val;
+}
+
+static inline unsigned long vcpu_get_vbar(struct kvm_vcpu *vcpu)
+{
+	return vcpu_cp15(vcpu, c12_VBAR);
+}
+
+static inline u32 vcpu_get_c1_sctlr(struct kvm_vcpu *vcpu)
+{
+	return vcpu_cp15(vcpu, c1_SCTLR);
+}
+
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr);
 void kvm_inject_undef32(struct kvm_vcpu *vcpu);
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8fce576199e0..997c0568bfa3 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -203,6 +203,8 @@ struct kvm_vcpu_stat {
 
 #define vcpu_cp15(v,r)	(v)->arch.ctxt.cp15[r]
 
+#define vcpu_sysregs_loaded(_v)	(false)
+
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 635137e6ed1c..3f765b9de94d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -26,6 +26,7 @@
 
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_mmio.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
@@ -77,11 +78,6 @@ static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pc;
 }
 
-static inline unsigned long *vcpu_elr_el1(const struct kvm_vcpu *vcpu)
-{
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->elr_el1;
-}
-
 static inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pstate;
@@ -92,6 +88,40 @@ static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 	return !!(*vcpu_cpsr(vcpu) & PSR_MODE32_BIT);
 }
 
+/* Set the SPSR for the current mode */
+static inline void vcpu_set_spsr(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (vcpu_mode_is_32bit(vcpu))
+		*vcpu_spsr32(vcpu) = val;
+
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		write_sysreg_el1(val, spsr);
+	else
+		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = val;
+}
+
+static inline unsigned long vcpu_get_vbar(struct kvm_vcpu *vcpu)
+{
+	unsigned long vbar;
+
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		vbar = read_sysreg_el1(vbar);
+	else
+		vbar = vcpu_sys_reg(vcpu, VBAR_EL1);
+
+	if (vcpu_el1_is_32bit(vcpu))
+		return lower_32_bits(vbar);
+	return vbar;
+}
+
+static inline u32 vcpu_get_c1_sctlr(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_sysregs_loaded(vcpu))
+		return lower_32_bits(read_sysreg_el1(sctlr));
+	else
+		return vcpu_cp15(vcpu, c1_SCTLR);
+}
+
 static inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu))
@@ -131,15 +161,6 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
 }
 
-/* Get vcpu SPSR for current mode */
-static inline unsigned long *vcpu_spsr(const struct kvm_vcpu *vcpu)
-{
-	if (vcpu_mode_is_32bit(vcpu))
-		return vcpu_spsr32(vcpu);
-
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
-}
-
 static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 {
 	u32 mode;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f6afe685a280..992c19816893 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -294,6 +294,8 @@ struct kvm_vcpu_arch {
 #define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
 #define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
 
+#define vcpu_sysregs_loaded(_v)	((_v)->arch.sysregs_loaded_on_cpu)
+
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
 };
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 2d38ede2eff0..1d941e8e8102 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -23,6 +23,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
 #include <asm/esr.h>
 
 #define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
@@ -33,6 +34,14 @@
 #define LOWER_EL_AArch64_VECTOR		0x400
 #define LOWER_EL_AArch32_VECTOR		0x600
 
+static void vcpu_set_elr_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		write_sysreg_el1(val, elr);
+	else
+		vcpu_gp_regs(vcpu)->elr_el1 = val;
+}
+
 enum exception_type {
 	except_type_sync	= 0,
 	except_type_irq		= 0x80,
@@ -58,7 +67,7 @@ static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
 		exc_offset = LOWER_EL_AArch32_VECTOR;
 	}
 
-	return vcpu_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
+	return vcpu_get_vbar(vcpu) + exc_offset + type;
 }
 
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
@@ -67,11 +76,11 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
+	vcpu_set_elr_el1(vcpu, *vcpu_pc(vcpu));
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-	*vcpu_spsr(vcpu) = cpsr;
+	vcpu_set_spsr(vcpu, cpsr);
 
 	vcpu_sys_reg(vcpu, FAR_EL1) = addr;
 
@@ -102,11 +111,11 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
+	vcpu_set_elr_el1(vcpu, *vcpu_pc(vcpu));
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-	*vcpu_spsr(vcpu) = cpsr;
+	vcpu_set_spsr(vcpu, cpsr);
 
 	/*
 	 * Build an unknown exception, depending on the instruction
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 80adbec933de..6109dc8d5fb7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -87,12 +87,16 @@ static u32 cache_levels;
 static u32 get_ccsidr(u32 csselr)
 {
 	u32 ccsidr;
+	u32 csselr_preserve;
 
-	/* Make sure noone else changes CSSELR during this! */
+	/* Make sure noone else changes CSSELR during this and preserve any
+	 * existing value in the CSSELR! */
 	local_irq_disable();
+	csselr_preserve = read_sysreg(csselr_el1);
 	write_sysreg(csselr, csselr_el1);
 	isb();
 	ccsidr = read_sysreg(ccsidr_el1);
+	write_sysreg(csselr_preserve, csselr_el1);
 	local_irq_enable();
 
 	return ccsidr;
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 8bc479fa37e6..67b62ff79b6f 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -166,7 +166,7 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
 	bool is_thumb = (new_spsr_value & COMPAT_PSR_T_BIT);
 	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
-	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
+	u32 sctlr = vcpu_get_c1_sctlr(vcpu);
 
 	cpsr = mode | COMPAT_PSR_I_BIT;
 
@@ -178,14 +178,14 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	*vcpu_cpsr(vcpu) = cpsr;
 
 	/* Note: These now point to the banked copies */
-	*vcpu_spsr(vcpu) = new_spsr_value;
+	vcpu_set_spsr(vcpu, new_spsr_value);
 	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
 
 	/* Branch to exception vector */
 	if (sctlr & (1 << 13))
 		vect_offset += 0xffff0000;
 	else /* always have security exceptions */
-		vect_offset += vcpu_cp15(vcpu, c12_VBAR);
+		vect_offset += vcpu_get_vbar(vcpu);
 
 	*vcpu_pc(vcpu) = vect_offset;
 }
@@ -206,6 +206,19 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 	u32 *far, *fsr;
 	bool is_lpae;
 
+	/*
+	 * The emulation code here is going to modify several system
+	 * registers, so on arm64 with VHE we want to load them into memory
+	 * and store them back into registers, ensuring that we observe the
+	 * most recent values and that we expose the right values back to the
+	 * guest.
+	 *
+	 * We disable preemption to avoid racing with another vcpu_put/load
+	 * operation.
+	 */
+	preempt_disable();
+	kvm_vcpu_put_sysregs(vcpu);
+
 	if (is_pabt) {
 		vect_offset = 12;
 		far = &vcpu_cp15(vcpu, c6_IFAR);
@@ -226,6 +239,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 		*fsr = 1 << 9 | 0x34;
 	else
 		*fsr = 0x14;
+
+	kvm_vcpu_load_sysregs(vcpu);
+	preempt_enable();
 }
 
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)
-- 
2.14.2
