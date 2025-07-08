Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920902E03E0
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995639; cv=none; b=dxgVoC9RJsQfxTj3MadtQpug0/8ZBDQiWgniV3ErjEXQ+dU35lvXbkwuyXZRaISpdt6T3iJ5vUcxxiVh4hjA7PIqv8+7cb48T17/mQboAVLW29H/8bshRRs0OtLuafpNBakIkT2vXkJ6OEBW1CcDkORjKmAg9yTCR9hJbcKXZ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995639; c=relaxed/simple;
	bh=xpZczMgAiQEUCM+B3dItqQvrzwOmtKlHHexTJgrzOu0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SO+8wY1pV7NNABdaa602NfBN/CSXhC//fozT7ONhCcIktvCXP2w4OwG8RrOPd1MI/jOF9HxAJ0vFP/vxZVQUdVFc0EXif+vDex8xoq5pTIhGByvvBh/FaYk92mWRFMOqfmS/UPbopx5wMyuKYXvvdnxO3yTDCy661I0cHxBP/Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VCSGMY18; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VCSGMY18"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=32QET0TLhL3tM7oB60QGVk61oUKKQJ3b74DM1kljI50=;
	b=VCSGMY184on/HiT7kRHqv+fbNLO9EsnsFhXDQX/h0SIfP7Xl+yiQ5KRgzpTWetI+A30uOZ
	LY7AHih7xWyBwJ83tO0QU002qqs139ARuFiwcXK78Zc8J8lf7ikpgLBs7YTp0CTxsSRMcM
	bkcVJFXLgssICL0czRGot2nhP2e56PA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 14/27] KVM: arm64: Describe SCTLR2_ELx RESx masks
Date: Tue,  8 Jul 2025 10:25:19 -0700
Message-Id: <20250708172532.1699409-15-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

External abort injection will soon rely on a sanitised view of
SCTLR2_ELx to determine exception routing. Compute the RESx masks.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/config.c | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c |  6 ++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 54911a93b001..e8a33e91e665 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -131,6 +131,8 @@ struct reg_bits_to_feat_map {
 #define FEAT_SPMU		ID_AA64DFR1_EL1, SPMU, IMP
 #define FEAT_SPE_nVM		ID_AA64DFR2_EL1, SPE_nVM, IMP
 #define FEAT_STEP2		ID_AA64DFR2_EL1, STEP, IMP
+#define FEAT_SYSREG128		ID_AA64ISAR2_EL1, SYSREG_128, IMP
+#define FEAT_CPA2		ID_AA64ISAR3_EL1, CPA, CPA2
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -832,6 +834,23 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
 };
 
+static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
+	NEEDS_FEAT(SCTLR2_EL1_NMEA	|
+		   SCTLR2_EL1_EASE,
+		   FEAT_DoubleFault2),
+	NEEDS_FEAT(SCTLR2_EL1_EnADERR, feat_aderr),
+	NEEDS_FEAT(SCTLR2_EL1_EnANERR, feat_anerr),
+	NEEDS_FEAT(SCTLR2_EL1_EnIDCP128, FEAT_SYSREG128),
+	NEEDS_FEAT(SCTLR2_EL1_EnPACM	|
+		   SCTLR2_EL1_EnPACM0,
+		   feat_pauth_lr),
+	NEEDS_FEAT(SCTLR2_EL1_CPTA	|
+		   SCTLR2_EL1_CPTA0	|
+		   SCTLR2_EL1_CPTM	|
+		   SCTLR2_EL1_CPTM0,
+		   FEAT_CPA2),
+};
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 res0, const char *str)
 {
@@ -863,6 +882,8 @@ void __init check_feature_map(void)
 		       __HCRX_EL2_RES0, "HCRX_EL2");
 	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
 		       HCR_EL2_RES0, "HCR_EL2");
+	check_feat_map(sctlr2_feat_map, ARRAY_SIZE(sctlr2_feat_map),
+		       SCTLR2_EL1_RES0, "SCTLR2_EL1");
 }
 
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
@@ -1077,6 +1098,13 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res0 |= HCR_EL2_RES0 | (mask & ~fixed);
 		*res1 = HCR_EL2_RES1 | (mask & fixed);
 		break;
+	case SCTLR2_EL1:
+	case SCTLR2_EL2:
+		*res0 = compute_res0_bits(kvm, sctlr2_feat_map,
+					  ARRAY_SIZE(sctlr2_feat_map), 0, 0);
+		*res0 |= SCTLR2_EL1_RES0;
+		*res1 = SCTLR2_EL1_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 = *res1 = 0;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c7063f670187..096747a61bf6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1690,6 +1690,12 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= SCTLR_EL1_EPAN;
 	set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
 
+	/* SCTLR2_ELx */
+	get_reg_fixed_bits(kvm, SCTLR2_EL1, &res0, &res1);
+	set_sysreg_masks(kvm, SCTLR2_EL1, res0, res1);
+	get_reg_fixed_bits(kvm, SCTLR2_EL2, &res0, &res1);
+	set_sysreg_masks(kvm, SCTLR2_EL2, res0, res1);
+
 	/* MDCR_EL2 */
 	res0 = MDCR_EL2_RES0;
 	res1 = MDCR_EL2_RES1;
-- 
2.39.5

