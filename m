Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9055B2F3604
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810075; cv=none; b=evtwZ5Ais5AFmZ70R1JqNo2yiXrPSTX8BAQJRpX8eCLi00gybTfpxCfLPciazc5lRKRYqOoa2/AlIHT7WJTUJ2cCfmmn7xdcD1urm/4HVeztogEFvht+ji9zTwRzki6yRb2F0feQ+EqTmhllGREDnrIdNcN4IzBMPTRriSCsrvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810075; c=relaxed/simple;
	bh=wzbsuKcJ4wvLXzApjrI6i7l0No25qC4BNkAFtcIBLxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e7gjEyKsXPhn7C32X/yU6zqsqBVSbbQcLZHYCuv4YnIQjQpX73c90S7AWr4pFeKk1YjekVZRshnhICZe27vLuuxIlUn/llvFPJzBGg3s32T9RKgEE/AaRN5H9FQkD/KKbae5Yn+e6alotFr5L8xLxLw7IgRe5zmlmTMmmtdDWTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lm+y7hnW; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lm+y7hnW"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4716fa1e59so1158143a12.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810071; x=1756414871; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WFOpvpsT1MnunRLl4T+BHRi0vN/i3KJyyI1xXmPrPlw=;
        b=Lm+y7hnWC5vgOCxMmcNJPLK3zIejTYJjOevsfqa+4M7exZHaBbSjxMOpfp0x5Wy5xC
         buhIPPcUhQxKBh/P5PMrIq16hnbZ2ghbhCuEyL/FWNtGWUDUu4RaS3FvJrs9F5LdvGB5
         0HVYMZQIobTSceHIPaQrk0p5sR2aLJh5kDu1TT6mLcpW3llByFbcFqrgVJKoPo9c8wYN
         4MNuSvbPuikhVloxYOTBc/vk1sn8yDwPLRSdofRMi6FX8+NdHxF19V1RBnY0JWlTza1j
         6P6tx0fND8op7FoGxDxtyW/Mw4aBoSP4pK0HXjfFvgeP5y3/pYF8CexMTH8PBJ8GKssS
         ruig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810071; x=1756414871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFOpvpsT1MnunRLl4T+BHRi0vN/i3KJyyI1xXmPrPlw=;
        b=TYXSkM1kDGoHMxveZg5StlRDOsMnv9H9sfA1BkkfGgZhSN5mbJA2E4GIJDVtymSsh/
         wuSfVuxQZewkDB3PQyVcHX7S3izse5hzqyieXjwBMZRBaMGMZAwn3w08GqtjlLLFTSMq
         ayeQp7QkRt68nY+NqFBxFRfjW3IYBsOfmXk9WYup30Wzy/O58U4wVu026qLZN5SWPK0t
         7Cj4D468sfrggQ5owEui2/ewTglPcCM41b3TvtkYdlCwcRhN4Cy2kyWBlufKohcmmXC5
         2+MgJ6V+BBnMYBRBgIxpI5QgncVcSZ9T9HnSOUBmwEjT4TbEigNE1fCdVcQ+thr7MPjx
         SLjg==
X-Forwarded-Encrypted: i=1; AJvYcCV4VQKcAOj6if1sa2EtkYY7LCPBI0QkdqGd4BJsM/mi8xVcvFxgsZ/a7OKyfaN2UMXQ0+DosWg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJCEFp0/McTTreB1zz+puKOHFdM4aCveVZ3oQXC2f25DC7K2fJ
	/MYesuSO9c75jWwLdbNdMWGCbV9Y93/oJcb+NqpOw1ERZyJbBEmac9OHNdrnnThZKlYOFHE8N5g
	XcDHjqQ==
X-Google-Smtp-Source: AGHT+IH2D5yvxXbQMYKp9CQ1/YsbKvTYEoUYMROb+eewLnOLV2mjTAu7kJckUk9DqMy3wtdy3hZnzxFFxu8=
X-Received: from pghz18.prod.google.com ([2002:a63:e112:0:b0:b42:8a4c:7b14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2446:b0:240:1fb6:d335
 with SMTP id adf61e73a8af0-24340db0419mr735886637.37.1755810071501; Thu, 21
 Aug 2025 14:01:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:41 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-16-seanjc@google.com>
Subject: [RFC PATCH 15/16] KVM: arm64: Extract mmap_lock-protected code to
 helper for user mem aborts
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Factor out the mmap_lock-protected portion of user_mem_abort() to a new
helper, partly to make user_mem_abort() easier to follow, but mostly so
that the scope of the mmap_lock-protected code is more explicitly bounded.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 96 ++++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fec3a6aeabd0..ea326d66f027 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1466,47 +1466,10 @@ static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
 	}
 }
 
-static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_gather_fault_vma_info(struct kvm_vcpu *vcpu,
+				     struct kvm_page_fault *fault)
 {
-	int ret = 0;
-	bool writable;
-	struct kvm *kvm = vcpu->kvm;
 	struct vm_area_struct *vma;
-	void *memcache;
-	bool logging_active = memslot_is_logging(fault->slot);
-	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
-	struct kvm_pgtable *pgt;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
-
-	VM_BUG_ON(fault->write && fault->exec);
-
-	if (fault->is_perm && !fault->write && !fault->exec) {
-		kvm_err("Unexpected L2 read permission error\n");
-		return -EFAULT;
-	}
-
-	if (!is_protected_kvm_enabled())
-		memcache = &vcpu->arch.mmu_page_cache;
-	else
-		memcache = &vcpu->arch.pkvm_memcache;
-
-	/*
-	 * Permission faults just need to update the existing leaf entry,
-	 * and so normally don't require allocations from the memcache. The
-	 * only exception to this is when dirty logging is enabled at runtime
-	 * and a write fault needs to collapse a block entry into a table.
-	 */
-	if (!fault->is_perm || (logging_active && fault->write)) {
-		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
-
-		if (!is_protected_kvm_enabled())
-			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
-		else
-			ret = topup_hyp_memcache(memcache, min_pages);
-
-		if (ret)
-			return ret;
-	}
 
 	/*
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
@@ -1520,11 +1483,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return -EFAULT;
 	}
 
-	/*
-	 * logging_active is guaranteed to never be true for VM_PFNMAP
-	 * memslots.
-	 */
-	if (logging_active) {
+	/* Logging is guaranteed to never be active for VM_PFNMAP memslots. */
+	if (memslot_is_logging(fault->slot)) {
 		fault->force_pte = true;
 		fault->vma.pageshift = PAGE_SHIFT;
 	} else {
@@ -1613,6 +1573,54 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	return 0;
+}
+
+static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	int ret = 0;
+	bool writable;
+	struct kvm *kvm = vcpu->kvm;
+	void *memcache;
+	bool logging_active = memslot_is_logging(fault->slot);
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	struct kvm_pgtable *pgt;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+
+	VM_BUG_ON(fault->write && fault->exec);
+
+	if (fault->is_perm && !fault->write && !fault->exec) {
+		kvm_err("Unexpected L2 read permission error\n");
+		return -EFAULT;
+	}
+
+	if (!is_protected_kvm_enabled())
+		memcache = &vcpu->arch.mmu_page_cache;
+	else
+		memcache = &vcpu->arch.pkvm_memcache;
+
+	/*
+	 * Permission faults just need to update the existing leaf entry,
+	 * and so normally don't require allocations from the memcache. The
+	 * only exception to this is when dirty logging is enabled at runtime
+	 * and a write fault needs to collapse a block entry into a table.
+	 */
+	if (!fault->is_perm || (logging_active && fault->write)) {
+		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
+
+		if (!is_protected_kvm_enabled())
+			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
+		else
+			ret = topup_hyp_memcache(memcache, min_pages);
+
+		if (ret)
+			return ret;
+	}
+
+	ret = kvm_gather_fault_vma_info(vcpu, fault);
+	if (ret)
+		return ret;
+
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn,
 				       fault->write ? FOLL_WRITE : 0,
 				       &writable, &fault->page);
-- 
2.51.0.261.g7ce5a0a67e-goog

