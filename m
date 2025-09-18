Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C118521B9D2
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208469; cv=none; b=UrwoeW9UMMQf8BlhYi6W1edfjlJPbCl0ugwJUW686P1PJckefOCZyGHy+Y8g1W5YTIUC/VooHDYaWzW/CCK7W+xMFeFQG9sEjajv2WgGXOZASfISxg3pMWQRohNBDmrelM6NeFc7LdATvhjeAb2xAxg5PnPC6oZdLGM9AQi5SfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208469; c=relaxed/simple;
	bh=4JKWva21hEmO3GDcKRhhJ0dp6bwMOj89EVA7MRjSyVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M2sys4QxYpAYJLFZRZtDpJHRlI8vlvWFhBbYwOsfqax1RdOxnADZR6GVLzquHwlS3XdB6y3FwCy/pyFVS4s1voJjqGQPfHr3/Sfh7wZS3El4+K561hVG7Hh1dQlCyg3JewSbQaJ+SO11+Oy0IzAWxyPy0D5re/k05Jncc8CnzEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQHsCcWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQHsCcWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09D7C4CEE7;
	Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208469;
	bh=4JKWva21hEmO3GDcKRhhJ0dp6bwMOj89EVA7MRjSyVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQHsCcWB8KZ14t29aq1GCt4MT1Mr7y8BCf5SgvaFFeXfJy5QIn0XZwK96CpbtDRzb
	 kOSWsu5rfPRioHfEnnZizevQbJh3BTNHbKcZnmQrJmaqg2EXnkzAjDe9Bqb6gTWdht
	 2jf836H3J7Hn2QAkOuHv4M7SJspAhoF6XgOCP6t7ZV0cOVoFC38j1WxMnLOgk2ZBaW
	 X44yUpQySfT6bh8oOTIfdQgaC0H7GIyHOsGyJgKo4kYpmio1w+Bf04U36DKhgsvNvl
	 xqC9x6r921h96W9Jj89QHeeD5R3/+Zuwqmw9d2vsNE+KzjkpzdgAG4O2T3p9F+x0tT
	 zsfCZs9LfDR3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL5-00000007TmF-3TmN;
	Thu, 18 Sep 2025 15:14:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 08/10] KVM: arm64: Enforce absence of FEAT_TCR2 on TCR2_EL2
Date: Thu, 18 Sep 2025 16:14:00 +0100
Message-Id: <20250918151402.1665315-9-maz@kernel.org>
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

Enforce that TCR2_EL2 are RES0 when FEAT_TCR2 isn't present.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 94dfc1320bd36..c91b9ed3cb400 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1051,6 +1051,9 @@ static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 	NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
 };
 
+static const DECLARE_FEAT_MAP(tcr2_el2_desc, TCR2_EL2,
+			      tcr2_el2_feat_map, FEAT_TCR2);
+
 static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 	NEEDS_FEAT(SCTLR_EL1_CP15BEN	|
 		   SCTLR_EL1_ITD	|
@@ -1196,8 +1199,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&hcrx_desc);
 	check_reg_desc(&hcr_desc);
 	check_reg_desc(&sctlr2_desc);
-	check_feat_map(tcr2_el2_feat_map, ARRAY_SIZE(tcr2_el2_feat_map),
-		       TCR2_EL2_RES0, "TCR2_EL2");
+	check_reg_desc(&tcr2_el2_desc);
 	check_feat_map(sctlr_el1_feat_map, ARRAY_SIZE(sctlr_el1_feat_map),
 		       SCTLR_EL1_RES0, "SCTLR_EL1");
 	check_feat_map(mdcr_el2_feat_map, ARRAY_SIZE(mdcr_el2_feat_map),
@@ -1405,9 +1407,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = SCTLR2_EL1_RES1;
 		break;
 	case TCR2_EL2:
-		*res0 = compute_res0_bits(kvm, tcr2_el2_feat_map,
-					  ARRAY_SIZE(tcr2_el2_feat_map), 0, 0);
-		*res0 |= TCR2_EL2_RES0;
+		*res0 = compute_reg_res0_bits(kvm, &tcr2_el2_desc, 0, 0);
 		*res1 = TCR2_EL2_RES1;
 		break;
 	case SCTLR_EL1:
-- 
2.39.2

