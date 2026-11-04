Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793796296;
	b=y6HiOSIaUeNOHtvGnh06rx7bqc+BI2a8TdYJYddmpaAiMMK2mlo5hL7W5TYoCRz7kqmh
	 YpydZNIzxbW6hAB463LpBFwzbLieg54S9NoYpmXpFOoahQXVcSRiVGXwPMbh6MciBRQNE
	 FHXJ2jA70YK6O8ffYHd7svMt+EiClgjMr+1gycEcws4LHOK/e7IVShN1COxbOBLXRjAJH
	 pkmI5DslVkteYMOV7q92oH9I+NZ3Q2FvJTrTh2tVvu/SKnLkQGmkXmccW0hKW47eNcwOf
	 9bLZw5NaWdxMsqAtgg8/oWU4mLE/x2vRGkk2p8nhNOudYIWkfX1QZhfczrTMPAntmpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793796296;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AOH3Su8TZJSoK9UPHpeuwIAfG494iGEabcz+aB8amog=;
	b=UvCCE8peMG7vrVKju+6AR2CLwxEwgEwzFgwoHp4zTA8OXCR7PVYu7YaCeg+IP5aJCdoZ
	 WY49pocW/OVh+b+2dKoitOoZqs7FXbuTmPtxqA12yjZUu/SP2+5WEbu92I8bpnHtXq0kb
	 Wd6QJSfQMsc+nwsQrU9zqNRveU12PpYolvDeiDVfNiOp21D4u8AF/OeO8VBw84K1pP5vU
	 MM9ea0X6hVOHgKqUsGQy4NA1lyaYA92dPyxOOiKcVACAkCRQFm5g8jfloySGFXnowHthj
	 vl62ufR6MsE4S7BX2LbcN7cCeUyaIT/RkyL6Jl84bqvkIP+8Iw7TTbgH4iyEICJFyVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QylGKXh7;
	arc=none smtp.remote-ip=95.215.58.141
Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51FA606A332
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 12:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E51FA606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QylGKXh7
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=MxRHPNAABvoNmLp9OTJVcSokfGwwqtsziGyV/1PffQk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793796293; v=1; x=1794401093;
 b=QylGKXh7uruaLMMEMoxZ64DR/6WRHSeRr9NW0qyTOuBE10TrPTF2dySKAaKqBH8OXK9T5lgW
 JuVyld+yb+3T7O/1JiDm1nj1jAxQHg1Yx+8Ir/sF6OYZ8nchI3kbHqN0Ed71GeYVXqwp3PGSJvU
 Px8botegn2j4AGcqtjnNkmgM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fec1c38f76d92ee4;
	Wed, 04 Nov 2026 12:44:53 +0000
X-Mizu-Trace-ID: fec1c38f76d92ee4
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
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: Resume stage-2 teardown where the walk stopped
Date: Wed,  4 Nov 2026 12:44:50 +0000
Message-ID: <20261104124451.2148724-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104124451.2148724-1-fuad.tabba@linux.dev>
References: <20261104124451.2148724-1-fuad.tabba@linux.dev>
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
pkvm_pgtable_stage2_destroy_range() returns the end of its range, and
EL2's kvm_pgtable_stage2_destroy() ignores the value.

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++--
 arch/arm64/include/asm/kvm_pkvm.h    |  4 ++--
 arch/arm64/kvm/hyp/pgtable.c         | 15 ++++++++++++---
 arch/arm64/kvm/mmu.c                 |  4 ++--
 arch/arm64/kvm/pkvm.c                |  8 +++++---
 5 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1c9c57cd6ae40..20b988e99e074 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -599,9 +599,13 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  *
  * The page-table is assumed to be unreachable by any hardware walkers prior
  * to freeing and therefore no TLB invalidation is performed.
+ *
+ * Return: the address the walk reached, which can be past @addr + @size
+ * when the range ends within a block or an invalid entry, or @addr + @size
+ * if the walk fails.
  */
-void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size);
+u64 kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				     u64 addr, u64 size);
 
 /**
  * kvm_pgtable_stage2_destroy_pgd() - Destroy the PGD of guest stage-2 page-table.
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fd042d2b54624..731632aa24520 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -349,8 +349,8 @@ int __pkvm_handle_smccc_req(struct arm_smccc_res *res);
 
 int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			     struct kvm_pgtable_mm_ops *mm_ops);
-void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size);
+u64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				      u64 addr, u64 size);
 void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
 int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 			    enum kvm_pgtable_prot prot, void *mc,
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b184d3..6bb1c0beb4dcc 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1653,16 +1653,25 @@ static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	}
 }
 
-void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-				       u64 addr, u64 size)
+u64 kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
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
 
-	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
+	if (WARN_ON(_kvm_pgtable_walk(pgt, &data)))
+		return addr + size;
+
+	return data.addr;
 }
 
 void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db73..4f1adadeffb8b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1011,8 +1011,8 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
 
 	do {
 		next = stage2_range_addr_end(addr, end);
-		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
-							     next - addr);
+		next = KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr, next - addr);
+		next = min(next, end);
 		if (next != end)
 			cond_resched();
 	} while (addr = next, addr != end);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 016997288fd23..f21c3326dda68 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -499,14 +499,14 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
 	return 0;
 }
 
-void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size)
+u64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
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

