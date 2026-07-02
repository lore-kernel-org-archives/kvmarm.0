Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B10532720D;
	Thu,  2 Jul 2026 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008188; cv=none; b=ABwC+QdcaZoVbc0tnRrvjvc76vH8zn+zjqfTUkQGetMynPoc81F/ZvarMlTm9DkAmu/ot+iuqGqQDJsWhKiZgIr8OR0IQ69Zk+MaK7gmBQyWAXVXHqxoxTsidPvJn2ar/oD1MGmtserwlFbWog5I0CW1xnR2ebkaZh6bh6ahIQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008188; c=relaxed/simple;
	bh=Yld4mjRutIIVOWYvwtWeV4FA6FT219Sj/GPTWBpOvuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwBNaIKbS2QDNeRV99MA6El2T3ZJvRDdq8powsZB9S1zHjsSJHSOBQefYlI7Qa2BS2Ezdhky92pMm52Y0PdwJObFJMIv31PI7AlXki0Mr8iZTPhQVVjRnk3s8hJpqi6y7pthRsNrHVKFxIu23QBaKx7rukuRnl7yKoa6DWsqRKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVZavD/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVZavD/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F5E1F01567;
	Thu,  2 Jul 2026 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008183;
	bh=uv4tFulsNiPMlPTOYPgO5fxapV7GH8mlELnn979IaNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVZavD/KrqwrDZVGsf41nm92OCBkMV5XoohBvzKIz+M7gOv/VqdoZrtC5EO09I0S3
	 FHqQMKVwt5IOILoMsc06JUcWqsMuwxMPIMTLs1gK95mZaGYSAjHylbQfd04ZSFAgzb
	 LrZE+Ly+ngPV5r/vJGxtNyvyTMqr8TcUIn9A91oJgZKk+Iq1Hug+7egBCKlOdUE/yr
	 i/5psThji7sl+FoQPPCA/OvDMxnUHWKeICJ4eRxNQlLMcZg4BMSzuhkh8SjOwUPZxm
	 99uW+eLLCcDWDX3C9ZpDeqTVdIZ4RvVCO2WhL1ebOdwnMw240qATpD9TL3Hl1dGT8f
	 FZkyWVKmOwNgA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsU-00000000ojd-0llR;
	Thu, 02 Jul 2026 16:03:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 20/28] KVM: arm64: Add sanitisation for NVHCR_EL2
Date: Thu,  2 Jul 2026 17:02:40 +0100
Message-ID: <20260702160248.1377250-21-maz@kernel.org>
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

Just like any other VNCR-based register, NVHCR_EL2 requires some
level of sanitisation. Being specified as a live copy of HCR_EL2,
it adopts the exact same format, but depends on FEAT_NV3 instead.

A subtle aspect is that we only want to apply the sanitisation if
FEAT_NV3 is actually present, as the VNCR location is otherwise
used to back accesses to HCR_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 15 +++++++++++++++
 arch/arm64/kvm/nested.c |  4 ++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index b9a9d65b973e6..7e86479142723 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1017,6 +1017,9 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 static const DECLARE_FEAT_MAP(hcr_desc, HCR_EL2,
 			      hcr_feat_map, FEAT_AA64EL2);
 
+static const DECLARE_FEAT_MAP(nvhcr_desc, NVHCR_EL2,
+			      hcr_feat_map, FEAT_NV3);
+
 static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 	NEEDS_FEAT(SCTLR2_EL1_NMEA	|
 		   SCTLR2_EL1_EASE,
@@ -1391,6 +1394,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&hdfgwtr2_desc);
 	check_reg_desc(&hcrx_desc);
 	check_reg_desc(&hcr_desc);
+	check_reg_desc(&nvhcr_desc);
 	check_reg_desc(&sctlr2_desc);
 	check_reg_desc(&tcr2_el2_desc);
 	check_reg_desc(&sctlr_el1_desc);
@@ -1590,6 +1594,17 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 	case HCR_EL2:
 		resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
 		break;
+	case NVHCR_EL2:
+		/*
+		 * Only apply sanitisation if we do have FEAT_NV3.
+		 * Otherwise, the register aliases with HCR_EL2 in VNCR,
+		 * and we're better off relying on data transfers between
+		 * NVHCR_EL2 and HCR_EL2 to sanitise things.
+		 */
+		resx = (kvm_has_nv3(kvm) ?
+			compute_reg_resx_bits(kvm, &nvhcr_desc, 0, 0) :
+			(typeof(resx)){});
+		break;
 	case SCTLR2_EL1:
 	case SCTLR2_EL2:
 		resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9972dea42d12a..c9bf04944f9cb 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1830,6 +1830,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	resx = get_reg_fixed_bits(kvm, HCR_EL2);
 	set_sysreg_masks(kvm, HCR_EL2, resx);
 
+	/* NVHCR_EL2 */
+	resx = get_reg_fixed_bits(kvm, NVHCR_EL2);
+	set_sysreg_masks(kvm, NVHCR_EL2, resx);
+
 	/* HCRX_EL2 */
 	resx = get_reg_fixed_bits(kvm, HCRX_EL2);
 	set_sysreg_masks(kvm, HCRX_EL2, resx);
-- 
2.47.3

