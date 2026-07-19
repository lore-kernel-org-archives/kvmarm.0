Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5215382F0C;
	Sun, 19 Jul 2026 23:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502686; cv=none; b=tumKDhHeYeMrdvpY4Z3eU+JPekQaqMQwBW2CCM88JnOnspqPhQUt4LgEAO0Eqi/J2Hsjbd0TD1x1AyzVzWMT4vkJEyXV3sLpUlVAOspxEwmVlABL5gX69/Nw+l+v3IWuMtzqQRi7QttBrlIRqnXnuKOfZxVA0k1mrIsG7eV7phI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502686; c=relaxed/simple;
	bh=jUFGq0+icNwT/iYb+BgbYtlTqmLb6rTTJWQ/OH31Z3M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=grSOh8IrpFtVazxmbwFJI2K410dJazA2j9VLRvI7XdJ+/jX8hJYCCZ2Y4UZEWcgRgD7kD/Vub6vCY+aJYMnteZCvNleSZW91aauw6hpgYbW+bdKruM+yFsPDiWZVl3WPRr9SAvSlFQpwmenfOXl3LGFeh+4exhRNyvxU2mYcd+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLuAB16M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLuAB16M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457DB1F00A3A;
	Sun, 19 Jul 2026 23:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502684;
	bh=Vyvgwe2bx2dMjhTv9BT8Y3V+NK2lIb8ZDTnayo4YW1U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fLuAB16MkkOeLbyqPMy5WPMmk4GEbJp9zOqlOKy17Y2kZl/OVJI8h2Cb3bhMtpVFF
	 tORDcHG3pxi1K38vh+NpfszVZbH2WT09/lSPUdR3chkED3aU/CMbZJrB8hHNnhTchq
	 Pk/b9bdFzA4uoqJ+J/3hJhODhjkYQ9sBJ3Iulb6vXIyKOEIT2UDpI0Dlo2RXT5DB7y
	 rc2P77ZBd7ug4/uoOOUWMla4zCPcxA6X0mwJewK2cUrY6n49qh1n/cQaGRb2J7r/Qi
	 8x6DOwQRepyqtIbgkZKqiv+Lwwppndv0iI6zn2QwGV4XohVeq3T9a8ij1iMS8HeQ1L
	 fBardkLXw3UAA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:47 +0100
Subject: [PATCH v13 20/32] KVM: arm64: Support SME identification registers
 for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-20-d9abd3ffa245@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9449; i=broonie@kernel.org;
 h=from:subject:message-id; bh=jUFGq0+icNwT/iYb+BgbYtlTqmLb6rTTJWQ/OH31Z3M=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVk3yTMAvBMEIV+vecNalUWKkHlwIDiqJuc3f
 o1Oz9591kyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZNwAKCRAk1otyXVSH
 0DzwB/sFPMC46Xkm+HFi62G9r06cck3V/VhdxryVgz94WysJ8TQi3Sk2n8uF9FuB89X7sLFu06W
 UoBiBPLDwYKjmXT6qaQXFhhl37nFI8/bzgtMJGA3mvzx5g2QlCaix7bqQ8gFqLSKZegu7/3N0kE
 Ktuu95tmmdQdBTMSFZUgWhbgHJeux8QMAyR43LR01d4kZOS5/AjuNUEun3S8Du7/cV94ZCfuDpc
 st1L2y8DKf0wf2qP56plry7UIUnt86o4i2qqfWEyT/UYcOZOKTwHNNrw5IPYXPuWKf3dUYY3ZXu
 EWytZm7jvdm3YOb9AczYx/73GgV8lKhM+qT8VwblvU+X96Jl
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The primary register for identifying SME is ID_AA64PFR1_EL1.SME.  This
is hidden from guests unless SME is enabled by the VMM.
When it is visible it is writable and can be used to control the
availability of SME2.  In order to avoid any confusion in the KVM
implementation we force ID_AA64PFR1_EL1.SME to advertise SME when SME is
enabled for the guest.

There is also a new register ID_AA64SMFR0_EL1 which we make writable,
forcing it to all bits 0 if SME is disabled.  This includes the field
SMEver giving the SME version, userspace is responsible for ensuring
the value is consistent with ID_AA64PFR1_EL1.SME.  It also includes
FA64, a separately enableable extension which provides the full FPSIMD
and SVE instruction set including FFR in streaming mode.  Userspace can
control the availability of FA64 by writing to this field.  The other
features enumerated there only add new instructions, there are no
architectural controls for these.

There is a further identification register SMIDR_EL1 which provides a
basic description of the SME microarchitecture, in a manner similar to
MIDR_EL1 for the PE.  It also describes support for priority management
and a basic affinity description for shared SME units, plus some RES0
space.  We do not support priority management for guests so this is
hidden from guests, along with any fields defined in future.

As for MIDR_EL1 and REVIDR_EL1 we expose the implementer and revision
information to guests with the raw value from the CPU we are running on,
this may present issues for asymmetric systems or for migration as it
does for the existing registers.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/config.c           |  8 +-----
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  4 ++-
 arch/arm64/kvm/sys_regs.c         | 55 ++++++++++++++++++++++++++++++++++-----
 4 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index da7e572822a1..e8c2907aacd2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -410,6 +410,7 @@ struct kvm_arch {
 	u64 revidr_el1;
 	u64 aidr_el1;
 	u64 ctr_el0;
+	u64 smidr_el1;
 
 	/* Masks for VNCR-backed and general EL2 sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
@@ -1585,6 +1586,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 		return &ka->revidr_el1;
 	case SYS_AIDR_EL1:
 		return &ka->aidr_el1;
+	case SYS_SMIDR_EL1:
+		return &ka->smidr_el1;
 	default:
 		WARN_ON_ONCE(1);
 		return NULL;
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 0622162b089e..cb6f3ea556c2 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -281,14 +281,8 @@ static bool feat_anerr(struct kvm *kvm)
 
 static bool feat_sme_smps(struct kvm *kvm)
 {
-	/*
-	 * Revisit this if KVM ever supports SME -- this really should
-	 * look at the guest's view of SMIDR_EL1. Funnily enough, this
-	 * is not captured in the JSON file, but only as a note in the
-	 * ARM ARM.
-	 */
 	return (kvm_has_feat(kvm, FEAT_SME) &&
-		(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
+		(kvm_read_vm_id_reg(kvm, SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
 }
 
 static bool feat_spe_fds(struct kvm *kvm)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index d49f7f327adf..620f3395ea4e 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -357,8 +357,10 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 			    host_kvm->arch.vcpu_features,
 			    KVM_VCPU_MAX_FEATURES);
 
-		if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &host_arch_flags))
+		if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &host_arch_flags)) {
 			hyp_vm->kvm.arch.midr_el1 = host_kvm->arch.midr_el1;
+			hyp_vm->kvm.arch.smidr_el1 = host_kvm->arch.smidr_el1;
+		}
 
 		return;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8f19caac6008..9a993e76da18 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1951,6 +1951,7 @@ static inline bool is_vm_ftr_id_reg(u32 id)
 	case SYS_MIDR_EL1:
 	case SYS_REVIDR_EL1:
 	case SYS_AIDR_EL1:
+	case SYS_SMIDR_EL1:
 		return true;
 	default:
 		return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
@@ -1979,7 +1980,11 @@ static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 
 	switch (id) {
 	case SYS_ID_AA64ZFR0_EL1:
-		if (!vcpu_has_sve(vcpu))
+		if (!vcpu_has_sve(vcpu) && !vcpu_has_sme(vcpu))
+			return REG_RAZ;
+		break;
+	case SYS_ID_AA64SMFR0_EL1:
+		if (!vcpu_has_sme(vcpu))
 			return REG_RAZ;
 		break;
 	}
@@ -2101,7 +2106,9 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
 	      SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, pfr0) == ID_AA64PFR0_EL1_RAS_IMP))
 		val &= ~ID_AA64PFR1_EL1_RAS_frac;
 
-	val &= ~ID_AA64PFR1_EL1_SME;
+	if (!kvm_has_sme(vcpu->kvm))
+		val &= ~ID_AA64PFR1_EL1_SME;
+
 	val &= ~ID_AA64PFR1_EL1_RNDR_trap;
 	val &= ~ID_AA64PFR1_EL1_NMI;
 	val &= ~ID_AA64PFR1_EL1_GCS;
@@ -2316,6 +2323,15 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 		user_val |= hw_val & ID_AA64PFR1_EL1_MTE_frac_MASK;
 	}
 
+	/*
+	 * Prevent userspace removing SME from the ID registers while
+	 * leaving the capability enabled, avoiding potential bugs.
+	 */
+	if (kvm_has_sme(vcpu->kvm) &&
+	    SYS_FIELD_GET(ID_AA64PFR1_EL1, SME, user_val) == 0)
+		user_val |= SYS_FIELD_PREP(ID_AA64PFR1_EL1, SME,
+					   ID_AA64PFR1_EL1_SME_IMP);
+
 	return set_id_reg(vcpu, rd, user_val);
 }
 
@@ -3119,8 +3135,11 @@ static bool access_imp_id_reg(struct kvm_vcpu *vcpu,
 		return access_id_reg(vcpu, p, r);
 
 	/*
-	 * Otherwise, fall back to the old behavior of returning the value of
-	 * the current CPU.
+	 * Otherwise, fall back to the old behavior of returning the
+	 * value of the current CPU for REVIDR_EL1 and AIDR_EL1, or
+	 * use whatever the sanitised reset value we have is for other
+	 * registers not exposed prior to writability support for
+	 * these registers.
 	 */
 	switch (reg_to_encoding(r)) {
 	case SYS_REVIDR_EL1:
@@ -3129,6 +3148,9 @@ static bool access_imp_id_reg(struct kvm_vcpu *vcpu,
 	case SYS_AIDR_EL1:
 		p->regval = read_sysreg(aidr_el1);
 		break;
+	case SYS_SMIDR_EL1:
+		p->regval = read_id_reg(vcpu, r);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 	}
@@ -3139,12 +3161,15 @@ static bool access_imp_id_reg(struct kvm_vcpu *vcpu,
 static u64 __ro_after_init boot_cpu_midr_val;
 static u64 __ro_after_init boot_cpu_revidr_val;
 static u64 __ro_after_init boot_cpu_aidr_val;
+static u64 __ro_after_init boot_cpu_smidr_val;
 
 static void init_imp_id_regs(void)
 {
 	boot_cpu_midr_val = read_sysreg(midr_el1);
 	boot_cpu_revidr_val = read_sysreg(revidr_el1);
 	boot_cpu_aidr_val = read_sysreg(aidr_el1);
+	if (system_supports_sme())
+		boot_cpu_smidr_val = read_sysreg_s(SYS_SMIDR_EL1);
 }
 
 static u64 reset_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
@@ -3156,6 +3181,8 @@ static u64 reset_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		return boot_cpu_revidr_val;
 	case SYS_AIDR_EL1:
 		return boot_cpu_aidr_val;
+	case SYS_SMIDR_EL1:
+		return boot_cpu_smidr_val & r->val;
 	default:
 		KVM_BUG_ON(1, vcpu->kvm);
 		return 0;
@@ -3204,6 +3231,16 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	.val = mask,					\
 	}
 
+#define IMPLEMENTATION_ID_FILTERED(reg, mask, reg_visibility) {	\
+	SYS_DESC(SYS_##reg),				\
+	.access = access_imp_id_reg,			\
+	.get_user = get_id_reg,				\
+	.set_user = set_imp_id_reg,			\
+	.reset = reset_imp_id_reg,			\
+	.visibility = reg_visibility,			\
+	.val = mask,					\
+	}
+
 static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	__vcpu_assign_sys_reg(vcpu, r->reg, vcpu->kvm->arch.nr_pmu_counters);
@@ -3320,7 +3357,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				       ID_AA64PFR1_EL1_MTE_frac |
 				       ID_AA64PFR1_EL1_NMI |
 				       ID_AA64PFR1_EL1_RNDR_trap |
-				       ID_AA64PFR1_EL1_SME |
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
@@ -3331,7 +3367,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		     ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
-	ID_HIDDEN(ID_AA64SMFR0_EL1),
+	ID_WRITABLE(ID_AA64SMFR0_EL1, ~ID_AA64SMFR0_EL1_RES0),
 	ID_UNALLOCATED(4,6),
 	ID_WRITABLE(ID_AA64FPFR0_EL1, ~ID_AA64FPFR0_EL1_RES0),
 
@@ -3544,6 +3580,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
 	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
+	IMPLEMENTATION_ID_FILTERED(SMIDR_EL1,
+				   (SMIDR_EL1_NSMC | SMIDR_EL1_HIP |
+				    SMIDR_EL1_AFFINITY2 |
+				    SMIDR_EL1_IMPLEMENTER |
+				    SMIDR_EL1_REVISION | SMIDR_EL1_SH |
+				    SMIDR_EL1_AFFINITY),
+				   sme_visibility),
 	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	ID_FILTERED(CTR_EL0, ctr_el0,

-- 
2.47.3

