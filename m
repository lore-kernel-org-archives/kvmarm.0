Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13164224B06
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208469; cv=none; b=RAwvUDK9Pq2axc3ih9fDxDg9/Ta3+qCiJM2AJ+Q3/BnLNInNG/ItrH4umSUz12/HSou7A48k5VGKhQ6Z/3mmXYSUL8G0Zg0H0hSlGVnYfUg6VkRHI9gqgVT0cTu+AOmMDiISJSLedOaa8u+3pHxq90kfqQ4ySxdy7YjzTTPQLWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208469; c=relaxed/simple;
	bh=yYfSuLfRp+IRGv+O5TMw6uaFscMZw/7NMBt8kQ9t6j4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nb3a2Zqtgdd8dQFrqJdmvBFtIOePR3aJBpq9nyNivUg7G1ONa6vraXmyE9jNVYkg1osLnOdOUgvLNTpYssuojvRXITWn8x8QEmX+Liyret7jgjrlTnDE3vb7YWZcUYtvjh9Dp33G0FywUvUjaq11Xbakgb48SUclaiR8v1h+p8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXS9bAMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXS9bAMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2B9C4CEFB;
	Thu, 18 Sep 2025 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208468;
	bh=yYfSuLfRp+IRGv+O5TMw6uaFscMZw/7NMBt8kQ9t6j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXS9bAMAFMcl0paKqcjVb3matN7kwbhlI6kSM86BL3V4tU8hQcfr02+nXgjVUmPcG
	 oBaOcfKCGYac8c6S1RLYwm/PLLBEGvDc1c0DwWlP6+EsflXRgHGCh7cZKCbd4isKc9
	 t3ep6BsBhIapxxTnZn8USNsVfgrgp7DwPsljLlGul4Wn9gxGa5AfAesp0TNBrjij7q
	 S60AOlZLSTmSIEMpHHbLQrj5i+xojXJ5Kxtb8Et6nafHSf8ZwZKBae1Uwyxq7wKZ+5
	 GTFlrVkfRHQkhnn5UrdCMePdv54x64D/DRSm9L0jX+/8PSxsQr2e9bGOETtctTy+KS
	 568ppi23r1DlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL4-00000007TmF-3M0I;
	Thu, 18 Sep 2025 15:14:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 03/10] KVM: arm64: Enforce absence of FEAT_FGT on FGT registers
Date: Thu, 18 Sep 2025 16:13:55 +0100
Message-Id: <20250918151402.1665315-4-maz@kernel.org>
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

As we want to enforce FGT registers behaving as RES0 when FEAT_FGT
is not exposed to the guest, We move a bumch of things that are
so far passed as parameter into a structure that points to the
bit description.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 126 ++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index c2bfffe660bca..bb38364d55e9a 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -458,6 +458,10 @@ static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
 			NEVER_FGU, FEAT_AA64EL1),
 };
 
+
+static const DECLARE_FEAT_MAP_FGT(hfgrtr_desc, hfgrtr_masks,
+				  hfgrtr_feat_map, FEAT_FGT);
+
 static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
 	NEEDS_FEAT(HFGWTR_EL2_nAMAIR2_EL1	|
 		   HFGWTR_EL2_nMAIR2_EL1,
@@ -522,6 +526,9 @@ static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
 			NEVER_FGU, FEAT_AA64EL1),
 };
 
+static const DECLARE_FEAT_MAP_FGT(hfgwtr_desc, hfgwtr_masks,
+				  hfgwtr_feat_map, FEAT_FGT);
+
 static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
 	NEEDS_FEAT(HDFGRTR_EL2_PMBIDR_EL1	|
 		   HDFGRTR_EL2_PMSLATFR_EL1	|
@@ -589,6 +596,9 @@ static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
 			NEVER_FGU, FEAT_AA64EL1)
 };
 
+static const DECLARE_FEAT_MAP_FGT(hdfgrtr_desc, hdfgrtr_masks,
+				  hdfgrtr_feat_map, FEAT_FGT);
+
 static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
 	NEEDS_FEAT(HDFGWTR_EL2_PMSLATFR_EL1	|
 		   HDFGWTR_EL2_PMSIRR_EL1	|
@@ -649,6 +659,8 @@ static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
 	NEEDS_FEAT(HDFGWTR_EL2_TRFCR_EL1, FEAT_TRF),
 };
 
+static const DECLARE_FEAT_MAP_FGT(hdfgwtr_desc, hdfgwtr_masks,
+				  hdfgwtr_feat_map, FEAT_FGT);
 
 static const struct reg_bits_to_feat_map hfgitr_feat_map[] = {
 	NEEDS_FEAT(HFGITR_EL2_PSBCSYNC, FEAT_SPEv1p5),
@@ -723,6 +735,9 @@ static const struct reg_bits_to_feat_map hfgitr_feat_map[] = {
 			NEVER_FGU, FEAT_AA64EL1),
 };
 
+static const DECLARE_FEAT_MAP_FGT(hfgitr_desc, hfgitr_masks,
+				  hfgitr_feat_map, FEAT_FGT);
+
 static const struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
 	NEEDS_FEAT(HAFGRTR_EL2_AMEVTYPER115_EL0	|
 		   HAFGRTR_EL2_AMEVTYPER114_EL0	|
@@ -765,6 +780,9 @@ static const struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
 		   FEAT_AMUv1),
 };
 
+static const DECLARE_FEAT_MAP_FGT(hafgrtr_desc, hafgrtr_masks,
+				  hafgrtr_feat_map, FEAT_FGT);
+
 static const struct reg_bits_to_feat_map hfgitr2_feat_map[] = {
 	NEEDS_FEAT(HFGITR2_EL2_nDCCIVAPS, FEAT_PoPS),
 	NEEDS_FEAT(HFGITR2_EL2_TSBCSYNC, FEAT_TRBEv1p1)
@@ -1122,20 +1140,25 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 			str, mask ^ ~res0);
 }
 
+static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
+{
+	return map->flags & RES0_POINTER ? ~(*map->res0p) : map->bits;
+}
+
+static void __init check_reg_desc(const struct reg_feat_map_desc *r)
+{
+	check_feat_map(r->bit_feat_map, r->bit_feat_map_sz,
+		       ~reg_feat_map_bits(&r->feat_map), r->name);
+}
+
 void __init check_feature_map(void)
 {
-	check_feat_map(hfgrtr_feat_map, ARRAY_SIZE(hfgrtr_feat_map),
-		       hfgrtr_masks.res0, hfgrtr_masks.str);
-	check_feat_map(hfgwtr_feat_map, ARRAY_SIZE(hfgwtr_feat_map),
-		       hfgwtr_masks.res0, hfgwtr_masks.str);
-	check_feat_map(hfgitr_feat_map, ARRAY_SIZE(hfgitr_feat_map),
-		       hfgitr_masks.res0, hfgitr_masks.str);
-	check_feat_map(hdfgrtr_feat_map, ARRAY_SIZE(hdfgrtr_feat_map),
-		       hdfgrtr_masks.res0, hdfgrtr_masks.str);
-	check_feat_map(hdfgwtr_feat_map, ARRAY_SIZE(hdfgwtr_feat_map),
-		       hdfgwtr_masks.res0, hdfgwtr_masks.str);
-	check_feat_map(hafgrtr_feat_map, ARRAY_SIZE(hafgrtr_feat_map),
-		       hafgrtr_masks.res0, hafgrtr_masks.str);
+	check_reg_desc(&hfgrtr_desc);
+	check_reg_desc(&hfgwtr_desc);
+	check_reg_desc(&hfgitr_desc);
+	check_reg_desc(&hdfgrtr_desc);
+	check_reg_desc(&hdfgwtr_desc);
+	check_reg_desc(&hafgrtr_desc);
 	check_feat_map(hcrx_feat_map, ARRAY_SIZE(hcrx_feat_map),
 		       __HCRX_EL2_RES0, "HCRX_EL2");
 	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
@@ -1190,7 +1213,7 @@ static u64 __compute_fixed_bits(struct kvm *kvm,
 			match = idreg_feat_match(kvm, &map[i]);
 
 		if (!match || (map[i].flags & FIXED_VALUE))
-			val |= map[i].bits;
+			val |= reg_feat_map_bits(&map[i]);
 	}
 
 	return val;
@@ -1206,6 +1229,29 @@ static u64 compute_res0_bits(struct kvm *kvm,
 				    require, exclude | FIXED_VALUE);
 }
 
+static u64 compute_reg_res0_bits(struct kvm *kvm,
+				 const struct reg_feat_map_desc *r,
+				 unsigned long require, unsigned long exclude)
+				 
+{
+	u64 res0;
+
+	res0 = compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
+				 require, exclude);
+
+	/*
+	 * If computing FGUs, don't take RES0 or register existence
+	 * into account -- we're not computing bits for the register
+	 * itself.
+	 */
+	if (!(exclude & NEVER_FGU)) {
+		res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
+		res0 |= ~reg_feat_map_bits(&r->feat_map);
+	}
+
+	return res0;
+}
+
 static u64 compute_fixed_bits(struct kvm *kvm,
 			      const struct reg_bits_to_feat_map *map,
 			      int map_size,
@@ -1223,30 +1269,24 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 
 	switch (fgt) {
 	case HFGRTR_GROUP:
-		val |= compute_res0_bits(kvm, hfgrtr_feat_map,
-					 ARRAY_SIZE(hfgrtr_feat_map),
-					 0, NEVER_FGU);
-		val |= compute_res0_bits(kvm, hfgwtr_feat_map,
-					 ARRAY_SIZE(hfgwtr_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgrtr_desc,
+					     0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgwtr_desc,
+					     0, NEVER_FGU);
 		break;
 	case HFGITR_GROUP:
-		val |= compute_res0_bits(kvm, hfgitr_feat_map,
-					 ARRAY_SIZE(hfgitr_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgitr_desc,
+					     0, NEVER_FGU);
 		break;
 	case HDFGRTR_GROUP:
-		val |= compute_res0_bits(kvm, hdfgrtr_feat_map,
-					 ARRAY_SIZE(hdfgrtr_feat_map),
-					 0, NEVER_FGU);
-		val |= compute_res0_bits(kvm, hdfgwtr_feat_map,
-					 ARRAY_SIZE(hdfgwtr_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hdfgrtr_desc,
+					     0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hdfgwtr_desc,
+					     0, NEVER_FGU);
 		break;
 	case HAFGRTR_GROUP:
-		val |= compute_res0_bits(kvm, hafgrtr_feat_map,
-					 ARRAY_SIZE(hafgrtr_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hafgrtr_desc,
+					     0, NEVER_FGU);
 		break;
 	case HFGRTR2_GROUP:
 		val |= compute_res0_bits(kvm, hfgrtr2_feat_map,
@@ -1282,39 +1322,27 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 
 	switch (reg) {
 	case HFGRTR_EL2:
-		*res0 = compute_res0_bits(kvm, hfgrtr_feat_map,
-					  ARRAY_SIZE(hfgrtr_feat_map), 0, 0);
-		*res0 |= hfgrtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgrtr_desc, 0, 0);
 		*res1 = HFGRTR_EL2_RES1;
 		break;
 	case HFGWTR_EL2:
-		*res0 = compute_res0_bits(kvm, hfgwtr_feat_map,
-					  ARRAY_SIZE(hfgwtr_feat_map), 0, 0);
-		*res0 |= hfgwtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgwtr_desc, 0, 0);
 		*res1 = HFGWTR_EL2_RES1;
 		break;
 	case HFGITR_EL2:
-		*res0 = compute_res0_bits(kvm, hfgitr_feat_map,
-					  ARRAY_SIZE(hfgitr_feat_map), 0, 0);
-		*res0 |= hfgitr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgitr_desc, 0, 0);
 		*res1 = HFGITR_EL2_RES1;
 		break;
 	case HDFGRTR_EL2:
-		*res0 = compute_res0_bits(kvm, hdfgrtr_feat_map,
-					  ARRAY_SIZE(hdfgrtr_feat_map), 0, 0);
-		*res0 |= hdfgrtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hdfgrtr_desc, 0, 0);
 		*res1 = HDFGRTR_EL2_RES1;
 		break;
 	case HDFGWTR_EL2:
-		*res0 = compute_res0_bits(kvm, hdfgwtr_feat_map,
-					  ARRAY_SIZE(hdfgwtr_feat_map), 0, 0);
-		*res0 |= hdfgwtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hdfgwtr_desc, 0, 0);
 		*res1 = HDFGWTR_EL2_RES1;
 		break;
 	case HAFGRTR_EL2:
-		*res0 = compute_res0_bits(kvm, hafgrtr_feat_map,
-					  ARRAY_SIZE(hafgrtr_feat_map), 0, 0);
-		*res0 |= hafgrtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hafgrtr_desc, 0, 0);
 		*res1 = HAFGRTR_EL2_RES1;
 		break;
 	case HFGRTR2_EL2:
-- 
2.39.2

