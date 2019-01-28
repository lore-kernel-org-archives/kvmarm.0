From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v5 5/5] arm64/kvm: control accessibility of ptrauth key
 registers
Date: Mon, 28 Jan 2019 12:28:46 +0530
Message-ID: <1548658727-14271-6-git-send-email-amit.kachhap@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4AAE4A3C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 01:59:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VB3SEHg0qEtm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 01:59:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F1C14A422
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 01:59:35 -0500 (EST)
In-Reply-To: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

According to userspace settings, ptrauth key registers are conditionally
present in guest system register list based on user specified flag
KVM_ARM_VCPU_PTRAUTH.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 Documentation/arm64/pointer-authentication.txt |  3 ++
 arch/arm64/kvm/sys_regs.c                      | 42 +++++++++++++++++++-------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
index 0529a7d..3be4ee1 100644
--- a/Documentation/arm64/pointer-authentication.txt
+++ b/Documentation/arm64/pointer-authentication.txt
@@ -87,3 +87,6 @@ created by passing a flag (KVM_ARM_VCPU_PTRAUTH) requesting this feature
 to be enabled. Without this flag, pointer authentication is not enabled
 in KVM guests and attempted use of the feature will result in an UNDEFINED
 exception being injected into the guest.
+
+Additionally, when KVM_ARM_VCPU_PTRAUTH is not set then KVM will filter
+out the authentication key registers from userspace.
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2546a65..b46a78e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1334,12 +1334,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -1491,6 +1485,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -2093,6 +2095,8 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	r = find_reg(params, table, num);
 	if (!r)
 		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	if (!r && kvm_arm_vcpu_ptrauth_allowed(vcpu))
+		r = find_reg(params, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
 
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
@@ -2206,6 +2210,8 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	r = find_reg_by_id(id, &params, table, num);
 	if (!r)
 		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	if (!r && kvm_arm_vcpu_ptrauth_allowed(vcpu))
+		r = find_reg(&params, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
 
 	/* Not saved in the sys_reg array and not otherwise accessible? */
 	if (r && !(r->reg || r->get_user))
@@ -2487,18 +2493,22 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
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
 
@@ -2526,7 +2536,10 @@ unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
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
@@ -2541,7 +2554,12 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
@@ -2575,6 +2593,7 @@ void kvm_sys_reg_table_init(void)
 	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs)));
 	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs)));
 	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs)));
+	BUG_ON(check_sysreg_table(ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs)));
 
 	/* We abuse the reset function to overwrite the table itself. */
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
@@ -2616,6 +2635,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 
 	/* Generic chip reset first (so target could override). */
 	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	reset_sys_reg_descs(vcpu, ptrauth_reg_descs, ARRAY_SIZE(ptrauth_reg_descs));
 
 	table = get_target_table(vcpu->arch.target, true, &num);
 	reset_sys_reg_descs(vcpu, table, num);
-- 
2.7.4
