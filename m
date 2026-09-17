Received: from mta0.migadu.com (out-135.mta0.migadu.com [91.218.175.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593F44ACC9A
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 09:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636721; cv=none; b=dWx3rrn6lz9EC6PNFRf03FZVgNrX5Vz5H5ZeGC0/o8goaCsobd9ArfrBg86/L0RldICk8afXLlCx+1bIXwE0+6KRKzzb4njkVFhvCWFoBjatTwbEPrUITYJXWjr9N/9V+nJ6NTRiGISSMlzZVL4vNkZJR12ba8cKzYhi7g7OzEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636721; c=relaxed/simple;
	bh=qWxN+EE1n/NUST3E3o6AfroyhPJ5HLiC0YPhK6f/EL4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DiDjf0fNjzsS1xgX3RzMcEQ3nWaIRylRvRJZX8svCHUdOZD5LaPL9JJTQSeZ1bVxH7s2m6w+PnG+reYDKpy4qHL/vkC0oMKohsUIfl1/r5p7Bp8yFS28YOHgTi6ttxaK7JRwL13sna8uj/xg1xpiEmAiPyVrBM65brVuyRMy66k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lryTLbVG; arc=none smtp.client-ip=91.218.175.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lryTLbVG"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qWxN+EE1n/NUST3E3o6AfroyhPJ5HLiC0YPhK6f/EL4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789636717; v=1; x=1790241517;
 b=lryTLbVG0IdxUM+FXjxuRvrAM6K+TupsS9K+15+MMaDRrKvxpUze5nEWAd9nQn7R2WfgbMP2
 Juz23r1veoh4d5i0YPE3/YilRQDReNHe8K4QPweN0Zo7gD4R6UFcrXYLEnKBZUok8oTtZ45YVS+
 Sv4wIcLIkmf72azCG/H9z2j4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2a294692267e0b73;
	Thu, 17 Sep 2026 09:18:37 +0000
X-Mizu-Trace-ID: 2a294692267e0b73
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	qperret@google.com,
	vdonnefort@google.com,
	martijnbogaard@google.com,
	seiden@linux.ibm.com,
	tabba@google.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/4] KVM: arm64: Check PGD alignment when creating a pVM
Date: Thu, 17 Sep 2026 10:18:24 +0100
Message-Id: <20260917091826.2639205-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917091826.2639205-1-fuad.tabba@linux.dev>
References: <20260917091826.2639205-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

Martijn reported a hypervisor crash when providing pKVM with an
undersized PGD allocation. Indeed, although the size of the PGD
allocation at EL2 is not under host control, a smaller host-side
allocation can lead to providing pKVM with a misaligned PGD, which will
cause the guest stage-2 init to fail in a bad way. Specifically,
guest_s2_zalloc_pages_exact() expects a successful allocation from
hyp_alloc_pages(), which can only happen if the pool has been pre-filled
with a physically aligned high-order page.

In order to guarantee allocation success in this path, check the
host-provided PGD alignment early on.

Fixes: a1ec5c70d3f6 ("KVM: arm64: Add infrastructure to create and track pKVM instances at EL2")
Reported-by: Martijn Bogaard <martijnbogaard@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
[Fuad: rejected with -EINVAL before any donation is mapped, as the
 other input checks in __pkvm_init_vm() do]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c        | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 39aa8911f62c1..805dade1d4510 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -186,7 +186,7 @@ static void *guest_s2_zalloc_pages_exact(size_t size)
 {
 	void *addr = hyp_alloc_pages(&current_vm->pool, get_order(size));
 
-	WARN_ON(size != (PAGE_SIZE << get_order(size)));
+	WARN_ON(!addr || size != (PAGE_SIZE << get_order(size)));
 	hyp_split_page(hyp_virt_to_page(addr));
 
 	return addr;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4bc..3770315b50361 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -846,6 +846,10 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 
 	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
 	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
+	if (!IS_ALIGNED(pgd_hva, pgd_size)) {
+		ret = -EINVAL;
+		goto err_unpin_kvm;
+	}
 
 	ret = -ENOMEM;
 
-- 
2.39.5

