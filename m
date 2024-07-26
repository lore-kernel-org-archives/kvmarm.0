Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D3E15EFC8
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037986; cv=none; b=GVJBiEp8SFA+BPGM+uzV+6o3HioeU7oc3hR9+DTEKxEiMKy02PrPBE/s3H0r1jYdRW+NYtQtgN20/kl/E1Rn8FDcdL0CBogPEYXrT6yRk2ptYdilACFpB2ksdWg/FncQVLX5F5NS+7zBa6HtRFibMAD/IKrgPQewEgZhpzPzJwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037986; c=relaxed/simple;
	bh=qQVc59im7GngCaPa3TwBCc9CgIeFb9pgAGD2oXsQqY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kC/UtmEX15LQCUOHqQbwbaxIsbca7XiQ5BmAz6oQP0GKmqu6NCyAKJxykwtzhkikLHodKFbUlpU6o5HnFjV9vzoBUTVlsBDRnhkIRCH0W1jU6YU6l0BdL1j7JidVdS0SKUjoYiWI5yNB5WLTNjlid1eDUKs96SXv04Nj+vyYBeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kk1pwRFG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kk1pwRFG"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-665a6dd38c8so7196377b3.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037982; x=1722642782; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ADEmxv9XmYXZ8ay6LRZAqHHnUfOELcTSDZRch+cTwuw=;
        b=Kk1pwRFG7Lo2Sgku5DhH2OHk8bCeks+YA2/p/1G9mY3Q9Xa8YSdjALQ6ukrF2L4mos
         qtYIqy7vgOaU6HjqOLocct36oRZPba/elFTRoEBD2qPDLXaD4x17SrLLHMhxJ8m6HVbd
         i6hLdXh3MkzWl7mgalkyjOeXZ8iX7mQg1dXf3CW6wbIfEgwBhuGX5q1+X0FiGfwVaCf7
         99H/2kEXq+PG7jLAkvomi9sjNvjteXYEBL2z60GGwdy7p3EtnsPiKr1fru2NHGgJ2txX
         0QWnn3brdO4zUHIl09sb5DxM5BxokK3rv6nSz3b96kvnkIzwzpLguvBRyaty3WViWNCw
         YjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037982; x=1722642782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ADEmxv9XmYXZ8ay6LRZAqHHnUfOELcTSDZRch+cTwuw=;
        b=bV8rUyRcstBgut9gWcqFFmguTl999J4SeZ3Z+E+nkxnPSBZO0LlSW98dEmDgNS2e7x
         d9cHh6mnEvIi9oJ3RBKR6iPJMbZsvcah/vo5cmOn9uCGhHY8MPtiE9+Si+21cYowMa/p
         fPpTmr3GgBpSfEZQ4S/n26Xau2o0rDT0VnZyRYo239w1N6muiJNDzKEGegUxBCIeEmKB
         HozKtQRtIhWlbQrLzoiEyB3fhDCDrs638wx6Md5m6dLFzPaQU9O86T9GHRGrLKFnGMvw
         uqcAG3+AGzgsP/Acjn5L7uXT1jirpzJVT3AuUnOViW3GZO5UsL6c9n3Co7PkjtEZvhZt
         LKpg==
X-Forwarded-Encrypted: i=1; AJvYcCUNyLUEFaAobtTQnjOt7atw/5DRso93pTnZs5k0XYbw5oJWyaoMenlZsonxHyZ8r0gIyxTnY3Sb4wj5dyaNZ7Lcs5JvSNCX
X-Gm-Message-State: AOJu0Yx0LyTxXI6bn7FwPZZRWxL3lC75Ek3jD6ZoZZ6zQIl+fzt/QZwX
	G34V0/BXEHq7WvT5zM7/yQxlWi03kmccu1TgYhu0GkLh0fcBq+8OYvO2QX/m/fzorWvm8hlRs/R
	XxQ==
X-Google-Smtp-Source: AGHT+IFvuKtzzbSFT7TzhVG4cD407iDdVRMZdEo+hUTgj12n6OpGkNu03b7iXctLyyeC9wijqsbDK83s/Cg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f03:b0:665:a4a4:57c1 with SMTP id
 00721157ae682-67a057b7ffdmr33777b3.2.1722037981863; Fri, 26 Jul 2024 16:53:01
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:21 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-13-seanjc@google.com>
Subject: [PATCH v12 12/84] KVM: Drop @atomic param from gfn=>pfn and hva=>pfn APIs
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

Drop @atomic from the myriad "to_pfn" APIs now that all callers pass
"false".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst     |  4 +--
 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 12 ++++-----
 include/linux/kvm_host.h               |  4 +--
 virt/kvm/kvm_main.c                    | 36 +++++---------------------
 virt/kvm/kvm_mm.h                      |  4 +--
 virt/kvm/pfncache.c                    |  2 +-
 9 files changed, 22 insertions(+), 46 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 8b3bb9fe60bf..9af511e7aa53 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -126,8 +126,8 @@ We dirty-log for gfn1, that means gfn2 is lost in dirty-bitmap.
 For direct sp, we can easily avoid it since the spte of direct sp is fixed
 to gfn.  For indirect sp, we disabled fast page fault for simplicity.
 
-A solution for indirect sp could be to pin the gfn, for example via
-kvm_vcpu_gfn_to_pfn_atomic, before the cmpxchg.  After the pinning:
+A solution for indirect sp could be to pin the gfn before the cmpxchg.  After
+the pinning:
 
 - We have held the refcount of pfn; that means the pfn can not be freed and
   be reused for another gfn.
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..30dd62f56a11 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1562,7 +1562,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
 				   write_fault, &writable, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 1b51b1c4713b..8cd02ca4b1b8 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -613,7 +613,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 		write_ok = true;
 	} else {
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
 					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 408d98f8a514..26a969e935e3 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -852,7 +852,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 		unsigned long pfn;
 
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
 					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c1914f02c5e1..d76390ef49b2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4334,9 +4334,9 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, false,
-					  &async, fault->write,
-					  &fault->map_writable, &fault->hva);
+	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, &async,
+					  fault->write, &fault->map_writable,
+					  &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4356,9 +4356,9 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
-					  NULL, fault->write,
-					  &fault->map_writable, &fault->hva);
+	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, NULL,
+					  fault->write, &fault->map_writable,
+					  &fault->hva);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79fed9fea638..6d4503e8eabe 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1217,9 +1217,8 @@ kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
-kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool interruptible, bool *async,
+			       bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
@@ -1300,7 +1299,6 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
-kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 803299778cf8..84c73b4fc804 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2929,7 +2929,6 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function is forbidden from sleeping
  * @interruptible: whether the process can be interrupted by non-fatal signals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
@@ -2941,22 +2940,16 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  * 2): @write_fault = false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-		     bool *async, bool write_fault, bool *writable)
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
+		     bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn;
 	int npages, r;
 
-	/* we can do it either atomically or asynchronously, not both */
-	BUG_ON(atomic && async);
-
 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
 
-	if (atomic)
-		return KVM_PFN_ERR_FAULT;
-
 	npages = hva_to_pfn_slow(addr, async, write_fault, interruptible,
 				 writable, &pfn);
 	if (npages == 1)
@@ -2993,7 +2986,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 }
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool interruptible, bool *async,
+			       bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
@@ -3015,39 +3008,24 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}
 
-	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
-			  writable);
+	return hva_to_pfn(addr, interruptible, async, write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    NULL, write_fault, writable, NULL);
+	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
+				    write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
-				    NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
-kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
-				    NULL, NULL);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
-
-kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_atomic);
-
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01..a3fa86f60d6c 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -20,8 +20,8 @@
 #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-		     bool *async, bool write_fault, bool *writable);
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
+		     bool write_fault, bool *writable);
 
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e..58c706a610e5 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -198,7 +198,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		}
 
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(gpc->uhva, false, NULL, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

