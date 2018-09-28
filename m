From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 12/23] KVM: arm64/sve: System register context switch
 and access support
Date: Fri, 28 Sep 2018 14:39:16 +0100
Message-ID: <1538141967-15375-13-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4B2E49F86
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P9gNNHMqKX3a for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E3E64A238
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:39 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds the necessary support for context switching ZCR_EL1
for each vcpu.

ZCR_EL1 is trapped alongside the FPSIMD/SVE registers, so it makes
sense for it to be handled as part of the guest FPSIMD/SVE context
for context switch purposes instead of handling it as a general
system register.  This means that it can be switched in lazily at
the appropriate time.  No effort is made to track host context for
this register, since SVE requires VHE: thus the hosts's value for
this register lives permanently in ZCR_EL2 and does not alias the
guest's value at any time.

The Hyp switch and fpsimd context handling code is extended
appropriately.

Accessors are added in sys_regs.c to expose the SVE system
registers and ID register fields.  Because these need to be
conditionally visible based on the guest configuration, they are
implemented separately for now rather than by use of the generic
system register helpers.  This may be abstracted better later on
when/if there are more features requiring this model.

ID_AA64ZFR0_EL1 is RO-RAZ for MRS/MSR when SVE is disabled for the
guest, but for compatibility with non-SVE aware KVM implementations
the register should not be enumerated at all for KVM_GET_REG_LIST
in this case.  For consistency we also reject ioctl access to the
register.  This ensures that a non-SVE-enabled guest looks the same
to userspace, irrespective of whether the kernel KVM implementation
supports SVE.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---

Changes since RFCv1:

 * The conditional visibility logic in sys_regs.c has been
   simplified.

 * The guest's ZCR_EL1 is now treated as part of the FPSIMD/SVE state
   for switching purposes.  Any access to this register before it is
   switched in generates an SVE trap, so we have a change to switch it
   along with the vector registers.

   Because SVE is only available with VHE there is no need ever to
   restore the host's version of this register (which instead lives
   permanently in ZCR_EL2).
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/include/asm/sysreg.h   |   3 ++
 arch/arm64/kvm/fpsimd.c           |   9 +++-
 arch/arm64/kvm/hyp/switch.c       |   4 ++
 arch/arm64/kvm/sys_regs.c         | 111 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 123 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 20baf4a..76cbb95e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -110,6 +110,7 @@ enum vcpu_sysreg {
 	SCTLR_EL1,	/* System Control Register */
 	ACTLR_EL1,	/* Auxiliary Control Register */
 	CPACR_EL1,	/* Coprocessor Access Control */
+	ZCR_EL1,	/* SVE Control */
 	TTBR0_EL1,	/* Translation Table Base Register 0 */
 	TTBR1_EL1,	/* Translation Table Base Register 1 */
 	TCR_EL1,	/* Translation Control Register */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index c147093..dbac42f 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -418,6 +418,9 @@
 #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
+/* VHE encodings for architectural EL0/1 system registers */
+#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_IESB	(1 << 21)
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 55654cb..29e5585 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -102,6 +102,9 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
+	bool host_has_sve = system_supports_sve();
+	bool guest_has_sve =
+		host_has_sve && (vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
 
 	local_irq_save(flags);
 
@@ -109,7 +112,11 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		/* Clean guest FP state to memory and invalidate cpu view */
 		fpsimd_save();
 		fpsimd_flush_cpu_state();
-	} else if (system_supports_sve()) {
+
+		if (guest_has_sve)
+			vcpu->arch.ctxt.sys_regs[ZCR_EL1] =
+				read_sysreg_s(SYS_ZCR_EL12);
+	} else if (host_has_sve) {
 		/*
 		 * The FPSIMD/SVE state in the CPU has not been touched, and we
 		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ca46153..085ed06 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -366,6 +366,10 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 
 	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
 
+	if (system_supports_sve() &&
+	    vcpu->arch.flags & KVM_ARM64_GUEST_HAS_SVE)
+		write_sysreg_s(vcpu->arch.ctxt.sys_regs[ZCR_EL1], SYS_ZCR_EL12);
+
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(vcpu->arch.ctxt.sys_regs[FPEXC32_EL2],
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index adb6cbd..6f03211 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1036,10 +1036,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
 	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
 
-	if (id == SYS_ID_AA64PFR0_EL1) {
-		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
-			kvm_debug("SVE unsupported for guests, suppressing\n");
-
+	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
 	} else if (id == SYS_ID_AA64MMFR1_EL1) {
 		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
@@ -1083,6 +1080,105 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
 static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
+#ifdef CONFIG_ARM64_SVE
+static bool sve_check_present(const struct kvm_vcpu *vcpu,
+			      const struct sys_reg_desc *rd)
+{
+	return vcpu_has_sve(vcpu);
+}
+
+static bool access_zcr_el1(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *rd)
+{
+	/*
+	 * ZCR_EL1 access is handled directly in Hyp as part of the FPSIMD/SVE
+	 * context, so we should only arrive here for non-SVE guests:
+	 */
+	WARN_ON(vcpu_has_sve(vcpu));
+
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
+static int get_zcr_el1(struct kvm_vcpu *vcpu,
+		       const struct sys_reg_desc *rd,
+		       const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	return reg_to_user(uaddr, &vcpu->arch.ctxt.sys_regs[ZCR_EL1],
+			   reg->id);
+}
+
+static int set_zcr_el1(struct kvm_vcpu *vcpu,
+		       const struct sys_reg_desc *rd,
+		       const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	return reg_from_user(&vcpu->arch.ctxt.sys_regs[ZCR_EL1], uaddr,
+			     reg->id);
+}
+
+/* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
+static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	return read_sanitised_ftr_reg(SYS_ID_AA64ZFR0_EL1);
+}
+
+static bool access_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *rd)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, rd);
+
+	p->regval = guest_id_aa64zfr0_el1(vcpu);
+	return true;
+}
+
+static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
+		const struct sys_reg_desc *rd,
+		const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	u64 val;
+
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	val = guest_id_aa64zfr0_el1(vcpu);
+	return reg_to_user(uaddr, &val, reg->id);
+}
+
+static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
+		const struct sys_reg_desc *rd,
+		const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	const u64 id = sys_reg_to_index(rd);
+	int err;
+	u64 val;
+
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	err = reg_from_user(&val, uaddr, id);
+	if (err)
+		return err;
+
+	/* This is what we mean by invariant: you can't change it. */
+	if (val != guest_id_aa64zfr0_el1(vcpu))
+		return -EINVAL;
+
+	return 0;
+}
+#endif /* CONFIG_ARM64_SVE */
+
 /*
  * cpufeature ID register user accessors
  *
@@ -1270,7 +1366,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
+#ifdef CONFIG_ARM64_SVE
+	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .check_present = sve_check_present },
+#else
 	ID_UNALLOCATED(4,4),
+#endif
 	ID_UNALLOCATED(4,5),
 	ID_UNALLOCATED(4,6),
 	ID_UNALLOCATED(4,7),
@@ -1307,6 +1407,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
+#ifdef CONFIG_ARM64_SVE
+	{ SYS_DESC(SYS_ZCR_EL1), access_zcr_el1, reset_unknown, ZCR_EL1, ~0xfUL, .get_user = get_zcr_el1, .set_user = set_zcr_el1, .check_present = sve_check_present },
+#endif
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
-- 
2.1.4
