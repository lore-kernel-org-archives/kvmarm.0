Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114268;
	b=LoDy7s47WFBFG0emCGS1fc5+DQceY8l9CrVMfGJLzTIvOdImwLcS1jByIwAJzHokFUAg
	 EKpjhcjVQlTsPqg2mo7Wohrs+DKOp6CTVuIH2d+L75rw0SWPsb1MVY/ayILT633ormtqa
	 04S7C6LYi7JvZ9zL30y985U59P1/X/mN0h5CAxSPVrznkF+CUxNu2ETBNfdkcq04ziJmF
	 kP4bSjlmjlH6f0uakxwe5FR3ExiP78UUkCqQH+gEtgwTp6mZiYVO0Wu7JpNYyDt3pSX0S
	 CjY7v3aP6dWXB8dvdv8IIxWmASKr70e8x8MzFDfQowKvtpJqLddHWyRW0gKqBx/ZUAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114268;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=EUVB3lvAAA+9cFv96d1naxWu3Fm3QF4X7A86Sm9t51E=;
	b=ThiyUrkJNF0WI/EU7gafPKYA/wfMZFYLLPbLimf+66zpjmVM6xUvVHxyWJAbEgMl9TkE
	 xmNW1k+kxmsfdhce1xG5Q2YlrkRozOKJFcXMcCq4T4fTrkTGhSPwRrEvpWg4dgmrwU5cv
	 t1TB7PwSF5jfRQyxNIjQPp+wQMeLxis5atve3xT9GxN6+f5xSQYJMi5onrFry/iYylDz0
	 +hjBAcDiGmH12UhcGN4y33zOoJlwVQ5nsl8H8tJXHbiyh7LH7wMLS4X+l3uqoN2yOVx/c
	 mSCNBiHwgo07aX6BtHzKotz5dr2quFtk+bkSYGN2R51WqimQdpUqG7ukrAnENOUK2dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KSUGXfLH;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AE9606A32A
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20AE9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KSUGXfLH
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b37620eb73so237907b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114267; x=1795719067; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EUVB3lvAAA+9cFv96d1naxWu3Fm3QF4X7A86Sm9t51E=;
        b=KSUGXfLH1uAV1nwOWIystfHKE6Ta5mC5guPx9GjOJ8R540ec42jJD0RzT5aY9M1JnF
         tR70iSqFgYU3QOCHohdwSOB/Cw9mDVpSvHJPWPlVSx/lU81xvEHzgdy9is8np8asaEUh
         7nR4EkfvTPutc1AgB27/F5Ae5geGINzXdRgrzmLvxdTkI6e0v0dxQZhLdDInN4T4wvux
         ijQRmeud+aCIzrYduIFrCX+coJucFQIPmX6rXnbube8g0MI0vU7yzWchmlRFcpcpVbz/
         AkDeL+9xmuD1EsKIl+0MwkfJabKL9xGYJBcWigzlGekQjvKj+r9Dg4rwsZd8z7ul2ROj
         mBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114267; x=1795719067;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EUVB3lvAAA+9cFv96d1naxWu3Fm3QF4X7A86Sm9t51E=;
        b=IQDxOe0vbbXzRlulFcRMG4xhlvBIvHoFykClvyb6HLExtKCUzjQ1YJIJ+vTiSDeKdH
         jG8L3GNYl42CsvTIvhZa8jL/DzfTu4eqOR9YT94TwQu+K2ORieX5g/ULerBrqNbht1CS
         mM4+DyOS8zkC6kO6IR3ET+usAiolZ6QvAtymRgNjQ4q7lD6Q49X1UH+X9C1h631Y49tr
         dLRiFwGDay6ANLOxWuQ5UV2E1mPPVFSgoJwqNnhgEuu9ByVb0avHo/XBEvgsVg6u57V2
         XRUe0GwDYT+7aM0tSJ+LYy+oA8sjaKjcFNxA2tjc2p84Ux7wWs0JW2t9T/LDyxyAE/Qp
         s9MA==
X-Forwarded-Encrypted: i=1; AL+hErEZpvsZyq73+n4ZoNJQwDIfhFLkq1KY0uRCQANI3BsbPufiwnr4AziC2Bbyxq4joWuWjIkP/bE=@lists.linux.dev
X-Gm-Message-State: APuU4Z9ijkRsjHOg9eu0KRQ0Bg3zmGqSV3nj00GYGLGNT6pVvoPMj+Ce
	7k7qaGMITQZiafPVHJ5HTm84/wSTSEkNPVtGkv+2/cvKSukT0yMKcTsL69lysJ/CbkqHTpifda5
	NfdwSQxsv/yEhQuQ8tjDTqAZQoA==
X-Received: from jafr21-n2.prod.google.com ([2002:a05:6638:afd5:20b0:621:af13:c8e0])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1789:b0:572:48fd:bdb7 with SMTP id 5614622812f47-57a06b1d9a3mr1038736b6e.2.1795114266544;
 Thu, 19 Nov 2026 10:51:06 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:05 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185105.626343-1-coltonlewis@google.com>
Subject: [PATCH] KVM: arm64: nv: Fix guest stage-2 mapping leak on sub-block unmap
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Wei-Lin Chang <weilin.chang@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Steffen Eiden <seiden@linux.ibm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When a shadow stage-2 block mapping (for example, 2M at PMD level) is
partially invalidated by a smaller guest unmap such as a 4K TLBI
IPAS2E1IS, kvm_pgtable_stage2_unmap() shatters and clears the entire
block descriptor in mmu->pgt. However, kvm_remove_guest_s2_mappings()
only removes a struct kvm_guest_s2_mapping node when its entire
[nested_start, nested.last] span lies within the unmap range. As a
result, every sub-block invalidation followed by a re-fault leaks a
stale block-sized tracking node in mmu->guest_s2_mappings and
kvm->arch.mmu.guest_s2_mappings until the shadow MMU is destroyed,
allowing an L1 guest to grow host kernel memory and degrade subsequent
TLBI IPAS2E1IS walks to O(N) under write_lock(&kvm->mmu_lock).

Conversely, unconditionally removing any overlapping tracking node on a
sub-block unmap would be unsafe when a shadow block mapping has been
split into a child table (such as on a page-granule fault under dirty
logging or a racing shared walk returning -EAGAIN), because sibling
sub-page PTEs outside the unmapped range remain live in mmu->pgt and
still rely on the block-sized tracking node for host MMU notifier
unmaps.

Since stage2_unmap_walker() unlinks empty child page tables in
KVM_PGTABLE_WALK_TABLE_POST as soon as their last valid entry is
cleared, check mmu->pgt via kvm_pgtable_get_leaf() on partial-overlap
candidates: when no valid entry or split sub-table remains at or below
the recorded mapping granule (!kvm_pte_valid(pte) &&
kvm_granule_size(level) >= map_size), remove and free the tracking node;
otherwise retain it to cover surviving split sub-entries.

In addition, suppress exact-match duplicate insertions in
kvm_record_guest_s2_mapping() when concurrent faults or -EAGAIN retries
record an identical (nested, canonical) range on the same shadow MMU.

Fixes: 5491980c1a41 ("KVM: arm64: nv: Track guest stage-2 mapping removal")
Fixes: c2778d14cd2f ("KVM: arm64: nv: Track guest stage-2 mapping creation")
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/nested.c | 68 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 61 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28b..2b1c85de5b719 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -896,6 +896,30 @@ static unsigned long s2_mapping_to_nested_start(struct kvm_guest_s2_mapping *map
 	return mapping->nested.start & ~S2_MMU_IDX_MASK;
 }
 
+static bool guest_s2_mapping_exists(struct kvm_s2_mmu *mmu,
+				    struct kvm_guest_s2_mapping *mapping)
+{
+	struct interval_tree_node *node;
+
+	for (node = interval_tree_iter_first(&mmu->guest_s2_mappings,
+					     mapping->nested.start,
+					     mapping->nested.last);
+	     node;
+	     node = interval_tree_iter_next(node, mapping->nested.start,
+					    mapping->nested.last)) {
+		struct kvm_guest_s2_mapping *curr;
+
+		curr = container_of(node, struct kvm_guest_s2_mapping, nested);
+		if (curr->nested.start == mapping->nested.start &&
+		    curr->nested.last == mapping->nested.last &&
+		    curr->canonical.start == mapping->canonical.start &&
+		    curr->canonical.last == mapping->canonical.last)
+			return true;
+	}
+
+	return false;
+}
+
 void kvm_record_guest_s2_mapping(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
 				 gpa_t nested_ipa, size_t map_size,
 				 struct kvm_guest_s2_mapping *mapping)
@@ -915,9 +939,32 @@ void kvm_record_guest_s2_mapping(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
 
 	tag_s2_mapping_mmu(mapping, mmu);
 
-	guard(spinlock)(&kvm->arch.guest_s2_tracking_lock);
-	interval_tree_insert(&mapping->nested, &mmu->guest_s2_mappings);
-	interval_tree_insert(&mapping->canonical, &kvm->arch.mmu.guest_s2_mappings);
+	scoped_guard(spinlock, &kvm->arch.guest_s2_tracking_lock) {
+		if (!guest_s2_mapping_exists(mmu, mapping)) {
+			interval_tree_insert(&mapping->nested,
+					     &mmu->guest_s2_mappings);
+			interval_tree_insert(&mapping->canonical,
+					     &kvm->arch.mmu.guest_s2_mappings);
+			mapping = NULL;
+		}
+	}
+
+	kfree(mapping);
+}
+
+static bool guest_s2_mapping_unmapped(struct kvm_s2_mmu *mmu,
+				      gpa_t nested_start, size_t map_size)
+{
+	kvm_pte_t pte;
+	s8 level;
+
+	if (!mmu->pgt)
+		return true;
+
+	if (kvm_pgtable_get_leaf(mmu->pgt, nested_start, &pte, &level, 0))
+		return false;
+
+	return !kvm_pte_valid(pte) && kvm_granule_size(level) >= map_size;
 }
 
 void kvm_remove_guest_s2_mappings(struct kvm_s2_mmu *mmu, gpa_t nipa,
@@ -937,17 +984,24 @@ void kvm_remove_guest_s2_mappings(struct kvm_s2_mmu *mmu, gpa_t nipa,
 	node = interval_tree_iter_first(&mmu->guest_s2_mappings, nipa, nipa_end);
 	while (node) {
 		unsigned long nested_start;
+		size_t map_size;
 
 		next = interval_tree_iter_next(node, nipa, nipa_end);
 		mapping = container_of(node, struct kvm_guest_s2_mapping,
 				       nested);
 		/*
-		 * Tracking must be conservative on removal, only remove
-		 * mappings that are within the unmap range.
+		 * A sub-block unmap tears down an unsplit shadow block entry
+		 * in mmu->pgt, whereas a split block may still have valid
+		 * sub-page entries outside [nipa, nipa_end]. Remove the
+		 * tracking entry when it lies within the unmap range or no
+		 * mappings remain across its span in mmu->pgt.
 		 */
 		nested_start = s2_mapping_to_nested_start(mapping);
-		if (nipa <= nested_start && nipa_end >= mapping->nested.last) {
-			interval_tree_remove(&mapping->nested, &mmu->guest_s2_mappings);
+		map_size = mapping->nested.last - nested_start + 1;
+		if ((nipa <= nested_start && nipa_end >= mapping->nested.last) ||
+		    guest_s2_mapping_unmapped(mmu, nested_start, map_size)) {
+			interval_tree_remove(&mapping->nested,
+					     &mmu->guest_s2_mappings);
 			interval_tree_remove(&mapping->canonical,
 					     &kvm->arch.mmu.guest_s2_mappings);
 			kfree(mapping);

base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
-- 
2.56.1.809.ga0b61035b5-goog

