Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4901A3ABE;
	Wed, 11 Sep 2024 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062720; cv=none; b=I0CPHYGNIVOvTqMWccU6iWU17E4z8zpvvWO5U41Bpocs/pstKybQrJCwvYyryJq284cHB6QK+Jli+/EPHU80scVtA/fHASbCmkO7+KBM8aW6gPkkRaYAX7dhWjlc8+dzdMEeAI7b/0ATSf0eznFs/KyKjT1zNlKrtJ2ZbmsftTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062720; c=relaxed/simple;
	bh=aoz1Bb53hTRUp41pPRfVm6sJcysjHwU0cagBi4hT464=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rbVquELNav1qh+exuRX/fmhWauJoCNQaQmC22MF0cCkL/f3Jf4BpBMDu57V7FPESvhuV0xS//yqzoLIx2AJ3+4v6T68UxL85zfJLfznInIsf/1VIy9LTHlK4URxFGsqzrbMb/2u5scdXq6jTsnOqAo5laFinUjM8PRvKrZxNVxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GE4Wh0bT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GE4Wh0bT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D64FC4CEC0;
	Wed, 11 Sep 2024 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062720;
	bh=aoz1Bb53hTRUp41pPRfVm6sJcysjHwU0cagBi4hT464=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GE4Wh0bTK8kwocFaSQsIBhSH6MO3w0pqHjm8jwXaxd17cvoIWXlNao2xmDR1/bSyg
	 sK7Cy3CzJWov4GaeZOU2tnS5oT50jeXlS72It42SmILOLvtzoVy2t1Ud+P7WQPsZlB
	 wvIEbKlYdta5vUFyO8I1smGjk/ZUMxUvtz3VeksMfh9Xze1jQ4q2wIXzwQlxEFdJvd
	 y0bLCG+Soszx0SwyoRLQncVxBbOZdrjaQ8Fxv4F/HpGXRQ+liZGTS2K3ofjFsinTT/
	 GRnK2vAg99Tu+ZqznYdRgRTe9fkSfln/Qc84CQPNN+ilRTbWbvUstlFgrWthhTWgWJ
	 9bbpM2u6tjccw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlG-00C7tL-9Z;
	Wed, 11 Sep 2024 14:51:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 10/24] KVM: arm64: Add TCR2_EL2 to the sysreg arrays
Date: Wed, 11 Sep 2024 14:51:37 +0100
Message-Id: <20240911135151.401193-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the TCR2_EL2 register to the per-vcpu sysreg register array,
the sysreg descriptor array, and advertise it as mapped to TCR2_EL1
for NV purposes.

Access to this register is conditional based on ID_AA64MMFR3_EL1.TCRX
being advertised.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bb65da14963d4..fac6c458afc79 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -486,6 +486,7 @@ enum vcpu_sysreg {
 
 	/* Anything from this can be RES0/RES1 sanitised */
 	MARKER(__SANITISED_REG_START__),
+	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
 
 	/* Any VNCR-capable reg goes after this point */
 	MARKER(__VNCR_START__),
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8fce896685b9c..886ff9557d14c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -126,6 +126,7 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		MAPPED_EL2_SYSREG(ESR_EL2,     ESR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(FAR_EL2,     FAR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(MAIR_EL2,    MAIR_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(TCR2_EL2,    TCR2_EL1,    NULL	     );
 		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
@@ -448,6 +449,18 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_tcr2_el2(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	return access_rw(vcpu, p, r);
+}
+
 static bool access_actlr(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -2795,6 +2808,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
+	EL2_REG(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
-- 
2.39.2

