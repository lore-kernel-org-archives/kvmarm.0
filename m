Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5185A3DE424
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 19:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782933880; cv=none; b=CDMKYTwOM0aMwwRg3ixWOdZz+K32YULQOHn2kjZvG29KEODAna2rvhjxp33dczuPFKFEt3/Wmcd/aXdXueyvKxWUREcsT0OKAvmiC3Nv6cwOzpXf2G4K/28X4/xVBRN+C5B0b4NaGJ8q+bCRGREp95m3E8ua22XV55FjQzDAz10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782933880; c=relaxed/simple;
	bh=DDKdaqnoOKAYbVyBjKEohT/W3Mj0zLWsM3lzHDdQjNs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DDKfTjHjsnzy+aaF8w+7+3JPmkRfYiiVNbdvqceqA8gZgRWou5MhM0sHTFLBJ7lEFQRNAdBJfRnqZyGh/TvFou3Rv8Sw6cWtOuVijeSQfpXqou0THet7dWy53OiNDLqS8HRbTDRMEpI9L26u5BvEV0yM4AQjXeZpdi8GeIwVrIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=IOwZNiFZ; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="IOwZNiFZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782933869;
	bh=ApOH0P25anaf8G9Ri8bIsKw129Af3l9xDMyuv0tC9qM=;
	h=From:To:Cc:Subject:Date:From;
	b=IOwZNiFZdBWwBCt2IuZiSddeTU0g11S2tUIJJKy9YTY23EeaxgvxYCMGyhRNOIAUy
	 jC/bANTXx7vvqa+HEHEC0GBj0nsmUDBP/XbZ5mGDFFopDYS9KfSRB0HQIjcsnVFCpt
	 QwLnMqJ+VeVLnsoPZI1r5bkJuCaOfan43oU3N8pQ=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4gr91n0gF0z115b;
	Wed, 01 Jul 2026 19:24:29 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4gr91l0mrkz112N;
	Wed, 01 Jul 2026 19:24:27 +0000 (UTC)
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
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Bradley Morgan <include@grrlz.net>
Subject: [PATCH v4] KVM: arm64: Record whether pKVM stage 2 mapping is cacheable
Date: Wed,  1 Jul 2026 19:24:28 +0000
Message-ID: <20260701192428.17430-1-include@grrlz.net>
X-Mailer: git-send-email 2.53.0
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
Changes since V3:
- addressed some review :)

 arch/arm64/kvm/pkvm.c | 51 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..6d1cad890c7e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -302,9 +302,32 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping *m)
 	return m->gfn * PAGE_SIZE;
 }
 
+#define PKVM_MAPPING_NR_PAGES_MASK     GENMASK_ULL(47, 0)
+#define PKVM_MAPPING_NC                        BIT_ULL(48)
+
+static u64 pkvm_mapping_nr_pages(struct pkvm_mapping *m)
+{
+	return m->nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
+}
+
+static bool pkvm_mapping_is_nc(struct pkvm_mapping *m)
+{
+	return m->nr_pages & PKVM_MAPPING_NC;
+}
+
+static void pkvm_mapping_set_nr_pages(struct pkvm_mapping *m, u64 nr_pages,
+				      bool nc)
+{
+	WARN_ON_ONCE(nr_pages & ~PKVM_MAPPING_NR_PAGES_MASK);
+
+	m->nr_pages = nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
+	if (nc)
+		m->nr_pages |= PKVM_MAPPING_NC;
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
+	       WARN_ON_ONCE(pkvm_mapping_nr_pages(mapping) != 1);
 		unpin_user_pages_dirty_lock(&page, 1, true);
 		account_locked_vm(current->mm, 1, false);
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
@@ -369,7 +392,7 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
 
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
-					mapping->nr_pages);
+				       pkvm_mapping_nr_pages(mapping));
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
+				  (prot & (KVM_PGTABLE_PROT_DEVICE |
+					   KVM_PGTABLE_PROT_NORMAL_NC)));
 	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
 
 	return ret;
@@ -503,7 +528,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
-					mapping->nr_pages);
+				       pkvm_mapping_nr_pages(mapping));
 		if (WARN_ON(ret))
 			break;
 	}
@@ -517,9 +542,13 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct pkvm_mapping *mapping;
 
 	lockdep_assert_held(&kvm->mmu_lock);
-	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
+	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
+		if (pkvm_mapping_is_nc(mapping))
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

