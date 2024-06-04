Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE218146019
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506360; cv=none; b=jC2kADtuNv/aB/BbUvjyhw48LG2IxBQMhuTcITNPEC6P3SMBCDC3T2p+LlI/bmsYvMXXkQn8hzAgppp0+Xd34mY7ccseyr/2sLBppVvqrCnN4RTeBVK2jNGjOAFcG9Y44hazHHIQDLUCa/VcnjdaZJtwOlHdMJWE9Z6hHLjRzlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506360; c=relaxed/simple;
	bh=QEFZI2brFAzQ8xk1Oq/yD8qdyEr5vfeWKcz+4devpzA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=irwyVdzewj4xK0RcY56dH4xV1kRjqounhgPyAkNXh2fWvmtSWHXqie1CNBPqlzPkatz5lnXF4ktXnfoD+0HlBaUqSj0AOmULx8Y8EdW65nV5JDlGmdkINMqWmkKRVfg/GfUitDYJJE1h/MuDsipOmpwmBCZHqe93b8IeO+c1B94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+bKlyLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+bKlyLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0711C4AF07;
	Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717506359;
	bh=QEFZI2brFAzQ8xk1Oq/yD8qdyEr5vfeWKcz+4devpzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+bKlyLoCkkW/Mhvfrlz2PgjMZgQ9QS3skUylMA1ijbFJ7QhxrNAW6B1XRC0r+GZ1
	 yLdp6Jy48id/wRvzgn3D3XU1HiQKvNxnM09Qp9S4yey1oHjZHRg+RTIxVwqQCY0xe7
	 Sg2aQyJtR7rpUR6lh7VptKZ44+WUY+Q/nAygJDka8AeNLNn7yB29yFCt1pjbU1v82C
	 rj7RTVCcpqd0lDC725az9BXfyC+Aysm2eVl1bkMhmjKhhiccg2u1EYWAys3ICXLyJ0
	 p7CbEw8ygWxGa56eZbBrufLW87hG0Uu6TyjLLvbq05l+zG15fM6ywpRBEWB0ePARU0
	 vdq+jyMdup9KQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sETrR-000ZSS-Ow;
	Tue, 04 Jun 2024 14:05:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 2/4] KVM: arm64: nv: Add trap description for CPTR_EL2
Date: Tue,  4 Jun 2024 14:05:51 +0100
Message-Id: <20240604130553.199981-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240604130553.199981-1-maz@kernel.org>
References: <20240604130553.199981-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add trap description for CPTR_EL2.{TCPAC,TAM,E0POE,TTA}.

TTA is a bit annoying as it changes location depending on E2H.
This forces us to add yet another "complex" trap condition.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 91 +++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 72d733c74a38..61e6b97c3e25 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -79,6 +79,10 @@ enum cgt_group_id {
 	CGT_MDCR_E2TB,
 	CGT_MDCR_TDCC,
 
+	CGT_CPACR_E0POE,
+	CGT_CPTR_TAM,
+	CGT_CPTR_TCPAC,
+
 	/*
 	 * Anything after this point is a combination of coarse trap
 	 * controls, which must all be evaluated to decide what to do.
@@ -106,6 +110,8 @@ enum cgt_group_id {
 	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
 	CGT_CNTHCTL_EL1PTEN,
 
+	CGT_CPTR_TTA,
+
 	/* Must be last */
 	__NR_CGT_GROUP_IDS__
 };
@@ -345,6 +351,24 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= MDCR_EL2_TDCC,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
+	[CGT_CPACR_E0POE] = {
+		.index		= CPTR_EL2,
+		.value		= CPACR_ELx_E0POE,
+		.mask		= CPACR_ELx_E0POE,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_CPTR_TAM] = {
+		.index		= CPTR_EL2,
+		.value		= CPTR_EL2_TAM,
+		.mask		= CPTR_EL2_TAM,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_CPTR_TCPAC] = {
+		.index		= CPTR_EL2,
+		.value		= CPTR_EL2_TCPAC,
+		.mask		= CPTR_EL2_TCPAC,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
 };
 
 #define MCB(id, ...)						\
@@ -410,12 +434,26 @@ static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
 	return BEHAVE_FORWARD_ANY;
 }
 
+static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
+{
+	u64 val = __vcpu_sys_reg(vcpu, CPTR_EL2);
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		val = translate_cptr_el2_to_cpacr_el1(val);
+
+	if (val & CPACR_ELx_TTA)
+		return BEHAVE_FORWARD_ANY;
+
+	return BEHAVE_HANDLE_LOCALLY;
+}
+
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
 static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
 	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
+	CCC(CGT_CPTR_TTA, check_cptr_tta),
 };
 
 /*
@@ -1000,6 +1038,59 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_TRBPTR_EL1, 	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBSR_EL1, 		CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBTRG_EL1,		CGT_MDCR_E2TB),
+	SR_TRAP(SYS_CPACR_EL1,		CGT_CPTR_TCPAC),
+	SR_TRAP(SYS_AMUSERENR_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCFGR_EL0,		CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCGCR_EL0,		CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCNTENCLR0_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCNTENCLR1_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCNTENSET0_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCNTENSET1_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCR_EL0,		CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR0_EL0(0),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR0_EL0(1),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR0_EL0(2),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR0_EL0(3),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(0),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(1),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(2),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(3),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(4),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(5),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(6),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(7),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(8),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(9),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(10),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(11),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(12),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(13),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(14),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(15),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER0_EL0(0),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER0_EL0(1),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER0_EL0(2),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER0_EL0(3),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(0),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(1),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(2),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(3),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(4),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(5),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(6),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(7),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(8),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(9),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(10),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(11),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(12),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(13),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(14),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(15),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_POR_EL0,		CGT_CPACR_E0POE),
+	/* op0=2, op1=1, and CRn<0b1000 */
+	SR_RANGE_TRAP(sys_reg(2, 1, 0, 0, 0),
+		      sys_reg(2, 1, 7, 15, 7), CGT_CPTR_TTA),
 	SR_TRAP(SYS_CNTP_TVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
 	SR_TRAP(SYS_CNTP_CVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
 	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
-- 
2.39.2

