Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFA92E11D7
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995634; cv=none; b=u4U6S/Y//93kETgrdSduNFH9BK3RKR5PPP9ZfQB+SMKvX+Emubw8nhITh8hW0IYN5Akikski8GNMYN+e65Eeb86WLnAtEweprkOqQXvZJFpwYO8bSocGjVP2mos6VzR6zZwgt5tB1ghQtldvBdBecDDkqPpbaTCNIwlFnSSa10s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995634; c=relaxed/simple;
	bh=uCBw3AtgFt8N72/ZpRNM636YaZb3uOWTrqU3LR6BIe0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dehb6y7kOnbb20Vdjag9rvDKQgPcVdP1Yd/rP45yu8BXmHmG4JTUHlI+kdcCHCbGb598QjdS2+oBTqCpXTotX4dXL2u1dwyekN5C+8XqFwnKf+hzRKv6rB2foi+SraVdyAGgjma+B6STUTKseDLWftJEi4PQIfiBG+HQgpvIzH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kLu495BY; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kLu495BY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1cWWV49gtfooix8nIqQE0wE7VSsIXEg2dWHBkJBExy4=;
	b=kLu495BYaB24OVegVjubw96Y5Wl/3Dk53eS5MzLPLCr1gM7YsILwpVivVpgKr/WJVc/+/y
	RuBwaMeUB8QwDfezxuRKbWYKRdbZ6B0nDiZwNODozwayrSNib0PGbq358RsZnhrwpGHq3k
	rwFaqsmlTXUVCYcJHi5YE34ipxGIGI0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 11/27] KVM: arm64: Wire up SCTLR2_ELx sysreg descriptors
Date: Tue,  8 Jul 2025 10:25:16 -0700
Message-Id: <20250708172532.1699409-12-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Set up the sysreg descriptors for SCTLR2_ELx, along with the associated
storage and VNCR mapping.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h     |  7 +++++++
 arch/arm64/include/asm/vncr_mapping.h |  1 +
 arch/arm64/kvm/sys_regs.c             | 20 ++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 20d63ece3138..e54d29feb469 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -523,6 +523,7 @@ enum vcpu_sysreg {
 	/* Anything from this can be RES0/RES1 sanitised */
 	MARKER(__SANITISED_REG_START__),
 	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
+	SCTLR2_EL2,	/* System Control Register 2 (EL2) */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 
@@ -537,6 +538,7 @@ enum vcpu_sysreg {
 	VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
 	VNCR(TCR_EL1),	/* Translation Control Register */
 	VNCR(TCR2_EL1),	/* Extended Translation Control Register */
+	VNCR(SCTLR2_EL1), /* System Control Register 2 */
 	VNCR(ESR_EL1),	/* Exception Syndrome Register */
 	VNCR(AFSR0_EL1),/* Auxiliary Fault Status Register 0 */
 	VNCR(AFSR1_EL1),/* Auxiliary Fault Status Register 1 */
@@ -1204,6 +1206,7 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
 	case ZCR_EL1:		*val = read_sysreg_s(SYS_ZCR_EL12);	break;
+	case SCTLR2_EL1:	*val = read_sysreg_s(SYS_SCTLR2_EL12);	break;
 	default:		return false;
 	}
 
@@ -1254,6 +1257,7 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
 	case ZCR_EL1:		write_sysreg_s(val, SYS_ZCR_EL12);	break;
+	case SCTLR2_EL1:	write_sysreg_s(val, SYS_SCTLR2_EL12);	break;
 	default:		return false;
 	}
 
@@ -1685,6 +1689,9 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_ras(k)					\
 	(kvm_has_feat((k), ID_AA64PFR0_EL1, RAS, IMP))
 
+#define kvm_has_sctlr2(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
+
 static inline bool kvm_arch_has_irq_bypass(void)
 {
 	return true;
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index f4ec53166d8e..f6ec500ad3fa 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -51,6 +51,7 @@
 #define VNCR_SP_EL1             0x240
 #define VNCR_VBAR_EL1           0x250
 #define VNCR_TCR2_EL1		0x270
+#define VNCR_SCTLR2_EL1		0x278
 #define VNCR_PIRE0_EL1		0x290
 #define VNCR_PIR_EL1		0x2A0
 #define VNCR_POR_EL1		0x2A8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b6d75d473ab8..a3dacfce2e5b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -144,6 +144,7 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
 		MAPPED_EL2_SYSREG(ZCR_EL2,     ZCR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(CONTEXTIDR_EL2, CONTEXTIDR_EL1, NULL	     );
+		MAPPED_EL2_SYSREG(SCTLR2_EL2,  SCTLR2_EL1,  NULL	     );
 	default:
 		return false;
 	}
@@ -2483,6 +2484,21 @@ static unsigned int vncr_el2_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int sctlr2_visibility(const struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *rd)
+{
+	if (kvm_has_sctlr2(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static unsigned int sctlr2_el2_visibility(const struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	return __el2_visibility(vcpu, rd, sctlr2_visibility);
+}
+
 static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -2955,6 +2971,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
+	{ SYS_DESC(SYS_SCTLR2_EL1), access_vm_reg, reset_val, SCTLR2_EL1, 0,
+	  .visibility = sctlr2_visibility },
 
 	MTE_REG(RGSR_EL1),
 	MTE_REG(GCR_EL1),
@@ -3302,6 +3320,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(VMPIDR_EL2, reset_unknown, 0),
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
+	EL2_REG_FILTERED(SCTLR2_EL2, access_vm_reg, reset_val, 0,
+			 sctlr2_el2_visibility),
 	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
 	EL2_REG(MDCR_EL2, access_mdcr, reset_mdcr, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
-- 
2.39.5

