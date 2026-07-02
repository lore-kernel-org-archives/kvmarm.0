Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C4D329E79;
	Thu,  2 Jul 2026 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008186; cv=none; b=P/bFVI3eDNpt2xJjWiymCJJfJDEC3zWGEA3EaVFH7uL5ZzM8QK8U5+d3SKxh40FO4FMfGGOMBsL331XEb6TSn+42bHoSVAj4wcDoC0OdG/S5nQ/0lD7jDrpir/kjb0m1nacIkhCL3FDpVKRmLKo0eVh+p0AMpvslFf/ah0S4iUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008186; c=relaxed/simple;
	bh=LBg29hDhAIWuWyFJighEySCfU8/gxpsVB0aIMUbISek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeShDbLiWRuFopAXwicn08pbWSjE87TUXvkTOkh5zro6jU7aPyn6pac4NwdV8wmaW4SUAwCuI2sAWHR7vMLDOA8A9y4bK+gCoUbNAxpCXBTvwdwzwcH94EzlwlJlJHG5xL1i0En8JXGCmdEWQV/DkThTxWOImcHpoIMkg3da+c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UX0llUcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UX0llUcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497CE1F00A3D;
	Thu,  2 Jul 2026 16:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008184;
	bh=1GX3MJ5dlCzoGDnIm3FDvikY6d8Vo9kOExa3P+h1mME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UX0llUcV/cOAKu23+67wiD/FF7LbG62D33e6N6WvPPaI1mM1yFYYLEZXxksJV7U0V
	 nfF9zLiKw+wkeoHsgOtk80pC33XDW09AC1Q/eKgVNCIb9qAqt8ovxbVnTEgdCHYXJs
	 IBfK+VA22cCjvJO8kNkIG63OWfwEhVB39yNKwrtsNVIwfFNAtG4KTLsqHp103nFTLC
	 1Qou3FEKmNQdDKP45nd/8bYuLgiaAy26Qjg7NMf3HajztscEEcO8TTt4kOAQje0fy9
	 ZRh4qtDuEI7y23bIw+TB1jAXSAM2z2vtPfs/kTcuhOn5I7GGzTJ04WBjKapMmMvg9o
	 d4vvnDrUaujcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsU-00000000ojd-2QZ5;
	Thu, 02 Jul 2026 16:03:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 22/28] KVM: arm64: Add routing for NVHCR_EL2 trap
Date: Thu,  2 Jul 2026 17:02:42 +0100
Message-ID: <20260702160248.1377250-23-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

NVHCR_EL2 accesses from EL1 are taken to EL2 when HCRX_EL2.NVTGE==0
and HCR_EL2.NV==1. Describe this in the exception routing tables.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b7f3d86a94031..f5dc578d8c985 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -90,6 +90,7 @@ enum cgt_group_id {
 	CGT_HCRX_EnFPM,
 	CGT_HCRX_TCR2En,
 	CGT_HCRX_SCTLR2En,
+	CGT_HCRX_nNVTGE,
 
 	CGT_CNTHCTL_EL1TVT,
 	CGT_CNTHCTL_EL1TVCT,
@@ -121,6 +122,8 @@ enum cgt_group_id {
 	CGT_MDCR_TDE_TDRA,
 	CGT_MDCR_TDCC_TDE_TDA,
 
+	CGT_HCR_NV_HCRX_nNVTGE,
+
 	CGT_ICH_HCR_TC_TDIR,
 
 	/*
@@ -413,6 +416,12 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= HCRX_EL2_SCTLR2En,
 		.behaviour	= BEHAVE_FORWARD_RW,
 	},
+	[CGT_HCRX_nNVTGE] = {
+		.index		= HCRX_EL2,
+		.value		= 0,
+		.mask		= HCRX_EL2_NVTGE,
+		.behaviour	= BEHAVE_FORWARD_RW,
+	},
 	[CGT_CNTHCTL_EL1TVT] = {
 		.index		= CNTHCTL_EL2,
 		.value		= CNTHCTL_EL1TVT,
@@ -468,6 +477,7 @@ static const enum cgt_group_id *coarse_control_combo[] = {
 					CGT_HCR_TVM, CGT_HCR_TRVM, CGT_HCRX_SCTLR2En),
 	MCB(CGT_HCR_TPU_TICAB,		CGT_HCR_TPU, CGT_HCR_TICAB),
 	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
+	MCB(CGT_HCR_NV_HCRX_nNVTGE,	CGT_HCR_NV, CGT_HCRX_nNVTGE),
 	MCB(CGT_HCR_NV1_nNV2_ENSCXT,	CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT),
 	MCB(CGT_MDCR_TPM_TPMCR,		CGT_MDCR_TPM, CGT_MDCR_TPMCR),
 	MCB(CGT_MDCR_TPM_HPMN,		CGT_MDCR_TPM, CGT_MDCR_HPMN),
@@ -853,6 +863,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_SCTLR2_EL2,		CGT_HCR_NV),
 	SR_RANGE_TRAP(SYS_HCR_EL2,
 		      SYS_HCRX_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_NVHCR_EL2,		CGT_HCR_NV_HCRX_nNVTGE),
 	SR_TRAP(SYS_SMPRIMAP_EL2,	CGT_HCR_NV),
 	SR_TRAP(SYS_SMCR_EL2,		CGT_HCR_NV),
 	SR_RANGE_TRAP(SYS_TTBR0_EL2,
-- 
2.47.3

