Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B27311968;
	Thu,  2 Jul 2026 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008185; cv=none; b=SmfoVHiMjh6aFjfh6scfgWk7Ml/h/VVvVLSLGAKnj4C/IF1H25sGKQjGyGvbBqPAQ20e2p3P7iUjikqajI1sIIOrAYE1XCRlHIkK8nUGOIikucEMSwXiY3Vipyr2zXlKxJW/kyY90JB0bRmcHgur0s3CGKE8Js/3k34Q6x0W8YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008185; c=relaxed/simple;
	bh=+ZWGG0utavSZRIi1Qg0sruWk2lPoHkMy2BA9JdIBsG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bnyv55WpVxzkovoyW25fGtQat/Ck+udxl1jqoIQZM/wnJupgsTKK4Qx6sXJDARf67ws7j1zJSTTN1gMtXWKQRHqWg61PW30EQGxfRzafIpr9xIUlR/Ygkpw3MLNBAWCPoLFfLeGWK9pMX8X4ApgdVGUy/aVgsYu264C+h81oAps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUy1tjS5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUy1tjS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506761F00ACA;
	Thu,  2 Jul 2026 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008183;
	bh=4i3a3SA0E4D8pxClJTF3Hke40ERPur3j2IbFmT5XNDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUy1tjS50IcEg3DWDkAEEMAvhqE0HdiMjqpp/tLYlfimTRzzXkIGrbCaycHbJHAVM
	 OQCOdAx8ipSAJMy75Gf0af9bC1SSXYugQATSEGUJ8GPoUdqpY7+4OBnDLlxMdkhc9Q
	 qd/tWyz2zs1jVETICwIZxO5KIU3UziIGJLzEdbZg7xb9HhQKxIILV6S9z1KWpBfPfh
	 6dcSYvi/t5yyzy2nYFypruj+ZTHN7SF6GTRLEfSIYb7H+++tkBDTO43pKKNr6jk/+u
	 0cI/I2mrmQa6Ra50zAiWYbl31T83aQJDX6a2GC+xDp0RspzhDdsrR6zw9YGAxIyvJ/
	 tlkAtAMZN6McA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsT-00000000ojd-2JhU;
	Thu, 02 Jul 2026 16:03:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 17/28] KVM: arm64: Add NV3 control bits to HCRX_EL2 sanitisation
Date: Thu,  2 Jul 2026 17:02:37 +0100
Message-ID: <20260702160248.1377250-18-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Expose the FEAT_NV3 control bits to the sanitisation code so that
KVM stops moaning about the unattributed bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 8d5e4aacf49c4..b9a9d65b973e6 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -225,6 +225,7 @@ struct reg_feat_map_desc {
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
 #define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
 #define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
+#define FEAT_NV3		ID_AA64MMFR4_EL1, NV_frac, NV3
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -904,6 +905,11 @@ static const DECLARE_FEAT_MAP_FGT(hdfgwtr2_desc, hdfgwtr2_masks,
 
 
 static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
+	NEEDS_FEAT(HCRX_EL2_NVTGE		|
+		   HCRX_EL2_NVnTTLB		|
+		   HCRX_EL2_NVnTTLBIS		|
+		   HCRX_EL2_NVnTTLBOS,
+		   FEAT_NV3),
 	NEEDS_FEAT(HCRX_EL2_SRMASKEn, FEAT_SRMASK),
 	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
 	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
-- 
2.47.3

