Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7386D280335
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128326; cv=none; b=aerEXNjsorfP1AiB0+uN/K/9rsa3KBYX7h1WCD4SmGY3WbYnahqcxGeG5Uq4J9sc8hQXPREZq9L3hj7DGCRkkHRJYkGfxMLm/PEfXh/ZMQxaUAHmCaAyAj8ZzV+tG2FOpQsIiHseNNDEAAAmTdUqIAzavDkXjeFXvZ1r0oPzJuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128326; c=relaxed/simple;
	bh=cSC14ut31BTnaiIXpiotB6yDjSva7fSPUzTwWq0RIpo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EWiPMdnC/UxmHvs1BO4gqSYtVj4TWgGxGAw86tCnhyRePPI8LEZWlqpGPmL8B4ZpkniPcdFTFFfeyuYnIQOvErbiTiFuwbV5H2eqtvwa0E03TiUwEhHCVdyAHn9K7/p0ELIWeStmNHjYUgAp5qU3HbVe7vLhCkxC5RCarGdTh0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWEv/sB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWEv/sB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F097C4CEE7;
	Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128326;
	bh=cSC14ut31BTnaiIXpiotB6yDjSva7fSPUzTwWq0RIpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWEv/sB7YVloCJCT7uhXlZNtSBRNlBGaiIpZYsD4XjYFwvEss+xn1keJsseDB+9vu
	 KoHEVhc82+dxEJ8XWPrKUpNc2GH1uUDEpgSCJ2XhSmcs0Hcdh6bDtA1AuX1cNPstKU
	 O2TAd6FgX/upFELGhcjsLyE39EHY3c2OXkyCCyR2odcl5xV1AbkXMyKVtzzBcpD/Tf
	 gqN41cNtdcERRu2lKUuK6w80GZ6BP3ONAwc3pbcpBG6juVFsHvqCZP4Z/gAFKEWCY7
	 89vMG1Ujrsdgzp4tTyEzLtRsIcqnylIP58XRdK7hlrAELvwKYyP3uMfhOwcoC8MtId
	 poWKubSS/UaLw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUS-00000007AQw-0xFh;
	Wed, 17 Sep 2025 16:58:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 1/8] KVM: arm64: Enforce absence of FEAT_FGT on FGT registers
Date: Wed, 17 Sep 2025 17:58:33 +0100
Message-Id: <20250917165840.1633412-2-maz@kernel.org>
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
 arch/arm64/kvm/config.c | 201 +++++++++++++++++++++++++++-------------
 1 file changed, 137 insertions(+), 64 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index da66c4a147752..42b834c82a20d 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -8,11 +8,16 @@
 #include <asm/sysreg.h>
 
 struct reg_bits_to_feat_map {
-	u64		bits;
+	union {
+		u64	bits;
+		u64	*res0p;
+	};
 
 #define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
 #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
 #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
+#define	RES0_POINTER	BIT(3)	/* Pointer to RES0 value instead of bits */
+
 	unsigned long	flags;
 
 	union {
@@ -28,9 +33,16 @@ struct reg_bits_to_feat_map {
 	};
 };
 
-#define __NEEDS_FEAT_3(m, f, id, fld, lim)		\
+struct reg_to_feat_map {
+	const char				*name;
+	const struct reg_bits_to_feat_map	feat_map;
+	const struct reg_bits_to_feat_map	*bit_feat_map;
+	const unsigned int			bit_feat_map_sz;
+};
+
+#define __NEEDS_FEAT_3(m, f, w, id, fld, lim)		\
 	{						\
-		.bits	= (m),				\
+		.w	= (m),				\
 		.flags = (f),				\
 		.regidx	= IDREG_IDX(SYS_ ## id),	\
 		.shift	= id ##_## fld ## _SHIFT,	\
@@ -39,28 +51,50 @@ struct reg_bits_to_feat_map {
 		.lo_lim	= id ##_## fld ##_## lim	\
 	}
 
-#define __NEEDS_FEAT_2(m, f, fun, dummy)		\
+#define __NEEDS_FEAT_2(m, f, w, fun, dummy)		\
 	{						\
-		.bits	= (m),				\
+		.w	= (m),				\
 		.flags = (f) | CALL_FUNC,		\
 		.fval = (fun),				\
 	}
 
-#define __NEEDS_FEAT_1(m, f, fun)			\
+#define __NEEDS_FEAT_1(m, f, w, fun)			\
 	{						\
-		.bits	= (m),				\
+		.w	= (m),				\
 		.flags = (f) | CALL_FUNC,		\
 		.match = (fun),				\
 	}
 
+#define __NEEDS_FEAT_FLAG(m, f, w, ...)			\
+	CONCATENATE(__NEEDS_FEAT_, COUNT_ARGS(__VA_ARGS__))(m, f, w, __VA_ARGS__)
+
 #define NEEDS_FEAT_FLAG(m, f, ...)			\
-	CONCATENATE(__NEEDS_FEAT_, COUNT_ARGS(__VA_ARGS__))(m, f, __VA_ARGS__)
+	__NEEDS_FEAT_FLAG(m, f, bits, __VA_ARGS__)
 
 #define NEEDS_FEAT_FIXED(m, ...)			\
-	NEEDS_FEAT_FLAG(m, FIXED_VALUE, __VA_ARGS__, 0)
+	__NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
+
+#define NEEDS_FEAT_RES0(p, ...)				\
+	__NEEDS_FEAT_FLAG(p, RES0_POINTER, res0p, __VA_ARGS__)
 
 #define NEEDS_FEAT(m, ...)	NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
 
+#define FEAT_MAP(r, f, m)						\
+	{								\
+		.name			= #r,				\
+		.feat_map		= NEEDS_FEAT(~r##_RES0, f), 	\
+		.bit_feat_map		= m,				\
+		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
+	}
+
+#define FEAT_MAP_FGT(msk, m, f)						\
+	{								\
+		.name			= #msk,				\
+		.feat_map		= NEEDS_FEAT_RES0(&msk.res0, f),\
+		.bit_feat_map		= m,				\
+		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
+	}
+
 #define FEAT_SPE		ID_AA64DFR0_EL1, PMSVer, IMP
 #define FEAT_SPE_FnE		ID_AA64DFR0_EL1, PMSVer, V1P2
 #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
@@ -320,7 +354,7 @@ static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
 	return true;
 }
 
-static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
+static const struct reg_bits_to_feat_map hfgrtr_bit_feat_map[] = {
 	NEEDS_FEAT(HFGRTR_EL2_nAMAIR2_EL1	|
 		   HFGRTR_EL2_nMAIR2_EL1,
 		   FEAT_AIE),
@@ -397,7 +431,12 @@ static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
 			NEVER_FGU, FEAT_AA64EL1),
 };
 
-static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
+static const
+struct reg_to_feat_map hfgrtr_feat_map = FEAT_MAP_FGT(hfgrtr_masks,
+						      hfgrtr_bit_feat_map,
+						      FEAT_FGT);
+
+static const struct reg_bits_to_feat_map hfgwtr_bit_feat_map[] = {
 	NEEDS_FEAT(HFGWTR_EL2_nAMAIR2_EL1	|
 		   HFGWTR_EL2_nMAIR2_EL1,
 		   FEAT_AIE),
@@ -461,7 +500,12 @@ static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
 			NEVER_FGU, FEAT_AA64EL1),
 };
 
-static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
+static const
+struct reg_to_feat_map hfgwtr_feat_map = FEAT_MAP_FGT(hfgwtr_masks,
+						      hfgwtr_bit_feat_map,
+						      FEAT_FGT);
+
+static const struct reg_bits_to_feat_map hdfgrtr_bit_feat_map[] = {
 	NEEDS_FEAT(HDFGRTR_EL2_PMBIDR_EL1	|
 		   HDFGRTR_EL2_PMSLATFR_EL1	|
 		   HDFGRTR_EL2_PMSIRR_EL1	|
@@ -528,7 +572,12 @@ static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
 			NEVER_FGU, FEAT_AA64EL1)
 };
 
-static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
+static const
+struct reg_to_feat_map hdfgrtr_feat_map = FEAT_MAP_FGT(hdfgrtr_masks,
+						       hdfgrtr_bit_feat_map,
+						       FEAT_FGT);
+
+static const struct reg_bits_to_feat_map hdfgwtr_bit_feat_map[] = {
 	NEEDS_FEAT(HDFGWTR_EL2_PMSLATFR_EL1	|
 		   HDFGWTR_EL2_PMSIRR_EL1	|
 		   HDFGWTR_EL2_PMSICR_EL1	|
@@ -588,8 +637,12 @@ static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
 	NEEDS_FEAT(HDFGWTR_EL2_TRFCR_EL1, FEAT_TRF),
 };
 
+static const
+struct reg_to_feat_map hdfgwtr_feat_map = FEAT_MAP_FGT(hdfgwtr_masks,
+						       hdfgwtr_bit_feat_map,
+						       FEAT_FGT);
 
-static const struct reg_bits_to_feat_map hfgitr_feat_map[] = {
+static const struct reg_bits_to_feat_map hfgitr_bit_feat_map[] = {
 	NEEDS_FEAT(HFGITR_EL2_PSBCSYNC, FEAT_SPEv1p5),
 	NEEDS_FEAT(HFGITR_EL2_ATS1E1A, FEAT_ATS1A),
 	NEEDS_FEAT(HFGITR_EL2_COSPRCTX, FEAT_SPECRES2),
@@ -662,7 +715,12 @@ static const struct reg_bits_to_feat_map hfgitr_feat_map[] = {
 			NEVER_FGU, FEAT_AA64EL1),
 };
 
-static const struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
+static const
+struct reg_to_feat_map hfgitr_feat_map = FEAT_MAP_FGT(hfgitr_masks,
+						      hfgitr_bit_feat_map,
+						      FEAT_FGT);
+
+static const struct reg_bits_to_feat_map hafgrtr_bit_feat_map[] = {
 	NEEDS_FEAT(HAFGRTR_EL2_AMEVTYPER115_EL0	|
 		   HAFGRTR_EL2_AMEVTYPER114_EL0	|
 		   HAFGRTR_EL2_AMEVTYPER113_EL0	|
@@ -704,6 +762,11 @@ static const struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
 		   FEAT_AMUv1),
 };
 
+static const
+struct reg_to_feat_map hafgrtr_feat_map = FEAT_MAP_FGT(hafgrtr_masks,
+						       hafgrtr_bit_feat_map,
+						       FEAT_FGT);
+
 static const struct reg_bits_to_feat_map hfgitr2_feat_map[] = {
 	NEEDS_FEAT(HFGITR2_EL2_nDCCIVAPS, FEAT_PoPS),
 	NEEDS_FEAT(HFGITR2_EL2_TSBCSYNC, FEAT_TRBEv1p1)
@@ -1061,20 +1124,25 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 			str, mask ^ ~res0);
 }
 
+static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
+{
+	return map->flags & RES0_POINTER ? ~(*map->res0p) : map->bits;
+}
+
+static void __init check_reg_feat_map(const struct reg_to_feat_map *r)
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
+	check_reg_feat_map(&hfgrtr_feat_map);
+	check_reg_feat_map(&hfgwtr_feat_map);
+	check_reg_feat_map(&hfgitr_feat_map);
+	check_reg_feat_map(&hdfgrtr_feat_map);
+	check_reg_feat_map(&hdfgwtr_feat_map);
+	check_reg_feat_map(&hafgrtr_feat_map);
 	check_feat_map(hcrx_feat_map, ARRAY_SIZE(hcrx_feat_map),
 		       __HCRX_EL2_RES0, "HCRX_EL2");
 	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
@@ -1129,7 +1197,7 @@ static u64 __compute_fixed_bits(struct kvm *kvm,
 			match = idreg_feat_match(kvm, &map[i]);
 
 		if (!match || (map[i].flags & FIXED_VALUE))
-			val |= map[i].bits;
+			val |= reg_feat_map_bits(&map[i]);
 	}
 
 	return val;
@@ -1145,6 +1213,29 @@ static u64 compute_res0_bits(struct kvm *kvm,
 				    require, exclude | FIXED_VALUE);
 }
 
+static u64 compute_reg_res0_bits(struct kvm *kvm,
+				 const struct reg_to_feat_map *r,
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
@@ -1162,30 +1253,24 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 
 	switch (fgt) {
 	case HFGRTR_GROUP:
-		val |= compute_res0_bits(kvm, hfgrtr_feat_map,
-					 ARRAY_SIZE(hfgrtr_feat_map),
-					 0, NEVER_FGU);
-		val |= compute_res0_bits(kvm, hfgwtr_feat_map,
-					 ARRAY_SIZE(hfgwtr_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgrtr_feat_map,
+					     0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgwtr_feat_map,
+					     0, NEVER_FGU);
 		break;
 	case HFGITR_GROUP:
-		val |= compute_res0_bits(kvm, hfgitr_feat_map,
-					 ARRAY_SIZE(hfgitr_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hfgitr_feat_map,
+					     0, NEVER_FGU);
 		break;
 	case HDFGRTR_GROUP:
-		val |= compute_res0_bits(kvm, hdfgrtr_feat_map,
-					 ARRAY_SIZE(hdfgrtr_feat_map),
-					 0, NEVER_FGU);
-		val |= compute_res0_bits(kvm, hdfgwtr_feat_map,
-					 ARRAY_SIZE(hdfgwtr_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hdfgrtr_feat_map,
+					     0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hdfgwtr_feat_map,
+					     0, NEVER_FGU);
 		break;
 	case HAFGRTR_GROUP:
-		val |= compute_res0_bits(kvm, hafgrtr_feat_map,
-					 ARRAY_SIZE(hafgrtr_feat_map),
-					 0, NEVER_FGU);
+		val |= compute_reg_res0_bits(kvm, &hafgrtr_feat_map,
+					     0, NEVER_FGU);
 		break;
 	case HFGRTR2_GROUP:
 		val |= compute_res0_bits(kvm, hfgrtr2_feat_map,
@@ -1221,39 +1306,27 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 
 	switch (reg) {
 	case HFGRTR_EL2:
-		*res0 = compute_res0_bits(kvm, hfgrtr_feat_map,
-					  ARRAY_SIZE(hfgrtr_feat_map), 0, 0);
-		*res0 |= hfgrtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgrtr_feat_map, 0, 0);
 		*res1 = HFGRTR_EL2_RES1;
 		break;
 	case HFGWTR_EL2:
-		*res0 = compute_res0_bits(kvm, hfgwtr_feat_map,
-					  ARRAY_SIZE(hfgwtr_feat_map), 0, 0);
-		*res0 |= hfgwtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgwtr_feat_map, 0, 0);
 		*res1 = HFGWTR_EL2_RES1;
 		break;
 	case HFGITR_EL2:
-		*res0 = compute_res0_bits(kvm, hfgitr_feat_map,
-					  ARRAY_SIZE(hfgitr_feat_map), 0, 0);
-		*res0 |= hfgitr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hfgitr_feat_map, 0, 0);
 		*res1 = HFGITR_EL2_RES1;
 		break;
 	case HDFGRTR_EL2:
-		*res0 = compute_res0_bits(kvm, hdfgrtr_feat_map,
-					  ARRAY_SIZE(hdfgrtr_feat_map), 0, 0);
-		*res0 |= hdfgrtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hdfgrtr_feat_map, 0, 0);
 		*res1 = HDFGRTR_EL2_RES1;
 		break;
 	case HDFGWTR_EL2:
-		*res0 = compute_res0_bits(kvm, hdfgwtr_feat_map,
-					  ARRAY_SIZE(hdfgwtr_feat_map), 0, 0);
-		*res0 |= hdfgwtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hdfgwtr_feat_map, 0, 0);
 		*res1 = HDFGWTR_EL2_RES1;
 		break;
 	case HAFGRTR_EL2:
-		*res0 = compute_res0_bits(kvm, hafgrtr_feat_map,
-					  ARRAY_SIZE(hafgrtr_feat_map), 0, 0);
-		*res0 |= hafgrtr_masks.res0;
+		*res0 = compute_reg_res0_bits(kvm, &hafgrtr_feat_map, 0, 0);
 		*res1 = HAFGRTR_EL2_RES1;
 		break;
 	case HFGRTR2_EL2:
-- 
2.39.2

