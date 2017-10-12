From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 25/37] KVM: arm64: Prepare to handle traps on remaining
 deferred EL1 sysregs
Date: Thu, 12 Oct 2017 12:41:29 +0200
Message-ID: <20171012104141.26902-26-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2F049D8A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UDONXvznU+tE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:33 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2D7149D31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:32 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id f4so12126920wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:17 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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
 arch/arm64/include/asm/kvm_emulate.h | 14 -------
 arch/arm64/kvm/inject_fault.c        | 79 ++++++++++++++++++++++++++++++++----
 arch/arm64/kvm/sys_regs.c            |  6 ++-
 3 files changed, 76 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 630dd60..69bb40d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -66,11 +66,6 @@ static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
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
@@ -120,15 +115,6 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
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
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 45c7026..f4513fc 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -23,6 +23,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
 #include <asm/esr.h>
 
 #define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
@@ -33,13 +34,55 @@
 #define LOWER_EL_AArch64_VECTOR		0x400
 #define LOWER_EL_AArch32_VECTOR		0x600
 
+static u64 vcpu_get_vbar_el1(struct kvm_vcpu *vcpu)
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
+static void vcpu_set_elr_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		write_sysreg_el1(val, elr);
+	else
+		vcpu_gp_regs(vcpu)->elr_el1 = val;
+}
+
+/* Set the SPSR for the current mode */
+static void vcpu_set_spsr(struct kvm_vcpu *vcpu, u64 val)
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
+static u32 vcpu_get_c1_sctlr(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		return lower_32_bits(read_sysreg_el1(sctlr));
+	else
+		return vcpu_cp15(vcpu, c1_SCTLR);
+}
+
 static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
 	unsigned long cpsr;
 	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
 	bool is_thumb = (new_spsr_value & COMPAT_PSR_T_BIT);
 	u32 return_offset = (is_thumb) ? 4 : 0;
-	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
+	u32 sctlr = vcpu_get_c1_sctlr(vcpu);
 
 	cpsr = mode | COMPAT_PSR_I_BIT;
 
@@ -51,14 +94,14 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
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
+		vect_offset += vcpu_get_vbar_el1(vcpu);
 
 	*vcpu_pc(vcpu) = vect_offset;
 }
@@ -79,6 +122,20 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 	u32 *far, *fsr;
 	bool is_lpae;
 
+	/*
+	 * We are going to need the latest values of the following system
+	 * regiters:
+	 *   DFAR:  mapped to FAR_EL1
+	 *   IFAR:  mapped to FAR_EL1
+	 *   DFSR:  mapped to ESR_EL1
+	 *   TTBCR: mapped to TCR_EL1
+	 */
+	if (vcpu->arch.sysregs_loaded_on_cpu) {
+		vcpu->arch.ctxt.sys_regs[FAR_EL1] = read_sysreg_el1(far);
+		vcpu->arch.ctxt.sys_regs[ESR_EL1] = read_sysreg_el1(esr);
+		vcpu->arch.ctxt.sys_regs[TCR_EL1] = read_sysreg_el1(tcr);
+	}
+
 	if (is_pabt) {
 		vect_offset = 12;
 		far = &vcpu_cp15(vcpu, c6_IFAR);
@@ -99,6 +156,12 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 		*fsr = 1 << 9 | 0x34;
 	else
 		*fsr = 0x14;
+
+	/* Sync back any registers we may have changed */
+	if (vcpu->arch.sysregs_loaded_on_cpu) {
+		write_sysreg_el1(vcpu->arch.ctxt.sys_regs[FAR_EL1], far);
+		write_sysreg_el1(vcpu->arch.ctxt.sys_regs[ESR_EL1], esr);
+	}
 }
 
 enum exception_type {
@@ -126,7 +189,7 @@ static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
 		exc_offset = LOWER_EL_AArch32_VECTOR;
 	}
 
-	return vcpu_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
+	return vcpu_get_vbar_el1(vcpu) + exc_offset + type;
 }
 
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
@@ -135,11 +198,11 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
+	vcpu_set_elr_el1(vcpu, *vcpu_pc(vcpu));
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-	*vcpu_spsr(vcpu) = cpsr;
+	vcpu_set_spsr(vcpu, cpsr);
 
 	vcpu_sys_reg(vcpu, FAR_EL1) = addr;
 
@@ -170,11 +233,11 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
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
index f7887dd..60d1660 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -86,12 +86,16 @@ static u32 cache_levels;
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
-- 
2.9.0
