Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A0622538F
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208470; cv=none; b=ZQeRMqpyeg+YRwD9Nm+yDwfkrx0yxF9XzwdH0+IY5BnCgsa3plILFK/iytb0eXtekN64o+/724SVNwxAZcGLeTQIRuYhrHqTXOgxxGLmJfJaZdRD9eWapVVrq43HhUlSfpforZWGnelSGoriY0kmBgDmtNuMoxFG6kv6GCFZny8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208470; c=relaxed/simple;
	bh=bkWRQqtYrz4w2lEEIkO4Lvo5LEDT2zg7t3ybpVPswlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KPv9FqKP2ixjWdrN3kHgY3pm9nnJHvWWE+JvTTh97ljKA8nYhNveh3kU3e1eHn/CllK3FdOh9nN4ek8FP//CwKgf0QH75/yXDbQWkOYl1wG0hqNy6IBg2uu/iGdILn2yiG1zvZfJ5YceNsi6k+bfE8aZTUsK0+mXA8djSN4VFCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FrLpR0ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FrLpR0ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70740C4CEF7;
	Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208469;
	bh=bkWRQqtYrz4w2lEEIkO4Lvo5LEDT2zg7t3ybpVPswlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrLpR0ciEZS6I/NGoRrWy3efFsOnQJSNZ/d8aiMIf55zzCGCN9rTqbmM4PxdhAuFP
	 /HdQKVZYGDl766IAI2FX61xQAKONpPcQw+3jXFtX8U+4MLMdJMHIWdd8qw/68NHHZt
	 Ozq34nmiJMFUPCjXHUNKUryIbfu/sKjmvO3JBTGAfJnOHdhX9UZkqrvQ7v8jr49/n4
	 FoVMW02i2Cv9CArYlSK56oFg3eW/8ZSaNsFK2eleS3vArLPLgisXzq/wuOQIFm7sqj
	 QlGtvv1iD/oDfxCaG9VGrVj4hQ36yRMa49IwlrHs/nBnwUtDaOFJ4MxaIhD+mcMP44
	 oAIiQTFqBHj1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL5-00000007TmF-2fd5;
	Thu, 18 Sep 2025 15:14:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 07/10] KVM: arm64: Enforce absence of FEAT_SCTLR2 on SCTLR2_EL{1,2}
Date: Thu, 18 Sep 2025 16:13:59 +0100
Message-Id: <20250918151402.1665315-8-maz@kernel.org>
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

Enforce that SCTLR2_EL{1,2} are RES0 when FEAT_SCTLR2 isn't present.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index c96d5ff760deb..94dfc1320bd36 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1026,6 +1026,9 @@ static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 		   FEAT_CPA2),
 };
 
+static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
+			      sctlr2_feat_map, FEAT_SCTLR2);
+
 static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 	NEEDS_FEAT(TCR2_EL2_FNG1	|
 		   TCR2_EL2_FNG0	|
@@ -1192,8 +1195,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&hdfgwtr2_desc);
 	check_reg_desc(&hcrx_desc);
 	check_reg_desc(&hcr_desc);
-	check_feat_map(sctlr2_feat_map, ARRAY_SIZE(sctlr2_feat_map),
-		       SCTLR2_EL1_RES0, "SCTLR2_EL1");
+	check_reg_desc(&sctlr2_desc);
 	check_feat_map(tcr2_el2_feat_map, ARRAY_SIZE(tcr2_el2_feat_map),
 		       TCR2_EL2_RES0, "TCR2_EL2");
 	check_feat_map(sctlr_el1_feat_map, ARRAY_SIZE(sctlr_el1_feat_map),
@@ -1399,9 +1401,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		break;
 	case SCTLR2_EL1:
 	case SCTLR2_EL2:
-		*res0 = compute_res0_bits(kvm, sctlr2_feat_map,
-					  ARRAY_SIZE(sctlr2_feat_map), 0, 0);
-		*res0 |= SCTLR2_EL1_RES0;
+		*res0 = compute_reg_res0_bits(kvm, &sctlr2_desc, 0, 0);
 		*res1 = SCTLR2_EL1_RES1;
 		break;
 	case TCR2_EL2:
-- 
2.39.2

