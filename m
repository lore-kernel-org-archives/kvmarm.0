Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2703B3B2AA
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 00:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776125046; cv=none; b=pbHSO5Bv2br9Whz6qQq7UjErMH0F1zuX4K3zvroISKqnSF1elRCBgZrv9OYDo3Qy+Pc+nSwmf+swilJI4WLbLlnVnVCTXIxerxB1tTpz0cVvPqd5P3Vo2ywQSdylMLcMSaOZ3eRKAMyLcNg5UXsE2V3JG4Si2fV86xLim44faAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776125046; c=relaxed/simple;
	bh=hEJOa8RFZZTEyMjtJNuutXiH+ANECuK/KTknvYqeWN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8pOBmJLRHf8gmspLSxPUDm5mJoJSRs6WLt+n/ULHMI4LS45kWLiVzOSo9Ma/H1vdRg6WhJSt+8jaJjxf9CI/sWcs/J6Yg32wcrMj/KweDC3aIuqzcrpVLAgnyDbrVyEBCKRCd2Mhd9xM+HNSy1YYczL+SRiZ5SoWKbJAlzyWJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GCi8IVOd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GCi8IVOd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9D014E2A;
	Mon, 13 Apr 2026 17:03:57 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F23833F7B4;
	Mon, 13 Apr 2026 17:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776125043; bh=hEJOa8RFZZTEyMjtJNuutXiH+ANECuK/KTknvYqeWN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCi8IVOd+MwfFd/o/V/cELURlvjgld91kDSixTrCEwUMLTtg5tVi0qidqNx+do0w2
	 cGYBki1EhhyQsz4Y1iuFEsIRz9BQVyednOaawsi92ZWYekkFQtR0ydcADA6yMTZnBY
	 0OZ0RbPyZijMMUkwgBDlQDYwZqOrKMg+VWqbLWAE=
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
Subject: [PATCH v2 2/4] KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
Date: Tue, 14 Apr 2026 01:03:32 +0100
Message-ID: <20260414000334.3947257-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414000334.3947257-1-weilin.chang@arm.com>
References: <20260414000334.3947257-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current code decodes TCR.TG0/TG1 and VTCR.TG0 inline at several
places. Extract this logic into helpers so the granule size can be
derived in one place. This enables us to alter the effective granule
size in the same place, which we will do in a later patch.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/at.c     | 77 ++++++++++++++++++++++++++---------------
 arch/arm64/kvm/nested.c | 27 +++++++++------
 2 files changed, 65 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index a024d9a770dc..927226266081 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -135,14 +135,58 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
 	wi->e0poe = (wi->regime != TR_EL2) && (val & TCR2_EL1_E0POE);
 }
 
+static unsigned int tcr_to_tg0_pgshift(u64 tcr)
+{
+	u64 tg0 = tcr & TCR_TG0_MASK;
+
+	switch (tg0) {
+	case TCR_TG0_4K:
+		return 12;
+	case TCR_TG0_16K:
+		return 14;
+	case TCR_TG0_64K:
+	default:	/* IMPDEF: treat any other value as 64k */
+		return 16;
+	}
+}
+
+static unsigned int tcr_to_tg1_pgshift(u64 tcr)
+{
+	u64 tg1 = tcr & TCR_TG1_MASK;
+
+	switch (tg1) {
+	case TCR_TG1_4K:
+		return 12;
+	case TCR_TG1_16K:
+		return 14;
+	case TCR_TG1_64K:
+	default:	/* IMPDEF: treat any other value as 64k */
+		return 16;
+	}
+}
+
+static unsigned int tcr_tg_pgshift(u64 tcr, bool upper_range)
+{
+	unsigned int shift;
+
+	/* Someone was silly enough to encode TG0/TG1 differently */
+	if (upper_range)
+		shift = tcr_to_tg1_pgshift(tcr);
+	else
+		shift = tcr_to_tg0_pgshift(tcr);
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
@@ -173,35 +217,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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
 
+	wi->pgshift = tcr_tg_pgshift(tcr, upper_range);
 	wi->pa52bit = has_52bit_pa(vcpu, wi, tcr);
 
 	ia_bits = get_ia_size(wi);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f20402d0d7e5..40d52e9100d6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -378,28 +378,33 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	return 0;
 }
 
-static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
-{
-	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
 
-	wi->baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-	wi->t0sz = vtcr & VTCR_EL2_T0SZ_MASK;
+static unsigned int vtcr_to_tg0_pgshift(u64 vtcr)
+{
+	u64 tg0 = FIELD_GET(VTCR_EL2_TG0_MASK, vtcr);
 
-	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
+	switch (tg0) {
 	case VTCR_EL2_TG0_4K:
-		wi->pgshift = 12;	 break;
+		return 12;
 	case VTCR_EL2_TG0_16K:
-		wi->pgshift = 14;	 break;
+		return 14;
 	case VTCR_EL2_TG0_64K:
-	default:	    /* IMPDEF: treat any other value as 64k */
-		wi->pgshift = 16;	 break;
+	default:	/* IMPDEF: treat any other value as 64k */
+		return 16;
 	}
+}
+
+static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
+{
+	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
 
+	wi->baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	wi->t0sz = vtcr & VTCR_EL2_T0SZ_MASK;
+	wi->pgshift = vtcr_to_tg0_pgshift(vtcr);
 	wi->sl = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	/* Global limit for now, should eventually be per-VM */
 	wi->max_oa_bits = min(get_kvm_ipa_limit(),
 			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
-
 	wi->ha = vtcr & VTCR_EL2_HA;
 	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
 }
-- 
2.43.0

