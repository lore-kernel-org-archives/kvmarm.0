Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B4582D93
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197267; cv=none; b=hqojI+21XuJdog1Rcab4Bx70k9947fV+6hiWyvbWdPPscCka+Tl0PBYso605PlNmPKQk0TWnYcuMyxHnivKI5TDasJLVKZSPOEOGg83FF4BSw8lglEMdnbARkURbNMO0rzIZmV0K6WqmCEVC53BpaUwYxldCgwQ7mJgUFKSZ7U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197267; c=relaxed/simple;
	bh=GQLmpLEJpZCcxYIrQKwBbYXAdNIe7Oqcd/jiMpVJ4hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFRC7TnJxcfeF2mzEdfKoT/qMgavDYqE047BrMCaSgCPLA9nMwx435KdbkxVyFMN9CgPI5MMWRUzPLf9DLZkmdT/lFSWySzCRc5GGlmYFixxlEAiOTi0AaKdC1Yyw9dfKVkeRQc0227Huc77Y8KqO6qmZQQpOm1eo7od73onkrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GsBamMFb; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GsBamMFb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6UxvKsGCyjIAUWY8dK13u5dkkNDiZQb2bow6ZF/6Aqk=;
	b=GsBamMFbbt0/DaM0h0j03fZ34YQfqQnUkIYf4Vj1+2rvfWVBvCqIKXbFWY9qF/M4gsAFOD
	KdDqsAugkSPxJN1lWDBIBfS3sRx8DizQXSIVWMXWuvQcf/aXucVat62mqycgMN2yAjDxpW
	9RTFB5dq/6Nc9QOTpigGkJhpPmctkx0=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 05/11] KVM: arm64: nv: Handle ZCR_EL2 traps
Date: Fri, 31 May 2024 23:13:52 +0000
Message-ID: <20240531231358.1000039-6-oliver.upton@linux.dev>
In-Reply-To: <20240531231358.1000039-1-oliver.upton@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
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

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
Notes, because I'm too lazy to respin before sending on a Friday:

 - I'll want to add a helper for synthesizing the SVE trap, open-coding
   it in the sysreg handler is gross.

 - The sysreg handler needs to check CPACR_ELx_FPEN in addition to _ZEN,
   like what I have now.

 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 40 +++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e01e6de414f1..aeb1c567dfad 100644
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
@@ -972,6 +973,7 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
+	case ZCR_EL1:		*val = read_sysreg_s(SYS_ZCR_EL12);	break;
 	default:		return false;
 	}
 
@@ -1017,6 +1019,7 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
+	case ZCR_EL1:		write_sysreg_s(val, SYS_ZCR_EL12);	break;
 	default:		return false;
 	}
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..a662e9d2d917 100644
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
@@ -2199,6 +2200,42 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
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
+	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SVE) |
+		  ESR_ELx_IL;
+	unsigned int vq;
+
+	if (guest_hyp_sve_traps_enabled(vcpu)) {
+		kvm_inject_nested_sync(vcpu, esr);
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
@@ -2688,6 +2725,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(HFGITR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HACR_EL2, reset_val, 0),
 
+	{ SYS_DESC(SYS_ZCR_EL2), .access = access_zcr_el2, .reset = reset_val,
+	  .visibility = sve_el2_visibility, .reg = ZCR_EL2 },
+
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
-- 
2.45.1.288.g0e0cd299f1-goog

