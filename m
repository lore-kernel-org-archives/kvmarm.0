Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D0D185E4D
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038073; cv=none; b=AnHajiw4ufjazSpnmjK/LFILky8K4YLG58lnGRBxpOa5v0F7UYJdn2W2G0X7IK3MN95aziewxysBVPbFWTm0iBW3K25ZEAMnSDbK7PVbO/c/fdws/5ZgyrAJAr9ROrN+q3Kd1wMCiatW1H73s93tUhv6n6V5NUHEh5+Qw7+WFn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038073; c=relaxed/simple;
	bh=+aOTq/dN+ZtKhcKidsUn1n9XU82CWPIY26uxDS8eRrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UzZpGbKWhhjIpvieavS/6ECbnktk46F8CfGTql0aE7Y3XtP8u7uZIbCY6pNgaWRtxlSmU116pCSK5h8vro7zrmDMfgFGTT/wxylO9objz1C924fzToX0Fcf/7kj2KTjnaeBjNGDp78mgMai4PcWD+I3oMVH01M7G4N+gELU8LEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kvAh6E7/; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kvAh6E7/"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70e9ea89b42so1344309b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038071; x=1722642871; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=caIg6eZHDZieCZ2y8TnIGsflH+xvFOT1i8qMSVM8X2U=;
        b=kvAh6E7/oNdPdw+ZZiTiv3QeL+porMFLobjNyKKQNiBZcaTfmbkw/VqpbjILRXcWqz
         gBg0WPHiY8gfLqXvzSk5v3HaU8d9zukRfVU5PFyFtCH0zembUc9rGCPLMsJTYLxQHcYX
         vQb/oxLbvv1L+rPjqKYuNBvQ90kHCXjVtuRATEfsM++vjFPYdn+hNRcyvH9YqPrVt5Fe
         BYK88xYvrWnM9VImlScR49vv6XcvpRKH5L2Psd0DHgPiC9ITXy8g9grHVfFS2BeTsXoT
         pxRfdp6Xxhtxc4xO98OCV3iQcJOpmrPuN7MGrYiESTDuVh7Xyu4akaNcLgVH9cgM7QBI
         Zk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038071; x=1722642871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=caIg6eZHDZieCZ2y8TnIGsflH+xvFOT1i8qMSVM8X2U=;
        b=vNXvBV4Xvzq9psYkEKmo7R1JbYUyhO+Qy+j07NOh6g8paGyYIe7eQrHxr6g5a1pA0N
         Zjyl5r+atXB8Yj00jHIdPsL0WptBZIP1QsOe6WWHvnkciQDkGFII5qoXuA/ddj3xdSeY
         9Fhk/THdDHcPLDzGUh38uOOBtYX3gfQqUnu4t+Zor82kjly724vun4lDm5CdNa7KKOcW
         4S5WL4HbzDQeoXnSsWb1W0w1H2usWQMehvhT5jT6kYTpqr5sEAlLdNrwosVyiIWPNMYP
         W7GtxWdfSkmSMyhwtyHKGS7qEcJpH8rVBw2IomxWgiwYNTLx+MhpWizODBu5N3I+PHn4
         JDcA==
X-Forwarded-Encrypted: i=1; AJvYcCXMEIHCjkwd5WtDTaGSqV8vLs/z1gH1/lxD4It8BbksOOYMZmFeNYffcYgZatW2IFKiX1fqEZtD4WK2gX4dWYGbC92OrNHw
X-Gm-Message-State: AOJu0YztfzAjdngMfDfy6gYPByxrfzM25OMfU0z+yvXLYwc/zp5xP7ji
	7FXbXwZBU5erawtIqwHs81BIEfQt7lTOIkX0f0kWAAV79dcuhDSd+c1NX36asgkvhC3uanUDTVn
	Wgg==
X-Google-Smtp-Source: AGHT+IFCpL56eroYNOyLiVhUcT5fyuFzA98b59p62FwWY/A7pZmePwqTF4FXfEto2ywMz9XC9lExu2Xr4CM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9445:b0:706:3421:740d with SMTP id
 d2e1a72fcca58-70ece9ecf02mr25759b3a.1.1722038071004; Fri, 26 Jul 2024
 16:54:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:04 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-56-seanjc@google.com>
Subject: [PATCH v12 55/84] KVM: arm64: Use __kvm_faultin_pfn() to handle
 memory aborts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Convert arm64 to use __kvm_faultin_pfn()+kvm_release_faultin_page().
Three down, six to go.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ce13c3d884d5..756fc856ab44 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1439,6 +1439,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	struct page *page;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1553,7 +1554,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or __gfn_to_pfn_memslot() become stale prior to
+	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
 	 * acquiring kvm->mmu_lock.
 	 *
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
@@ -1562,8 +1563,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable);
+	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -1576,7 +1577,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * If the page was identified as device early by looking at
 		 * the VMA flags, vma_pagesize is already representing the
 		 * largest quantity we can map.  If instead it was mapped
-		 * via gfn_to_pfn_prot(), vma_pagesize is set to PAGE_SIZE
+		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
 		 * and must not be upgraded.
 		 *
 		 * In both cases, we don't let transparent_hugepage_adjust()
@@ -1685,11 +1686,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	if (writable && !ret)
-		kvm_set_pfn_dirty(pfn);
-	else
-		kvm_release_pfn_clean(pfn);
-
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
 	read_unlock(&kvm->mmu_lock);
 
 	/* Mark the page dirty only if the fault is handled successfully */
-- 
2.46.0.rc1.232.g9752f9e123-goog

