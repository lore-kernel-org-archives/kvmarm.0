Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A275017E6
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 07:51:58 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1b7e1875cc1so29948855ad.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 00:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688457118; x=1691049118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VCpKC4uXwQHydKgBR4yAPbGVdXRXBlTDW5vlI7SMZnI=;
        b=VdipnehtoBWVnZgiiIRUC3n4cutyHftCzzQTvCt+6pDBfsoJDl0IPP7jexUln1Z3yv
         24G47TmH8QpI+nwzx6ctjE817ctenOUmr6AjP+CmoU02rktwSe6aOZx2ZntH2UwQ9DeO
         KBx6QbhtpOviBTERdqZU9t3L7LqRKS8+C/r84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688457118; x=1691049118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VCpKC4uXwQHydKgBR4yAPbGVdXRXBlTDW5vlI7SMZnI=;
        b=TaDnRkr/f3wjKI72rL1VMH4IMH+2QdHGnPts6oDhjBJGKIq4bx41SRCyQ7b9tmAbfN
         fJlaF4FLrJagSbUJ9n9MaGuOMQvXiNeSoI5WMLi/40LL7oB68MSX8vVRxW5zzUFN6ZYA
         3ot1r39qmYmo7z89sO5QygrafzE7gqxW9G6I8vgvNulMKM69ZI9M2Lu2A95OqfbVJBSU
         GVqHI4wwUOL5CJnclif0QFDx+ad89qOsDfATdHu3RbMWUipIpOV1c1hwWghL7D/F4xB+
         0ObVdAtjqi0oKlQKR5hQzK4vy2+g9ce/92KwCFtOr7ep9xOCKZZQ+hm3oZ/BOolI6mjy
         +oGw==
X-Gm-Message-State: ABy/qLYUl6YROwxkttUJyeXPMaLL1A9fmUPiuktwDLh7eCN8s9tbVY4X
	lR0Duew33TmjeO/mqMPG6xVP1w==
X-Google-Smtp-Source: APBJJlFlOFbHWdaS64bV6rkagDydvh49k9oEO7W5D2RIf2i40ajXmc6e9E8Ak2SPFXB+2GmF5HmwRQ==
X-Received: by 2002:a17:902:c409:b0:1b8:6cae:4400 with SMTP id k9-20020a170902c40900b001b86cae4400mr9997546plk.37.1688457118004;
        Tue, 04 Jul 2023 00:51:58 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:a11b:bff7:d8ae:bb0])
        by smtp.gmail.com with UTF8SMTPSA id a4-20020a1709027d8400b001ae0a4b1d3fsm16529164plm.153.2023.07.04.00.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 00:51:57 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v7 6/8] KVM: arm64: Migrate to __kvm_follow_pfn
Date: Tue,  4 Jul 2023 16:50:51 +0900
Message-ID: <20230704075054.3344915-7-stevensd@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
In-Reply-To: <20230704075054.3344915-1-stevensd@google.com>
References: <20230704075054.3344915-1-stevensd@google.com>
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
index 6db9ef288ec3..c706530d304d 100644
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
+		.allow_write_mapping = true,
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
2.41.0.255.g8b1d071c50-goog

