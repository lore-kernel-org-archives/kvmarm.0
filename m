Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2861D435F
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214482; cv=none; b=lMiy6faS4ksJCBr7j5ddvZunukKQZ+jnz4QITo3JCjfqi/IxGANBkbdw0YB+3ZclMnzjPuigwpS2/8UGO/21dxqXu+lnc079d+T7LWJNr9mJc9FdBfYIY7fVewl4In9nG4rAkDQWXXaVyq/q5ulKQ3+u54axZRr7t71L4yrp1vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214482; c=relaxed/simple;
	bh=BjxW262jWOvORosPq7PxX/9CsrLeqavdc93cs9tr2cA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eFliSMHxqDHhaxsxR9loB+PRwZpmSIZQqoxAe/zN1EyMYJ8VGF0vlit2wFHEqpbLWxuZRLdg8zDIXXf5khzMEX52zlh4p8fEiCIO1J5coZ5+xO+DooJTWjQnY4hixGu1/4/DPhVItsqSAwdfhk2bnITFmZs4oFghmyVcC17wlDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0iZNYm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0iZNYm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56269C4CEE3;
	Wed,  9 Apr 2025 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214482;
	bh=BjxW262jWOvORosPq7PxX/9CsrLeqavdc93cs9tr2cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0iZNYm0uA4SOXE0iS3bvXrZxcCAuGwrO6QthjKYVT0kuhhLvfAj3tuA1HzKxLSAH
	 VdUBIRhREc8IQh03iFL8PsDqHDiGv6r+4CoxBVFsUznIldAHkE3ZAuLzaNBKBrVSBm
	 QszP/gnIoBv5wYfdjrJnzDZ6cmNjJW/b8JrENAHzO6+CH40mA7X+6iRB2coPhOe70r
	 SAzzurCQ6jeNBXd7LfRd+rM1UsX/m19T50oDIvUrNBPno0Wp82kQ2dq3pAidLwkkjQ
	 kCohmoiNB8iQWyOBH9foYl0qQM5bnHnJL++KPcT08mfVqqtKlgxl6DqWuaOtgrNXn2
	 Z03QEWvzrGADg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u2Xrc-003vQT-5y;
	Wed, 09 Apr 2025 17:01:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 1/6] KVM: arm64: Fix MDCR_EL2.HPMN reset value
Date: Wed,  9 Apr 2025 17:01:01 +0100
Message-Id: <20250409160106.6445-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250409160106.6445-1-maz@kernel.org>
References: <20250409160106.6445-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The MDCR_EL2 documentation indicates that the HPMN field has
the following behaviour:

"On a Warm reset, this field resets to the expression NUM_PMU_COUNTERS."

However, it appears we reset it to zero, which is not very useful.

Add a reset helper for MDCR_EL2, and handle the case where userspace
changes the target PMU, which may force us to change HPMN again.

Reported-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.c |  8 +++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a1bc10d7116a5..4dc4f3a473c3f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1033,6 +1033,19 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 
 	kvm->arch.arm_pmu = arm_pmu;
 	kvm->arch.pmcr_n = kvm_arm_pmu_get_max_counters(kvm);
+
+	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
+	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
+		struct kvm_vcpu *vcpu;
+		unsigned long i;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
+			val &= ~MDCR_EL2_HPMN;
+			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.pmcr_n);
+			__vcpu_sys_reg(vcpu, MDCR_EL2) = val;
+		}
+	}
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 005ad28f73068..73d68ea37ac21 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2698,6 +2698,12 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	.set_user = set_imp_id_reg,			\
 	.reset = reset_imp_id_reg,			\
 	.val = mask,					\
+	}
+
+static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	__vcpu_sys_reg(vcpu, r->reg) = vcpu->kvm->arch.pmcr_n;
+	return vcpu->kvm->arch.pmcr_n;
 }
 
 /*
@@ -3243,7 +3249,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
 	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
-	EL2_REG(MDCR_EL2, access_mdcr, reset_val, 0),
+	EL2_REG(MDCR_EL2, access_mdcr, reset_mdcr, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG_VNCR(HSTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HFGRTR_EL2, reset_val, 0),
-- 
2.39.2

