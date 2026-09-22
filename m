Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA85542EE6
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082514; cv=none; b=BE5z33gekSr/k1bijMSWva4/y1vEl4zdJ49PGMAZD4fDEe/GUAjbmz8rWxuWtoZGcuIcZRXtMOjEIgZU3nJ2VhwI+ZOowlz1f8wzCaWEe9wp1DPVmxPOJZjLLdmATC1mBoKiW1lUTcKttf+Ae8ogjY9Bwq6hSd9wgaITnUEJQe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082514; c=relaxed/simple;
	bh=PlCDbEwl5BctPEBC7xZPKx79cUQZC+KCLYRgOvgkXkM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cXcDzP9MeIEhqG4BXQTLKGoir8v4wlnirbHMvhxFlD3pN50DR/X2Y9IPMo1KGLwGMG1lBFDVhsdDE1hw8C1hvLvr9HIyWV/hLonDqhSioR0UwhYcoGXO2Ou+fjT/JrsuYuk5ajrK0FjWaQZsXbr5qvdGdoaO/Ia41FQu31Bo9nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kXWL1FdJ; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kXWL1FdJ"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49d0ae342b9so29840985e9.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082510; x=1790687310; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RnwZ0cT1VSP253hz9gmCiW8/GwJgIh7mpYiKx6W5pXA=;
        b=kXWL1FdJNVv/Iu+JETMlSNtweD33RwFU5dcbs8alB2rfVpMFRgfDE+2Hc4BQvjQU0o
         M5O0kedlDjRkNhT7WMvOvCBpCYxVlebejgNX7JoXWCV2WxQtnd9G84KINJWm6DerqxbB
         515LdZa/TyvNs/o6DiZ9V/1lMk+oSnMbpeg/j3/pzscxTppgGgOUa/HwVkXy9xuhv51K
         7lacsPw1TxL5e8QiYjL9+ffw13yY9C3V7IG+uq2zOyhGKUeJdw1rLZ6A3uExGCAUNcLy
         GUxi0SnUkHyfGSMRAN4Ba5Qu6N3NeLUKmOVyoJgj3I1CeVMhm9Gbqwi2GwnKK5zBmLoZ
         JIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082510; x=1790687310;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RnwZ0cT1VSP253hz9gmCiW8/GwJgIh7mpYiKx6W5pXA=;
        b=KrfTvj/u/+o003KIoNBpib0+Be/U9FgIBEsvH+BmFmYm04UTHGYnKUbWd/SfVc3fxn
         TjMghPKpY0lLWXI7mIdLL6bduDRLzhr2f6RevbLGZbouO9hg88qbc+PO+DUNpNGNemLi
         SIHxHlnIxiiOo6z1lV29+xPnRF24ofdBnWsxGwXmWgXYVqJq+2Z9dOLV48IliOE4kSlc
         ls3Z9zGsZNEAtF17NUqYANLBmFq2XsbRmdCdo4MnIYMSbGYi8upii2fmoyPeqXrPfq1H
         1l1/i+WX9bV+iEiBDpefqvDbEDpUzQHFZPR+MRfXscuw1FE6bkGvyJDJ5t6NQLcolt21
         HH9Q==
X-Forwarded-Encrypted: i=1; AKwUvBwAK1sU/Z9v63JoUwDW4ewf+Jt+up5akBl4L23JcnPsb1LnpBzOFnNcvNZJM1gnS0wM2ANU0ao=@lists.linux.dev
X-Gm-Message-State: AFuF++mumI7Ci91i/VUWrOJmixyp61EtSEddzjyl0bV/jvkm7LjrSLk2
	IlFZpz5bUrSbfnY9L3QY/N7GXzgvFk+Z8UrmcmbDjD2WuOUV0VQvpCa7pE6kHuQgsy7SXsihb9R
	skseDY0WtyrVvnk463E1Uqw==
X-Received: from wmix7-n2.prod.google.com ([2002:a05:600c:e547:20b0:49e:602d:8036])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:314a:b0:49f:ce73:7aa with SMTP id 5b1f17b1804b1-49fce730865mr141981295e9.35.1790082510224;
 Tue, 22 Sep 2026 06:08:30 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:08:19 +0100
In-Reply-To: <20260922130821.1666713-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922130821.1666713-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922130821.1666713-5-vdonnefort@google.com>
Subject: [PATCH v1 4/6] KVM: arm64: Move gmem_abort()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <fuad.tabba@linux.dev>

Move gmem_abort() below get_canonical_gfn() so that the next patch can
use it without a forward declaration.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c | 170 +++++++++++++++++++++----------------------
 1 file changed, 85 insertions(+), 85 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 242f63066252..5aac624b0442 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1606,91 +1606,6 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
 	return prot;
 }
 
-static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
-{
-	bool write_fault, exec_fault;
-	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
-	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
-	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
-	unsigned long mmu_seq;
-	struct page *page;
-	struct kvm *kvm = s2fd->vcpu->kvm;
-	void *memcache = NULL;
-	kvm_pfn_t pfn;
-	gfn_t gfn;
-	int ret;
-
-	if (!perm_fault) {
-		memcache = get_mmu_memcache(s2fd->vcpu);
-		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
-		if (ret)
-			return ret;
-	}
-
-	if (s2fd->nested)
-		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
-	else
-		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
-
-	write_fault = kvm_is_write_fault(s2fd->vcpu);
-	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
-
-	VM_WARN_ON_ONCE(write_fault && exec_fault);
-
-	mmu_seq = kvm->mmu_invalidate_seq;
-	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
-	smp_rmb();
-
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
-	if (ret) {
-		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
-					      write_fault, exec_fault, false);
-		return ret;
-	}
-
-	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
-		prot |= KVM_PGTABLE_PROT_W;
-
-	if (s2fd->nested)
-		prot = adjust_nested_fault_perms(s2fd->nested, prot);
-
-	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
-		prot |= KVM_PGTABLE_PROT_X;
-
-	if (s2fd->nested)
-		prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
-
-	kvm_fault_lock(kvm);
-	if (mmu_invalidate_retry(kvm, mmu_seq)) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
-	if (perm_fault) {
-		/*
-		 * Drop the SW bits in favour of those stored in the
-		 * PTE, which will be preserved.
-		 */
-		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
-								 prot, flags);
-	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
-							 __pfn_to_phys(pfn), prot,
-							 memcache, flags);
-	}
-
-out_unlock:
-	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
-	kvm_fault_unlock(kvm);
-
-	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
-		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
-
-	return ret != -EAGAIN ? ret : 0;
-}
-
 struct kvm_s2_fault_vma_info {
 	unsigned long	mmu_seq;
 	long		vma_pagesize;
@@ -2031,6 +1946,91 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	return 0;
 }
 
+static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
+{
+	bool write_fault, exec_fault;
+	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
+	unsigned long mmu_seq;
+	struct page *page;
+	struct kvm *kvm = s2fd->vcpu->kvm;
+	void *memcache = NULL;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int ret;
+
+	if (!perm_fault) {
+		memcache = get_mmu_memcache(s2fd->vcpu);
+		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
+		if (ret)
+			return ret;
+	}
+
+	if (s2fd->nested)
+		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
+	else
+		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
+
+	write_fault = kvm_is_write_fault(s2fd->vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
+
+	VM_WARN_ON_ONCE(write_fault && exec_fault);
+
+	mmu_seq = kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
+					      write_fault, exec_fault, false);
+		return ret;
+	}
+
+	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
+		prot |= KVM_PGTABLE_PROT_W;
+
+	if (s2fd->nested)
+		prot = adjust_nested_fault_perms(s2fd->nested, prot);
+
+	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	if (s2fd->nested)
+		prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
+
+	kvm_fault_lock(kvm);
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	if (perm_fault) {
+		/*
+		 * Drop the SW bits in favour of those stored in the
+		 * PTE, which will be preserved.
+		 */
+		prot &= ~KVM_NV_GUEST_MAP_SZ;
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
+								 prot, flags);
+	} else {
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
+							 __pfn_to_phys(pfn), prot,
+							 memcache, flags);
+	}
+
+out_unlock:
+	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
+	kvm_fault_unlock(kvm);
+
+	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
+		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
-- 
2.55.0.1082.g2b9226bbc0-goog

