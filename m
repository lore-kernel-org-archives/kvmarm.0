Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625A922538F
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208469; cv=none; b=CR4aGDasj0Rpjq12hWiUvfNEpk7hlawKSdo1t9I/0EE1wtkFtWWQEKmiw8hWjNJw3msQeRxuG0Uwp8C8uHschnOPo+HzoYdhjgELfjUUwn71B/80xoTswYkLYYVpP66GADiqrQDVbYLG3roaMEyF+sfmYgYEn0HF1uy1kmMXxIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208469; c=relaxed/simple;
	bh=ilXsDS/foRM6sit3FtBx43M37aV0E6//jOyFV8KLEoI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EWcc453kUue2ZJElLbg5RyRTi9ivP/jPxfrxgXywaQGsj0l0QpbqqtjJDmQx9goJqSgd2MJs/evrnadIDYG5Fpnuhwc6vOsZTOXLy7rClHq6frI69pTiku2Sa9E6GMeZzb0gtx8L0orWKHDd89iCpimp4UqpHc4N5suaduu+FaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inE4KJnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inE4KJnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412F2C4CEEB;
	Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208469;
	bh=ilXsDS/foRM6sit3FtBx43M37aV0E6//jOyFV8KLEoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inE4KJnvJsEFRpKkvSS0B0DracHcC1biwESrZSw32Th92WkIZAJkpqDZyeMndzOP3
	 K/fHjaYZ04CLFOdG75LcSzOqXx9AengG0o1bUreEtbRDAUeZ7+J3uptVKizGb7ofXN
	 nqnLW852kEsMrtKB6tnQTsft3KjBPU3iBHbi6QGL4cyEDe14w+KLqB8itPj5gPbmNJ
	 VLeKXg7LN5wDUayIG/33TQF4idYcLRbGrLFsX13KIzWreDmAEOE/HIvBeDloy73VM2
	 lCylXNvc+tFcXoWLGomRKdhXC3icYTpMgX4PeA6SVuS2D/e2b1iAOw3iGhN46xC+oE
	 QWj8qVH/DBs/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL5-00000007TmF-1qef;
	Thu, 18 Sep 2025 15:14:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 06/10] KVM: arm64: Convert HCR_EL2 RES0 handling to compute_reg_res0_bits()
Date: Thu, 18 Sep 2025 16:13:58 +0100
Message-Id: <20250918151402.1665315-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250918151402.1665315-1-maz@kernel.org>
References: <20250918151402.1665315-1-maz@kernel.org>
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

While HCR_EL2 is unlikely to ever be RES0 (at least when NV is on),
but consistency doesn't hurt, and it can be described in the same
way as the other registers.

Convert it over to the new RES0-computing infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 2b2a87e31389d..c96d5ff760deb 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -136,6 +136,7 @@ struct reg_feat_map_desc {
 #define FEAT_AA32EL0		ID_AA64PFR0_EL1, EL0, AARCH32
 #define FEAT_AA32EL1		ID_AA64PFR0_EL1, EL1, AARCH32
 #define FEAT_AA64EL1		ID_AA64PFR0_EL1, EL1, IMP
+#define FEAT_AA64EL2		ID_AA64PFR0_EL1, EL2, IMP
 #define FEAT_AA64EL3		ID_AA64PFR0_EL1, EL3, IMP
 #define FEAT_AIE		ID_AA64MMFR3_EL1, AIE, IMP
 #define FEAT_S2POE		ID_AA64MMFR3_EL1, S2POE, IMP
@@ -1005,6 +1006,9 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
 };
 
+static const DECLARE_FEAT_MAP(hcr_desc, HCR_EL2,
+			      hcr_feat_map, FEAT_AA64EL2);
+
 static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 	NEEDS_FEAT(SCTLR2_EL1_NMEA	|
 		   SCTLR2_EL1_EASE,
@@ -1187,8 +1191,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&hdfgrtr2_desc);
 	check_reg_desc(&hdfgwtr2_desc);
 	check_reg_desc(&hcrx_desc);
-	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
-		       HCR_EL2_RES0, "HCR_EL2");
+	check_reg_desc(&hcr_desc);
 	check_feat_map(sctlr2_feat_map, ARRAY_SIZE(sctlr2_feat_map),
 		       SCTLR2_EL1_RES0, "SCTLR2_EL1");
 	check_feat_map(tcr2_el2_feat_map, ARRAY_SIZE(tcr2_el2_feat_map),
@@ -1278,15 +1281,13 @@ static u64 compute_reg_res0_bits(struct kvm *kvm,
 	return res0;
 }
 
-static u64 compute_fixed_bits(struct kvm *kvm,
-			      const struct reg_bits_to_feat_map *map,
-			      int map_size,
-			      u64 *fixed_bits,
-			      unsigned long require,
-			      unsigned long exclude)
+static u64 compute_reg_fixed_bits(struct kvm *kvm,
+				  const struct reg_feat_map_desc *r,
+				  u64 *fixed_bits, unsigned long require,
+				  unsigned long exclude)
 {
-	return __compute_fixed_bits(kvm, map, map_size, fixed_bits,
-				    require | FIXED_VALUE, exclude);
+	return __compute_fixed_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
+				    fixed_bits, require | FIXED_VALUE, exclude);
 }
 
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
@@ -1391,12 +1392,9 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = __HCRX_EL2_RES1;
 		break;
 	case HCR_EL2:
-		mask = compute_fixed_bits(kvm, hcr_feat_map,
-					  ARRAY_SIZE(hcr_feat_map), &fixed,
-					  0, 0);
-		*res0 = compute_res0_bits(kvm, hcr_feat_map,
-					  ARRAY_SIZE(hcr_feat_map), 0, 0);
-		*res0 |= HCR_EL2_RES0 | (mask & ~fixed);
+		mask = compute_reg_fixed_bits(kvm, &hcr_desc, &fixed, 0, 0);
+		*res0 = compute_reg_res0_bits(kvm, &hcr_desc, 0, 0);
+		*res0 |= (mask & ~fixed);
 		*res1 = HCR_EL2_RES1 | (mask & fixed);
 		break;
 	case SCTLR2_EL1:
-- 
2.39.2

