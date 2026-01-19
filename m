Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E3221543
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826853; cv=none; b=WOjqEL+GeBOYMthMbXIG0FmAm4GjL0siPy1QUoC+nJlUZdvcaWkT8AFDJDDqNSvO9CdTMFNa/eWhgFI5vUJ/ESp858xqJQQn2Dh+VprBin5Nvv5XLvmoiHDtUuCfGPjAkHX3gzui+yttDrhcQN1Gm5CEhXppqb0QsCeAEnv1noo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826853; c=relaxed/simple;
	bh=QIytrQ+JfCPY7Q3YwnW8a4Og7XxTsWbx3KsFumlCxiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWVKbk25KrctsJpAz9YMzgJdymI/k/Mv6M2PxBnjwWvn50zaiTxrCZy1fxB6GLYr4qCSneOxPWPm471Hb/cHLTLTtKgLCVdFWTMZirnhTndmBwjgtu1PuO9q+Qse9ko99SHfm21OQERzpU0OhgOhOpLtfwIR0yBdDOlWAu0IRsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NiF+0H2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NiF+0H2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD18FC19424;
	Mon, 19 Jan 2026 12:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826853;
	bh=QIytrQ+JfCPY7Q3YwnW8a4Og7XxTsWbx3KsFumlCxiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiF+0H2bfF2Qb1ajGj1R+aEucc0tewjwIKdkT9f6PXgO2wIc2D4pTk5epyHp1dGE1
	 gAkKapugTSt3Six+tATtLeRqtkuQRHCJT8Q/GFwHOGHJlDaYmwYDxU0ZyAXSWC1xh6
	 PZB67fdHdxHbPrshnN6RQhTao0gibntg1WgTacs7nidGkNt+Eedv399yZtL2M97o9D
	 sPMruWov3HvdfxDfmesVGvzYQWzNVOYN0LCYyWMu095yCiBlbFwffSa1BHJmLONoj6
	 D904AWlQ4Ydkcytv7oAdVbJD4eHaZ0/9n4SCYmQ8L0Wvo2Onv3DiZa0KBP2MYqpvvA
	 shv16tzAYoz6A==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 13/35] KVM: arm64: Hook up donation hypercall to pkvm_pgtable_stage2_map()
Date: Mon, 19 Jan 2026 12:46:06 +0000
Message-ID: <20260119124629.2563-14-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mapping pages into a protected guest requires the donation of memory
from the host.

Extend pkvm_pgtable_stage2_map() to issue a donate hypercall when the
target VM is protected. Since the hypercall only handles a single page,
the splitting logic used for the share path is not required.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/pkvm.c | 58 ++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index a39dacd1d617..1814e17d600e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -373,31 +373,55 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	struct kvm_hyp_memcache *cache = mc;
 	u64 gfn = addr >> PAGE_SHIFT;
 	u64 pfn = phys >> PAGE_SHIFT;
+	u64 end = addr + size;
 	int ret;
 
-	if (size != PAGE_SIZE && size != PMD_SIZE)
-		return -EINVAL;
-
 	lockdep_assert_held_write(&kvm->mmu_lock);
+	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
 
-	/*
-	 * Calling stage2_map() on top of existing mappings is either happening because of a race
-	 * with another vCPU, or because we're changing between page and block mappings. As per
-	 * user_mem_abort(), same-size permission faults are handled in the relax_perms() path.
-	 */
-	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, addr + size - 1);
-	if (mapping) {
-		if (size == (mapping->nr_pages * PAGE_SIZE))
+	if (kvm_vm_is_protected(kvm)) {
+		/* Protected VMs are mapped using RWX page-granular mappings */
+		if (WARN_ON_ONCE(size != PAGE_SIZE))
+			return -EINVAL;
+
+		if (WARN_ON_ONCE(prot != KVM_PGTABLE_PROT_RWX))
+			return -EINVAL;
+
+		/*
+		 * We raced with another vCPU.
+		 */
+		if (mapping)
 			return -EAGAIN;
 
-		/* Remove _any_ pkvm_mapping overlapping with the range, bigger or smaller. */
-		ret = __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
-		if (ret)
-			return ret;
-		mapping = NULL;
+		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn);
+	} else {
+		if (WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE))
+			return -EINVAL;
+
+		/*
+		 * We either raced with another vCPU or we're changing between
+		 * page and block mappings. As per user_mem_abort(), same-size
+		 * permission faults are handled in the relax_perms() path.
+		 */
+		if (mapping) {
+			if (size == (mapping->nr_pages * PAGE_SIZE))
+				return -EAGAIN;
+
+			/*
+			 * Remove _any_ pkvm_mapping overlapping with the range,
+			 * bigger or smaller.
+			 */
+			ret = __pkvm_pgtable_stage2_unshare(pgt, addr, end);
+			if (ret)
+				return ret;
+
+			mapping = NULL;
+		}
+
+		ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn,
+					size / PAGE_SIZE, prot);
 	}
 
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, size / PAGE_SIZE, prot);
 	if (WARN_ON(ret))
 		return ret;
 
-- 
2.52.0.457.g6b5491de43-goog

