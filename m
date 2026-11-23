Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795476410;
	b=B41+i0HASxXMzAD65USIXLj2b7IT+kamMIVsC2tWnG+iX4/CzN4704Bt/FcLbvg1Vj8R
	 APK3AmQ9izJMA81b4U8W+kGvqbwhtOaO41Mx80fi8fv9J2qzhi8ArvQVChmJObJplyOno
	 kyhRh3o8Emq2ynU/Xq9lDcCGJwWqSzCuPw7IbuvjZhPJf5Z+kulFP/2mykEdat+4ZBpou
	 8P54blRq1l/6+naTz6W+XJKQBbrBtkkS8l6D36jsgjf8uA07KwdVN139nkLEK+mpggSrl
	 hfTM86ep4utWC5OBq27ovyp4vyvGej3efEQmhoD/50xT+gtUk1Ysw3kbdiluV2HghXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795476410;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=qaxHM38G/+bXzIaF++R5ruI8cfESxy9Hb2JWe3Lf6do=;
	b=d1248tm8t6QafjxqWUQOCL1VXAAdb0obLHr9vAq2BVzApbMzlhMOCLWQz9IMQvZV2C1u
	 PsTT7Xa67PxzB6ygPns/2H0pkCia4TnGpmNmLu+R0xqPfYs2EA0YPlgsivd+J/9d6c0UI
	 11gqW2hANuZz66uDfM3A6yh3u2LE2hXAryqb3G5fxKmTvGB2Ocr6n0kTxL+cteIqLZ+CP
	 /U5I6hOKGZSX8w1+BG6fgTzs7BbZwohxU/Y93RtLjiiHZpaXC+gET4AfmFeEUB7Nz4/A6
	 uMFrs95ogWZscbkClLuLRj6+74ruqhahdLUSEHdhgDgRuK2ZQuO+YXMjTM5Cq929a0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RBBvDJnz;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557E4606A335
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 23:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 557E4606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RBBvDJnz
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4cc89e86e9eso4754348b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 15:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795476409; x=1796081209; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qaxHM38G/+bXzIaF++R5ruI8cfESxy9Hb2JWe3Lf6do=;
        b=RBBvDJnzl70OZkv94zZc2xjMM9dS1/UNGDmvM9o7teamkNi30EzoBbJGeyY6lGifjg
         +mNvcmfmWRVrcdR4wYM1T9qKJdmzmFLFQjDtGCM5fRL4wBBbUX2KpWUyqYm6/6+Mxw3C
         2O7f3370Rj/ZtjQBwMcoA99LJereJJvdiGF4S1/6Xxf7ufuDBf+/GzpYUEv1vrG+ppu+
         4s0LebdZ1HhUMP0cj67RD5sT1fmH65xxMrRaRsmqJnPhUWL7FV6bzXZtU89xlNAWsEf3
         yvakrXO/BYQAS2lUbBnB+AyPfpt3ZI1/RXYdqh7ssben6sIOYFzXIPVA+a9AUzYmsHMI
         E67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795476409; x=1796081209;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qaxHM38G/+bXzIaF++R5ruI8cfESxy9Hb2JWe3Lf6do=;
        b=PpJ+H3TiukpTP/TFIMUpo+h9Vx31yDp26hH5G8oQU8jp1UrlwHvKPgQ/FqKIfgRx60
         mh5Z/qJu9y5JnKwqPGpUJNYrBmYr0XBNfN3vi1oGG/YzSbjeaWIwSD0y7cK8GZ0moZJm
         rlYl0aqy3n1NZpPqa1KyVwYnoOW5qx17dlHP/m2wDZLpBTRqsGpxNEdo8nU4wTBAJLEs
         m1/g8Jlf9eFYTLwXzJ9PN0Idbsxix3lwZeS8NVsX2jsK3KDXJob8c7bLuQvkR8g/t7UJ
         Y4GzjBbdIyFFGSEyuEmHlRhZLNTUyHrM2J8DrZwHOE+6ae2L13YmMtASO56jYYYaiLDl
         IXyA==
X-Forwarded-Encrypted: i=1; AL+hErF4q+rgEtQuazH6xDsim0LRLGkHlrnNy1+OOB6nhRMZ64MUoUM8W9+AePiGbb1GhHBTqV8mTlo=@lists.linux.dev
X-Gm-Message-State: APuU4Z/VybS6cxSmld5ugTZTUOFmXFhJAcdto5BZWXAQPcSkQBv1pbqm
	VBjmFp9rA6zHvSpL+6NlLDr4Hs29iuKaSAtYTwO1tACuJ3XvHeywPMJODSfovqVl2wQilZ6P8Ba
	Ibkbv8PxfgMkfWnJ4l2eyX3MEYQ==
X-Received: from iok27-n2.prod.google.com ([2002:a05:6602:c61b:20b0:9e0:ddf2:d76c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c211:b0:573:4e8b:1f5c with SMTP id 5614622812f47-57a0b048d59mr14167327b6e.35.1795476409032;
 Mon, 23 Nov 2026 15:26:49 -0800 (PST)
Date: Mon, 23 Nov 2026 23:26:46 +0000
In-Reply-To: <20261123232647.3733149-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261123232647.3733149-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261123232647.3733149-2-coltonlewis@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: nv: Discard undersized TTL hints in compute_tlb_inval_range()
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Dan Carpenter <dan@pereq.eu>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When an L1 guest issues TLBI IPAS2E1 with a non-zero TTL hint,
compute_tlb_inval_range() takes it at face value. If the hinted size is
smaller than the actual mapping (for example, a 4kB L3 hint on a 2MB
block), kvm_pgtable_stage2_unmap() clears the entire block while
kvm_remove_guest_s2_mappings() leaves its stale tracking entry behind in
guest_s2_mappings. On 16kB or 64kB hosts, a 4kB hint also triggers
WARN_ON(size & ~PAGE_MASK) in kvm_stage2_unmap_range().

A TTL hint smaller than PAGE_SIZE or the mapped entry is wrong. Check
it against PAGE_SIZE, the shadow stage-2 leaf size, and the guest block
size encoded in KVM_NV_GUEST_MAP_SZ. If it is too small, ignore the hint
and fall through to the unhinted invalidation path.

When falling back to the maximum mapping extent with stage-2 disabled,
size it from PAGE_SIZE rather than VTCR_EL2.TG0 so 1:1 shadow blocks are
still covered.

Fixes: d1de1576dc21 ("KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations")
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/nested.c | 76 +++++++++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28b..d3a19b1db2144 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -610,6 +610,19 @@ static u8 pgshift_level_to_ttl(u16 shift, s8 level)
 	return ttl;
 }
 
+static u8 vtcr_tg0_to_ttl_gran(struct kvm_s2_mmu *mmu)
+{
+	switch (vtcr_to_tg0_pgsize(kvm_s2_mmu_to_kvm(mmu), mmu->tlb_vtcr)) {
+	case SZ_4K:
+		return TLBI_TTL_TG_4K << 2;
+	case SZ_16K:
+		return TLBI_TTL_TG_16K << 2;
+	case SZ_64K:
+	default:	/* IMPDEF: treat any other value as 64k */
+		return TLBI_TTL_TG_64K << 2;
+	}
+}
+
 /*
  * Compute the equivalent of the TTL field by parsing the shadow PT.  The
  * granule size is extracted from the cached VTCR_EL2.TG0 while the level is
@@ -624,18 +637,7 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 
 	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
 
-	switch (tg0_size) {
-	case SZ_4K:
-		ttl = (TLBI_TTL_TG_4K << 2);
-		break;
-	case SZ_16K:
-		ttl = (TLBI_TTL_TG_16K << 2);
-		break;
-	case SZ_64K:
-	default:	    /* IMPDEF: treat any other value as 64k */
-		ttl = (TLBI_TTL_TG_64K << 2);
-		break;
-	}
+	ttl = vtcr_tg0_to_ttl_gran(mmu);
 
 	tmp = addr;
 
@@ -686,29 +688,61 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 	return 0;
 }
 
+static bool tlbi_ttl_too_small(struct kvm_s2_mmu *mmu, u64 addr,
+			       unsigned long max_size)
+{
+	u8 guest_level;
+	kvm_pte_t pte;
+	s8 level;
+
+	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
+
+	if (max_size < PAGE_SIZE)
+		return true;
+
+	if (kvm_pgtable_get_leaf(mmu->pgt, addr, &pte, &level, 0))
+		return false;
+
+	if (!kvm_pte_valid(pte))
+		return false;
+
+	if (kvm_granule_size(level) > max_size)
+		return true;
+
+	guest_level = FIELD_GET(KVM_NV_GUEST_MAP_SZ, pte);
+	if (guest_level &&
+	    __ttl_to_size(vtcr_tg0_to_ttl_gran(mmu) | guest_level) > max_size)
+		return true;
+
+	return false;
+}
+
 unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 {
+	u64 addr = (val & GENMASK_ULL(35, 0)) << 12;
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	u8 ttl = FIELD_GET(TLBI_TTL_MASK, val);
 	unsigned long max_size;
-	u8 ttl;
-
-	ttl = FIELD_GET(TLBI_TTL_MASK, val);
 
-	if (!ttl || !kvm_has_feat(kvm, ID_AA64MMFR2_EL1, TTL, IMP)) {
-		/* No TTL, check the shadow S2 for a hint */
-		u64 addr = (val & GENMASK_ULL(35, 0)) << 12;
-		ttl = get_guest_mapping_ttl(mmu, addr);
+	if (ttl && kvm_has_feat(kvm, ID_AA64MMFR2_EL1, TTL, IMP)) {
+		max_size = __ttl_to_size(ttl);
+		if (max_size && !tlbi_ttl_too_small(mmu, addr, max_size))
+			return max_size;
 	}
 
+	/* No usable TTL hint, check the shadow S2 for a hint */
+	ttl = get_guest_mapping_ttl(mmu, addr);
+
 	/*
 	 * Don't use the default 1GB fallback, as we can adapt to the
 	 * max mapping size we allow at S2.
 	 */
 	max_size = __ttl_to_size(ttl);
 
-	if (!max_size) {
+	if (max_size < PAGE_SIZE) {
 		/* Compute the maximum extent of the invalidation */
-		switch (vtcr_to_tg0_pgsize(kvm, mmu->tlb_vtcr)) {
+		switch (mmu->nested_stage2_enabled ?
+			vtcr_to_tg0_pgsize(kvm, mmu->tlb_vtcr) : PAGE_SIZE) {
 		case SZ_4K:
 			max_size = SZ_1G;
 			break;
-- 
2.56.1.839.g22a8290db9-goog

