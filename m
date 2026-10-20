Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792478598;
	b=ACjXHli+w8KNVSxcMVD5WYpULeo+vAOD+wphlwcF1bGp0KpNPtVCJOyDuNgTa/9F6N5T
	 ejmjfZSuojo3HpPANZc87YCmFVT37/hTp4cRjznpP2KY4b7t7rzUh5lxEEOnbnQY/wKgp
	 rBuCwyG7RaQRiEJ9GTKm1BhCT43r/a4qEZJcURom3IjT0pMFFJSmCR5c3kSDSMmwF/NYE
	 e6GT94mNQuPWnj1xv79o537ySOvWc2tkqFt7HyN+Xj0cuarLTFxNYbl0GpbM0T0FwBDP5
	 utu1/tomwXqI9u+bM15HzuZ2HsgcuINtu9Wi1lf+assmHdP/HntK71j9y33HAlVAj3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792478598;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=A4Jhss0pRPIhgOnD8xRK1TmnFOh+C6KbjtZV2ahE5wE=;
	b=MG21jWgmrOkwkM9rNtdtleLvfImzrJNjCK4QGrtnTpL1EB3bkpBkLHGX00GBxygVHRgE
	 IXHUeXUCmEwVLZdXhFxPSCIS/s1Nw3Px1+icmKAkYxqyJWsbudBwWHNExiZPokKR4YBJ8
	 hoDngn0MBQIIUr+soco9HDUCaDLV4dbOJ0JW/nIOuUsplnqj2+veJ8fnSzM2LI5W5CeON
	 rREHGp3xEAzqIKC9sbKn4oXlHqYV7iwA947/plKDp9q2odLwFMuTQa3IhcrC3t3qIwTTV
	 ClXFnJVDjUCDtcPsiuSANJCp5hj/q+E6LKZqSKlwCZfbbjPjWq/tOZzE+6omtivhAtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="BP/zGISa";
	arc=none smtp.remote-ip=91.218.175.180
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6901D606A31B
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 06:43:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6901D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BP/zGISa
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=BmlXgOG0RMJHh37iPBOzDPjQSKllj1HY7c2b8Mw6ROM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792478594; v=1; x=1793083394;
 b=BP/zGISajVO78Q4y1q5o2WUmHt99E3xrMdETB07e1OA5jkietsgWcdBEIZV2NcmLvqD5PpDt
 zPAfWO6igXTEJhmBTnOJbIcUJMVOaiuzHWM0vrpBpVep0ocQkt/Uq3leSTTt+R9u6hCrEdn6+FD
 RLgUyFDzgYRDmsk7WXOhQCIU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ca1f3b611870107a;
	Tue, 20 Oct 2026 06:43:14 +0000
X-Mizu-Trace-ID: ca1f3b611870107a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
Date: Tue, 20 Oct 2026 07:43:06 +0100
Message-ID: <20261020064306.1542865-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

KVM uses the VM's ID registers as the source of truth for what the
guest has, but userspace can expose S1PIE or S1POE without the features
they imply. As per the architecture, both imply TCR2 and ATS1A, and
S1POE also implies HPDS. With TCR2 hidden, the world switch skips
PIR_EL1, PIRE0_EL1 and POR_EL1 while KVM doesn't trap them, so the guest
accesses registers that are neither trapped nor switched. Under VHE,
that leaks values between guests. On nVHE and hVHE, pKVM included, the
host kernel resumes with the guest's PIR_EL1 and PIRE0_EL1.

On first run, clear S1PIE and S1POE from the VM's ID registers when the
features they imply are missing, before anything derives state from
them. The guest and userspace then see neither feature, and the guest's
accesses to their registers UNDEF.

Fixes: 70ed7238297fb ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Fixes: d4a89e5aee23e ("KVM: arm64: Expose S1PIE to guests")
Reported-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20260930-arm64-gcs-v21-2-3556644cd927@kernel.org
Link: https://lore.kernel.org/r/8633u229lq.wl-maz@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
Changes in v3:
- Sanitise the ID registers instead of changing the trap tables, using
  Marc's patch (Marc, Sashiko)
- Rebased on kvmarm-7.4
- Link to v2: https://lore.kernel.org/r/20261018080921.3942517-1-fuad.tabba@linux.dev

Changes in v2:
- Also require FEAT_HPDS for S1POE (Marc)
- Link to v1: https://lore.kernel.org/r/20261015153041.3770032-1-fuad.tabba@linux.dev

Based on kvmarm-7.4 (dd0bc00e3e920; also applies to kvmarm/fixes
2ea3a929fe01e).

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/config.c           | 78 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  2 +
 3 files changed, 81 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1c6632216e327..695c389047c91 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1741,6 +1741,7 @@ static inline bool kvm_arch_has_irq_bypass(void)
 	return true;
 }
 
+void kvm_idregs_enforce_dependencies(struct kvm *kvm);
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
 struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg);
 void check_feature_map(void);
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1053676551aff..d856c0b5c3907 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -59,6 +59,7 @@ struct reg_feat_map_desc {
 	const struct reg_bits_to_feat_map feat_map;
 	const struct reg_bits_to_feat_map *bit_feat_map;
 	const unsigned int		  bit_feat_map_sz;
+	const unsigned int		  idreg_idx;
 };
 
 #define __NEEDS_FEAT_3(m, f, w, id, fld, lim)		\
@@ -130,6 +131,21 @@ struct reg_feat_map_desc {
 		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
 	}
 
+/*
+ * Declare the dependency between the features advertised in an id
+ * register, and the set of other features they depend on. This
+ * generates a struct reg_feat_map_desc.
+ */
+#define DECLARE_IDREG_FEAT_MAP(n, r, m, f)				\
+	struct reg_feat_map_desc n = {					\
+		.name			= #r,				\
+		.feat_map		= NEEDS_FEAT(~(r##_RES0 |	\
+						       r##_RES1), f),	\
+		.bit_feat_map		= m,				\
+		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
+		.idreg_idx		= IDREG_IDX(SYS_##r),		\
+	}
+
 #define FEAT_SPE		ID_AA64DFR0_EL1, PMSVer, IMP
 #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
 #define FEAT_TRC_SR		ID_AA64DFR0_EL1, TraceVer, IMP
@@ -205,6 +221,7 @@ struct reg_feat_map_desc {
 #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
 #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
 #define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
+#define FEAT_HPDS		ID_AA64MMFR1_EL1, HPDS, IMP
 #define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
 #define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
 #define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
@@ -280,6 +297,25 @@ static bool feat_anerr(struct kvm *kvm)
 		kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SNERR, FEAT_ANERR));
 }
 
+/*
+ * S1PIE and S1POE imply TCR2 and ATS1A, and S1POE also implies HPDS, but
+ * userspace can set them independently.
+ */
+static bool feat_s1pie(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, FEAT_S1PIE) &&
+		kvm_has_feat(kvm, FEAT_TCR2) &&
+		kvm_has_feat(kvm, FEAT_ATS1A));
+}
+
+static bool feat_s1poe(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, FEAT_S1POE) &&
+		kvm_has_feat(kvm, FEAT_TCR2) &&
+		kvm_has_feat(kvm, FEAT_ATS1A) &&
+		kvm_has_feat(kvm, FEAT_HPDS));
+}
+
 static bool feat_sme_smps(struct kvm *kvm)
 {
 	/*
@@ -1299,6 +1335,14 @@ static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
 static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
 			      vtcr_el2_feat_map, FEAT_AA64EL2);
 
+static const struct reg_bits_to_feat_map id_aa64mmfr3_el1_feat_map[] = {
+	NEEDS_FEAT(ID_AA64MMFR3_EL1_S1PIE, feat_s1pie),
+	NEEDS_FEAT(ID_AA64MMFR3_EL1_S1POE, feat_s1poe),
+};
+
+static const DECLARE_IDREG_FEAT_MAP(id_aa64mmfr3_el1_desc, ID_AA64MMFR3_EL1,
+				    id_aa64mmfr3_el1_feat_map, FEAT_AA64EL1);
+
 static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] = {
 	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
 		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
@@ -1408,6 +1452,40 @@ void __init check_feature_map(void)
 	check_reg_desc(&ich_hfgitr_desc);
 }
 
+static const struct reg_feat_map_desc *idreg_feat_maps[] = {
+	&id_aa64mmfr3_el1_desc,
+};
+
+static bool idreg_deps(struct kvm *kvm, const struct reg_feat_map_desc *r)
+{
+	struct resx resx = {};
+	u64 val;
+
+	for (int i = 0; i < r->bit_feat_map_sz; i++) {
+		if ((r->bit_feat_map[i].flags & CALL_FUNC) &&
+		    !r->bit_feat_map[i].match(kvm))
+			resx.res0 |= reg_feat_map_bits(&r->bit_feat_map[i]);
+	}
+
+	val = kvm->arch.id_regs[r->idreg_idx];
+	kvm->arch.id_regs[r->idreg_idx] &= ~resx.res0;
+	kvm->arch.id_regs[r->idreg_idx] |= resx.res1;
+
+	return val != kvm->arch.id_regs[r->idreg_idx];
+}
+
+void kvm_idregs_enforce_dependencies(struct kvm *kvm)
+{
+	bool again;
+
+	do {
+		again = false;
+
+		for (int i = 0; i < ARRAY_SIZE(idreg_feat_maps); i++)
+			again |= idreg_deps(kvm, idreg_feat_maps[i]);
+	} while (again);
+}
+
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
 {
 	u64 regval = kvm->arch.id_regs[map->regidx];
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e9cf6cc340349..f10905347f3a1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5872,6 +5872,8 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
 	if (kvm_id_regs_final(kvm))
 		return 0;
 
+	kvm_idregs_enforce_dependencies(kvm);
+
 	/*
 	 * This hacks into the ID registers, so only perform it when the
 	 * first vcpu runs, or the kvm_set_vm_id_reg() helper will scream.

base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.47.3

