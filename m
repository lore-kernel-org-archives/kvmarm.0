Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EAD224B06
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208469; cv=none; b=BjUBAHzrb28VlVx63qHJGq4k8UQCXVLdxZdAk1vZDw1IjfOHgGDlATbGNIwlAhPaXom93Brrxi/mBHCYe6/8NKkOUBuiyDXjfBzqEaT+S/tCWYzqonbDZzldzn+kXeCQPUYBOeH7DC60Hgcya5bSlgyrMrzfRvvpcAg5g41vsI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208469; c=relaxed/simple;
	bh=eupJ06qxqUgb5TzZ8DopOro3ckZwNVxHqqwxA+gfRPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HfZHrEDXETj3tNEzg5yUNwImgqP4nFc5TMANkpAQsabE4CZzbcTrJBWmQWM0InHGohJHwQl2OC9yNpa6G6o2Ke/ktW0Tbk9ZaJCRvcOqO+nKhKBqt2iFdtNyABtu8Op1up00QMokjt9NaqbCl1BLQfs5BahhSMF6vHqZMeMjXZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVgiE2vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVgiE2vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3866FC4CEE7;
	Thu, 18 Sep 2025 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208469;
	bh=eupJ06qxqUgb5TzZ8DopOro3ckZwNVxHqqwxA+gfRPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVgiE2vykyaN2upImbYB+dknQb5kqcBGSXSHjB5lgvOHplixqJZkLIrAHamIvnww5
	 bsqACzrWGidF4FoHJ5vVktN+Kju6YRUzXf4WTryfT8GSBLuNVX1NSYKqMFZ1qxwMYO
	 wMzVtODwhhSP0qkLZ58w3GcJmI0wHAzNa/5Y7xjPBPviCVu3+OAbHiOL/IAIMQkLg0
	 LKyRTwlOTATIFUhnNp/WLsiOigMz8I32c7hkaA3Yvi4tilmlv33UxEL1Lg4Aqzm29V
	 rZ2zsFeWOdOe0IhYacsSpjdAT0RylkdR8gcBUZJ0QXEC4q4wJpBrJd/717AqDSED0s
	 J/R1p7GXn6XwQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL5-00000007TmF-0wC1;
	Thu, 18 Sep 2025 15:14:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 05/10] KVM: arm64: Enforce absence of FEAT_HCX on HCRX_EL2
Date: Thu, 18 Sep 2025 16:13:57 +0100
Message-Id: <20250918151402.1665315-6-maz@kernel.org>
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

Add the dependency between the HCRX_EL2 register and FEAT_HCX.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 6828bcdc038d8..2b2a87e31389d 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -214,6 +214,7 @@ struct reg_feat_map_desc {
 #define FEAT_FGT		ID_AA64MMFR0_EL1, FGT, IMP
 #define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
+#define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -929,6 +930,10 @@ static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
 	NEEDS_FEAT(HCRX_EL2_EnAS0, FEAT_LS64_ACCDATA),
 };
 
+
+static const DECLARE_FEAT_MAP(hcrx_desc, __HCRX_EL2,
+			      hcrx_feat_map, FEAT_HCX);
+
 static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_TID0, FEAT_AA32EL0),
 	NEEDS_FEAT_FIXED(HCR_EL2_RW, compute_hcr_rw),
@@ -1181,8 +1186,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&hfgitr2_desc);
 	check_reg_desc(&hdfgrtr2_desc);
 	check_reg_desc(&hdfgwtr2_desc);
-	check_feat_map(hcrx_feat_map, ARRAY_SIZE(hcrx_feat_map),
-		       __HCRX_EL2_RES0, "HCRX_EL2");
+	check_reg_desc(&hcrx_desc);
 	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
 		       HCR_EL2_RES0, "HCR_EL2");
 	check_feat_map(sctlr2_feat_map, ARRAY_SIZE(sctlr2_feat_map),
@@ -1383,9 +1387,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = HDFGWTR2_EL2_RES1;
 		break;
 	case HCRX_EL2:
-		*res0 = compute_res0_bits(kvm, hcrx_feat_map,
-					  ARRAY_SIZE(hcrx_feat_map), 0, 0);
-		*res0 |= __HCRX_EL2_RES0;
+		*res0 = compute_reg_res0_bits(kvm, &hcrx_desc, 0, 0);
 		*res1 = __HCRX_EL2_RES1;
 		break;
 	case HCR_EL2:
-- 
2.39.2

