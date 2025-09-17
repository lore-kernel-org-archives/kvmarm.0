Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D2E2FB98B
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128327; cv=none; b=GZJKXVnqCSNEB5yTn0iqeTslbXlbBjXZ1r7IRf+309OkRHsdP1Qz+pRITJJ5Uzvw1vrip74wVqWYNyYppEmj4kT60n00jEpso9pI+NrmhU/qtz++h/3inFAeoigCLwSU0jodn6EXsHML9XXDmEVV8UWsDgEaz4WsQupKgrryKx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128327; c=relaxed/simple;
	bh=Kiey6llcR/9OaYihZ/Gd4p8aLsz+gppndFzWm8Yg6Jc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CEY3YXc2xMve91itPcDa9jSXQk7HFNdX+ng1q/5Ynn08psPdOQ1yYm0wfFO6Y53XC798tgqjkrySuZzzOzF9virmg3Q05FhOMgQ4YqGiXzoRltgMZO4HbU47z3GEPKpeXgYGWOmHzdbHZyqit+6i32NWH9nP+xcAnzwdRHREHFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pt+E3mU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pt+E3mU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7755BC4CEF7;
	Wed, 17 Sep 2025 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128327;
	bh=Kiey6llcR/9OaYihZ/Gd4p8aLsz+gppndFzWm8Yg6Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pt+E3mU4DZbdi+uC/jKdJQ/sHiY21giwbK8o16iKMtCjgdYfjmhpxWPWl7bI7SkS1
	 Gw41ll6KvukB/h4GwcfqR1qVQOhYM2PAz05XKgelZquSyrLQLgZxq27loCY42hvCDp
	 H/IWnzmbNVpG7fl8VM4GXRgXWuH2n2dDIDUWtxALWQ1iD8CGoMZCPsvPYlUxeYhtxi
	 F2/wIm1AZICWWslMNHNQIY3GGT4tvdwdKat5sdKZ+4N/lb4yXAWHg4Dc3tsC6VnviE
	 ZyNWfDhjZYjZr4fPNtEdrX750s8cq+ZjKtPXkymoAoL5RUZDgp3bVZZwo1iywnyYln
	 1UWFJ7BgvSnFw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUT-00000007AQw-35BH;
	Wed, 17 Sep 2025 16:58:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 8/8] KVM: arm64: Convert MDCR_EL2 RES0 handling to compute_reg_res0_bits()
Date: Wed, 17 Sep 2025 17:58:40 +0100
Message-Id: <20250917165840.1633412-9-maz@kernel.org>
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
 arch/arm64/kvm/config.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 09af46e16ac30..91e235cfdbffd 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1128,7 +1128,7 @@ static const
 struct reg_to_feat_map sctlr_el1_feat_map = FEAT_MAP(SCTLR_EL1, FEAT_AA64EL1,
 						    sctlr_el1_bit_feat_map);
 
-static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
+static const struct reg_bits_to_feat_map mdcr_el2_bit_feat_map[] = {
 	NEEDS_FEAT(MDCR_EL2_EBWE, FEAT_Debugv8p9),
 	NEEDS_FEAT(MDCR_EL2_TDOSA, FEAT_DoubleLock),
 	NEEDS_FEAT(MDCR_EL2_PMEE, FEAT_EBEP),
@@ -1159,6 +1159,10 @@ static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
 		   FEAT_AA64EL1),
 };
 
+static const
+struct reg_to_feat_map mdcr_el2_feat_map = FEAT_MAP(MDCR_EL2, FEAT_AA64EL2,
+						    mdcr_el2_bit_feat_map);
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 res0, const char *str)
 {
@@ -1201,8 +1205,7 @@ void __init check_feature_map(void)
 	check_reg_feat_map(&sctlr2_feat_map);
 	check_reg_feat_map(&tcr2_el2_feat_map);
 	check_reg_feat_map(&sctlr_el1_feat_map);
-	check_feat_map(mdcr_el2_feat_map, ARRAY_SIZE(mdcr_el2_feat_map),
-		       MDCR_EL2_RES0, "MDCR_EL2");
+	check_reg_feat_map(&mdcr_el2_feat_map);
 }
 
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
@@ -1414,8 +1417,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = SCTLR_EL1_RES1;
 		break;
 	case MDCR_EL2:
-		*res0 = compute_res0_bits(kvm, mdcr_el2_feat_map,
-					  ARRAY_SIZE(mdcr_el2_feat_map), 0, 0);
+		*res0 = compute_reg_res0_bits(kvm, &mdcr_el2_feat_map, 0, 0);
 		*res0 |= MDCR_EL2_RES0;
 		*res1 = MDCR_EL2_RES1;
 		break;
-- 
2.39.2

