Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB70F3FD97F
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293447; cv=none; b=NV4cmEpqBRlQxo93GLRZ7kC3bXkFYftKfWprFnymw90Jmav1rXLWhHY72F56zNoYSaoPDI+E2wQIpXrsOwMR4cuosl8o6SI4+m8Ag8P1qqjj1ongpb5u5EX4Lwl2mR8DWkBtg1bL0fU6wTrbtKx0/JWcCHjQVhmukb+Y5odEtvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293447; c=relaxed/simple;
	bh=ixcN7TojDaxCxxawPFqmnn7W+Nnfy5nReo+h5Jaceho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QkCb7OAo4vdH3n44rEujsA6veWjsu4deags0XH7Fk1VzAAug6PllRmNKoGaMFgNxArEk14ez8ptZVAlMuZZpuM5Ch3J+E5CO5DINCSf/UBXOI5s7lv1Kte7sxlhZn1SntDz4y/CDUcJP35RzBIfgCbNIZOTwpGXwseropt1F4Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qIpcuxTa; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qIpcuxTa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784293443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vQfbr1Pd7lVsaw2RzzlCdtntUUL+zBQG5yeNfbLMXec=;
	b=qIpcuxTaDqo6sQz8/i5CXU/dpCr2ttdwiMxdMha9Lg5rEajvtQvQ6WJQLiBnoEKtAH4r7x
	dAuyhQeNzDPdcY5tBqHqiO1JocEGtwmQAE8aRj4BFUrDpLm16+GHKtAp9kneAPxFrz2ZrV
	IVPaeeXa8W4oLN0N2Fkg11vbF6KdKss=
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
Subject: [PATCH v5 2/7] KVM: arm64: Top up the memcache for pKVM permission faults
Date: Fri, 17 Jul 2026 14:03:12 +0100
Message-Id: <20260717130317.1953574-3-fuad.tabba@linux.dev>
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

A permission fault normally only relaxes a leaf, so user_mem_abort()
skips the memcache top-up. Under pKVM such a fault can instead collapse
pages into a block. That needs a fresh pkvm_mapping object, and without
it cache->mapping is NULL, so pkvm_pgtable_stage2_map() dereferences NULL
and faults the host under mmu_lock. Staging only the object is not
enough: the hypervisor requires kvm_mmu_cache_min_pages in the memcache
even for the allocation-free install, so under memcache pressure the
collapse returns -ENOMEM and trips the WARN_ON(ret) in
pkvm_pgtable_stage2_map() where a non-pKVM guest succeeds.

Top up the full memcache for pKVM permission faults so both the mapping
object and the min-pages are staged before mmu_lock.

Fixes: db14091d8f75 ("KVM: arm64: Stage-2 huge mappings for np-guests")
Reported-by: Bradley Morgan <include@grrlz.net>
Link: https://lore.kernel.org/all/20260623161545.EA08E1F000E9@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..4d7c9bdcef00 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2114,10 +2114,14 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	 * and so normally don't require allocations from the memcache. The
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
+	 * Under pKVM a permission fault can also collapse pages into a block,
+	 * which needs a fresh mapping object, and the hypervisor requires the
+	 * min-pages memcache even when the install allocates nothing.
 	 */
 	memcache = get_mmu_memcache(s2fd->vcpu);
 	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
-			    kvm_is_write_fault(s2fd->vcpu))) {
+			    kvm_is_write_fault(s2fd->vcpu)) ||
+	    is_protected_kvm_enabled()) {
 		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
 		if (ret)
 			return ret;
-- 
2.39.5

