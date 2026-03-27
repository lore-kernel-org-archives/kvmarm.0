Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E64221264
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620094; cv=none; b=t9RHuPvB2g/qOwhqeFN5xtltkw3iJzqzWZMrVHDiXlVQDemNhGpTLtFXPrisPYeY7RQPL/NiAo1TIieizFy1vbqRd1jcY8faZsallr6Vw1Ga7x06stYbpq2eftZa1TxSGygQ1iTtueMFKvMIZ3xi+APSNlTv2rUR12ygUtyb6Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620094; c=relaxed/simple;
	bh=mvm9UmqZ0+vr1pjWR9462kBgjk8s08LfdeZKP6SDr18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUWPgeaQzxDBxkTdJ+ell214zYBUeIhuVI2MJ8d1lW5Tr4cOlI017qPQQTAX0QFert5QfmQQurWQq5Bf/GvDLVl+/Q9nfdqU3Wlmf5J9Jz+JHFrTXkMQkXB9V8ekhk3xWgoQZ1/DtsjgoulvnXbS4RUX+sdxx7MdUQo65Y04fiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXc2JaB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXc2JaB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDA1C19423;
	Fri, 27 Mar 2026 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620093;
	bh=mvm9UmqZ0+vr1pjWR9462kBgjk8s08LfdeZKP6SDr18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXc2JaB40sbtzjLgPM9XQziJ0unXfPCjQtlQMrrVhD+ryQiLeLBTEcbr1sHsYgj3D
	 GXTVbcY5u2nzZnke2EnAHxsnHCnCjQdS+Qlo8jC8l2UMvbrGuvOcRbjDPNgTXB/WN1
	 ZndzeTiYg7Ynd+PIuoubs89xKkKC8alKPehm6vC+61EUzPSJz53beTeLxooxBbJpnv
	 ysP9iLYmoqYXXPsSTqiHUqF9szju73hJlvV1RwK7ehlzkBX83gLT+IsJhpQ1B5MgoO
	 Qami/CeF5iOuQYkdyuIiQlDcNmJGB1QEpRCt8J9h3Ef2ZD339yFpZ0wdKUF30R1BEX
	 V8+mnWtD5mPpQ==
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
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 13/38] KVM: arm64: Hook up donation hypercall to pkvm_pgtable_stage2_map()
Date: Fri, 27 Mar 2026 14:00:12 +0000
Message-ID: <20260327140039.21228-14-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
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

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
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
2.53.0.1018.g2bb0e51243-goog

