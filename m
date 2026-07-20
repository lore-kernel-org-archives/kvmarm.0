Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A639427A05
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553763; cv=none; b=JVmIiHFZP9D5y9WKaMTruDmlCk02DfXNqmzOLj2x6OVqi5BnbXvAmx6ji7rZZGbsKB4VHdryhq895MFLQMOKq0TR9GY0w0gIEtAlKY2M0m2vkdXmPNyjG7TzdYDSRH8lozs1o5L2CN8a9AmYWGCUBsUF2Vs9Uo+IANYjs2/YQnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553763; c=relaxed/simple;
	bh=RYQ7QGwaFSyFADqEt9FDjdPkCVdshkEkY2rmOo7xaCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8LtfAsv3fhV7bSGpz+YH6ydHk8p5DNT3lFR5NnjTAM9bD5X/UJlamY5GWYMQoZ87kKSAehI2xWIv3vdUF2BfDkD26BNxKYBhMQG8ZlESYSoa22M/1Rm67cprHlmz9mNmcKWzkzzflJxKTCEZ38iemKK8Am1UMpeuxDLdfepbkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtQQlf8H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtQQlf8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E091F00ACA;
	Mon, 20 Jul 2026 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784553761;
	bh=4gktMd1z97qKRm65uykxL7tkOFdtPf+UvDzjJVptox4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtQQlf8H8Pw+B272nhx53brEQt1RRgoy9wVSajVdF6Tj32zR6DpdKpOQislBHhkOu
	 qhzrG6xBxvdlNGBZR2qFdJ6js7fWZwrQZ5sqwnIv2FCWHByZ+rCw+6+z+xkgE9tXdo
	 s+61+yC3l1nVB7BcPmILND7e49ui0Uv5MlMxRuSiqrVG6LYDn6z/aeT5gd8XN6Bpw3
	 XWHA36oBZFQmbnboUcWhcdWHgI5I75FSz9/BVsj1MNViQ0GC49WqAmBi3rNKD0p9Oi
	 v9lauV175+kGfkZzIW4Ryvn5qhPxI++whZ2nedPZID69wvdaTBBBwfdBuY10CdL6Gf
	 7Wps0P89ImF/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wlnx9-00000006oKK-20dx;
	Mon, 20 Jul 2026 13:22:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 4/5] KVM: arm64: vgic-v3: Simplify initial GICv3 configuration sampling
Date: Mon, 20 Jul 2026 14:22:19 +0100
Message-ID: <20260720132220.2143486-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720132220.2143486-1-maz@kernel.org>
References: <20260720132220.2143486-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have our magic inline helper for ICH_VTR_EL2, we can
get rid of the hack that was reporting a combination of that
register and of the indication of the CPU interface supporting
GICv2 compatibility. We now only report the latter.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c |  9 ++-------
 arch/arm64/kvm/vgic/vgic-v3.c   | 13 +++++++------
 arch/arm64/kvm/vgic/vgic-v5.c   |  2 +-
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 3e5d5ddf35a19..8a15d6854d1bd 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -439,8 +439,6 @@ void __vgic_v3_init_lrs(void)
 
 /*
  * Return the GIC CPU configuration:
- * - [31:0]  ICH_VTR_EL2
- * - [62:32] RES0
  * - [63]    MMIO (GICv2) capable
  */
 u64 __vgic_v3_get_gic_config(void)
@@ -455,7 +453,7 @@ u64 __vgic_v3_get_gic_config(void)
 	 * system, so we first check if we have GICv5 support.
 	 */
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
-		return vgic_ich_vtr();
+		return 0;
 
 	sre = read_gicreg(ICC_SRE_EL1);
 	/*
@@ -497,10 +495,7 @@ u64 __vgic_v3_get_gic_config(void)
 		isb();
 	}
 
-	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
-	val |= vgic_ich_vtr();
-
-	return val;
+	return (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
 }
 
 static void __vgic_v3_compat_mode_enable(void)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index ef62dd498f5cf..68d4a486df0a1 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -906,6 +906,9 @@ void noinstr kvm_patch_ich_vtr_el2(struct alt_instr *alt,
 
 	vtr = res.a1;
 
+	if (vgic_v3_broken_seis())
+		vtr &= ~ICH_VTR_EL2_SEIS;
+
 	/* Compute target register */
 	oinsn = le32_to_cpu(*origptr);
 	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
@@ -950,12 +953,12 @@ void vgic_v3_enable_cpuif_traps(void)
  */
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
-	u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	u64 ich_vtr_el2;
 	bool has_v2;
 	int ret;
 
-	has_v2 = ich_vtr_el2 >> 63;
-	ich_vtr_el2 = (u32)ich_vtr_el2;
+	has_v2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config) >> 63;
+	ich_vtr_el2 = vgic_ich_vtr();
 
 	/*
 	 * The ListRegs field is 5 bits, but there is an architectural
@@ -1010,10 +1013,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (has_v2)
 		static_branch_enable(&vgic_v3_has_v2_compat);
 
-	if (vgic_v3_broken_seis()) {
+	if (vgic_v3_broken_seis())
 		kvm_info("GICv3 with broken locally generated SEI\n");
-		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_EL2_SEIS;
-	}
 
 	vgic_v3_enable_cpuif_traps();
 
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d4789ff3e7402..16bc0a670d3e5 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -83,7 +83,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	}
 
 	kvm_vgic_global_state.has_gcie_v3_compat = true;
-	ich_vtr_el2 =  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	ich_vtr_el2 = vgic_ich_vtr();
 	kvm_vgic_global_state.ich_vtr_el2 = (u32)ich_vtr_el2;
 
 	/*
-- 
2.47.3

