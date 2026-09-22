Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C79545DB5
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082515; cv=none; b=E9ON8GfzIHhxjXzxq0jONvJzVosjaeb9FdguQljGDyXeG7/hfB0iGwuypHStP1v5r9Zq6a4LcFnPEI9UXo7fXVPcdKxpY4YL8QnxJaznoZNyV9RpLgB/mZgKoYogt8BMcwXRNRYUmNU84y1RwLyy5AfeM/tTJtatka/jLRPrbrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082515; c=relaxed/simple;
	bh=ofQ1oPhtNYdQIg2drBmsKL5iLxiuc2AiZdhA9y3Ej3k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kOsLpZVDDCZFXOWgtohWiypSgfdBqcsvUvsKDrqMzF2QUiXciJ/IlPkJSUV7cNIj4y7JCv4A0BYLD4Fpj/BraTWlJQauCeml03LRnmqRhCs196bmyd23e11oo4yjMdQAkKBw6P1gHFYoCQvAmzJ5CRMMudm3gdb4s2UYNLiz3e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tUtffjNR; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tUtffjNR"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e735659b7so33294145e9.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082512; x=1790687312; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hRT4LKrWmlIEgB+8kAa2SxHNKz3rcwa3j5wHsFjjrzo=;
        b=tUtffjNRrYPDHpkCBq2wtUu+fdveuBMBvp1aA3SDstLl6RGTukmj78b2JyqEit8yKr
         7XOsYyKIbAuSO1R6Si/N2TO7eEaFuslAQqj63oRkMau2tAQRf0otWCnvKGaX1n0xGXXC
         BLQzr3et9Ea9MVfbxL5DyXGm705uIzi7TV7bnzaidQ7KpeMbhdwe1i0FszfHJ1x+vhYt
         LncXdaMV6j8bEIaH82INq8Z3R5LH00WwYUNnek30W09m0WRrR+Ki336nTsTuOK+0NqV9
         s2K3nGOEbNpKN6vA1LfItSgTsexzVLqVepP9R3KwY6IdxXfpbdEuwwHW/ADeRWWsHH71
         NJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082512; x=1790687312;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hRT4LKrWmlIEgB+8kAa2SxHNKz3rcwa3j5wHsFjjrzo=;
        b=QaieDLLqeTNkluqrlXlN1ku+iDs8khcnHohhry2KSRnmPNbYFr13bd2+wzXNc/vjAg
         bV9lUvZ6RL69SjpQpuhMfh+pZMR8LBiQLeOJvd/GacDx5bdu96sUIZlY42bEhCuxCN4K
         3DBRpX1X2LqRNwpMCjD2W9js/RkPQ6GiulU8qfgqJYJNvqDHNLGBrD2WaGzgA/K2qufP
         zUm0wlStmahh/vn53M0OcIM3mn2Jarae+nNWrk+uzEO/gBEjNRTdhNA8nEwuP3Jls/rI
         SPbKynuGOgopRC8ByDAgDQlH76xlIAb/W1SpCSPiJJDDd0pVjuZoR6KyNlb1FFTRM8a8
         SLBw==
X-Forwarded-Encrypted: i=1; AKwUvByNwlEAMK+zJ4wtUs5+Z4UJOUV47lxyBbpup9kTUR6UK29GUlw+DrPbhfvLRXKZtP8Vjzz7cBc=@lists.linux.dev
X-Gm-Message-State: AFuF++knFehUVf9uC8CeyrhLVaLH2aDHq2dlXZzztxHLUgmcglU6vNCY
	9T0zC7hJBCxxhv35CSI+o263uZCQFQ0eEEfNy7C1rCM5PFc9u1qjxndjnIRWzZmIZgvNoLDjxY7
	2KsZ1Kw4d9DValkhLYQ3Xbg==
X-Received: from wmbgv5.prod.google.com ([2002:a05:600c:80c5:b0:49e:6a1d:16af])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e24:b0:49c:fc6e:a3d2 with SMTP id 5b1f17b1804b1-49fc574f74bmr191646085e9.17.1790082511588;
 Tue, 22 Sep 2026 06:08:31 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:08:20 +0100
In-Reply-To: <20260922130821.1666713-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922130821.1666713-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922130821.1666713-6-vdonnefort@google.com>
Subject: [PATCH v1 5/6] KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <fuad.tabba@linux.dev>

gmem_abort() maps at s2fd->fault_ipa, which HPFAR_EL2 holds at 4K
granularity whatever the page size. The generic page-table code aligns
it, but pkvm_pgtable_stage2_map() looks up existing mappings over
[addr, addr + size), so on a pKVM host with pages larger than 4K a
guest_memfd-backed guest that faults past the first 4K of a page can
find its neighbour's mapping, get -EAGAIN and take the same fault
forever.

Take the addresses from kvm_s2_fault_vma_info instead, as
user_mem_abort() does, and report the gfn kvm_gmem_get_pfn() failed on
in the memory fault exit. kvm_s2_fault_get_vma_info() itself isn't
called: a guest_memfd memslot's userspace_addr doesn't need to be
backed by a VMA.

Fixes: a7b57e0995927 ("KVM: arm64: Handle guest_memfd-backed guest page faults")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260913175105.A57AC1F000FF@smtp.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5aac624b0442..ee0fcca838c1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1953,11 +1953,9 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
-	unsigned long mmu_seq;
-	struct page *page;
+	struct kvm_s2_fault_vma_info s2vi = {};
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	void *memcache = NULL;
-	kvm_pfn_t pfn;
 	gfn_t gfn;
 	int ret;
 
@@ -1968,23 +1966,22 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 			return ret;
 	}
 
-	if (s2fd->nested)
-		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
-	else
-		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
+	s2vi.vma_pagesize = PAGE_SIZE;
+	s2vi.gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi.vma_pagesize) >> PAGE_SHIFT;
+	gfn = get_canonical_gfn(s2fd, &s2vi);
 
 	write_fault = kvm_is_write_fault(s2fd->vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
 
 	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
-	mmu_seq = kvm->mmu_invalidate_seq;
+	s2vi.mmu_seq = kvm->mmu_invalidate_seq;
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &s2vi.pfn, &s2vi.page, NULL);
 	if (ret) {
-		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
+		kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(gfn), s2vi.vma_pagesize,
 					      write_fault, exec_fault, false);
 		return ret;
 	}
@@ -2002,7 +1999,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
 
 	kvm_fault_lock(kvm);
-	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+	if (mmu_invalidate_retry(kvm, s2vi.mmu_seq)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -2013,16 +2010,17 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		 * PTE, which will be preserved.
 		 */
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(s2vi.gfn),
 								 prot, flags);
 	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
-							 __pfn_to_phys(pfn), prot,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(s2vi.gfn),
+							 s2vi.vma_pagesize,
+							 __pfn_to_phys(s2vi.pfn), prot,
 							 memcache, flags);
 	}
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
+	kvm_release_faultin_page(kvm, s2vi.page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);
 
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
-- 
2.55.0.1082.g2b9226bbc0-goog

