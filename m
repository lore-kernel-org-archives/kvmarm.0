Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A2B280335
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128327; cv=none; b=H/7yGhlJ9A/Ocw0Duufih9HYjBPnjDC/Aq+TqaOa1Tsglf2CDa969UUXMwkKrbXuu2SnILWqxmn3hXrohhEREXlWyK11CUSsNJ85NxIXgZOmixVxEIn8Sr6ejd8TlCuaZIHp6xRFgMbdphUVEScRba06GqrJ+ZHjMLCB3KwcU6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128327; c=relaxed/simple;
	bh=Pa98mkhuBJArUvMDV8PBj6/ByutdSNF9nvR2HjxXO/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VadWx958X26svQlSu6P0TKa9WDT/AHVjPA2zM9NdBttckx6MrvSDNumgw1SApAmuEa2L0fZ+ep0kJzJ+FIIRfXbY3Oa4k1QhdzlHjTCfGYKuT4NkAlc9C758tEdBcJJT98y2PGbklV//lcatLcFHhmKwaNHSF837ePGXKbRkTO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uLUvB7m+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uLUvB7m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2C0C4CEE7;
	Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128326;
	bh=Pa98mkhuBJArUvMDV8PBj6/ByutdSNF9nvR2HjxXO/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLUvB7m+MLXzlO2dWFGH8cbzmWuh4S+ir0qDrpN+/3VxWRkdaOOeYiidIdMhPCdSN
	 dI1q4FupdS0+tqOvY1UnmgdrwGubU9uS8DQwYosxRxhmP2JJoF8w+TXbnx/vahDWOL
	 NS5mMEHsL27DojK3oQvPj0ODyGpZo1wdnfENIFbE0aZZ7o51VqP9BXCu9bMx2rHeic
	 XPU32Ejzrh8oqlIHbAt1yM2dhjd4HAahCIozwEPtiGFlyVf+cIi7PZFGI9aAtiw0ep
	 x5RhejJ1Iu2a33/whJ/sjSWcKETyuX4+Rve861prhAAovKQ6n/dWHIj/vrbhQ9QdF8
	 0j/LyUZHFmg+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUS-00000007AQw-3fWT;
	Wed, 17 Sep 2025 16:58:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 4/8] KVM: arm64: Convert HCR_EL2 RES0 handling to compute_reg_res0_bits()
Date: Wed, 17 Sep 2025 17:58:36 +0100
Message-Id: <20250917165840.1633412-5-maz@kernel.org>
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
 arch/arm64/kvm/config.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index f8e9cfa844266..c064c31effee9 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -107,6 +107,7 @@ struct reg_to_feat_map {
 #define FEAT_AA32EL0		ID_AA64PFR0_EL1, EL0, AARCH32
 #define FEAT_AA32EL1		ID_AA64PFR0_EL1, EL1, AARCH32
 #define FEAT_AA64EL1		ID_AA64PFR0_EL1, EL1, IMP
+#define FEAT_AA64EL2		ID_AA64PFR0_EL1, EL2, IMP
 #define FEAT_AA64EL3		ID_AA64PFR0_EL1, EL3, IMP
 #define FEAT_AIE		ID_AA64MMFR3_EL1, AIE, IMP
 #define FEAT_S2POE		ID_AA64MMFR3_EL1, S2POE, IMP
@@ -927,7 +928,7 @@ static const
 struct reg_to_feat_map hcrx_feat_map = FEAT_MAP(__HCRX_EL2, FEAT_HCX,
 						hcrx_bit_feat_map);
 
-static const struct reg_bits_to_feat_map hcr_feat_map[] = {
+static const struct reg_bits_to_feat_map hcr_bit_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_TID0, FEAT_AA32EL0),
 	NEEDS_FEAT_FIXED(HCR_EL2_RW, compute_hcr_rw),
 	NEEDS_FEAT(HCR_EL2_HCD, not_feat_aa64el3),
@@ -998,6 +999,10 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
 };
 
+static const
+struct reg_to_feat_map hcr_feat_map = FEAT_MAP(HCR_EL2, FEAT_AA64EL2,
+					       hcr_bit_feat_map);
+
 static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 	NEEDS_FEAT(SCTLR2_EL1_NMEA	|
 		   SCTLR2_EL1_EASE,
@@ -1180,8 +1185,7 @@ void __init check_feature_map(void)
 	check_reg_feat_map(&hdfgrtr2_feat_map);
 	check_reg_feat_map(&hdfgwtr2_feat_map);
 	check_reg_feat_map(&hcrx_feat_map);
-	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
-		       HCR_EL2_RES0, "HCR_EL2");
+	check_reg_feat_map(&hcr_feat_map);
 	check_feat_map(sctlr2_feat_map, ARRAY_SIZE(sctlr2_feat_map),
 		       SCTLR2_EL1_RES0, "SCTLR2_EL1");
 	check_feat_map(tcr2_el2_feat_map, ARRAY_SIZE(tcr2_el2_feat_map),
@@ -1271,15 +1275,13 @@ static u64 compute_reg_res0_bits(struct kvm *kvm,
 	return res0;
 }
 
-static u64 compute_fixed_bits(struct kvm *kvm,
-			      const struct reg_bits_to_feat_map *map,
-			      int map_size,
-			      u64 *fixed_bits,
-			      unsigned long require,
-			      unsigned long exclude)
+static u64 compute_reg_fixed_bits(struct kvm *kvm,
+				  const struct reg_to_feat_map *r,
+				  u64 *fixed_bits, unsigned long require,
+				  unsigned long exclude)
 {
-	return __compute_fixed_bits(kvm, map, map_size, fixed_bits,
-				    require | FIXED_VALUE, exclude);
+	return __compute_fixed_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
+				    fixed_bits, require | FIXED_VALUE, exclude);
 }
 
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
@@ -1384,12 +1386,9 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = __HCRX_EL2_RES1;
 		break;
 	case HCR_EL2:
-		mask = compute_fixed_bits(kvm, hcr_feat_map,
-					  ARRAY_SIZE(hcr_feat_map), &fixed,
-					  0, 0);
-		*res0 = compute_res0_bits(kvm, hcr_feat_map,
-					  ARRAY_SIZE(hcr_feat_map), 0, 0);
-		*res0 |= HCR_EL2_RES0 | (mask & ~fixed);
+		mask = compute_reg_fixed_bits(kvm, &hcr_feat_map, &fixed, 0, 0);
+		*res0 = compute_reg_res0_bits(kvm, &hcr_feat_map, 0, 0);
+		*res0 |= (mask & ~fixed);
 		*res1 = HCR_EL2_RES1 | (mask & fixed);
 		break;
 	case SCTLR2_EL1:
-- 
2.39.2

