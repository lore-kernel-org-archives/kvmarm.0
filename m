Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0556514884C
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 12:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718369944; cv=none; b=oGYz8sPviNn6p43MWFoAz5hd05WQU9xwX2CPNAl7Tver/VPl3LAt3g/3Q0GUFEtcj+I/txB8l5Ycc7tfjdftZ+pMOK+tA9KPvZpsdk19WNWBLn+cgeQmMXtvv5sjgLuO0NfmZ0cyqmWdAyNirJHzKRPaK/ezhs1RHvN9PgUpcdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718369944; c=relaxed/simple;
	bh=wA8k1cwbW4STWF0u1Fo4FBrcTbS31tLjN9PXmbqjgFg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ix2gwU2wBDfBPqfDok8vvb/M7IhmZo0P9bCD1cwevDnFtxrWaXMec2HRx/9XNoQwx6nb1DnClGmbz02T/y1Jd6rjLdJFnArcF9i0pmXsc2zv/LA78QFbVrpDBHrSjOzhAOFH+FJCA/A7ouSJy+jIpAdpjj75O+jOvEUNaFh57b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VfJMVOQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfJMVOQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BA3C2BD10;
	Fri, 14 Jun 2024 12:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718369943;
	bh=wA8k1cwbW4STWF0u1Fo4FBrcTbS31tLjN9PXmbqjgFg=;
	h=From:To:Cc:Subject:Date:From;
	b=VfJMVOQjVwAmW5g4YeL3vg6ZJRgxWiup5OytuvAWVFt3yyZQoHWLhxlVq1Td4q/eM
	 0/A7Y9ap0gs1JiWEm90cRr038fzWaItVEk+g940GO/5CaoNqDro+9A1CqF1SpZ8djX
	 1PphwRPiLPMkOmjxgwDwu3uim4XBAuhsZDQcJOeA8OXFsiC3AYZTptdCmic77SSRRH
	 wo8SApesW0CIfoewS4yQSgnBQcLvLw+yQ2vBGsK3SvwriXQ+rBvzO2iRyMToGi2O6b
	 37X3WSf44/1uN5tYgq+/AgFjcBXl2mYIEcz9qJxjjaDYBO9dCwknoQID5ocZQiDyHk
	 jWy3qgXRsmU7Q==
Received: from [104.132.45.100] (helo=wait-a-minute.lon.corp.google.com)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI6WD-003v9v-KW;
	Fri, 14 Jun 2024 13:59:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH] KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with negative polarity
Date: Fri, 14 Jun 2024 13:58:58 +0100
Message-Id: <20240614125858.78361-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 104.132.45.100
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The Fine Grained Trap extension is pretty messy as it doesn't
consistently use the same polarity for all trap bits. A bunch
of them, added later in the life of the architecture, have a
*negative* priority.

So if these bits are disabled, they must be RES1 and not RES0.
But that's not what the code implements, making the traps for
these negative trap bits being always on instead of disabled.

Fix the relevant bits, and stick a brown paper bag on my head
for the rest of the day...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index bae8536cbf00..0acb60273482 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -328,21 +328,21 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 			 HFGxTR_EL2_ERXPFGF_EL1 | HFGxTR_EL2_ERXPFGCTL_EL1 |
 			 HFGxTR_EL2_ERXPFGCDN_EL1 | HFGxTR_EL2_ERXADDR_EL1);
 	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
-		res0 |= HFGxTR_EL2_nACCDATA_EL1;
+		res1 |= HFGxTR_EL2_nACCDATA_EL1;
 	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
-		res0 |= (HFGxTR_EL2_nGCS_EL0 | HFGxTR_EL2_nGCS_EL1);
+		res1 |= (HFGxTR_EL2_nGCS_EL0 | HFGxTR_EL2_nGCS_EL1);
 	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP))
-		res0 |= (HFGxTR_EL2_nSMPRI_EL1 | HFGxTR_EL2_nTPIDR2_EL0);
+		res1 |= (HFGxTR_EL2_nSMPRI_EL1 | HFGxTR_EL2_nTPIDR2_EL0);
 	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
-		res0 |= HFGxTR_EL2_nRCWMASK_EL1;
+		res1 |= HFGxTR_EL2_nRCWMASK_EL1;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
-		res0 |= (HFGxTR_EL2_nPIRE0_EL1 | HFGxTR_EL2_nPIR_EL1);
+		res1 |= (HFGxTR_EL2_nPIRE0_EL1 | HFGxTR_EL2_nPIR_EL1);
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
-		res0 |= (HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nPOR_EL1);
+		res1 |= (HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nPOR_EL1);
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
-		res0 |= HFGxTR_EL2_nS2POR_EL1;
+		res1 |= HFGxTR_EL2_nS2POR_EL1;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
-		res0 |= (HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nAMAIR2_EL1);
+		res1 |= (HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nAMAIR2_EL1);
 	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | __HFGRTR_EL2_RES0, res1);
 	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | __HFGWTR_EL2_RES0, res1);
 
@@ -378,10 +378,10 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 			 HDFGRTR_EL2_TRBPTR_EL1 | HDFGRTR_EL2_TRBSR_EL1 |
 			 HDFGRTR_EL2_TRBTRG_EL1);
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
-		res0 |= (HDFGRTR_EL2_nBRBIDR | HDFGRTR_EL2_nBRBCTL |
+		res1 |= (HDFGRTR_EL2_nBRBIDR | HDFGRTR_EL2_nBRBCTL |
 			 HDFGRTR_EL2_nBRBDATA);
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
-		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
+		res1 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
 	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
 
 	/* Reuse the bits from the read-side and add the write-specific stuff */
@@ -417,9 +417,9 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= (HFGITR_EL2_CFPRCTX | HFGITR_EL2_DVPRCTX |
 			 HFGITR_EL2_CPPRCTX);
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
-		res0 |= (HFGITR_EL2_nBRBINJ | HFGITR_EL2_nBRBIALL);
+		res1 |= (HFGITR_EL2_nBRBINJ | HFGITR_EL2_nBRBIALL);
 	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
-		res0 |= (HFGITR_EL2_nGCSPUSHM_EL1 | HFGITR_EL2_nGCSSTR_EL1 |
+		res1 |= (HFGITR_EL2_nGCSPUSHM_EL1 | HFGITR_EL2_nGCSSTR_EL1 |
 			 HFGITR_EL2_nGCSEPP);
 	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX))
 		res0 |= HFGITR_EL2_COSPRCTX;
-- 
2.39.2

