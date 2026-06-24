Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF423E1216
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782332693; cv=none; b=V8DYMnqSliun6cAYt/f0bo7jK5MaZ/UxH/i1zcQNvkyDaHN7cvSF8YQTUAZoKV6tQZZRH/KP9ixjuj+HbJffAU3vlJ74AaVpFGybLovQrbtB8fEr0UoFC8dOGMiD78FgCiW8jkVeVAUw6vwHekcmvToG5FBCXK14wPtcluFSGvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782332693; c=relaxed/simple;
	bh=9A1yd4V01q1vp6C7cXsTsOFoaPPHb+DkSlMV4Kxd+0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQBhdlHlrVJ66deO99yMbwIasO24/I0bKj9PQNM6N4U8bfxSaFLVmlT4las4mj/7ii/ST9LPUOZ6xUxC9MB/rlOobTuU+WXMgXlZFPlDGTJll3ySNbdP9hvkK7+Xy4TnXJ44r9pPYRCCFPvNNL/ZaWV+a/p+iHt9Yfe+7QTFMPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmOgIuwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmOgIuwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0DE1F00A3E;
	Wed, 24 Jun 2026 20:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782332692;
	bh=2EbHLmQHprKbbwbbw5XIbT1c6AOB9dukhXoinX2XcVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmOgIuwZMbetjh+aEsV11eNB1bniMLrVQxU6m1FxZWPBSQg3et8WPEOgtk48eKWyo
	 PS6ZGkwcEput+fohrfCTij/iZDchhQ0TlQJPS16rVG0HJw6mDCzAODwp/pRxASYjUd
	 OFZ8Ra0bMMjuNlPityLssqtjat8rNqvB32Kp4lKHEiEXvfgozqHje60TIX9teKEUrI
	 UFISHdMm12FKlv2G5/mFiTeeDXQrxyJiMAlrydxFIP4FDRrM8aDCc4LJlbizl7rOlO
	 Xra6hr0LXi1KpS7dcQKUWoBjpNEWrzNLUO8ySDT0FJ3M4pNob7v+H6sONQDn+6Jbk3
	 Hlxum0MpKxq4A==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 1/2] KVM: arm64: Only consider S1PTW a write fault if HA is set
Date: Wed, 24 Jun 2026 13:24:45 -0700
Message-ID: <20260624202446.1698535-2-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624202446.1698535-1-oupton@kernel.org>
References: <20260624202446.1698535-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In yet another example where the architecture is awesome, S1PTW faults
may not have a valid ESR_ELx.WnR. kvm_is_write_fault() worked around
this by relying on a KVM implementation detail that canonical stage-2
translations must have at least read-only permissions.

That assumption no longer holds for nested virt where an L1 hypervisor
could construct write-only mappings that propagate to the shadow
stage-2.

Since there's no exact science to this, assume that the S1PTW fault was
for write if HA is enabled at stage-1.

Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/kvmarm/20260623213225.A89CF1F000E9@smtp.kernel.org/
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 22 +++++----------
 arch/arm64/include/asm/kvm_nested.h  |  2 ++
 arch/arm64/kvm/at.c                  | 42 +++++++++++++++++++++-------
 3 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c..8e208ce2597e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -479,21 +479,13 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_abt_iss1tw(vcpu)) {
-		/*
-		 * Only a permission fault on a S1PTW should be
-		 * considered as a write. Otherwise, page tables baked
-		 * in a read-only memslot will result in an exception
-		 * being delivered in the guest.
-		 *
-		 * The drawback is that we end-up faulting twice if the
-		 * guest is using any of HW AF/DB: a translation fault
-		 * to map the page containing the PT (read only at
-		 * first), then a permission fault to allow the flags
-		 * to be set.
-		 */
-		return kvm_vcpu_trap_is_permission_fault(vcpu);
-	}
+	/*
+	 * The architecture sucks; assume that the S1PTW fetched for write if
+	 * HA is enabled at stage-1. Note that hardware updates to dirty state
+	 * and table AF are predicated on HA=1 (DDI0487 M.a D24.2.194; R_SNVTX).
+	 */
+	if (kvm_vcpu_abt_iss1tw(vcpu))
+		return effective_tcr_ha(vcpu);
 
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index cbdaaa2a2903..e9f48f94a77f 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -417,4 +417,6 @@ u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime);
 
 int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new);
 
+bool effective_tcr_ha(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8263c648207b..91154654210e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -219,6 +219,36 @@ static unsigned int tcr_tg_pgshift(struct kvm *kvm, u64 tcr, bool upper_range)
 	return shift;
 }
 
+static bool __effective_tcr_ha(struct kvm_vcpu *vcpu, enum trans_regime regime)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, AF))
+		return false;
+
+	switch (regime) {
+	case TR_EL10:
+		return vcpu_read_sys_reg(vcpu, TCR_EL1) & TCR_HA;
+	case TR_EL20:
+		return vcpu_read_sys_reg(vcpu, TCR_EL2) & TCR_HA;
+	case TR_EL2:
+		return vcpu_read_sys_reg(vcpu, TCR_EL2) & TCR_EL2_HA;
+	default:
+		BUG();
+	}
+}
+
+static enum trans_regime vcpu_trans_regime(struct kvm_vcpu *vcpu)
+{
+	if (!is_hyp_ctxt(vcpu))
+		return TR_EL10;
+
+	return vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
+}
+
+bool effective_tcr_ha(struct kvm_vcpu *vcpu)
+{
+	return __effective_tcr_ha(vcpu, vcpu_trans_regime(vcpu));
+}
+
 static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			 struct s1_walk_result *wr, u64 va)
 {
@@ -407,12 +437,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		goto addrsz;
 
 	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
-
-	wi->ha  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, AF);
-	wi->ha &= (wi->regime == TR_EL2 ?
-		  FIELD_GET(TCR_EL2_HA, tcr) :
-		  FIELD_GET(TCR_HA, tcr));
-
+	wi->ha = __effective_tcr_ha(vcpu, wi->regime);
 	return 0;
 
 addrsz:
@@ -1723,10 +1748,7 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 	struct s1_walk_result wr = {};
 	int ret;
 
-	if (is_hyp_ctxt(vcpu))
-		wi.regime = vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
-	else
-		wi.regime = TR_EL10;
+	wi.regime = vcpu_trans_regime(vcpu);
 
 	ret = setup_s1_walk(vcpu, &wi, &wr, va);
 	if (ret)
-- 
2.47.3

