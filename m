Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86552FB98D
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128327; cv=none; b=DYi5HC0Ix1rZWpWsulrYxfa9wQt+UDJuGAITdzOuvuJ//CCEN4FrfPmlBygyDRJKciyRxmRnDJDR7AOZQi77iHeFgVFoCRJuXEiVMbcjiDVbeQ26VyKWMA6Ycc5ajGOfdOlJeIiI9DM73D18fZKCRqJ/RVpeKGwQSh6wWo6oPhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128327; c=relaxed/simple;
	bh=d+w3TjPvq3SS133fV6Sh+nZK6LHsjMEfCPRqIKDB9F0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b9HOKcFzINK4zL3V8pV6IDP5+kwhnhiCl1IKrbKD/1jk/XNRtdEl4myoZJgu5DfwYoz+hAdkO6QABP3vsICLMq9u9B4YuRk5sbZv41DkETuv20h9oiPuReIR6xPlydoouL3pvOGFiTaJ2w3vRsZ4SN1tE9wMxuo1QhF7ThvA2Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LObE7gn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LObE7gn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBE0C4CEFB;
	Wed, 17 Sep 2025 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128327;
	bh=d+w3TjPvq3SS133fV6Sh+nZK6LHsjMEfCPRqIKDB9F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LObE7gn/2oQ9thof55DcvUVU8XCcofs1b3KKKB1+b/lxmpoHZwjk5s8+zlhBW2X9y
	 N6mV59OP0xZccwtVcDpeSIriWIXm/DcO+o/21CEZ2n04+R9xXb34fMcfA3JrOpNn6v
	 BuHRjPD0f7dwp4a0W9zDhnyTMmW6dtc8cCRmr3KS20bG+/nbGnOUKcq6flKUDvF8az
	 iDoisbJ9NQpPL9g6+8J7T/irzS+hi4w9mlpqWhYNQP8Ei/E7K2Jq6LWXIPxORfbl/k
	 vzvDRzENjQMHKZaqhhFfDc79Fok6gRSuVNXwuomU4STzkRHiLaJJ6a8kqZzDWWaURx
	 JzV9etaLiMHBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUT-00000007AQw-2EJn;
	Wed, 17 Sep 2025 16:58:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 7/8] KVM: arm64: Convert SCTLR_EL1 RES0 handling to compute_reg_res0_bits()
Date: Wed, 17 Sep 2025 17:58:39 +0100
Message-Id: <20250917165840.1633412-8-maz@kernel.org>
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
 arch/arm64/kvm/config.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 0e6723bd75775..09af46e16ac30 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1050,7 +1050,7 @@ static const
 struct reg_to_feat_map tcr2_el2_feat_map = FEAT_MAP(TCR2_EL2, FEAT_TCR2,
 						    tcr2_el2_bit_feat_map);
 
-static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
+static const struct reg_bits_to_feat_map sctlr_el1_bit_feat_map[] = {
 	NEEDS_FEAT(SCTLR_EL1_CP15BEN	|
 		   SCTLR_EL1_ITD	|
 		   SCTLR_EL1_SED,
@@ -1124,6 +1124,10 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 		   FEAT_AA64EL1),
 };
 
+static const
+struct reg_to_feat_map sctlr_el1_feat_map = FEAT_MAP(SCTLR_EL1, FEAT_AA64EL1,
+						    sctlr_el1_bit_feat_map);
+
 static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
 	NEEDS_FEAT(MDCR_EL2_EBWE, FEAT_Debugv8p9),
 	NEEDS_FEAT(MDCR_EL2_TDOSA, FEAT_DoubleLock),
@@ -1196,8 +1200,7 @@ void __init check_feature_map(void)
 	check_reg_feat_map(&hcr_feat_map);
 	check_reg_feat_map(&sctlr2_feat_map);
 	check_reg_feat_map(&tcr2_el2_feat_map);
-	check_feat_map(sctlr_el1_feat_map, ARRAY_SIZE(sctlr_el1_feat_map),
-		       SCTLR_EL1_RES0, "SCTLR_EL1");
+	check_reg_feat_map(&sctlr_el1_feat_map);
 	check_feat_map(mdcr_el2_feat_map, ARRAY_SIZE(mdcr_el2_feat_map),
 		       MDCR_EL2_RES0, "MDCR_EL2");
 }
@@ -1407,9 +1410,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = TCR2_EL2_RES1;
 		break;
 	case SCTLR_EL1:
-		*res0 = compute_res0_bits(kvm, sctlr_el1_feat_map,
-					  ARRAY_SIZE(sctlr_el1_feat_map), 0, 0);
-		*res0 |= SCTLR_EL1_RES0;
+		*res0 = compute_reg_res0_bits(kvm, &sctlr_el1_feat_map, 0, 0);
 		*res1 = SCTLR_EL1_RES1;
 		break;
 	case MDCR_EL2:
-- 
2.39.2

