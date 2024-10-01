Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D7F645
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 00:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727741847; cv=none; b=dWotfW2zmbChXdOZs+rHwCkAlGn6oCeV8b6Q5TxVGpRXCXa3D0g5I1Hul4ZF0uTUnG8z1SY+vXVwVBqI/E5Gv2yRFI8rmV/hB2Onb7wTqAKc05lRfAXJzY7VVoXcteAYMapfBQtSMQ8igys05MisyW6vpl8srG8TZ3my+fjzIQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727741847; c=relaxed/simple;
	bh=4g8aUb0ZK29koBByoyOmIBKY7jmLr/W2F/f26J/2wTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv5FNDFDBINwwdC+CUU5tRO9ZcjXYZvVan4sRAaIXqchNyav3umrtgKXHHBEsQz21LfvC4GIibpshFhpou9+N2IQz1P2NGLlYHKs6MOP5AzMXkjVWt5q2yrlM8peG7zsS8r98r2MVeHpx7DIMC6/5vR3vG5eXS7vZoPcPI8YGmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rD2QzsKr; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rD2QzsKr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727741843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/OOv/+kWYut5sQwvgbK8l1vqAQOaV6gnpjjgOneG8EE=;
	b=rD2QzsKr10s/wROL9mh3Lk+nZclyJES6VfrNJnoKl74dg8EzBKvTjTLAe1FuTfl20+tbSX
	Ryz02yvDYQtE5fyMXWE95TciCq7I64UBH2YwGBZAQxMBBd5t2pzjNMbqimsJEFVJbQU6QM
	ixH4cyUsqlyqveBzqyNZnzgRNCDqUl4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/3] KVM: arm64: nv: Do not block when unmapping stage-2 if disallowed
Date: Tue,  1 Oct 2024 00:17:08 +0000
Message-ID: <20241001001709.1303668-3-oliver.upton@linux.dev>
In-Reply-To: <20241001001709.1303668-1-oliver.upton@linux.dev>
References: <20241001001709.1303668-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Right now the nested code allows unmap operations on a shadow stage-2 to
block unconditionally. This is wrong in a couple places, such as a
non-blocking MMU notifier or on the back of a sched_in() notifier as
part of shadow MMU recycling.

Carry through whether or not blocking is allowed to
kvm_pgtable_stage2_unmap(). This 'fixes' an issue where stage-2 MMU
reclaim would precipitate a stack overflow from a pile of vcpu_load()
calls, all trying to recycle a stage-2 MMU.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_mmu.h    |  3 ++-
 arch/arm64/include/asm/kvm_nested.h |  2 +-
 arch/arm64/kvm/mmu.c                | 15 ++++++++-------
 arch/arm64/kvm/nested.c             |  6 +++---
 arch/arm64/kvm/sys_regs.c           |  6 +++---
 5 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a6379ca1b0d7..a9a3225c9f75 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -166,7 +166,8 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
 void __init free_hyp_pgds(void);
 
-void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
+void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
+			    u64 size, bool may_block);
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index e8bc6d67aba2..e74b90dcfac4 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -124,7 +124,7 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 extern void kvm_nested_s2_wp(struct kvm *kvm);
-extern void kvm_nested_s2_unmap(struct kvm *kvm);
+extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 
 unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 800cf3e7ecae..02275854c288 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -328,9 +328,10 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 				   may_block));
 }
 
-void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
+void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
+			    u64 size, bool may_block)
 {
-	__unmap_stage2_range(mmu, start, size, true);
+	__unmap_stage2_range(mmu, start, size, may_block);
 }
 
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
@@ -1015,7 +1016,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
+			kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, vm_end - vm_start, true);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -1042,7 +1043,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
-	kvm_nested_s2_unmap(kvm);
+	kvm_nested_s2_unmap(kvm, true);
 
 	write_unlock(&kvm->mmu_lock);
 	mmap_read_unlock(current->mm);
@@ -1915,7 +1916,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
 
-	kvm_nested_s2_unmap(kvm);
+	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
 }
 
@@ -2182,8 +2183,8 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size);
-	kvm_nested_s2_unmap(kvm);
+	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
+	kvm_nested_s2_unmap(kvm, true);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c5b61415b852..1ba211541290 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -634,7 +634,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 
 	/* Clear the old state */
 	if (kvm_s2_mmu_valid(s2_mmu))
-		kvm_stage2_unmap_range(s2_mmu, 0, kvm_phys_size(s2_mmu));
+		kvm_stage2_unmap_range(s2_mmu, 0, kvm_phys_size(s2_mmu), false);
 
 	/*
 	 * The virtual VMID (modulo CnP) will be used as a key when matching
@@ -732,7 +732,7 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 	}
 }
 
-void kvm_nested_s2_unmap(struct kvm *kvm)
+void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 {
 	int i;
 
@@ -742,7 +742,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm)
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu));
+			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 	}
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dad88e31f953..e0c7cc16466e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2903,7 +2903,7 @@ static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 * Drop all shadow S2s, resulting in S1/S2 TLBIs for each of the
 	 * corresponding VMIDs.
 	 */
-	kvm_nested_s2_unmap(vcpu->kvm);
+	kvm_nested_s2_unmap(vcpu->kvm, true);
 
 	write_unlock(&vcpu->kvm->mmu_lock);
 
@@ -2955,7 +2955,7 @@ union tlbi_info {
 static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
 			       const union tlbi_info *info)
 {
-	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size);
+	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true);
 }
 
 static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
@@ -3050,7 +3050,7 @@ static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
 	max_size = compute_tlb_inval_range(mmu, info->ipa.addr);
 	base_addr &= ~(max_size - 1);
 
-	kvm_stage2_unmap_range(mmu, base_addr, max_size);
+	kvm_stage2_unmap_range(mmu, base_addr, max_size, true);
 }
 
 static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-- 
2.46.1.824.gd892dcdcdd-goog

