Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4133FD121
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293444; cv=none; b=k3/lhpnEKhm/SK+Dcwc8lRZBcBGEDWvMI2MSpuBHWMcf3OmqxobcH0L5dZH66SkmrrIm3dJlphJFzZWlTp8Zd/7ONpC+U2PqWkdoN0tW0WJBC1ujpDhxccO27orqHsFT+Kpb3dV8uzzT7Ut2D7qfxunfflagE6+m3WToB90uqKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293444; c=relaxed/simple;
	bh=6NkZvmG5WlRjKaf9vo/rU0FXUSyATvE4PlCrYHNBIoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GxGkQb1ABVCzuRcZ7ijffJ4FrSE4SkQYvJa+PIJnEsBXAqhMi3S5l6Hf6TXZYwZhlo/q4kyRSpyu67643eds3FsSvHl4r335AEVHOgff3QSK47uaziVsNWblIgkA+tD7lZi/8ZR6UchITZxtwGtQy24kzTaSefCc1rKJWRc/oZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bTt1bC3t; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bTt1bC3t"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784293440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nGVeKTTWAc9E9IUshZYvJfmhVmD43mhNRriYPRWPSws=;
	b=bTt1bC3tHPWxJo2efKJyKDuIt3XSi86C7GZICKn3qXE5I7cB/GAaA8VjpnZFgwl6xjOAZV
	uRDQ2pj768cQ0u8loDjVpiWbLRxhY9pu8D90pYSXaPs34u49hU7AY2tb5I4gW/zMuCATcB
	IvUxUdpzsAJoVi65gSAKgaNOobkCcfg=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Bradley Morgan <include@grrlz.net>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/7] KVM: arm64: Skip cache maintenance for non-cacheable pKVM mappings
Date: Fri, 17 Jul 2026 14:03:11 +0100
Message-Id: <20260717130317.1953574-2-fuad.tabba@linux.dev>
In-Reply-To: <20260717130317.1953574-1-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Bradley Morgan <include@grrlz.net>

The pKVM flush path walks its own pkvm_mappings list and cleans the
data cache for every mapping, unlike the generic stage-2 walker it
shadows, which skips non-cacheable leaves. Cleaning the cacheable
alias of a non-cacheable mapping is pointless and can corrupt a
device endpoint. Record whether a mapping is non-cacheable in spare
bits of nr_pages and skip cache maintenance for it.

Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Bradley Morgan <include@grrlz.net>
[tabba: use Marc's anonymous bitfield in place of the open-coded mask and helpers]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h |  5 ++++-
 arch/arm64/kvm/pkvm.c             | 15 +++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 74fedd9c5ff0..57afb07d6b13 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -195,7 +195,10 @@ struct pkvm_mapping {
 	struct rb_node node;
 	u64 gfn;
 	u64 pfn;
-	u64 nr_pages;
+	struct {
+		u64 nr_pages:48;
+		u64 nc:1;
+	};
 	u64 __subtree_last;	/* Internal member for interval tree */
 };
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..f70c601dcf4c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -369,7 +369,7 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
 
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
-					mapping->nr_pages);
+					(u64)mapping->nr_pages);
 		if (WARN_ON(ret))
 			return ret;
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
@@ -473,6 +473,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	mapping->gfn = gfn;
 	mapping->pfn = pfn;
 	mapping->nr_pages = size / PAGE_SIZE;
+	mapping->nc = !!(prot & (KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC));
 	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
 
 	return ret;
@@ -503,7 +504,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
-					mapping->nr_pages);
+					(u64)mapping->nr_pages);
 		if (WARN_ON(ret))
 			break;
 	}
@@ -517,9 +518,11 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct pkvm_mapping *mapping;
 
 	lockdep_assert_held(&kvm->mmu_lock);
-	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
-		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
-					  PAGE_SIZE * mapping->nr_pages);
+	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
+		if (!mapping->nc)
+			__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
+						  PAGE_SIZE * mapping->nr_pages);
+	}
 
 	return 0;
 }
@@ -537,7 +540,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   mapping->nr_pages, mkold);
+					   (u64)mapping->nr_pages, mkold);
 
 	return young;
 }
-- 
2.39.5

