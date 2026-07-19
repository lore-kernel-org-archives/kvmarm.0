Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F788388E42;
	Sun, 19 Jul 2026 23:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502689; cv=none; b=SveIwIq/lU+x2JY5HXMFop4/w7/La6Jnld4O3HZjh1lP+N6pISkFmc6EsXc6YUbOwTfhJKlHC6Ku6p6IbbXln2lBfMlH9XFIASCemCeHAiYkm3Iwz7oOOwcex2XiCbSO8g0Tg/kXr6j1WPysgyZ8p/tk2EkJPuRrrQBQxb2n1+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502689; c=relaxed/simple;
	bh=cYBJzWXUlFEk0NCpM7UpFBgugRQeF0dNkZ0uZU3Aefg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tNO3d2eSQxvDU1HWfia+w5nIPyNSJ9oF8GkK15jm4/R7QsdZdH5UtR89zxauSsKbBN1+IvWxeTLkEYY3h/Sabc9wUFJLHHTb9RQXkhnaZ6Y79IL2W++HipYOVPcPhLYHfMJHOZYkAz4eHLmM/os+dWXZNkz7sJHANKz7U+4bl9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOtmILhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOtmILhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BC41F000E9;
	Sun, 19 Jul 2026 23:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502688;
	bh=A2bN4tIPltWwBewhT2VmWsvljJVWBjMJb/lk1RQjUJ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IOtmILhcbqIUhxae31DsVCunrfgtE0ROBNka7Z0bKekDcNFFw6Y/9wo/REPNXAIjO
	 oQQRbkMY3haHLFt4PUAtqpzgUQXgrJw++byfuL5j/SXI24i2Apl7wzPxy6W6UICoib
	 jMgosrpmbUMARo7oB4j5Y/L7fKOMC2/rwcRNRHskLNRuyjU+TvQEbBnUPqRcyF6QX+
	 LFJP/OHlFUC/gyYLaxMpO/QN538pOTokHfuWew4niG3SEXMay0jMiS9RtTwMcn9dpu
	 g5yZvpRD67txmc2U/b4rM5eA6/7uP9Wm/QaHUK5r0RSueqfVsLj6zgcsUjTIbIFP0s
	 jEux23gWF92XA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:48 +0100
Subject: [PATCH v13 21/32] KVM: arm64: Support SME priority registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-21-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7564; i=broonie@kernel.org;
 h=from:subject:message-id; bh=cYBJzWXUlFEk0NCpM7UpFBgugRQeF0dNkZ0uZU3Aefg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVk3tB8szMB9+eqVoV3/1i6IZy25QvXGAvukL
 R+8AAH4gCKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZNwAKCRAk1otyXVSH
 0Jg+B/wMjCKDiE34S79TmLVqvdR3dnQUw+kJoRpDcGqW636f5wXtrcYe2m7WBsTWseCKIqDOfWy
 0G13ignCjEElwKDxdGJpqfQQzmERzuO2qt7E+QjK9+2Zd0hro9ORJJTs7neqf0Dv4mFZl7BcrYF
 LwAmKcSX6kJ1FKhDE9edMvxmFo86EczWE2tvEN0gPE1MocZy8yek62z1+OTn06X/DZQ60hMdauo
 Jk28JSXs0MW0aoNsN0RHktmRUtJ+Tq5ZPOOgDgHdGZ5jf4JHZiAf+ua2397N0MCXNV6K0Rw38RH
 URjN+kEElaj8pUfQ5ePfeXe1KIwF/er4i4fVGvG5oVwTH9RQ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME has optional support for configuring the relative priorities of PEs
in systems where they share a single SME hardware block, known as a
SMCU. Currently we do not have any support for this in Linux and will
also hide it from KVM guests, pending experience with practical
implementations. The interface for configuring priority support is via
two new system registers, these registers are always defined when SME is
available.

The register SMPRI_EL1 allows control of SME execution priorities. Since
we disable SME priority support for guests this register is RES0, define
it as such with no storage allocated and enable fine grained traps for
SMPRI_EL1 to ensure that guests can't write to it even if the hardware
supports priorities.  Since the register should be readable with fixed
contents we only trap writes, not reads.  Since there is no host support
for using priorities the register currently left with a value of 0 by
the host so we do not need to update the value for guests.

There is also an EL2 register SMPRIMAP_EL2 for virtualisation of
priorities which is VNCR mapped, this is RES0 when priority
configuration is not supported but has no register specific traps
available.  When saving state from a nested guest we overwrite any value
the guest stored.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     |  5 +++++
 arch/arm64/include/asm/vncr_mapping.h |  1 +
 arch/arm64/kvm/config.c               |  7 +++++--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c    |  7 +++++++
 arch/arm64/kvm/nested.c               |  7 +++++++
 arch/arm64/kvm/sys_regs.c             | 25 ++++++++++++++++++++++++-
 6 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e8c2907aacd2..6574c286f50f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -558,6 +558,7 @@ enum vcpu_sysreg {
 	VNCR(CPACR_EL1),/* Coprocessor Access Control */
 	VNCR(ZCR_EL1),	/* SVE Control */
 	VNCR(SMCR_EL1),	/* SME Control */
+	VNCR(SMPRIMAP_EL2),	/* Streaming Mode Priority Mapping Register */
 	VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
 	VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
 	VNCR(TCR_EL1),	/* Translation Control Register */
@@ -1691,6 +1692,10 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(system_supports_sme2() &&			\
 	 kvm_has_feat((k), ID_AA64PFR1_EL1, SME, SME2))
 
+#define kvm_has_smps(k)					\
+	(kvm_has_sme(k) &&				\
+	 (kvm_read_vm_id_reg(k, SYS_SMIDR_EL1) & SMIDR_EL1_SMPS))
+
 #ifdef __KVM_NVHE_HYPERVISOR__
 #define vcpu_has_sme2(vcpu)	kvm_has_sme2(kern_hyp_va((vcpu)->kvm))
 #define vcpu_has_fa64(vcpu)	kvm_has_fa64(kern_hyp_va((vcpu)->kvm))
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index c3bf92ac52d4..f6152fbbfe03 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -45,6 +45,7 @@
 #define VNCR_ZCR_EL1            0x1E0
 #define VNCR_HAFGRTR_EL2	0x1E8
 #define VNCR_SMCR_EL1		0x1F0
+#define VNCR_SMPRIMAP_EL2	0x1F8
 #define VNCR_TTBR0_EL1          0x200
 #define VNCR_TTBR1_EL1          0x210
 #define VNCR_FAR_EL1            0x220
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index cb6f3ea556c2..bc7f29a48399 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -281,8 +281,7 @@ static bool feat_anerr(struct kvm *kvm)
 
 static bool feat_sme_smps(struct kvm *kvm)
 {
-	return (kvm_has_feat(kvm, FEAT_SME) &&
-		(kvm_read_vm_id_reg(kvm, SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
+	return kvm_has_smps(kvm);
 }
 
 static bool feat_spe_fds(struct kvm *kvm)
@@ -1677,6 +1676,10 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
+
+	/* Emulate RES0 for SMPRI_EL1 until we support priorities */
+	if (cpus_have_final_cap(ARM64_SME))
+		*vcpu_fgt(vcpu, HFGWTR_EL2) &= ~HFGWTR_EL2_nSMPRI_EL1;
 }
 
 static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index be685b63e8cf..0fe7153eab08 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -80,6 +80,13 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 
 	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
 		__vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));
+
+	/*
+	 * We block SME priorities so SMPRIMAP_EL2 is RES0, however we
+	 * do not have traps to block access so the guest might have
+	 * updated the state, overwrite anything there.
+	 */
+	__vcpu_assign_sys_reg(vcpu, SMPRIMAP_EL2, 0);
 }
 
 static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 50e25ab9b604..7de9b7f8f90a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1925,6 +1925,13 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	resx.res1 = SMCR_ELx_RES1;
 	set_sysreg_masks(kvm, SMCR_EL2, resx);
 
+	/* SMPRMAP_EL2 - RES0 with SME but without priority mapping */
+	if (!kvm_has_smps(kvm)) {
+		resx.res0 = GENMASK_ULL(63, 0);
+		resx.res1 = 0;
+		set_sysreg_masks(kvm, SMPRIMAP_EL2, resx);
+	}
+
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
 		__vcpu_rmw_sys_reg(vcpu, sr, |=, 0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9a993e76da18..827502e3249a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -779,6 +779,15 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+static int set_res0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		    u64 val)
+{
+	if (val)
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -2054,6 +2063,15 @@ static unsigned int fp8_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int sme_raz_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	if (vcpu_has_sme(vcpu))
+		return REG_RAZ;
+
+	return REG_HIDDEN;
+}
+
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	if (!vcpu_has_sve(vcpu))
@@ -3450,7 +3468,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TRFCR_EL1), undef_access },
-	{ SYS_DESC(SYS_SMPRI_EL1), undef_access },
+
+	{ SYS_DESC(SYS_SMPRI_EL1), .access = trap_raz_wi, .set_user = set_res0,
+	  .get_user = get_raz_reg, .val = 0, .visibility = sme_raz_visibility },
+
 	{ SYS_DESC(SYS_SMCR_EL1), NULL, reset_val, SMCR_EL1, 0, .visibility = sme_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
@@ -3827,6 +3848,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
+	EL2_REG_FILTERED(SMPRIMAP_EL2, access_rw, reset_val, 0,
+			 sme_el2_visibility),
 	EL2_REG_FILTERED(SMCR_EL2, access_smcr_el2, reset_val, 0,
 			 sme_el2_visibility),
 

-- 
2.47.3

