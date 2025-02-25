Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD32F17578
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 00:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740444857; cv=none; b=jSJC/qlIeq/1SisUBwz8uex4CMG+hH5ZDysr8yb4W5vNtgsmmXY1TuDomClQ+3YZiLPqj35ThERvR8gJsTCltk84tPVSrM1debQC0poMMQ1Xm1qXTR6ej3oP3HcHFpZih2UBehK+1PXKKda/MSfrYCj3BFctw+s1INYeydjcByk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740444857; c=relaxed/simple;
	bh=jX358/drsVUwdw1yDkxSNR41zGknlh8tPhZAUBN+8ac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iHr6++a7PCgnEJ4dlc+URtScJqznEpEzLeMD6ZjoY8QRgmd3x4Wx+QNzbwuHLRevhO1aPrLCBuUu7seBRLBjPDBrdr8s4TQgjEhgYvAnkf8KBdoOsIx5PFbrgNcebcw94aHZwvotdbbCihm4mKkH2xXThdss7xd16T27QsoyuA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wcz25GPd; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wcz25GPd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740444853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8s0LIzrPyVSxQ+WJZZ25t8SXrQ9VHzO5ErBedCIuyJw=;
	b=wcz25GPdPPhF+K9bJQHSAermXpN+tctxfzhqbUwPWK/Pgj5Oz4JDLJwvSRwqlAujZqCxNU
	CO69MQ1r3qe1lmn6W98I3Rqja9qc9lGWC3H7vLLTxcZHf8a2ggcltqooq21HTlWtb7+TQW
	mPexs4vEtufsmBxtCvrjP/FdZGuCIGo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/5] KVM: arm64: Set HCR_EL2.TID1 unconditionally
Date: Mon, 24 Feb 2025 16:53:57 -0800
Message-Id: <20250225005401.679536-2-oliver.upton@linux.dev>
In-Reply-To: <20250225005401.679536-1-oliver.upton@linux.dev>
References: <20250225005401.679536-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

commit 90807748ca3a ("KVM: arm64: Hide SME system registers from
guests") added trap handling for SMIDR_EL1, treating it as UNDEFINED as
KVM does not support SME. This is right for the most part, however KVM
needs to set HCR_EL2.TID1 to _actually_ trap the register.

Unfortunately, this comes with some collateral damage as TID1 forces
REVIDR_EL1 and AIDR_EL1 to trap as well. KVM has long treated these
registers as "invariant" which is an awful term for the following:

 - Userspace sees the boot CPU values on all vCPUs

 - The guest sees the hardware values of the CPU on which a vCPU is
   scheduled

Keep the plates spinning by adding trap handling for the affected
registers and repaint all of the "invariant" crud into terms of
identifying an implementation. Yes, at this point we only need to
set TID1 on SME hardware, but REVIDR_EL1 and AIDR_EL1 are about to
become mutable anyway.

Cc: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 90807748ca3a ("KVM: arm64: Hide SME system registers from guests")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_arm.h |   4 +-
 arch/arm64/kvm/sys_regs.c        | 175 ++++++++++++++++---------------
 2 files changed, 94 insertions(+), 85 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8d94a6c0ed5c..b01c01e55de5 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -92,12 +92,12 @@
  * SWIO:	Turn set/way invalidates into set/way clean+invalidate
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
  * TID3:	Trap EL1 reads of group 3 ID registers
- * TID2:	Trap CTR_EL0, CCSIDR2_EL1, CLIDR_EL1, and CSSELR_EL1
+ * TID1:	Trap REVIDR_EL1, AIDR_EL1, and SMIDR_EL1
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
-			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3)
+			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6cd1ea7fb55..f25a157622e3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2483,6 +2483,93 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * For historical (ahem ABI) reasons, KVM treats MIDR_EL1, REVIDR_EL1, and
+ * AIDR_EL1 as "invariant" registers, meaning userspace cannot change them.
+ * The values made visible to userspace were the register values of the boot
+ * CPU.
+ *
+ * At the same time, reads from these registers at EL1 previously were not
+ * trapped, allowing the guest to read the actual hardware value. On big-little
+ * machines, this means the VM can see different values depending on where a
+ * given vCPU got scheduled.
+ *
+ * These registers are now trapped as collateral damage from SME, and what
+ * follows attempts to give a user / guest view consistent with the existing
+ * ABI.
+ */
+static bool access_imp_id_reg(struct kvm_vcpu *vcpu,
+			      struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	switch (reg_to_encoding(r)) {
+	case SYS_REVIDR_EL1:
+		p->regval = read_sysreg(revidr_el1);
+		break;
+	case SYS_AIDR_EL1:
+		p->regval = read_sysreg(aidr_el1);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	return true;
+}
+
+static u64 __ro_after_init boot_cpu_midr_val;
+static u64 __ro_after_init boot_cpu_revidr_val;
+static u64 __ro_after_init boot_cpu_aidr_val;
+
+static void init_imp_id_regs(void)
+{
+	boot_cpu_midr_val = read_sysreg(midr_el1);
+	boot_cpu_revidr_val = read_sysreg(revidr_el1);
+	boot_cpu_aidr_val = read_sysreg(aidr_el1);
+}
+
+static int get_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			  u64 *val)
+{
+	switch (reg_to_encoding(r)) {
+	case SYS_MIDR_EL1:
+		*val = boot_cpu_midr_val;
+		break;
+	case SYS_REVIDR_EL1:
+		*val = boot_cpu_revidr_val;
+		break;
+	case SYS_AIDR_EL1:
+		*val = boot_cpu_aidr_val;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			  u64 val)
+{
+	u64 expected;
+	int ret;
+
+	ret = get_imp_id_reg(vcpu, r, &expected);
+	if (ret)
+		return ret;
+
+	return (expected == val) ? 0 : -EINVAL;
+}
+
+#define IMPLEMENTATION_ID(reg) {			\
+	SYS_DESC(SYS_##reg),				\
+	.access = access_imp_id_reg,			\
+	.get_user = get_imp_id_reg,			\
+	.set_user = set_imp_id_reg,			\
+}
 
 /*
  * Architected system registers.
@@ -2532,7 +2619,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_DBGVCR32_EL2), undef_access, reset_val, DBGVCR32_EL2, 0 },
 
+	IMPLEMENTATION_ID(MIDR_EL1),
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
+	IMPLEMENTATION_ID(REVIDR_EL1),
 
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
@@ -2804,6 +2893,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
+	IMPLEMENTATION_ID(AIDR_EL1),
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	ID_FILTERED(CTR_EL0, ctr_el0,
 		    CTR_EL0_DIC_MASK |
@@ -4568,65 +4658,6 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-/*
- * These are the invariant sys_reg registers: we let the guest see the
- * host versions of these, so they're part of the guest state.
- *
- * A future CPU may provide a mechanism to present different values to
- * the guest, or a future kvm may trap them.
- */
-
-#define FUNCTION_INVARIANT(reg)						\
-	static u64 reset_##reg(struct kvm_vcpu *v,			\
-			       const struct sys_reg_desc *r)		\
-	{								\
-		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
-		return ((struct sys_reg_desc *)r)->val;			\
-	}
-
-FUNCTION_INVARIANT(midr_el1)
-FUNCTION_INVARIANT(revidr_el1)
-FUNCTION_INVARIANT(aidr_el1)
-
-/* ->val is filled in by kvm_sys_reg_table_init() */
-static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_MIDR_EL1), NULL, reset_midr_el1 },
-	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
-	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
-};
-
-static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
-{
-	const struct sys_reg_desc *r;
-
-	r = get_reg_by_id(id, invariant_sys_regs,
-			  ARRAY_SIZE(invariant_sys_regs));
-	if (!r)
-		return -ENOENT;
-
-	return put_user(r->val, uaddr);
-}
-
-static int set_invariant_sys_reg(u64 id, u64 __user *uaddr)
-{
-	const struct sys_reg_desc *r;
-	u64 val;
-
-	r = get_reg_by_id(id, invariant_sys_regs,
-			  ARRAY_SIZE(invariant_sys_regs));
-	if (!r)
-		return -ENOENT;
-
-	if (get_user(val, uaddr))
-		return -EFAULT;
-
-	/* This is what we mean by invariant: you can't change it. */
-	if (r->val != val)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 {
 	u32 val;
@@ -4708,15 +4739,10 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
-	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_get(vcpu, reg->id, uaddr);
 
-	err = get_invariant_sys_reg(reg->id, uaddr);
-	if (err != -ENOENT)
-		return err;
-
 	return kvm_sys_reg_get_user(vcpu, reg,
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
@@ -4752,15 +4778,10 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
-	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_set(vcpu, reg->id, uaddr);
 
-	err = set_invariant_sys_reg(reg->id, uaddr);
-	if (err != -ENOENT)
-		return err;
-
 	return kvm_sys_reg_set_user(vcpu, reg,
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
@@ -4849,23 +4870,14 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 
 unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
 {
-	return ARRAY_SIZE(invariant_sys_regs)
-		+ num_demux_regs()
+	return num_demux_regs()
 		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
 }
 
 int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	unsigned int i;
 	int err;
 
-	/* Then give them all the invariant registers' indices. */
-	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++) {
-		if (put_user(sys_reg_to_index(&invariant_sys_regs[i]), uindices))
-			return -EFAULT;
-		uindices++;
-	}
-
 	err = walk_sys_regs(vcpu, uindices);
 	if (err < 0)
 		return err;
@@ -5091,15 +5103,12 @@ int __init kvm_sys_reg_table_init(void)
 	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true);
 	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
 	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
-	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
 	valid &= check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false);
 
 	if (!valid)
 		return -EINVAL;
 
-	/* We abuse the reset function to overwrite the table itself. */
-	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
-		invariant_sys_regs[i].reset(NULL, &invariant_sys_regs[i]);
+	init_imp_id_regs();
 
 	ret = populate_nv_trap_config();
 
-- 
2.39.5

