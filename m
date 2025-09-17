Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB242EC54D
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128327; cv=none; b=fpthQ++s7KTOtGYp8N5Ng3dRPHoxvIRthfGJTdp8EsrFUmhVfRWV5bMQc/sRNH4pG4jY2zKI7L9H7J1yPPEK/D02e8LjnLC/oxmrUNgcCgLuJ0I1idHTswU9SCM1ymMfd9bakzeBnIGvFYyA/jtZRh1rE/yN86dNumZmLw4CBQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128327; c=relaxed/simple;
	bh=NLPqKBImEM5oQw3GL20ow1blcuzSCSxrMgiP2h3woVs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uZAu0wPU5fvzAjES5IJc80fvWhKjJoLS3vIIiXUIqtjfrHceNRx7LxGty4ZuCYk/BEnYOBe+/z6uJlAc+GwfmEzJm0fXGAwIpAnPk2T/8QbL6QriOPqaY2C4ASbaux1Mdi7eVDpm5wXod/01YQV3AdfejJVyVV+CHddvVIAo6m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyfZv9ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyfZv9ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C4EC4CEF7;
	Wed, 17 Sep 2025 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758128326;
	bh=NLPqKBImEM5oQw3GL20ow1blcuzSCSxrMgiP2h3woVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyfZv9wsBbfgi9ZBFOaJmElXCjzUV4IveKtCqZvbHAysDX8TFepOhD2jqJI++fH57
	 /2CmdM2cTofY7KRxAHncuU1Qu6ix5RweuXUnMvO6rbBrbeuLaY1sNgyqBOCnKW9GgK
	 nDpaN0Y+soecGxMAfQz0/vQnUcu7qUHNMDOMZr/ncR4+ZswVSsXTYDRsRnz/J/+Vck
	 6ZDsh5G904DVAPJhsSds1C35oSV140Ahilzb1MTQaDFg3ZuxHbH+M1nBKL1NyibTGN
	 OxpvfO7LXs88fWEK88hhCSIBh/yo4RUL65DJT2kllSUVUU+6QZDkHAdwlWMVAk4G0u
	 QYlLZR9XlRFJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvUS-00000007AQw-2jag;
	Wed, 17 Sep 2025 16:58:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH 3/8] KVM: arm64: Enforce absence of FEAT_HCX on HCRX_EL2
Date: Wed, 17 Sep 2025 17:58:35 +0100
Message-Id: <20250917165840.1633412-4-maz@kernel.org>
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
 arch/arm64/kvm/config.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 05be2b917c8c0..f8e9cfa844266 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -187,6 +187,7 @@ struct reg_to_feat_map {
 #define FEAT_FGT		ID_AA64MMFR0_EL1, FGT, IMP
 #define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
+#define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -893,7 +894,7 @@ struct reg_to_feat_map hdfgwtr2_feat_map = FEAT_MAP_FGT(hdfgwtr2_masks,
 							hdfgwtr2_bit_feat_map,
 							FEAT_FGT2);
 
-static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
+static const struct reg_bits_to_feat_map hcrx_bit_feat_map[] = {
 	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
 	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
 	NEEDS_FEAT(HCRX_EL2_GCSEn, FEAT_GCS),
@@ -922,6 +923,10 @@ static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
 	NEEDS_FEAT(HCRX_EL2_EnAS0, FEAT_LS64_ACCDATA),
 };
 
+static const
+struct reg_to_feat_map hcrx_feat_map = FEAT_MAP(__HCRX_EL2, FEAT_HCX,
+						hcrx_bit_feat_map);
+
 static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_TID0, FEAT_AA32EL0),
 	NEEDS_FEAT_FIXED(HCR_EL2_RW, compute_hcr_rw),
@@ -1174,8 +1179,7 @@ void __init check_feature_map(void)
 	check_reg_feat_map(&hfgitr2_feat_map);
 	check_reg_feat_map(&hdfgrtr2_feat_map);
 	check_reg_feat_map(&hdfgwtr2_feat_map);
-	check_feat_map(hcrx_feat_map, ARRAY_SIZE(hcrx_feat_map),
-		       __HCRX_EL2_RES0, "HCRX_EL2");
+	check_reg_feat_map(&hcrx_feat_map);
 	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
 		       HCR_EL2_RES0, "HCR_EL2");
 	check_feat_map(sctlr2_feat_map, ARRAY_SIZE(sctlr2_feat_map),
@@ -1376,9 +1380,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res1 = HDFGWTR2_EL2_RES1;
 		break;
 	case HCRX_EL2:
-		*res0 = compute_res0_bits(kvm, hcrx_feat_map,
-					  ARRAY_SIZE(hcrx_feat_map), 0, 0);
-		*res0 |= __HCRX_EL2_RES0;
+		*res0 = compute_reg_res0_bits(kvm, &hcrx_feat_map, 0, 0);
 		*res1 = __HCRX_EL2_RES1;
 		break;
 	case HCR_EL2:
-- 
2.39.2

