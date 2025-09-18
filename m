Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ECC22D4C8
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208470; cv=none; b=u3senSXhlNgQPCCBT2j+XINEdbYzisy60mq/1k1No0Jt7260yibiqGGyK/HqJTj6b9S8Q+xzMkYzT+tn6SliL3dqZ2eVTd6yskQYxYuDV3OIA8LWH1//U+7Hm+llbH92cg4DrikW6qv/ttGyw5DH69NXVCNeCSuhNJS7SVytXI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208470; c=relaxed/simple;
	bh=rTVEKx9DQvqp+P0eKcmld01l0tLrPHWx9n0xI8iQyyE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d9rWD71VZO7FLv8NdVd0rn9wHvJERZnR9sd+/f6MlKSRUUklHPwcX2lWzE+cIfbYkKVkgpwPeiJ522wvLiXrS0F7DKC763HR7L0BzfPcnxIMjMWKoRcclEjGVVc16K4v1Nsi+X90ydtgiyfeRytK8vUYCVAHQXr2P0ZOTkueC0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiMEMf1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiMEMf1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE30C4CEEB;
	Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208469;
	bh=rTVEKx9DQvqp+P0eKcmld01l0tLrPHWx9n0xI8iQyyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiMEMf1RUgGb7ICf/8qkOoOvwnduAOUvDm02wKnjt4zWgjDSoj7sqhIhyAsidV9zi
	 jL/0bs6TVQTkboX/HuMMWKP9Ty/RQC+mNBpuTdqJtMFd2xavzR7NNNIYBbY87nQ2M1
	 jjPBPffXFSXPtbnDYbCNiflHqlfKPbKpoarG3rQGPpAYkg1jQQpGj2Or2hmEXbEx3w
	 oyq6jQawQeP1sD4mHXUKb4TYRsdpZQInu58c5DbSx6AuUBZowv4uSIPErReD/cMEl5
	 7eXLjCpVfD0tN0l2vOI48ywoDAATJseJzPtQw0bYjwdEt0MiFS84O2+paYQ3Sg8Tpx
	 rUju9J9LMvE6g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL6-00000007TmF-05bq;
	Thu, 18 Sep 2025 15:14:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 09/10] KVM: arm64: Convert SCTLR_EL1 RES0 handling to compute_reg_res0_bits()
Date: Thu, 18 Sep 2025 16:14:01 +0100
Message-Id: <20250918151402.1665315-10-maz@kernel.org>
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

While SCTLR_EL1 cannot be RES0, convert it to the same infrastructure
anyway, as it make things cleaner.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index c91b9ed3cb400..7b5c5044d4f64 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1128,6 +1128,9 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 		   FEAT_AA64EL1),
 };
 
+static const DECLARE_FEAT_MAP(sctlr_el1_desc, SCTLR_EL1,
+			      sctlr_el1_feat_map, FEAT_AA64EL1);
+
 static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
 	NEEDS_FEAT(MDCR_EL2_EBWE, FEAT_Debugv8p9),
 	NEEDS_FEAT(MDCR_EL2_TDOSA, FEAT_DoubleLock),
@@ -1200,8 +1203,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&hcr_desc);
 	check_reg_desc(&sctlr2_desc);
 	check_reg_desc(&tcr2_el2_desc);
-	check_feat_map(sctlr_el1_feat_map, ARRAY_SIZE(sctlr_el1_feat_map),
-		       SCTLR_EL1_RES0, "SCTLR_EL1");
+	check_reg_desc(&sctlr_el1_desc);
 	check_feat_map(mdcr_el2_feat_map, ARRAY_SIZE(mdcr_el2_feat_map),
 		       MDCR_EL2_RES0, "MDCR_EL2");
 }
@@ -1411,9 +1413,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = TCR2_EL2_RES1;
 		break;
 	case SCTLR_EL1:
-		*res0 = compute_res0_bits(kvm, sctlr_el1_feat_map,
-					  ARRAY_SIZE(sctlr_el1_feat_map), 0, 0);
-		*res0 |= SCTLR_EL1_RES0;
+		*res0 = compute_reg_res0_bits(kvm, &sctlr_el1_desc, 0, 0);
 		*res1 = SCTLR_EL1_RES1;
 		break;
 	case MDCR_EL2:
-- 
2.39.2

