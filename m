Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AA22EC54D
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128327; cv=none; b=aGl745D9UmODEQwAuJxKYjKL+0hQHjDKnGXKymlmQ+LloQhhqOSnhKQDqQTueCRe9/TQypBEJwnfRDoSr1K/2rXmY4tJeIvEgZ8ju+oXPo6mdBFUFY6ssNudZhoSD0y3yFHyZYmFf4bS79YEXueGt4hLdHS6TzBK4pxMtLb+V8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128327; c=relaxed/simple;
	bh=VpOJNRwl2DYuPo+JJm5mHhn8oEhhYX3X3OUxG+V4VUk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RW0WReMgqe6Bp8JUY77/DYuhrC+VGqHd+OU02kxktdI/7NWxQccG9dHpMPkDktpOWHkrnR/GeXhuym6w8rMXEkoTW9CttabB5Msr7887H0SAO6t39WO0wo5pJ6MP7mo6E0phacLkBCgEU9WuQGRgNcDujjpyROxmYAP16ViezRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3rSxk1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3rSxk1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5FCC4CEFA;
	Wed, 17 Sep 2025 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128327;
	bh=VpOJNRwl2DYuPo+JJm5mHhn8oEhhYX3X3OUxG+V4VUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3rSxk1PXTi74V1sKyoNr4I69YSiqGdWUguQU7Ru/O+ZM5FOWtqyfYva6wKVN0ohU
	 6KZx/iEJInBE3OtJV/sowk9GS5ZSZ7f6kWKTabGj+12OttqLajruhl4vE4WJ5yJACm
	 6eu4tH0wU8sx4ybLETRDg0yiGhSIPa2aUPygEHfwp0XvIMEjvAOcHG0jinoM9xQV17
	 r7A5IPU39LS/+NC6jIy7GAsTPTz5FsB/PFnGhlzb3EK48759FIVDNgFG377OaPNkXV
	 I7aMrGLPacb48VBrdr2sL133QLwK72l5R/w1kLwrTTEyKm5fDKZjS72Nvvw+zenioh
	 qxK3kpOe+dVxQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUT-00000007AQw-0RSb;
	Wed, 17 Sep 2025 16:58:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 5/8] KVM: arm64: Enforce absence of FEAT_SCTLR2 on SCTLR2_EL{1,2}
Date: Wed, 17 Sep 2025 17:58:37 +0100
Message-Id: <20250917165840.1633412-6-maz@kernel.org>
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
index c064c31effee9..b008551fcf7e9 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1003,7 +1003,7 @@ static const
 struct reg_to_feat_map hcr_feat_map = FEAT_MAP(HCR_EL2, FEAT_AA64EL2,
 					       hcr_bit_feat_map);
 
-static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
+static const struct reg_bits_to_feat_map sctlr2_bit_feat_map[] = {
 	NEEDS_FEAT(SCTLR2_EL1_NMEA	|
 		   SCTLR2_EL1_EASE,
 		   FEAT_DoubleFault2),
@@ -1020,6 +1020,10 @@ static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 		   FEAT_CPA2),
 };
 
+static const
+struct reg_to_feat_map sctlr2_feat_map = FEAT_MAP(SCTLR2_EL1, FEAT_SCTLR2,
+						  sctlr2_bit_feat_map);
+
 static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 	NEEDS_FEAT(TCR2_EL2_FNG1	|
 		   TCR2_EL2_FNG0	|
@@ -1186,8 +1190,7 @@ void __init check_feature_map(void)
 	check_reg_feat_map(&hdfgwtr2_feat_map);
 	check_reg_feat_map(&hcrx_feat_map);
 	check_reg_feat_map(&hcr_feat_map);
-	check_feat_map(sctlr2_feat_map, ARRAY_SIZE(sctlr2_feat_map),
-		       SCTLR2_EL1_RES0, "SCTLR2_EL1");
+	check_reg_feat_map(&sctlr2_feat_map);
 	check_feat_map(tcr2_el2_feat_map, ARRAY_SIZE(tcr2_el2_feat_map),
 		       TCR2_EL2_RES0, "TCR2_EL2");
 	check_feat_map(sctlr_el1_feat_map, ARRAY_SIZE(sctlr_el1_feat_map),
@@ -1393,9 +1396,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		break;
 	case SCTLR2_EL1:
 	case SCTLR2_EL2:
-		*res0 = compute_res0_bits(kvm, sctlr2_feat_map,
-					  ARRAY_SIZE(sctlr2_feat_map), 0, 0);
-		*res0 |= SCTLR2_EL1_RES0;
+		*res0 = compute_reg_res0_bits(kvm, &sctlr2_feat_map, 0, 0);
 		*res1 = SCTLR2_EL1_RES1;
 		break;
 	case TCR2_EL2:
-- 
2.39.2

