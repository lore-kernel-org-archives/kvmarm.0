Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A743375AB
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527786; cv=none; b=RHm7BVC5cR7FX0HV75qjQf2MMTR/NYPxlRWtABEI5hWG5IIG+CTkPGYdE2PauLTYRfLkpR7wFHRXUDeTjPJ6K3inhpR6u6VLI9/25bOfdTJ0IqGYY/gh3Jp7coFFzJ56EZpLiZSWqOZf79fB+XAStr8dTOtDT2i6SmGr365CYCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527786; c=relaxed/simple;
	bh=YLrPv7rhUBCHhFgwGgPEWK/lsDTRMk9omx7U/VCyIj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AY2dUqBSOz22el6nQ5B9PWVqXLCpUyqDNoLkS5aPxIQacHX3O/1S6wx6oIbdhwqNJwQcZendm3q2ExWan27pWv1dYN/xtAVclHA/Znr5FuY9QhNnqEeTtWC3Wnl7O3t7DY5+SOJLj0kZNFL3Bo4IjTSaLmPh0z/+n8h8TbOIJfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ct3H6ePi; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ct3H6ePi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757527781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VUPfYyVXCglNp6ovY4cVZKUV53QWACTuU0KR3Evt0YI=;
	b=Ct3H6ePi2w0FFejgXVkgivGTv7nY8KIkfn6hCXXh6fdzvzuHjtnLMyrch8vK3wsHZ1/f5a
	nwl2DKpzu9FfzXx1fwPBn62UJ9P8X6X1bAxUCQbyRsmWcjT+51IXFaSKTTQO/d+Ap7/0bz
	M5NPx45JtFN0iOTBng3LjLSGzXp15Rg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] Revert "KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables"
Date: Wed, 10 Sep 2025 11:09:28 -0700
Message-Id: <20250910180930.3679473-2-oliver.upton@linux.dev>
In-Reply-To: <20250910180930.3679473-1-oliver.upton@linux.dev>
References: <20250910180930.3679473-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This reverts commit e9abe311f35631a999fe38c86f26f0e48ffe46d5.

syzkaller has managed to tease out multiple bugs in this change and
fixing-forward didn't remedy the situation. Considering newly-introduced
memory safety issues the potential for scheduler stalls don't seem that
bad in comparison

Link: https://lore.kernel.org/kvmarm/68c09802.050a0220.3c6139.000d.GAE@google.com/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/mmu.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 86f3d80daf37..6330a02c8418 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -904,35 +904,11 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	return 0;
 }
 
-/*
- * Assume that @pgt is valid and unlinked from the KVM MMU to free the
- * page-table without taking the kvm_mmu_lock and without performing any
- * TLB invalidations.
- *
- * Also, the range of addresses can be large enough to cause need_resched
- * warnings, for instance on CONFIG_PREEMPT_NONE kernels. Hence, invoke
- * cond_resched() periodically to prevent hogging the CPU for a long time
- * and schedule something else, if required.
- */
-static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
-				   phys_addr_t end)
-{
-	u64 next;
-
-	do {
-		next = stage2_range_addr_end(addr, end);
-		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
-								next - addr);
-		if (next != end)
-			cond_resched();
-	} while (addr = next, addr != end);
-}
-
 static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
 {
 	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
 
-	stage2_destroy_range(pgt, 0, BIT(ia_bits));
+	KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, 0, BIT(ia_bits));
 	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
 }
 
-- 
2.39.5

