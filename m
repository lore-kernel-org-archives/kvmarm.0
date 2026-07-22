Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9527D4746A2;
	Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706183; cv=none; b=rkeQLUgHFJ/u3bSuPQAPyYBdWaG/goGiuKIuvWHy6yNueNoC72IljMXkm9QUfKLU7ffPJiTamZ6NN2ZlQg74z/WrICFW9NoYI04Q1Q3cjLJKs5jVhIiLdLx5uCt9WPh24uP2Zpo9gitc/rvdKu4xcHDzLLEYL6XFxLIZx2VaM70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706183; c=relaxed/simple;
	bh=1a6g0FUNYjctw5B94xyjRpZGAbx7YJm1TxMbIoRmB4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcTLq9m8n5PpFYwOmZ0+uHaw3ZtrwjK4NWtQzVSjqgNLuO1WuIUzBxVt0D9ETfVAynXhiP3ZWtkBYgJFFcXr1Zg3JnZ39pDBHIun1YBb7gYU4KS9nluNqzi+Xg5QvP29JpKAPPGJOWyEIdDZhmP/uyITC/85o8q6T/htPaK+FNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PyfsmJiX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PyfsmJiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E071F000E9;
	Wed, 22 Jul 2026 07:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706180;
	bh=xvfRoiVVXMz5ozRg++qNQ5fER4Qs3LDX4/NpXBs7HWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyfsmJiXqK5QYaIox8z01Y3O4loGKP5br4n2s6FW9QPJVoqlSz9dWpUJh5jXi4w48
	 FaUH/kgVY9eRAE7KklrjIavGow2cc5jNfDubUknEhdW7tVRmk38L3UWkimFMCAPGKT
	 Yllsf2if0cpFy895uq/UjJQXmIyI1+AgwUGLhcRtAPvD5ZRjQqSiyYL9vf0/A4IbxD
	 MLeJNAQudSf666YnmRdnKR6Cs0g3ZSEVLi7z4Bu2jOZgpcebQaowmtcXpOmFCpKdpO
	 xXExTHExiZ4bSRk2S+M8r21zChwAYb4ZmbvoY7t8dv2HAAhpEX2zYLQV78ECV0+98M
	 eKuG49/FyoaQw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbX-00000007VfN-0j8g;
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
Subject: [PATCH v3 22/28] KVM: arm64: Add routing for NVHCR_EL2 trap
Date: Wed, 22 Jul 2026 08:42:28 +0100
Message-ID: <20260722074234.3330999-23-maz@kernel.org>
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

NVHCR_EL2 accesses from EL1 are taken to EL2 when HCRX_EL2.NVTGE==0
and HCR_EL2.NV==1. Describe this in the exception routing tables.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b7f3d86a94031..625604019fb32 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -136,6 +136,8 @@ enum cgt_group_id {
 	CGT_CPTR_TTA,
 	CGT_MDCR_HPMN,
 
+	CGT_HCR_NV_HCRX_nNVTGE,
+
 	/* Must be last */
 	__NR_CGT_GROUP_IDS__
 };
@@ -588,6 +590,15 @@ static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
 	return BEHAVE_HANDLE_LOCALLY;
 }
 
+static enum trap_behaviour check_hcr_nv_hcrx_nnvtge(struct kvm_vcpu *vcpu)
+{
+	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV) &&
+	    !(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE))
+		return BEHAVE_FORWARD_RW;
+
+	return BEHAVE_HANDLE_LOCALLY;
+}
+
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
@@ -598,6 +609,7 @@ static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1NVVCT, check_cnthctl_el1nvvct),
 	CCC(CGT_CPTR_TTA, check_cptr_tta),
 	CCC(CGT_MDCR_HPMN, check_mdcr_hpmn),
+	CCC(CGT_HCR_NV_HCRX_nNVTGE, check_hcr_nv_hcrx_nnvtge),
 };
 
 /*
@@ -853,6 +865,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_SCTLR2_EL2,		CGT_HCR_NV),
 	SR_RANGE_TRAP(SYS_HCR_EL2,
 		      SYS_HCRX_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_NVHCR_EL2,		CGT_HCR_NV_HCRX_nNVTGE),
 	SR_TRAP(SYS_SMPRIMAP_EL2,	CGT_HCR_NV),
 	SR_TRAP(SYS_SMCR_EL2,		CGT_HCR_NV),
 	SR_RANGE_TRAP(SYS_TTBR0_EL2,
-- 
2.47.3

