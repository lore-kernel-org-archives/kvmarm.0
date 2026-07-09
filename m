Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF344444715;
	Thu,  9 Jul 2026 18:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622476; cv=none; b=R9yZqAN+Wn2QZ11y2bdfASl9N/Mkl67SO+7uCvIfJKi1vs7g3PUnWODF/HBDGr+yTa5AptPCapbEWomFF8kuqEY+eE/hbp93Hne5BowCPIXQIWgMUrxlHDqTMB/ppSS77Mc5+svUzQa6yat1xA1V/6+XLu6k6kIGmOLfQKoaCKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622476; c=relaxed/simple;
	bh=H+o/3748vgny3lGilz48bxpWfmNuNNC3E7l3zKXni58=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V3VDUD/i9uqbNVt59CsJVarApunjCimaYr4De283Kt2CjpRLj5X+gdSZvjLNzCD9M3tcj8mX3cFAg80P5iWNyWPF+C9HcgyIFzKTl1mcSKQwoDnjrbn7LFpPC0CqcR0FVgQXU6OvGpkVBL+x779zN5hwEUrEzepCN0GhZTZslNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUhHySC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUhHySC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D181F000E9;
	Thu,  9 Jul 2026 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622474;
	bh=J1zy4AKaHiqNQMXG5h+LXU01eSdMuOzbdR0P6vsnTdA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YUhHySC5ldJ9PzM+dEsvIupD2s4maZWvpTCWI1UMUQexsLzv5x8TP2rP2CaP9XJCL
	 Qx6Q/HI/MWEkSi4Tq2zaap1HFZcx9pLGQl/T6y/D7h8rOCly72mhF5TRG4HERYnbWP
	 24Re/R0xAE6qb+bkMSeGzhi5ZmtjqLEzu+/eMeyL6YScbGswcdNrR5EVEq0XXtZfmX
	 S6qKRAW/VmHeKI2JquWu3njRoILzW9v1xzvU72D1rOiVggYpj9jUfgsmP4ynJCsuKk
	 7jJhCA764xMDrXjMyqEZpmE+iAsFKHX1W9wvlcLUDaUHb8zHejba+BuFDCRLbhjYkp
	 kJoxWtj4eeLsg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:36 +0100
Subject: [PATCH v12 15/29] KVM: arm64: Support SME control registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-15-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7447; i=broonie@kernel.org;
 h=from:subject:message-id; bh=H+o/3748vgny3lGilz48bxpWfmNuNNC3E7l3zKXni58=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+r15HXbQAr5sSxD3/cE7n/6Cxgqwt33CFRqy
 RwZCrlpSN2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q9QAKCRAk1otyXVSH
 0EVTB/0bMXu3zQH8xEUX43SPjfSfn//HtgI9O+hBCXcrYAsokFH2mf4/raz44k2Pbyu+KJUl/BM
 8lNWqaaks6Pz79NxvyjNI4KK4tEsNGs6IYquMAwggmpE4RddUKxqP9az5L74qqSmZVjOwHmMz4e
 GO/a0eG4bWVTCVLMPHq8zmDqlR4rudyLHzD6RlzErZQAsDXSXGO0Ddv5iddaUfAuEyVjjmxXFxf
 cFAem8xXKiG8yZllU8i+MNdYdhzBLZjt5v0ViGVCO2GNZNFJ1FslJi3xm/rCVJWhavugVMzKcE/
 0WH29PuGrOi6hC3mZsQ/44xl9cwfRni3H1Qbtnoz8fH/D5MQ
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME is configured by the system registers SMCR_EL1 and SMCR_EL2, add
definitions and userspace access for them.  These control the SME vector
length in a manner similar to that for SVE and also have feature enable
bits for SME2 and FA64.  A subsequent patch will add management of them
for guests as part of the general floating point context switch, as is
done for the equivalent SVE registers.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h  | 15 +++++++++++++++
 arch/arm64/include/asm/kvm_host.h     |  2 ++
 arch/arm64/include/asm/vncr_mapping.h |  1 +
 arch/arm64/kvm/nested.c               |  5 +++++
 arch/arm64/kvm/sys_regs.c             | 31 ++++++++++++++++++++++++++++++-
 5 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 994afbf479fc..b5dc8a4c320a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -90,6 +90,15 @@ static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
 	kvm_inject_nested_sync(vcpu, esr);
 }
 
+static inline void kvm_inject_nested_sme_trap(struct kvm_vcpu *vcpu,
+					      u64 smtc)
+{
+	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SME) |
+		  ESR_ELx_IL | smtc;
+
+	kvm_inject_nested_sync(vcpu, esr);
+}
+
 #if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
@@ -689,4 +698,10 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
 	}
 }
+
+static inline bool guest_hyp_sme_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	return __guest_hyp_cptr_xen_trap_enabled(vcpu, SMEN);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 858341eb1e8f..796b6e3a50f7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -546,6 +546,7 @@ enum vcpu_sysreg {
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	ZCR_EL2,	/* SVE Control Register (EL2) */
+	SMCR_EL2,	/* SME Control Register (EL2) */
 
 	/* Any VNCR-capable reg goes after this point */
 	MARKER(__VNCR_START__),
@@ -554,6 +555,7 @@ enum vcpu_sysreg {
 	VNCR(ACTLR_EL1),/* Auxiliary Control Register */
 	VNCR(CPACR_EL1),/* Coprocessor Access Control */
 	VNCR(ZCR_EL1),	/* SVE Control */
+	VNCR(SMCR_EL1),	/* SME Control */
 	VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
 	VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
 	VNCR(TCR_EL1),	/* Translation Control Register */
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 14366d35ce82..c3bf92ac52d4 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -44,6 +44,7 @@
 #define VNCR_HDFGWTR_EL2	0x1D8
 #define VNCR_ZCR_EL1            0x1E0
 #define VNCR_HAFGRTR_EL2	0x1E8
+#define VNCR_SMCR_EL1		0x1F0
 #define VNCR_TTBR0_EL1          0x200
 #define VNCR_TTBR1_EL1          0x210
 #define VNCR_FAR_EL1            0x220
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index fb54f6dad995..50e25ab9b604 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1920,6 +1920,11 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	resx.res1 = ZCR_ELx_RES1;
 	set_sysreg_masks(kvm, ZCR_EL2, resx);
 
+	/* SMCR_EL2 - bits 8:4 are RAZ/WI so treat them as RES0 */
+	resx.res0 = SMCR_ELx_RES0 | GENMASK_ULL(8, 4);
+	resx.res1 = SMCR_ELx_RES1;
+	set_sysreg_masks(kvm, SMCR_EL2, resx);
+
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
 		__vcpu_rmw_sys_reg(vcpu, sr, |=, 0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ba8a3ed8f5ff..24bbe30c075a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -121,6 +121,7 @@ static enum sr_loc_attr locate_direct_register(const struct kvm_vcpu *vcpu,
 	case ELR_EL1:
 	case SPSR_EL1:
 	case ZCR_EL1:
+	case SMCR_EL1:
 	case SCTLR2_EL1:
 		/*
 		 * EL1 registers which have an ELx2 mapping are loaded if
@@ -241,6 +242,7 @@ static u64 read_sr_from_cpu(enum vcpu_sysreg reg)
 	case ELR_EL1:		val = read_sysreg_s(SYS_ELR_EL12);	break;
 	case SPSR_EL1:		val = read_sysreg_s(SYS_SPSR_EL12);	break;
 	case ZCR_EL1:		val = read_sysreg_s(SYS_ZCR_EL12);	break;
+	case SMCR_EL1:		val = read_sysreg_s(SYS_SMCR_EL12);	break;
 	case SCTLR2_EL1:	val = read_sysreg_s(SYS_SCTLR2_EL12);	break;
 	case TPIDR_EL0:		val = read_sysreg_s(SYS_TPIDR_EL0);	break;
 	case TPIDRRO_EL0:	val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
@@ -279,6 +281,7 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
 	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
 	case SPSR_EL1:		write_sysreg_s(val, SYS_SPSR_EL12);	break;
 	case ZCR_EL1:		write_sysreg_s(val, SYS_ZCR_EL12);	break;
+	case SMCR_EL1:		write_sysreg_s(val, SYS_SMCR_EL12);	break;
 	case SCTLR2_EL1:	write_sysreg_s(val, SYS_SCTLR2_EL12);	break;
 	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
 	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
@@ -2830,6 +2833,12 @@ static unsigned int sve_el2_visibility(const struct kvm_vcpu *vcpu,
 	return __el2_visibility(vcpu, rd, sve_visibility);
 }
 
+static unsigned int sme_el2_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	return __el2_visibility(vcpu, rd, sme_visibility);
+}
+
 static unsigned int vncr_el2_visibility(const struct kvm_vcpu *vcpu,
 					const struct sys_reg_desc *rd)
 {
@@ -2872,6 +2881,23 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_smcr_el2(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (guest_hyp_sme_traps_enabled(vcpu)) {
+		kvm_inject_nested_sme_trap(vcpu, ESR_ELx_SME_ISS_SMTC_SME_DISABLED);
+		return false;
+	}
+
+	if (!p->is_write)
+		p->regval = __vcpu_sys_reg(vcpu, SMCR_EL2);
+	else
+		__vcpu_assign_sys_reg(vcpu, SMCR_EL2, p->regval);
+
+	return true;
+}
+
 static bool access_gic_vtr(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -3386,7 +3412,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TRFCR_EL1), undef_access },
 	{ SYS_DESC(SYS_SMPRI_EL1), undef_access },
-	{ SYS_DESC(SYS_SMCR_EL1), undef_access },
+	{ SYS_DESC(SYS_SMCR_EL1), NULL, reset_val, SMCR_EL1, 0, .visibility = sme_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
@@ -3754,6 +3780,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
+	EL2_REG_FILTERED(SMCR_EL2, access_smcr_el2, reset_val, 0,
+			 sme_el2_visibility),
+
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),

-- 
2.47.3

