From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v3 5/7] arm64/kvm: control accessibility of ptrauth key registers
Date: Wed, 17 Oct 2018 16:17:58 +0530
Message-ID: <1539773280-4159-6-git-send-email-amit.kachhap@arm.com>
References: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

According to userspace settings, ptrauth key registers are conditionally
present in guest system register list based on user specified flag
KVM_ARM_VCPU_PTRAUTH.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ce6144a..09302b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1343,12 +1343,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
 
-	PTRAUTH_KEY(APIA),
-	PTRAUTH_KEY(APIB),
-	PTRAUTH_KEY(APDA),
-	PTRAUTH_KEY(APDB),
-	PTRAUTH_KEY(APGA),
-
 	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
@@ -1500,6 +1494,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x70 },
 };
 
+static const struct sys_reg_desc ptrauth_reg_descs[] = {
+	PTRAUTH_KEY(APIA),
+	PTRAUTH_KEY(APIB),
+	PTRAUTH_KEY(APDA),
+	PTRAUTH_KEY(APDB),
+	PTRAUTH_KEY(APGA),
+};
+
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -2100,6 +2102,8 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	r = find_reg(params, table, num);
 	if (!r)
 		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	if (!r && kvm_arm_vcpu_ptrauth_allowed(vcpu))
+		r = find_reg(params, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
 
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
@@ -2213,6 +2217,8 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	r = find_reg_by_id(id, &params, table, num);
 	if (!r)
 		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	if (!r && kvm_arm_vcpu_ptrauth_allowed(vcpu))
+		r = find_reg(&params, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
 
 	/* Not saved in the sys_reg array and not otherwise accessible? */
 	if (r && !(r->reg || r->get_user))
@@ -2494,18 +2500,22 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
 }
 
 /* Assumed ordered tables, see kvm_sys_reg_table_init. */
-static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
+static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind,
+			const struct sys_reg_desc *desc, unsigned int len)
 {
 	const struct sys_reg_desc *i1, *i2, *end1, *end2;
 	unsigned int total = 0;
 	size_t num;
 	int err;
 
+	if (desc == ptrauth_reg_descs && !kvm_arm_vcpu_ptrauth_allowed(vcpu))
+		return total;
+
 	/* We check for duplicates here, to allow arch-specific overrides. */
 	i1 = get_target_table(vcpu->arch.target, true, &num);
 	end1 = i1 + num;
-	i2 = sys_reg_descs;
-	end2 = sys_reg_descs + ARRAY_SIZE(sys_reg_descs);
+	i2 = desc;
+	end2 = desc + len;
 
 	BUG_ON(i1 == end1 || i2 == end2);
 
@@ -2533,7 +2543,10 @@ unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
 {
 	return ARRAY_SIZE(invariant_sys_regs)
 		+ num_demux_regs()
-		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
+		+ walk_sys_regs(vcpu, (u64 __user *)NULL, sys_reg_descs,
+				ARRAY_SIZE(sys_reg_descs))
+		+ walk_sys_regs(vcpu, (u64 __user *)NULL, ptrauth_reg_descs,
+				ARRAY_SIZE(ptrauth_reg_descs));
 }
 
 int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
@@ -2548,7 +2561,12 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		uindices++;
 	}
 
-	err = walk_sys_regs(vcpu, uindices);
+	err = walk_sys_regs(vcpu, uindices, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	if (err < 0)
+		return err;
+	uindices += err;
+
+	err = walk_sys_regs(vcpu, uindices, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
 	if (err < 0)
 		return err;
 	uindices += err;
@@ -2582,6 +2600,7 @@ void kvm_sys_reg_table_init(void)
 	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs)));
 	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs)));
 	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs)));
+	BUG_ON(check_sysreg_table(ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs)));
 
 	/* We abuse the reset function to overwrite the table itself. */
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
@@ -2623,6 +2642,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 
 	/* Generic chip reset first (so target could override). */
 	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	reset_sys_reg_descs(vcpu, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
 
 	table = get_target_table(vcpu->arch.target, true, &num);
 	reset_sys_reg_descs(vcpu, table, num);
-- 
2.7.4
