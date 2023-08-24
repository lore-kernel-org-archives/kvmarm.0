Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED02E2455E
	for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 08:05:18 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-68bec3a1c0fso571215b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 01:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864318; x=1693469118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g56uEk2MwfqiIQL+ErCF8LkgNo1fm+/UVdRtKRVa5jM=;
        b=ZmfC2H94Cfq7qeuTdK+I523W7JgWVtf0NoVYhxiVkl1g+AhID2EBdD+chl2WsbO4/5
         b91CNyacOnMHohdGF0QhiuUgzViFJIFKuZruOBD5q27lVACYtj3C0Tb/Ezhbnft5wCAA
         HAvNrd3jOIzXBx/YwgBF4lQqE3BpOcApbhbdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864318; x=1693469118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g56uEk2MwfqiIQL+ErCF8LkgNo1fm+/UVdRtKRVa5jM=;
        b=hyWwuXwbly12txCi4YLHshiZMSv+1uKFQYfm7IRUJKlIBJXyXRKUG53Binyvi1qHci
         oDsa4fkxKh9bjwYcZO+4SVkqp4JmmLqtzSlgw+6ScH6ql8rpyRLSZ8c9q4Cpgpt0MDew
         X/hDkOTcg6dAT8gBQq5OCUeVRra6oYpmlh4WWtKl87+nrECckjqMNKhOPhD8s+qcfn+M
         LDbjyx/XodP7Vv/oAvhDi65ljJOhHi9h9mIqnKpjVumEru4m+gfilVDH/59zlmng+QB7
         GH+n7Tqn6tfRvWnKrWYUZex5lcrIEGGV+5zn/MYKoa1y6Bz8NUpXQ6PSzhsXQlFGz05c
         D+lA==
X-Gm-Message-State: AOJu0Yyxalxr4FkKkD9TaUE0HtmrV/1VpTDzPkotySKId8UHCuQBKVCe
	+UbprkSh9orbD9preFn4bTe5+A==
X-Google-Smtp-Source: AGHT+IG5DARchqgjlrYacKLWZkG/gje35tz5DbS9iEiEUj/zyN5dTp+yXFg5KHD5Ko9bddQ/hKa17g==
X-Received: by 2002:a05:6a21:3390:b0:14b:7c16:a590 with SMTP id yy16-20020a056a21339000b0014b7c16a590mr4964459pzb.60.1692864318384;
        Thu, 24 Aug 2023 01:05:18 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:515:8b2a:90c3:b79e])
        by smtp.gmail.com with UTF8SMTPSA id j24-20020aa79298000000b0068a077847c7sm8928630pfa.135.2023.08.24.01.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:05:17 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v8 6/8] KVM: arm64: Migrate to __kvm_follow_pfn
Date: Thu, 24 Aug 2023 17:04:06 +0900
Message-ID: <20230824080408.2933205-7-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230824080408.2933205-1-stevensd@google.com>
References: <20230824080408.2933205-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/arm64/kvm/mmu.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d3b4feed460c..e4abc2a57d7d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1334,7 +1334,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  unsigned long fault_status)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
+	bool write_fault = kvm_is_write_fault(vcpu);
+	bool force_pte = false;
 	bool exec_fault, mte_allowed;
 	bool device = false;
 	unsigned long mmu_seq;
@@ -1342,16 +1343,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
 	short vma_shift;
-	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	struct kvm_follow_pfn foll = {
+		.slot = memslot,
+		.flags = FOLL_GET | (write_fault ? FOLL_WRITE : 0),
+		.try_map_writable = true,
+	};
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
-	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
@@ -1425,7 +1429,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		fault_ipa &= ~(vma_pagesize - 1);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
+	foll.gfn = fault_ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
 	/* Don't use the VMA after the unlock -- it may have vanished */
@@ -1433,7 +1437,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or __gfn_to_pfn_memslot() become stale prior to
+	 * vma_lookup() or __kvm_follow_pfn() become stale prior to
 	 * acquiring kvm->mmu_lock.
 	 *
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
@@ -1442,8 +1446,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __kvm_follow_pfn(&foll);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -1468,7 +1471,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * Only actually map the page as writable if this was a write
 		 * fault.
 		 */
-		writable = false;
+		foll.writable = false;
 	}
 
 	if (exec_fault && device)
@@ -1508,7 +1511,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 	}
 
-	if (writable)
+	if (foll.writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (exec_fault)
@@ -1534,9 +1537,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 					     KVM_PGTABLE_WALK_SHARED);
 
 	/* Mark the page dirty only if the fault is handled successfully */
-	if (writable && !ret) {
+	if (foll.writable && !ret) {
 		kvm_set_pfn_dirty(pfn);
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+		mark_page_dirty_in_slot(kvm, memslot, foll.gfn);
 	}
 
 out_unlock:
-- 
2.42.0.rc1.204.g551eb34607-goog

