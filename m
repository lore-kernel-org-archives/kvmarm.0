Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAA8280335
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128327; cv=none; b=EDpA2EgeyRdWw5Gk1nDdwDiWeOOcAk2TMNjbk8qXmjVhAAI9ROPaRrN25mUyjdTFB3f5K4i/BRkxk65431hFQ1RVMuBub+7VlICwj+IkDlbvrQm5jLH8YRBt7gm51S7fdl7hS2HG4FzgF7q8FTXq5OzoLKSrNaVRIrGt12LvYGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128327; c=relaxed/simple;
	bh=oWjPl3WJCb1hk75ehhUmkSiPkaxHiKfqFBo/gwNk/hE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ue0PX5kOzYL1/PGiTC1ha8B5htwuGk16d3YyMUCn/QVJ4fh46r72nVWPcMUhFWeababbSnc9ovW/3PWBYztcWoQRbhfo29j8i7h3ROi1bf1gI4sQMZsvbUY1VqxkEOjN/+wkGkt2Nwl1ikAgkR9+O0ycctUH2rXhhTjJIZvDvRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/KrpJJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/KrpJJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820C8C4CEF9;
	Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128326;
	bh=oWjPl3WJCb1hk75ehhUmkSiPkaxHiKfqFBo/gwNk/hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/KrpJJA4ALIrnT1RtcVjYlUJu9FsZfyrWQHdWz82sSR17yxanV+Duyn3epPWdLGf
	 YcUnqpG7UuObR2SyLutcsnIrnScf6h6ZE5cBj17CUGDwa2QRgdD+nklUTuHaLId0y+
	 ZIN46byA5B6V2lLQozdKxYQogoHppZEhsTAZDuIu32oSdeVr1Xhb0KUDYlGFBStK0z
	 exLKsy5r8SNgteaRKM52/QYMgCxYJRjhavR5UIrt0b96rHxlBHhvKmthPKYsZqzV/P
	 pLD58LOQTkWktuMM7M5VPMl3K1wF7psE4KJZGopnmBTYNQUxVbj5sokgzhBM6PTa6L
	 PbAit0D2aAF3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUS-00000007AQw-1rSc;
	Wed, 17 Sep 2025 16:58:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 2/8] KVM: arm64: Enforce absence of FEAT_FGT2 on FGT2 registers
Date: Wed, 17 Sep 2025 17:58:34 +0100
Message-Id: <20250917165840.1633412-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250917165840.1633412-1-maz@kernel.org>
References: <20250917165840.1633412-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, yangjinqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 86 ++++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 42b834c82a20d..05be2b917c8c0 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -185,6 +185,7 @@ struct reg_to_feat_map {
 #define FEAT_SSBS		ID_AA64PFR1_EL1, SSBS, IMP
 #define FEAT_TIDCP1		ID_AA64MMFR1_EL1, TIDCP1, IMP
 #define FEAT_FGT		ID_AA64MMFR0_EL1, FGT, IMP
+#define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 
 static bool not_feat_aa64el3(struct kvm *kvm)
@@ -767,12 +768,17 @@ struct reg_to_feat_map hafgrtr_feat_map = FEAT_MAP_FGT(hafgrtr_masks,
 						       hafgrtr_bit_feat_map,
 						       FEAT_FGT);
 
-static const struct reg_bits_to_feat_map hfgitr2_feat_map[] = {
+static const struct reg_bits_to_feat_map hfgitr2_bit_feat_map[] = {
 	NEEDS_FEAT(HFGITR2_EL2_nDCCIVAPS, FEAT_PoPS),
 	NEEDS_FEAT(HFGITR2_EL2_TSBCSYNC, FEAT_TRBEv1p1)
 };
 
-static const struct reg_bits_to_feat_map hfgrtr2_feat_map[] = {
+static const
+struct reg_to_feat_map hfgitr2_feat_map = FEAT_MAP_FGT(hfgitr2_masks,
+						       hfgitr2_bit_feat_map,
+						       FEAT_FGT2);
+
+static const struct reg_bits_to_feat_map hfgrtr2_bit_feat_map[] = {
 	NEEDS_FEAT(HFGRTR2_EL2_nPFAR_EL1, FEAT_PFAR),
 	NEEDS_FEAT(HFGRTR2_EL2_nERXGSR_EL1, FEAT_RASv2),
 	NEEDS_FEAT(HFGRTR2_EL2_nACTLRALIAS_EL1	|
@@ -791,7 +797,12 @@ static const struct reg_bits_to_feat_map hfgrtr2_feat_map[] = {
 	NEEDS_FEAT(HFGRTR2_EL2_nRCWSMASK_EL1, FEAT_THE),
 };
 
-static const struct reg_bits_to_feat_map hfgwtr2_feat_map[] = {
+static const
+struct reg_to_feat_map hfgrtr2_feat_map = FEAT_MAP_FGT(hfgrtr2_masks,
+						       hfgrtr2_bit_feat_map,
+						       FEAT_FGT2);
+
+static const struct reg_bits_to_feat_map hfgwtr2_bit_feat_map[] = {
 	NEEDS_FEAT(HFGWTR2_EL2_nPFAR_EL1, FEAT_PFAR),
 	NEEDS_FEAT(HFGWTR2_EL2_nACTLRALIAS_EL1	|
 		   HFGWTR2_EL2_nACTLRMASK_EL1	|
@@ -809,7 +820,12 @@ static const struct reg_bits_to_feat_map hfgwtr2_feat_map[] = {
 	NEEDS_FEAT(HFGWTR2_EL2_nRCWSMASK_EL1, FEAT_THE),
 };
 
-static const struct reg_bits_to_feat_map hdfgrtr2_feat_map[] = {
+static const
+struct reg_to_feat_map hfgwtr2_feat_map = FEAT_MAP_FGT(hfgwtr2_masks,
+						       hfgwtr2_bit_feat_map,
+						       FEAT_FGT2);
+
+static const struct reg_bits_to_feat_map hdfgrtr2_bit_feat_map[] = {
 	NEEDS_FEAT(HDFGRTR2_EL2_nMDSELR_EL1, FEAT_Debugv8p9),
 	NEEDS_FEAT(HDFGRTR2_EL2_nPMECR_EL1, feat_ebep_pmuv3_ss),
 	NEEDS_FEAT(HDFGRTR2_EL2_nTRCITECR_EL1, FEAT_ITE),
@@ -839,7 +855,12 @@ static const struct reg_bits_to_feat_map hdfgrtr2_feat_map[] = {
 	NEEDS_FEAT(HDFGRTR2_EL2_nTRBMPAM_EL1, feat_trbe_mpam),
 };
 
-static const struct reg_bits_to_feat_map hdfgwtr2_feat_map[] = {
+static const
+struct reg_to_feat_map hdfgrtr2_feat_map = FEAT_MAP_FGT(hdfgrtr2_masks,
+							hdfgrtr2_bit_feat_map,
+							FEAT_FGT2);
+
+static const struct reg_bits_to_feat_map hdfgwtr2_bit_feat_map[] = {
 	NEEDS_FEAT(HDFGWTR2_EL2_nMDSELR_EL1, FEAT_Debugv8p9),
 	NEEDS_FEAT(HDFGWTR2_EL2_nPMECR_EL1, feat_ebep_pmuv3_ss),
 	NEEDS_FEAT(HDFGWTR2_EL2_nTRCITECR_EL1, FEAT_ITE),
@@ -867,6 +888,11 @@ static const struct reg_bits_to_feat_map hdfgwtr2_feat_map[] = {
 	NEEDS_FEAT(HDFGWTR2_EL2_nTRBMPAM_EL1, feat_trbe_mpam),
 };
 
+static const
+struct reg_to_feat_map hdfgwtr2_feat_map = FEAT_MAP_FGT(hdfgwtr2_masks,
+							hdfgwtr2_bit_feat_map,
+							FEAT_FGT2);
+
 static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
 	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
 	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
@@ -1143,6 +1169,11 @@ void __init check_feature_map(void)
 	check_reg_feat_map(&hdfgrtr_feat_map);
 	check_reg_feat_map(&hdfgwtr_feat_map);
 	check_reg_feat_map(&hafgrtr_feat_map);
+	check_reg_feat_map(&hfgrtr2_feat_map);
+	check_reg_feat_map(&hfgwtr2_feat_map);
+	check_reg_feat_map(&hfgitr2_feat_map);
+	check_reg_feat_map(&hdfgrtr2_feat_map);
+	check_reg_feat_map(&hdfgwtr2_feat_map);
 	check_feat_map(hcrx_feat_map, ARRAY_SIZE(hcrx_feat_map),
 		       __HCRX_EL2_RES0, "HCRX_EL2");
 	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
@@ -1273,25 +1304,20 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 					     0, NEVER_FGU);
 		break;
 	case HFGRTR2_GROUP:
-		val |= compute_res0_bits(kvm, hfgrtr2_feat_map,
-					 ARRAY_SIZE(hfgrtr2_feat_map),
-					 0, NEVER_FGU);
-		val |= compute_res0_bits(kvm, hfgwtr2_feat_map,
-					 ARRAY_SIZE(hfgwtr2_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgrtr2_feat_map,
+					     0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgwtr2_feat_map,
+					     0, NEVER_FGU);
 		break;
 	case HFGITR2_GROUP:
-		val |= compute_res0_bits(kvm, hfgitr2_feat_map,
-					 ARRAY_SIZE(hfgitr2_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgitr2_feat_map,
+					     0, NEVER_FGU);
 		break;
 	case HDFGRTR2_GROUP:
-		val |= compute_res0_bits(kvm, hdfgrtr2_feat_map,
-					 ARRAY_SIZE(hdfgrtr2_feat_map),
-					 0, NEVER_FGU);
-		val |= compute_res0_bits(kvm, hdfgwtr2_feat_map,
-					 ARRAY_SIZE(hdfgwtr2_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hdfgrtr2_feat_map,
+					     0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hdfgwtr2_feat_map,
+					     0, NEVER_FGU);
 		break;
 	default:
 		BUG();
@@ -1330,33 +1356,23 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = HAFGRTR_EL2_RES1;
 		break;
 	case HFGRTR2_EL2:
-		*res0 = compute_res0_bits(kvm, hfgrtr2_feat_map,
-					  ARRAY_SIZE(hfgrtr2_feat_map), 0, 0);
-		*res0 |= hfgrtr2_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgrtr2_feat_map, 0, 0);
 		*res1 = HFGRTR2_EL2_RES1;
 		break;
 	case HFGWTR2_EL2:
-		*res0 = compute_res0_bits(kvm, hfgwtr2_feat_map,
-					  ARRAY_SIZE(hfgwtr2_feat_map), 0, 0);
-		*res0 |= hfgwtr2_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgwtr2_feat_map, 0, 0);
 		*res1 = HFGWTR2_EL2_RES1;
 		break;
 	case HFGITR2_EL2:
-		*res0 = compute_res0_bits(kvm, hfgitr2_feat_map,
-					  ARRAY_SIZE(hfgitr2_feat_map), 0, 0);
-		*res0 |= hfgitr2_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgitr2_feat_map, 0, 0);
 		*res1 = HFGITR2_EL2_RES1;
 		break;
 	case HDFGRTR2_EL2:
-		*res0 = compute_res0_bits(kvm, hdfgrtr2_feat_map,
-					  ARRAY_SIZE(hdfgrtr2_feat_map), 0, 0);
-		*res0 |= hdfgrtr2_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hdfgrtr2_feat_map, 0, 0);
 		*res1 = HDFGRTR2_EL2_RES1;
 		break;
 	case HDFGWTR2_EL2:
-		*res0 = compute_res0_bits(kvm, hdfgwtr2_feat_map,
-					  ARRAY_SIZE(hdfgwtr2_feat_map), 0, 0);
-		*res0 |= hdfgwtr2_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hdfgwtr2_feat_map, 0, 0);
 		*res1 = HDFGWTR2_EL2_RES1;
 		break;
 	case HCRX_EL2:
-- 
2.39.2

