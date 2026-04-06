Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9879234107A
	for <kvmarm@lists.linux.dev>; Mon,  6 Apr 2026 16:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775494048; cv=none; b=XxcmbODEULMWCGdXChXzwESvHlcCwrnWqF1D9uxw1+SV/6GMEKXY5S0074BpkQjidOMDCKkik3W93gK1lErDnARg+SX6Hy3OC9q15Oogj0SEwMj/g4fFA8ho5iT+m5cvBYkS9bkHcGa15vHb1V8FDL/m6Dnh3l7GUDbFrIAQKMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775494048; c=relaxed/simple;
	bh=RjyP2D1fTKruhCbxtZ3oeTYzHGWYyMJK78WSAjXluj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVAEke1nSgQWnDuVKut3ApVeYbT9hvys44jcTg/XxgTeZBCTrxvW0fs06c0SApXpv+b1abFY7HsIO9d8ik+f2JA8GdpZ6qK2HRuhp3NFkvovbcT7Db6W61yxBJRcnqV2ifbaPwe4gCTWJ/EsAp6y6Tig7CCSkrZ6gsPxbiWl8g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WxFfwS1w; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WxFfwS1w"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6264F175A;
	Mon,  6 Apr 2026 09:47:20 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DCF03F7D8;
	Mon,  6 Apr 2026 09:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775494046; bh=RjyP2D1fTKruhCbxtZ3oeTYzHGWYyMJK78WSAjXluj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxFfwS1w80wr9zICsTMC6J+JNpju8crtP2jCoeyfELyI+XLJzpF9CY1Iu8T12pbkr
	 06ndLBLhnS3f2xIt/TI6JwRxbfAcAD49mtHEdq3TzA5su0G+QDzKnmUAg/AYr5k0XZ
	 t6TXPDEh0cmLkoTN0yxknXHdBBxX7U8uxM0W8M2k=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 1/2] KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
Date: Mon,  6 Apr 2026 17:46:17 +0100
Message-ID: <20260406164618.3312473-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260406164618.3312473-1-weilin.chang@arm.com>
References: <20260406164618.3312473-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current code decodes TCR.TG0/TG1 and VTCR.TG0 inline at several
places. Extract this logic into helpers so the granule size is derived
in one place. This enables us to alter the effective granule size in
the same place, which we will need in a later patch.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/at.c     | 73 +++++++++++++++++++++++++----------------
 arch/arm64/kvm/nested.c | 70 ++++++++++++++++++++++++---------------
 2 files changed, 89 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index c5c5644b1878..ff8ba30e917b 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -135,14 +135,54 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
 	wi->e0poe = (wi->regime != TR_EL2) && (val & TCR2_EL1_E0POE);
 }
 
+static unsigned int tg0_to_shift(u64 tg0)
+{
+	switch (tg0) {
+	case TCR_EL1_TG0_4K:
+		return 12;
+	case TCR_EL1_TG0_16K:
+		return 14;
+	case TCR_EL1_TG0_64K:
+	default:	/* IMPDEF: treat any other value as 64k */
+		return 16;
+	}
+}
+
+static unsigned int tg1_to_shift(u64 tg1)
+{
+	switch (tg1) {
+	case TCR_EL1_TG1_4K:
+		return 12;
+	case TCR_EL1_TG1_16K:
+		return 14;
+	case TCR_EL1_TG1_64K:
+	default:	/* IMPDEF: treat any other value as 64k */
+		return 16;
+	}
+}
+
+static u64 tcr_tg_shift(struct kvm *kvm, u64 tcr, bool upper_range)
+{
+	unsigned int shift;
+
+	/* Someone was silly enough to encode TG0/TG1 differently */
+	if (upper_range)
+		shift = tg1_to_shift(FIELD_GET(TCR_EL1_TG1_MASK, tcr));
+	else
+		shift = tg0_to_shift(FIELD_GET(TCR_EL1_TG0_MASK, tcr));
+
+	return shift;
+}
+
 static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			 struct s1_walk_result *wr, u64 va)
 {
-	u64 hcr, sctlr, tcr, tg, ps, ia_bits, ttbr;
+	u64 hcr, sctlr, tcr, ps, ia_bits, ttbr;
 	unsigned int stride, x;
-	bool va55, tbi, lva;
+	bool va55, tbi, lva, upper_range;
 
 	va55 = va & BIT(55);
+	upper_range = va55 && wi->regime != TR_EL2;
 
 	if (vcpu_has_nv(vcpu)) {
 		hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
@@ -173,35 +213,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		BUG();
 	}
 
-	/* Someone was silly enough to encode TG0/TG1 differently */
-	if (va55 && wi->regime != TR_EL2) {
+	if (upper_range)
 		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
-		tg = FIELD_GET(TCR_TG1_MASK, tcr);
-
-		switch (tg << TCR_TG1_SHIFT) {
-		case TCR_TG1_4K:
-			wi->pgshift = 12;	 break;
-		case TCR_TG1_16K:
-			wi->pgshift = 14;	 break;
-		case TCR_TG1_64K:
-		default:	    /* IMPDEF: treat any other value as 64k */
-			wi->pgshift = 16;	 break;
-		}
-	} else {
+	else
 		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
-		tg = FIELD_GET(TCR_TG0_MASK, tcr);
-
-		switch (tg << TCR_TG0_SHIFT) {
-		case TCR_TG0_4K:
-			wi->pgshift = 12;	 break;
-		case TCR_TG0_16K:
-			wi->pgshift = 14;	 break;
-		case TCR_TG0_64K:
-		default:	    /* IMPDEF: treat any other value as 64k */
-			wi->pgshift = 16;	 break;
-		}
-	}
 
+	wi->pgshift = tcr_tg_shift(vcpu->kvm, tcr, upper_range);
 	wi->pa52bit = has_52bit_pa(vcpu, wi, tcr);
 
 	ia_bits = get_ia_size(wi);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 883b6c1008fb..2bfab3007cb3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -378,20 +378,36 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	return 0;
 }
 
-static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
+static unsigned int tg0_to_shift(u64 tg0)
+{
+	switch (tg0) {
+	case VTCR_EL2_TG0_4K:
+		return 12;
+	case VTCR_EL2_TG0_16K:
+		return 14;
+	case VTCR_EL2_TG0_64K:
+	default:	/* IMPDEF: treat any other value as 64k */
+		return 16;
+	}
+}
+
+static u64 vtcr_tg0_shift(struct kvm *kvm, u64 vtcr)
+{
+	u64 tg0 = FIELD_GET(VTCR_EL2_TG0_MASK, vtcr);
+	unsigned int shift = tg0_to_shift(tg0);
+
+	return shift;
+}
+
+static size_t vtcr_tg0_size(struct kvm *kvm, u64 vtcr)
+{
+	return BIT(vtcr_tg0_shift(kvm, vtcr));
+}
+
+static void vtcr_to_walk_info(struct kvm *kvm, u64 vtcr, struct s2_walk_info *wi)
 {
 	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
-
-	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
-	case VTCR_EL2_TG0_4K:
-		wi->pgshift = 12;	 break;
-	case VTCR_EL2_TG0_16K:
-		wi->pgshift = 14;	 break;
-	case VTCR_EL2_TG0_64K:
-	default:	    /* IMPDEF: treat any other value as 64k */
-		wi->pgshift = 16;	 break;
-	}
-
+	wi->pgshift = vtcr_tg0_shift(kvm, vtcr);
 	wi->sl = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	/* Global limit for now, should eventually be per-VM */
 	wi->max_oa_bits = min(get_kvm_ipa_limit(),
@@ -414,7 +430,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 
 	wi.baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 
-	vtcr_to_walk_info(vtcr, &wi);
+	vtcr_to_walk_info(vcpu->kvm, vtcr, &wi);
 
 	wi.be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
 
@@ -515,17 +531,19 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 	u64 tmp, sz = 0, vtcr = mmu->tlb_vtcr;
 	kvm_pte_t pte;
 	u8 ttl, level;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	size_t tg0_size = vtcr_tg0_size(kvm, vtcr);
 
-	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
-	case VTCR_EL2_TG0_4K:
+	switch (tg0_size) {
+	case SZ_4K:
 		ttl = (TLBI_TTL_TG_4K << 2);
 		break;
-	case VTCR_EL2_TG0_16K:
+	case SZ_16K:
 		ttl = (TLBI_TTL_TG_16K << 2);
 		break;
-	case VTCR_EL2_TG0_64K:
+	case SZ_64K:
 	default:	    /* IMPDEF: treat any other value as 64k */
 		ttl = (TLBI_TTL_TG_64K << 2);
 		break;
@@ -535,19 +553,19 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 
 again:
 	/* Iteratively compute the block sizes for a particular granule size */
-	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
-	case VTCR_EL2_TG0_4K:
+	switch (tg0_size) {
+	case SZ_4K:
 		if	(sz < SZ_4K)	sz = SZ_4K;
 		else if (sz < SZ_2M)	sz = SZ_2M;
 		else if (sz < SZ_1G)	sz = SZ_1G;
 		else			sz = 0;
 		break;
-	case VTCR_EL2_TG0_16K:
+	case SZ_16K:
 		if	(sz < SZ_16K)	sz = SZ_16K;
 		else if (sz < SZ_32M)	sz = SZ_32M;
 		else			sz = 0;
 		break;
-	case VTCR_EL2_TG0_64K:
+	case SZ_64K:
 	default:	    /* IMPDEF: treat any other value as 64k */
 		if	(sz < SZ_64K)	sz = SZ_64K;
 		else if (sz < SZ_512M)	sz = SZ_512M;
@@ -598,14 +616,14 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 
 	if (!max_size) {
 		/* Compute the maximum extent of the invalidation */
-		switch (FIELD_GET(VTCR_EL2_TG0_MASK, mmu->tlb_vtcr)) {
-		case VTCR_EL2_TG0_4K:
+		switch (vtcr_tg0_size(kvm, mmu->tlb_vtcr)) {
+		case SZ_4K:
 			max_size = SZ_1G;
 			break;
-		case VTCR_EL2_TG0_16K:
+		case SZ_16K:
 			max_size = SZ_32M;
 			break;
-		case VTCR_EL2_TG0_64K:
+		case SZ_64K:
 		default:    /* IMPDEF: treat any other value as 64k */
 			/*
 			 * No, we do not support 52bit IPA in nested yet. Once
-- 
2.43.0

