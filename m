Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A7E472F99;
	Wed, 22 Jul 2026 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706183; cv=none; b=ZABMNPAzagZPEhjM1zxdAgpFv7hvgrPKaUtGnR74nSGBVC0clP3seiT7J1Wov1q153z6A0SMvN3GhCdIuKK29/HO6V3iRm2wV1jaDI7rSYpFOyPLhih1Sj8Hpjp/ywYXcsDxb3UiFAcnqMxCUogM959stvGr4dVCgC1I9UMceYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706183; c=relaxed/simple;
	bh=+AC0ZAnxae81VfoQo1YmtmSDnC5nuOsQgviqngbcL+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHwmAlrxyMS/bakm9PQxVADA2MovB16uB8tbfGT2Axbysx8ldiUtHE/b0Bbgtxbedsx+g4/l7TeXZKuMX/SDm2LkIQp/KfuQUp23O0y+G16LrFvQ9oAoVAIMgxk0JBCil9PPzM3bGq6HX/M47M5m4mIFsZdg2OVjYF1o7kfmpjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TaelijfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TaelijfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A050E1F01564;
	Wed, 22 Jul 2026 07:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706180;
	bh=nyIGlzMp8KtUkHTmmzLTDwn4GTo9DZ59gUjGug7RCBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaelijfD72iwipgFCmGA/AUi2T3n/3bSJbgipGJHBkv0bsgEhc1mNqKoaKRGfRDjU
	 L/+MrLKTAv6+kIcfPOSa6kUAAVR144c04Akvrx6glBJRjtTKjguY9smmbULWd9tz2A
	 UVQXATcUZUbvaEoEyrQ5iO3oUm9aLwJfnFs18oKjQjjXZBKP4GtPSNOF5Krz/STKTj
	 ifBFq4ejPldU/ruYmipy2WCeKGOcseC4Ki6G3G8lxOdQmW2H8VBKyo4NDZKiJvD5AJ
	 2l78lve8fCDZF4SHLdW2W50bdLz2gVKSAm9SAPLV+Ok1gbJQFPmPREx8rINRlDK51+
	 hEsqFMCcyiBXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbW-00000007VfN-3wf8;
	Wed, 22 Jul 2026 07:42:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 21/28] KVM: arm64: Add NVHCR_EL2 handling to the sysreg array
Date: Wed, 22 Jul 2026 08:42:27 +0100
Message-ID: <20260722074234.3330999-22-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Expose NVHCR_EL2 to userspace, and treat the direct access as UNDEF,
as that would only outline a bug in our exception routing.

The generic accessors are also updated to deal with the relatively
uncommon location of that register.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9439c5b2b1fe8..0aeb2e736fde3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -221,6 +221,20 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
 		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
 			loc->loc = SR_LOC_SPECIAL;
 		break;
+	case NVHCR_EL2:
+		/*
+		 * Yes, NVHCR_EL2 maps to itself when loaded in nested
+		 * context. If you feel like the architecture is double
+		 * backing on itself upside down, you're not alone.
+		 */
+		WARN_ON_ONCE(!kvm_has_nv3(vcpu->kvm));
+		if (is_hyp_ctxt(vcpu)) {
+			loc->loc = SR_LOC_MEMORY;
+		} else {
+			loc->loc = SR_LOC_LOADED | SR_LOC_MAPPED;
+			loc->map_reg = NVHCR_EL2;
+		}
+		break;
 	default:
 		loc->loc = locate_direct_register(vcpu, reg);
 	}
@@ -260,6 +274,7 @@ static u64 read_sr_from_cpu(enum vcpu_sysreg reg)
 	case DACR32_EL2:	val = read_sysreg_s(SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	val = read_sysreg_s(SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
+	case NVHCR_EL2:		val = read_sysreg_s(SYS_NVHCR_EL2);	break;
 	default:		WARN_ON_ONCE(1);
 	}
 
@@ -298,6 +313,7 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
 	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
+	case NVHCR_EL2:		write_sysreg_s(val, SYS_NVHCR_EL2);	break;
 	default:		WARN_ON_ONCE(1);
 	}
 }
@@ -2861,6 +2877,16 @@ static unsigned int vncr_el2_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int nvhcr_el2_visibility(const struct kvm_vcpu *vcpu,
+					const struct sys_reg_desc *rd)
+{
+	if (el2_visibility(vcpu, rd) == 0 &&
+	    kvm_has_feat(vcpu->kvm, ID_AA64MMFR4_EL1, NV_frac, NV3))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static unsigned int sctlr2_visibility(const struct kvm_vcpu *vcpu,
 				      const struct sys_reg_desc *rd)
 {
@@ -3774,6 +3800,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			 sve_el2_visibility),
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
+	EL2_REG_FILTERED(NVHCR_EL2, undef_access, reset_val, 0,
+			 nvhcr_el2_visibility),
 
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
-- 
2.47.3

