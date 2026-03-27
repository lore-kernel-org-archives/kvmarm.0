Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433D93DA7E0
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620084; cv=none; b=Av8DPogc2J9Y3A6qg64sV4/hFiz94gSqxQ1uCBx0HgxwkXxs+tDOIhLdWjYzGKPEzNhrIgPzqPydRaY2a1v9L6QLvVNkrUamQAy7EVKIULwRVpbM9sXEr4eLf5APWHYt4DjJM8YfsAT5ZU7RY93Cez20GnzDOIhPbaaX1RVa3C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620084; c=relaxed/simple;
	bh=kupY+rUTW2UPV/U5cwqqP9hhXbxo6oWLqyy18kOdLqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5ojQFUWMi1u+NtErY4VOgxcYSJTkOpxYG4FuDyDCdv1Fg549XsFvNhpHaW3IZmjXLat7s7CBS5qcgJbyFyovnCzF9lsCCEwR4VT+HBZ0dzT9QizMAv31tmrywscAsx6ZM5xwf9sSqMAuESM6XP1O7P9+6BIdHJkyxwOktWw908=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3CyJB6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3CyJB6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54259C2BC87;
	Fri, 27 Mar 2026 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620084;
	bh=kupY+rUTW2UPV/U5cwqqP9hhXbxo6oWLqyy18kOdLqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3CyJB6XuH1QxZ3XVr7pF5zKDjbprLRpmHGlayNlpMp7fpXR4gUwKbjpQMJOZviJY
	 /fkX6whX1aUKfgz7B9+1vm0GwrmUJ0ZvhY+HY4UXYck729EV8HconQGOth14Tp3Hot
	 Ge6YCwasgM0uJ7p+OvNcmQh5NTbUSTvObFUMa3Wwqh2LVHzyE/C7vvhQ2+wOez7DZp
	 J03BWY5JfcMPbeHcOgyMKCVvmhnV9awi42y1NtNnidmp8LeirQAAHYp/2LtXUbJVLw
	 rBtCEIzd+ZuYIaTwNUeGVwb7WsN1DDvaHm14yE3lRQWlckS7DdcZibNdIv2HGcWkEc
	 ytaXD5tZZUUPA==
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
Subject: [PATCH v4 10/38] KVM: arm64: Ignore -EAGAIN when mapping in pages for the pKVM host
Date: Fri, 27 Mar 2026 14:00:09 +0000
Message-ID: <20260327140039.21228-11-will@kernel.org>
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

If the host takes a stage-2 translation fault on two CPUs at the same
time, one of them will get back -EAGAIN from the page-table mapping code
when it runs into the mapping installed by the other.

Rather than handle this explicitly in handle_host_mem_abort(), pass the
new KVM_PGTABLE_WALK_IGNORE_EAGAIN flag to kvm_pgtable_stage2_map() from
__host_stage2_idmap() and return -EEXIST if host_stage2_adjust_range()
finds a valid pte. This will avoid having to test for -EAGAIN on the
reclaim path in subsequent patches.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d815265bd374..7d22893ab1dc 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -461,8 +461,15 @@ static bool range_is_memory(u64 start, u64 end)
 static inline int __host_stage2_idmap(u64 start, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
+	/*
+	 * We don't make permission changes to the host idmap after
+	 * initialisation, so we can squash -EAGAIN to save callers
+	 * having to treat it like success in the case that they try to
+	 * map something that is already mapped.
+	 */
 	return kvm_pgtable_stage2_map(&host_mmu.pgt, start, end - start, start,
-				      prot, &host_s2_pool, 0);
+				      prot, &host_s2_pool,
+				      KVM_PGTABLE_WALK_IGNORE_EAGAIN);
 }
 
 /*
@@ -504,7 +511,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 		return ret;
 
 	if (kvm_pte_valid(pte))
-		return -EAGAIN;
+		return -EEXIST;
 
 	if (pte) {
 		WARN_ON(addr_is_memory(addr) &&
@@ -609,7 +616,6 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
 	u64 esr, addr;
-	int ret = 0;
 
 	esr = read_sysreg_el2(SYS_ESR);
 	if (!__get_fault_info(esr, &fault)) {
@@ -628,8 +634,13 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
-	ret = host_stage2_idmap(addr);
-	BUG_ON(ret && ret != -EAGAIN);
+	switch (host_stage2_idmap(addr)) {
+	case -EEXIST:
+	case 0:
+		break;
+	default:
+		BUG();
+	}
 }
 
 struct check_walk_data {
-- 
2.53.0.1018.g2bb0e51243-goog

