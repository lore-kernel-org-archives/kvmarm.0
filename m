Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E59A3BB106;
	Thu, 30 Jul 2026 07:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395469; cv=none; b=KjPDH7rKqVvkP1lbiktdTTL3q+rxM8UbQ3JFxEHOHN8GKg88XM7XzqX/BE+fV9ZcjL3wwAsO9kEShm/235jHIzXx6q59Ie3rbI1Z/gXPjJl3j/0CWlPrVUyCuRSsfm2x6zpTz+3OnRN5SFcj7VxfYYwNx2MHsga4HqgziZoEeEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395469; c=relaxed/simple;
	bh=+AC0ZAnxae81VfoQo1YmtmSDnC5nuOsQgviqngbcL+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+OoITlzFPsLNxggH9DCoc2DlJv9mp9W8Ih8dHS9EVUfMcMLNk7OgSCdH0UjMLmbwkSCUbf8sOxdWVvZyCn1u+lc6tb5HjmfQ4IUOBzPzUnMsgoXOaVkGUfPuesTQyU/xbE242BDGtnSMOnaesr7A1DpxxXs4QsIOZ2+xUxeDUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGr7vw+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGr7vw+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898621F0155F;
	Thu, 30 Jul 2026 07:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395454;
	bh=nyIGlzMp8KtUkHTmmzLTDwn4GTo9DZ59gUjGug7RCBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGr7vw+T41uqCaXxsaoPdQR+aOs1OBcAXAatKBrNpXTCyEO7mgZ6bAl/WI+ZkbS7k
	 YWjkgq5EsQnh79Ocs5UuD1cM7JIBaaiASwPobLVrkKRibOqmGkYGDEr+HeUJuH+2m8
	 33xDAGsjdd3GMeKoPgdxs1v5rCHAFtdF/lyPeukBnl7yDcBKEeYCemBVL4W0/pqWV8
	 rVNWrAgPVdkkiAJUty4wi8R4ny3k2FSkgJFkgwDQe7ZPl3wPyDB+b/LenowxZeaijv
	 ODauhJUWEkjVSlwo0AQIfIHxo8l4nDwXAepnSxMkPQSKkqahZL2Bu5mLdBFvoVWcjT
	 2RpJBJ/JlpcRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKuq-0000000AOpW-3qi1;
	Thu, 30 Jul 2026 07:10:52 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 21/29] KVM: arm64: Add NVHCR_EL2 handling to the sysreg array
Date: Thu, 30 Jul 2026 08:10:14 +0100
Message-ID: <20260730071022.296811-22-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
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

