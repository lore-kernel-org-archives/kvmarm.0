Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B0F305699
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316861; cv=none; b=cDKJwmRCgUZe2rN4FOif03LwlgA2G3x9JljqxPOwXq0K29WGeIQznD18bEOcHEx53qdlhMXjkVwmtQog+D5Yr0A8RbBH/uM3e99KYfbY1R9j/vt2tTq3Ifzt7k1heUrmImqBwfSMtEEy+frhX64Yddj1mfc6CH7sOcyswYpL4BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316861; c=relaxed/simple;
	bh=FwlYweljixxcf/aCLOhKPunbJGB58oipYK6wGiFqL4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYCKRruZNgJyPCkoZ1fJsP73X7GcRc7mgX5+BcpggJVIaiB/SPQd/lNBXzmof6FoeXYs0PvIxgWiJZSqcMzjgXQC7C7JXKdKOoRys0bC/FG9on3aT//BpGvA5SeHT3RWS+L0OuBAUwUFaq0ltgKW6eLZ08vkHexW5/WM0VPdkDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=GExjL+0g; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="GExjL+0g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782316852;
	bh=1TizSR+F7DAiTkrpTXeVx6qQOYtrq2iNJ5sQ0l7hR80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GExjL+0gBG861De2/4YrEV8wzoyVq+05CzBbBuEiEwsoVtpj0hoFq4D0MDcZGwqCW
	 IKPYqIXolFbPVC6hg+C8s5+xISsOAyLV4U1mcYiO3l1OQzGmWC432DcwDsDz3iY9jW
	 JN46z0sRYognTEUCKHPFgPA/XOxGy/012uVPiWds=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4glmr41MYMz10tp;
	Wed, 24 Jun 2026 16:00:52 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4glmr240Xlz10tb;
	Wed, 24 Jun 2026 16:00:50 +0000 (UTC)
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Bradley Morgan <include@grrlz.net>
Subject: [PATCH v3 1/3] KVM: arm64: skip pKVM cache flushes for non cacheable mappings
Date: Wed, 24 Jun 2026 16:00:26 +0000
Message-ID: <20260624160028.15591-2-include@grrlz.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260624160028.15591-1-include@grrlz.net>
References: <20260624160028.15591-1-include@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM keeps its own mapping list for stage 2 operations. Its flush path
uses that list directly, so it lost the PTE attribute check done by the
generic stage 2 walker.

Record whether a mapping is cacheable and skip cache maintenance for
mappings that are not cacheable.

Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
Signed-off-by: Bradley Morgan <include@grrlz.net>
---
 arch/arm64/kvm/pkvm.c | 51 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 428723b1b0f5..ca6e823028c2 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -302,9 +302,32 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping *m)
 	return m->gfn * PAGE_SIZE;
 }
 
+#define PKVM_MAPPING_NR_PAGES_MASK	GENMASK_ULL(47, 0)
+#define PKVM_MAPPING_CACHEABLE		BIT_ULL(48)
+
+static u64 pkvm_mapping_nr_pages(struct pkvm_mapping *m)
+{
+	return m->nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
+}
+
+static bool pkvm_mapping_is_cacheable(struct pkvm_mapping *m)
+{
+	return m->nr_pages & PKVM_MAPPING_CACHEABLE;
+}
+
+static void pkvm_mapping_set_nr_pages(struct pkvm_mapping *m, u64 nr_pages,
+				      bool cacheable)
+{
+	WARN_ON_ONCE(nr_pages & ~PKVM_MAPPING_NR_PAGES_MASK);
+
+	m->nr_pages = nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
+	if (cacheable)
+		m->nr_pages |= PKVM_MAPPING_CACHEABLE;
+}
+
 static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
 {
-	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
+	return (m->gfn + pkvm_mapping_nr_pages(m)) * PAGE_SIZE - 1;
 }
 
 INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
@@ -350,7 +373,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
 			continue;
 
 		page = pfn_to_page(mapping->pfn);
-		WARN_ON_ONCE(mapping->nr_pages != 1);
+		WARN_ON_ONCE(pkvm_mapping_nr_pages(mapping) != 1);
 		unpin_user_pages_dirty_lock(&page, 1, true);
 		account_locked_vm(kvm->mm, 1, false);
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
@@ -369,7 +392,7 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
 
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
-					mapping->nr_pages);
+					pkvm_mapping_nr_pages(mapping));
 		if (WARN_ON(ret))
 			return ret;
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
@@ -448,7 +471,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		 * permission faults are handled in the relax_perms() path.
 		 */
 		if (mapping) {
-			if (size == (mapping->nr_pages * PAGE_SIZE))
+			if (size == (pkvm_mapping_nr_pages(mapping) * PAGE_SIZE))
 				return -EAGAIN;
 
 			/*
@@ -472,7 +495,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	swap(mapping, cache->mapping);
 	mapping->gfn = gfn;
 	mapping->pfn = pfn;
-	mapping->nr_pages = size / PAGE_SIZE;
+	pkvm_mapping_set_nr_pages(mapping, size / PAGE_SIZE,
+				  !(prot & (KVM_PGTABLE_PROT_DEVICE |
+					    KVM_PGTABLE_PROT_NORMAL_NC)));
 	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
 
 	return ret;
@@ -503,7 +528,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
-					mapping->nr_pages);
+					pkvm_mapping_nr_pages(mapping));
 		if (WARN_ON(ret))
 			break;
 	}
@@ -517,9 +542,13 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct pkvm_mapping *mapping;
 
 	lockdep_assert_held(&kvm->mmu_lock);
-	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
+	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
+		if (!pkvm_mapping_is_cacheable(mapping))
+			continue;
+
 		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
-					  PAGE_SIZE * mapping->nr_pages);
+					  PAGE_SIZE * pkvm_mapping_nr_pages(mapping));
+	}
 
 	return 0;
 }
@@ -536,8 +565,10 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
-		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   mapping->nr_pages, mkold);
+		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest,
+					   handle, mapping->gfn,
+					   pkvm_mapping_nr_pages(mapping),
+					   mkold);
 
 	return young;
 }
-- 
2.53.0

