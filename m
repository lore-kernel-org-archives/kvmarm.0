Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A47C8E6
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 00:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776125048; cv=none; b=EOvhTWNkOfuO1kPzULsOXfVyZSgr9yj9LGxrHBAupa60wvgOI+MWYs5bpRhSo4GanQqLYBIJltYwC5VSEhOncG1f+JjrfqCcUF8RdgD8jegmYWwDHh88nCrSOJI3rxWherZYEQZXtVVexvaGj7GZEjwleK2TZyWfBGOgkvkDyYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776125048; c=relaxed/simple;
	bh=rTwPoMoBGibDvIeg7vnDDP5LMIeeRhi6mWL8JuxGNWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTmEsRt1OvVcLfpqJQB8PGwDKIXeDjwlgmoMjYJLP5v2n6vJlWASSM3PSfxmkIbpLt5u0A6jGMp+uxRqOOUZmnOWw17AuAOpu3k9To4zg9FYLG+DYVCqg0ECTRa4+qAHQO4xS7bfgwAUSWX+ve0s+iWi4VHA11H3YVXRQzn+Cnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YT8o3hsS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YT8o3hsS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E24294E2C;
	Mon, 13 Apr 2026 17:03:59 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E68863F7B4;
	Mon, 13 Apr 2026 17:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776125045; bh=rTwPoMoBGibDvIeg7vnDDP5LMIeeRhi6mWL8JuxGNWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YT8o3hsSFlzjqWp2lvLm6XNX4RQqcecARDcEvZVudE1XIYx4yVik1u2x4Jr5H5wGB
	 sE+q4RhQMznFJMtcxA0nslEDSM/L8r7Jg9NWYFaiGq64Zl5QvExJHolSg7gAONPQR9
	 Wmcaim/glfLIoRfnroudgdJyEOauW6OlhnvRFwlw=
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
Subject: [PATCH v2 3/4] KVM: arm64: nv: Use literal granule size in TLBI range calculation
Date: Tue, 14 Apr 2026 01:03:33 +0100
Message-ID: <20260414000334.3947257-4-weilin.chang@arm.com>
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

TLBI handling derives the invalidation range from guest VTCR_EL2.TG0 in
get_guest_mapping_ttl() and compute_tlb_inval_range(). Switch these to
use a helper that returns the decoded VTCR_EL2.TG0 granule size instead
of decoding it inline.

This keeps the granule size derivation in one place and prepares for
following changes that adjust the effective granule size.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/nested.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 40d52e9100d6..a732d7b0bd5d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -394,6 +394,11 @@ static unsigned int vtcr_to_tg0_pgshift(u64 vtcr)
 	}
 }
 
+static size_t vtcr_to_tg0_pgsize(u64 vtcr)
+{
+	return BIT(vtcr_to_tg0_pgshift(vtcr));
+}
+
 static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
 {
 	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
@@ -516,20 +521,21 @@ static u8 pgshift_level_to_ttl(u16 shift, u8 level)
  */
 static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 {
-	u64 tmp, sz = 0, vtcr = mmu->tlb_vtcr;
+	u64 tmp, sz = 0;
 	kvm_pte_t pte;
 	u8 ttl, level;
+	size_t tg0_size = vtcr_to_tg0_pgsize(mmu->tlb_vtcr);
 
 	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
 
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
@@ -539,19 +545,19 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 
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
@@ -602,14 +608,14 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 
 	if (!max_size) {
 		/* Compute the maximum extent of the invalidation */
-		switch (FIELD_GET(VTCR_EL2_TG0_MASK, mmu->tlb_vtcr)) {
-		case VTCR_EL2_TG0_4K:
+		switch (vtcr_to_tg0_pgsize(mmu->tlb_vtcr)) {
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

