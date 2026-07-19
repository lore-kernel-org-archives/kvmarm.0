Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C567C386541;
	Sun, 19 Jul 2026 23:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502677; cv=none; b=fUsS0oKcKZaaVV6Af6owXqB0wBytrsI77kix5ExfklGRViStlZplodv2ab89Sba8VKsNr9q9xG+nU+pgtPAi0EkjnBXCPtf6gNm7aEJ/OJ5QJNzATzXGZkabMoeUVhSkAIRlAZeB8H8UDiuouirt6EQe5YuKN5+N+DWlR/rKjHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502677; c=relaxed/simple;
	bh=H+o/3748vgny3lGilz48bxpWfmNuNNC3E7l3zKXni58=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aSNbw+JbSSBwhadwb/nOL5xVlRxWijHDiYMIj+4ONq0y0nkyRUIkQFRhUUdEDKI38JdOzR4hkv/iCf5C8y1VJt+EjYnoGFpvXu1xEusTB+VWWs/lqVXMxDCF72WjOhze9Tj7oxxXezcbwHvuD/O3xuqXU3y32UplFoMJMtdaIrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CR+AGo53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CR+AGo53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC421F0155D;
	Sun, 19 Jul 2026 23:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502675;
	bh=J1zy4AKaHiqNQMXG5h+LXU01eSdMuOzbdR0P6vsnTdA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CR+AGo53oGMaQUwOjnmXma5GmYVF5o/SepsWJGYHNUf7HJ8TR7x9J5kLdj2IClBPj
	 WyoOnqjRTPv5ljDWLgUV+qgOXvt8s5n3bwEE9/4Rr4sHH37wWv8ui+VqL+beI0uLbM
	 QoNNYSxhuYsxiIRTOrMjVYJp4Fj59zOkQVMxs5PPur3pm2djv5x8hFqjkTt9WjOm82
	 eNv/5gbX+zTzNuwEU0yVdg4l3ooWE1sRVJMCic+eAhO1x4DpuqvsH8ACxxNOUY9TzJ
	 18ktmc/+oqQGiGRjFyHEIwuatdXDIoXC5s4EwapW6GYzzuQo/VmkJxjpx/GjWlqSbS
	 ig8O7e3YIo9oQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:45 +0100
Subject: [PATCH v13 18/32] KVM: arm64: Support SME control registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-18-d9abd3ffa245@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7447; i=broonie@kernel.org;
 h=from:subject:message-id; bh=H+o/3748vgny3lGilz48bxpWfmNuNNC3E7l3zKXni58=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVk188gckL59zgCkDG26AMosOkiyC8cqSWqM2
 9xeUsl7p0GJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZNQAKCRAk1otyXVSH
 0EZXB/9VPLqT4wWMIEOBirPK12gveDEDPbIVu+XFQ65v3JS5ZmksL7X7stlxE5cEy1jntxH0jDC
 dk3X851UHuxqt9q5XWbq4OybuDKnou0JXk7rVXhu7m391QXJiUtbt5QvrhUjFvptDMiJ8/1mHzq
 68EORrVaQsMx2hSi0rEJmEQMl+KaCrB6NvYMumYVIMDneDNpn/Do+GpXDpKG5d1D/q68uM7wt4u
 MIBKurzwXVONibhANXllZX1m9lqSwYyRc7rr+gg1UcKGCN1qXkr5oKT+xsNvxYx5AiuPD5U5AEg
 5+05IQORhZUXhxmntceE9NsgmAQETa3K41Dg72est0yejA7J
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

