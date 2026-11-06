Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.94
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793971808;
	b=Ih0iwYfdOSm9Y/b2AhpzlUPpg/m6ANnTrcun9iON4W8XwZhSD61wn5Dh97vLEGpdYGZW
	 ZINHyfDHRy2/wjkBXs3Z3mzLeUBRotgi5fYI7/MmHqqs04dUhNcIAllZYFZNuc+EEUsNE
	 QI1gZXDEWy2ytMudXoV8vvXFHYDLmyJCHM/KuwJ3Z/oOxRZvajEMvOoW0Q7I1MGmFPkj8
	 lY7JbNcL/6wiWVv4rsCjqt+mWk95k/EPNLE/ysIWcMWo5XYL68uIakziqeU++9UbJauJ4
	 hdbSPQ6NMks+t9P+++8okYhYQtvJoZF2d9kjxh/kjlt1JSSx1LTIBeXth9iSUbyHsWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793971808;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nChgFP7Zug4DxELreyjciF6D70tMQtD0xbbb+J5QLbE=;
	b=exQngajfsMUgVZlbz5OkonyZXy1qIJJMVJaXQ0Tv5eBFl0kIpHUCgyilVn2HLFz8bvxB
	 z1hm7Gv+yrlrq2v52ssBrhECyFnSFVsYPD6ZVIpd7psnj0QRdDL+iDawMDMc9FnozbR0V
	 dRUixucWkcFVbv2TU0qB3Kot2bW+9NAMTlGp21CUDL27MHiWEYxzMe90yd5Eev5yAqnID
	 JwGqT9/Lmpi/wQ3PLkJTxcEuKSwS6Q8D6Nipqobd7o0I01poqH5WoTYSlUZZOkKfRm4zm
	 sni86Z1cVC+Rf+lMzHlkQlmcZ5ePvS5YWaAaRycyO6h9VKxVOxRwN5H+y0758QGa81A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jp0iRFjR;
	arc=none smtp.remote-ip=91.218.175.94
Received: from mta0.migadu.com (out-94.mta0.migadu.com [91.218.175.94])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8508606D801
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 13:30:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8508606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jp0iRFjR
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ok/B0BRR1DxBjJDHlW9S+C61DNS/JMD+2uYdPWi7sl0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971804; v=1; x=1794576604;
 b=jp0iRFjRFlAFv8nlLtO+McWsSiUnsIwJ9gE9BjVvmEkQ/BGyLQZoLP7qh7hs8A25rzNH5T3S
 MDWvYxcIEuqsZfPhvn2hTFPUq+S9rvqkYb50PWQFHKmAiaMbs8JozEWu/v5fKCaiLSiMwdYGcOF
 EMhHKTgt5lOi/16Bm00SpVuY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0e491b9c63b601d3;
	Fri, 06 Nov 2026 13:30:04 +0000
X-Mizu-Trace-ID: 0e491b9c63b601d3
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 1/2] KVM: arm64: Resume stage-2 teardown where the walk stopped
Date: Fri,  6 Nov 2026 13:29:59 +0000
Message-ID: <20261106133000.453240-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106133000.453240-1-fuad.tabba@linux.dev>
References: <20261106133000.453240-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 4ddfab5436b6 ("KVM: arm64: Reschedule as needed when
destroying the stage-2 page-tables"), kvm_stage2_destroy() walks the
IPA space one block-sized chunk at a time. The walker steps over an
invalid entry in one go, but the next walk starts at the following
chunk, so an invalid entry larger than a chunk is visited once for every
chunk it covers. Destroying a VM with a 52-bit IPA then takes 2^27 walks
with 16K pages (2^22 with 4K), however little it maps.

Have kvm_pgtable_stage2_destroy_range() return the address its walk
reached, which kvm_pgtable_walk() doesn't expose, and resume from there.
A failed walk returns its error instead, and the callers warn about it
as the walk used to. stage2_destroy_range() then goes on to the next
chunk, as before. pkvm_pgtable_stage2_destroy_range() returns the end of
its range.

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++--
 arch/arm64/include/asm/kvm_pkvm.h    |  4 ++--
 arch/arm64/kvm/hyp/pgtable.c         | 19 +++++++++++++++----
 arch/arm64/kvm/mmu.c                 |  6 ++++--
 arch/arm64/kvm/pkvm.c                |  8 +++++---
 5 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1c9c57cd6ae40..41b137d39a5bb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -599,9 +599,13 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  *
  * The page-table is assumed to be unreachable by any hardware walkers prior
  * to freeing and therefore no TLB invalidation is performed.
+ *
+ * Return: the address the walk reached, which can be past @addr + @size
+ * when the range ends within a block or an invalid entry, or a negative
+ * error code on failure.
  */
-void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size);
+s64 kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				     u64 addr, u64 size);
 
 /**
  * kvm_pgtable_stage2_destroy_pgd() - Destroy the PGD of guest stage-2 page-table.
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fd042d2b54624..971ab6c0380de 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -349,8 +349,8 @@ int __pkvm_handle_smccc_req(struct arm_smccc_res *res);
 
 int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			     struct kvm_pgtable_mm_ops *mm_ops);
-void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size);
+s64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				      u64 addr, u64 size);
 void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
 int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 			    enum kvm_pgtable_prot prot, void *mc,
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b184d3..01fc3fc2b6553 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1653,16 +1653,27 @@ static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	}
 }
 
-void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-				       u64 addr, u64 size)
+s64 kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				     u64 addr, u64 size)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
 			  KVM_PGTABLE_WALK_TABLE_POST,
 	};
+	struct kvm_pgtable_walk_data data = {
+		.walker	= &walker,
+		.start	= addr,
+		.addr	= addr,
+		.end	= addr + size,
+	};
+	int ret;
 
-	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
+	ret = _kvm_pgtable_walk(pgt, &data);
+	if (ret)
+		return ret;
+
+	return data.addr;
 }
 
 void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
@@ -1681,7 +1692,7 @@ void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
 
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 {
-	kvm_pgtable_stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
+	WARN_ON(kvm_pgtable_stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits)) < 0);
 	kvm_pgtable_stage2_destroy_pgd(pgt);
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db73..372a1c04d3c47 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1008,11 +1008,13 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
 				   phys_addr_t end)
 {
 	u64 next;
+	s64 ret;
 
 	do {
 		next = stage2_range_addr_end(addr, end);
-		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
-							     next - addr);
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr, next - addr);
+		if (!WARN_ON(ret < 0))
+			next = min_t(u64, ret, end);
 		if (next != end)
 			cond_resched();
 	} while (addr = next, addr != end);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 016997288fd23..d0a6308008512 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -499,14 +499,14 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
 	return 0;
 }
 
-void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size)
+s64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				      u64 addr, u64 size)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	pkvm_handle_t handle = kvm->arch.pkvm.handle;
 
 	if (!handle)
-		return;
+		return addr + size;
 
 	if (pkvm_hyp_vm_is_created(kvm) && !kvm->arch.pkvm.is_dying) {
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_start_teardown_vm, handle));
@@ -517,6 +517,8 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
 	else
 		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
+
+	return addr + size;
 }
 
 void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
-- 
2.47.3

