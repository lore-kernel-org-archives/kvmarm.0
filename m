Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B8843FD03;
	Tue, 14 Jul 2026 09:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020614; cv=none; b=s0wxidnYBMpFZO18siApR+X8cJL2R0ReOwhA2/Lx99YEsloAZNstoS4Kyuj06qaBMMeX1SM0tpb8DLLkdSdgg1hzOEevtrxqg4fQ3kL/5Bj26UB0nSbGmNheyYu5sHmYaVLW6bTWQHz/Xcd+P8v/NWuAoVsAr7LSkOUt7tcou/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020614; c=relaxed/simple;
	bh=vM5rIUUKoUwYtebnDOmRSnQ7qOWjuDekPplXzX53rxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGclQI3+tS/fkIJMrrftazwP/V/eG17ytd1QzPqE5aO7GcUNkNEWlyQuqAW2D9t/Y+Vr+5LQl6nIjsO7h3rp5WUgWRvF86Skuy8TdbGAtjds4gz43wiG3q7gHWCtzB9/GdTIVUJp41toD0KZ5aLhWQOi2dWYqq96DX6wrMs2oek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mk2zk00V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mk2zk00V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFB11F00ACF;
	Tue, 14 Jul 2026 09:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020612;
	bh=F1AT8pfTT5H3v1VSsbczUJFUDFVFL+qUil+wR6QR9Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mk2zk00Vt4BmYjxSXwHy21DemZWEIRzvNRJUlCmU1rr1BPbdUcXBYdvT1hB7vJeGn
	 IUz8TDKuoXr6RIq9h+pgq29AXroQcbwtOaHqz9eZ7yd+1+MquJPzTZ9eTu3vWTXbFt
	 sJ0GJ+s+lEtrVum1WGptpm4QG0Ekcn28aHPxYS+ivAjeZHRJAd4Q1CFFkMSJ62YFtO
	 Z0BuwSBL+G+yhxbZIwg6RJlDxAGkh7HHygvAJdUv4qyhZazqqjkGLPM78XlmxqiIkE
	 kmVExOl9+HKY21+AGzJYjOZ9OX3hx8m0vswmoXVfgggGbQHlVi1YiKZYTZLGyVGYrQ
	 2LFvxu+mn+A+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFz-00000004ny1-0tKJ;
	Tue, 14 Jul 2026 09:16:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 20/28] KVM: arm64: Add sanitisation for NVHCR_EL2
Date: Tue, 14 Jul 2026 10:16:33 +0100
Message-ID: <20260714091641.1970822-21-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
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
index 467f57eb8e6bb..1053676551aff 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1019,6 +1019,9 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 static const DECLARE_FEAT_MAP(hcr_desc, HCR_EL2,
 			      hcr_feat_map, FEAT_AA64EL2);
 
+static const DECLARE_FEAT_MAP(nvhcr_desc, NVHCR_EL2,
+			      hcr_feat_map, FEAT_NV3);
+
 static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 	NEEDS_FEAT(SCTLR2_EL1_NMEA	|
 		   SCTLR2_EL1_EASE,
@@ -1393,6 +1396,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&hdfgwtr2_desc);
 	check_reg_desc(&hcrx_desc);
 	check_reg_desc(&hcr_desc);
+	check_reg_desc(&nvhcr_desc);
 	check_reg_desc(&sctlr2_desc);
 	check_reg_desc(&tcr2_el2_desc);
 	check_reg_desc(&sctlr_el1_desc);
@@ -1592,6 +1596,17 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
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
index 35a1c42ad3f84..f646894fec9a9 100644
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

