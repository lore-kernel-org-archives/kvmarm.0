Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F650156256
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902034; cv=none; b=I+SG8IuiG8EGlZk0xScsqva9FIxa2ExJ7Vqz6CKNtzgpTaBrIL+A/ZnC67ypQUrEvU6lU/+GiNcJ2hDzw64mq3gJw1T9ke+PX5EnFlZeiUIW+QUbZBo0E4BPZt0bf+/8m1WCgeXAfkWVrXWrH+Klzv62HEnAqsp7O2kyOFXJi8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902034; c=relaxed/simple;
	bh=SIQZqzQaFcBJrCKiOWUNha8OzuNiWrEQ8pZ8emdsv+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6ExAIOBvJ9VkhljGl+xkTVzrRACHruUo5d8kFtfyiaCmhoy59thpakc+oUtPcTq0tgVL84BmZiHgchZPmeZS0bz0Mz/JdopO6FDr7aYxf2xe85CSoY2ExW3oaOwV2N4piqFDt9Y9NLql5i+77wWmdX93ztVHtao+SHVAqu8/Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sr92Ybfe; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sr92Ybfe"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3aRGFWE/WQp/6kn+do3vtR0T38O3nr9oCPqc1hpA8o=;
	b=sr92YbfeOPHxAhqEwftdGMmmW4Sg0XkJza3cBXO3oIEvAUQb/bO64CtRgcdDSd3wsthSyF
	0CR0oIaXiguRVwDy7c15Bo6Z4lmh/i5ZEd+aTrx9JElKANZPQKlzpk3ErCIbQYjL3D1QrR
	hQqQ5WfsEI8B0iUjolPZj9UU9jhINqk=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 03/15] KVM: arm64: nv: Handle ZCR_EL2 traps
Date: Thu, 20 Jun 2024 16:46:40 +0000
Message-ID: <20240620164653.1130714-4-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Unlike other SVE-related registers, ZCR_EL2 takes a sysreg trap to EL2
when HCR_EL2.NV = 1. KVM still needs to honor the guest hypervisor's
trap configuration, which expects an SVE trap (i.e. ESR_EL2.EC = 0x19)
when CPTR traps are enabled for the vCPU's current context.

Otherwise, if the guest hypervisor has traps disabled, emulate the
access by mapping the requested VL into ZCR_EL1.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h |  8 ++++++
 arch/arm64/include/asm/kvm_host.h    |  3 +++
 arch/arm64/kvm/sys_regs.c            | 38 ++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cc5c93b46e6f..15c70f1ebeb3 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -56,6 +56,14 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
 int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
 int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
 
+static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
+{
+	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SVE) |
+		  ESR_ELx_IL;
+
+	kvm_inject_nested_sync(vcpu, esr);
+}
+
 #if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..5a114720fd57 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -422,6 +422,7 @@ enum vcpu_sysreg {
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
+	ZCR_EL2,	/* SVE Control Register (EL2) */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
@@ -968,6 +969,7 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
+	case ZCR_EL1:		*val = read_sysreg_s(SYS_ZCR_EL12);	break;
 	default:		return false;
 	}
 
@@ -1013,6 +1015,7 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
+	case ZCR_EL1:		write_sysreg_s(val, SYS_ZCR_EL12);	break;
 	default:		return false;
 	}
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..80aa99a012ae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -121,6 +121,7 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(ZCR_EL2,     ZCR_EL1,     NULL	     );
 	default:
 		return false;
 	}
@@ -2199,6 +2200,40 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return __vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
+static unsigned int sve_el2_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	unsigned int r;
+
+	r = el2_visibility(vcpu, rd);
+	if (r)
+		return r;
+
+	return sve_visibility(vcpu, rd);
+}
+
+static bool access_zcr_el2(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	unsigned int vq;
+
+	if (guest_hyp_sve_traps_enabled(vcpu)) {
+		kvm_inject_nested_sve_trap(vcpu);
+		return true;
+	}
+
+	if (!p->is_write) {
+		p->regval = vcpu_read_sys_reg(vcpu, ZCR_EL2);
+		return true;
+	}
+
+	vq = SYS_FIELD_GET(ZCR_ELx, LEN, p->regval) + 1;
+	vq = min(vq, vcpu_sve_max_vq(vcpu));
+	vcpu_write_sys_reg(vcpu, vq - 1, ZCR_EL2);
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2688,6 +2723,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(HFGITR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HACR_EL2, reset_val, 0),
 
+	{ SYS_DESC(SYS_ZCR_EL2), .access = access_zcr_el2, .reset = reset_val,
+	  .visibility = sve_el2_visibility, .reg = ZCR_EL2 },
+
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
-- 
2.45.2.741.gdbec12cfda-goog

