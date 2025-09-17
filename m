Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85D92EC54D
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128327; cv=none; b=O/+wW/1LkvfvSq1hF3OzbjNC2XjKAnSarlUGdwfMe5IPsAy1E2KjaB5oSSo50rQxNkRRRb08/ZrhYjwzr0yuel94T5jPpxSZ/o3gYklFEvWIyZJXmkuLGmWrFu9Vv+CYaKo0a9T24WS1NbJOLgR+XZQ2BVbUZq1am7Ga5w23zd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128327; c=relaxed/simple;
	bh=scTyprIG46wzzk/gBRmZrGtepaqC0rmNAeCBnCv2f18=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=msBbAaxGPWuLp+bdOHGnHV566/leITPy8t9TCVYnqvUMslRxys+Cw09ki2Hih2INYekqlYHtyedO8dgmkZJ5hrzxKNXDUW1MrSrdkuhgpZfj5riIIIA/UoqXVT3X2vjMdllfbiK1HK4UEuJqVZ8O4KCce/Yb860P3QKutCKlwi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=juuFVrex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juuFVrex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2702BC4CEF9;
	Wed, 17 Sep 2025 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128327;
	bh=scTyprIG46wzzk/gBRmZrGtepaqC0rmNAeCBnCv2f18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juuFVrexea4AiIX8dfoeS3iEFSVaN68SbbwSJjux3kL1m3EAfUu1/iEatD/5BRbzr
	 mqi+F+7FFJBL51EEQbT0wNKnAsWByyYs8FKLutCsRBJKjn7S8gBYsBTHzNA0qI2fXn
	 gtmuv77UbFtPhiQs4uAgo77hqZcBS01Hc2lh6eKnhf2xctkvuZxkE6HrhN7LPXugYZ
	 yjMycru63KJ+gMklf6GTl6CHbZCdhtZsWSHUJi/ScsbjZNrfOrSDbQpsfu9uebSfqd
	 sVYColMzN+X53Qyz6RPDICLbTovHt+T7WkcSXagGBe8RrvZrnCK1yPQmj6OHyERNt0
	 5jC+U6fekI9zQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUT-00000007AQw-1Lgh;
	Wed, 17 Sep 2025 16:58:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 6/8] KVM: arm64: Enforce absence of FEAT_TCR2 on TCR2_EL2
Date: Wed, 17 Sep 2025 17:58:38 +0100
Message-Id: <20250917165840.1633412-7-maz@kernel.org>
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
index b008551fcf7e9..0e6723bd75775 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1024,7 +1024,7 @@ static const
 struct reg_to_feat_map sctlr2_feat_map = FEAT_MAP(SCTLR2_EL1, FEAT_SCTLR2,
 						  sctlr2_bit_feat_map);
 
-static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
+static const struct reg_bits_to_feat_map tcr2_el2_bit_feat_map[] = {
 	NEEDS_FEAT(TCR2_EL2_FNG1	|
 		   TCR2_EL2_FNG0	|
 		   TCR2_EL2_A2,
@@ -1046,6 +1046,10 @@ static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 	NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
 };
 
+static const
+struct reg_to_feat_map tcr2_el2_feat_map = FEAT_MAP(TCR2_EL2, FEAT_TCR2,
+						    tcr2_el2_bit_feat_map);
+
 static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 	NEEDS_FEAT(SCTLR_EL1_CP15BEN	|
 		   SCTLR_EL1_ITD	|
@@ -1191,8 +1195,7 @@ void __init check_feature_map(void)
 	check_reg_feat_map(&hcrx_feat_map);
 	check_reg_feat_map(&hcr_feat_map);
 	check_reg_feat_map(&sctlr2_feat_map);
-	check_feat_map(tcr2_el2_feat_map, ARRAY_SIZE(tcr2_el2_feat_map),
-		       TCR2_EL2_RES0, "TCR2_EL2");
+	check_reg_feat_map(&tcr2_el2_feat_map);
 	check_feat_map(sctlr_el1_feat_map, ARRAY_SIZE(sctlr_el1_feat_map),
 		       SCTLR_EL1_RES0, "SCTLR_EL1");
 	check_feat_map(mdcr_el2_feat_map, ARRAY_SIZE(mdcr_el2_feat_map),
@@ -1400,9 +1403,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = SCTLR2_EL1_RES1;
 		break;
 	case TCR2_EL2:
-		*res0 = compute_res0_bits(kvm, tcr2_el2_feat_map,
-					  ARRAY_SIZE(tcr2_el2_feat_map), 0, 0);
-		*res0 |= TCR2_EL2_RES0;
+		*res0 = compute_reg_res0_bits(kvm, &tcr2_el2_feat_map, 0, 0);
 		*res1 = TCR2_EL2_RES1;
 		break;
 	case SCTLR_EL1:
-- 
2.39.2

