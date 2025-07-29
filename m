Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CADC2D238D
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829765; cv=none; b=qMYMHImjA/cXlDB2Lw9fd01O6KrQFj8yV25Tcq27sv+fsToXIkZe19Rp471sgHthhbJwrNpxfZ+OPgSNoflij6cZZPv58wnl3lU9cZu6590CRwdIbXH2Uof2QBKNGsoBgOG25JJiBbd2BCFQm/ZZVhPhIX1CTZxEA/ioVbjX14g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829765; c=relaxed/simple;
	bh=cJ74EwWgT8ssw15s8hHa0q/3vNUXZsCmxE/4AKvCbiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1mKiCcrrXFRHbxL8/2sc+JXbmvyTrzwiiuViUePNP9wrOcLy4l7SyMvek/CIUClmC0YajvO+5eJ/C+vKs1HAXPkRERAbFg11Qk49WSVigfVl8PsmZ8Z+mXa+OuDRBONbwe29XwgreMOWcp0m37K7fzIwq+EXNdJU/1Ms2Kc6Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lb4gG2tF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lb4gG2tF"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2400117dd80so24904565ad.2
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829763; x=1754434563; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YGSKpa2fHnKmvhwupUv+p380hnAGu6oGZqnkqfDR1aw=;
        b=Lb4gG2tFtrqHQ/0JjASgaLYDSNTGBx+AQfFSlzyn7A9Qq963WuVLlYOaipgm8ScI3R
         qEdTGY0sd+JBeC9kUksJDGWJhYoeHJQsUiJx1hM/VK2drbrkbfzbYjk3cIrvEPF2gyWY
         NgvsR4hOs7o9SqR53lJOHaAv3IZgyAxlT8BPvC3/7BxtQb6aV/KLSxw8QU1RqnDxsq0q
         /cAxphFXWwhLCT7EGnLBahn944+JK6EZ1LMKf6f3V229C8bOBXpcLyY79UFvcX7EkeVg
         RdMa7A/iCOuy9TB3GpH0ZDcxhGG/xvD8Pdod0XNUIAGVudSlC2Oi8uF1yLin1Z09LiRM
         2t1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829763; x=1754434563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YGSKpa2fHnKmvhwupUv+p380hnAGu6oGZqnkqfDR1aw=;
        b=BKgJCSGrO+FtgfWSfTbKsbeUWWFisyE7YPNKU6B+whBtwlSNh2AhJxHZzlU5gcCAAO
         0jMFYoWT8tMjY6xUa263t6jihoB9QPz3lAXY+FzDOl9C0HnQqXXrglA83ye3+q1Tk/0i
         SkhjmydhcIQu+2/zTxz8Gq6NvL0ojl2twMCN0CkQ/H9lL5NFtVbFspcPYD8jNQp4rSRp
         Azd8sNhTb+GnQIvp2m1T+ZUeyA6w/mBvfx5G8NLmSsFAvGsQ/3Upd5L6207YOELQTVS1
         y7umvJ8vKARhZwVXTeM6h1+cRAD0UMxcw1SuA76mLfnVEDoM5r4nFxwcIDW7yLeDxcWf
         BHhA==
X-Forwarded-Encrypted: i=1; AJvYcCUoIBMHrRtqwsjEvOaF24SQdFSka8IymNXinNKn68rRjJhUSSG0QQ1Oc0rXNfur1peVh2S5L74=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLHNjRQc1dNlQqtHTIGKmozOykCUH5z497SoEjngmxAyziCu41
	2yhnZLwXL+IFWtDWru7/GULdXNneJafWbX4+2m6SKQFNLOO+TeXmaJa/NfzlUP8kRZXWa2pQbIl
	ksRzr+A==
X-Google-Smtp-Source: AGHT+IFvhUHa66DXw0WO0M1QOBisEEAf0dqbz4+FB+6ytlMqLm65KTleMot3mI0oJ4nV+lB86TE50xbpvCQ=
X-Received: from pjk7.prod.google.com ([2002:a17:90b:5587:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2301:b0:240:2ee6:fd45
 with SMTP id d9443c01a7336-24096b410d1mr12990695ad.36.1753829762482; Tue, 29
 Jul 2025 15:56:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:49 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-19-seanjc@google.com>
Subject: [PATCH v17 18/24] KVM: arm64: Handle guest_memfd-backed guest page faults
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

Add arm64 architecture support for handling guest page faults on memory
slots backed by guest_memfd.

This change introduces a new function, gmem_abort(), which encapsulates
the fault handling logic specific to guest_memfd-backed memory. The
kvm_handle_guest_abort() entry point is updated to dispatch to
gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
determined by kvm_slot_has_gmem()).

Until guest_memfd gains support for huge pages, the fault granule for
these memory regions is restricted to PAGE_SIZE.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 86 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b3eacb400fab..8c82df80a835 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1512,6 +1512,82 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 	*prot |= kvm_encode_nested_level(nested);
 }
 
+#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
+
+static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		      struct kvm_s2_trans *nested,
+		      struct kvm_memory_slot *memslot, bool is_perm)
+{
+	bool write_fault, exec_fault, writable;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	unsigned long mmu_seq;
+	struct page *page;
+	struct kvm *kvm = vcpu->kvm;
+	void *memcache;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int ret;
+
+	ret = prepare_mmu_memcache(vcpu, true, &memcache);
+	if (ret)
+		return ret;
+
+	if (nested)
+		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
+	else
+		gfn = fault_ipa >> PAGE_SHIFT;
+
+	write_fault = kvm_is_write_fault(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+
+	VM_WARN_ON_ONCE(write_fault && exec_fault);
+
+	mmu_seq = kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
+					      write_fault, exec_fault, false);
+		return ret;
+	}
+
+	writable = !(memslot->flags & KVM_MEM_READONLY);
+
+	if (nested)
+		adjust_nested_fault_perms(nested, &prot, &writable);
+
+	if (writable)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	if (exec_fault ||
+	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
+	     (!nested || kvm_s2_trans_executable(nested))))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	kvm_fault_lock(kvm);
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+						 __pfn_to_phys(pfn), prot,
+						 memcache, flags);
+
+out_unlock:
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	kvm_fault_unlock(kvm);
+
+	if (writable && !ret)
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1536,7 +1612,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1961,8 +2037,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
 			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
 
-	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	if (kvm_slot_has_gmem(memslot))
+		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
+				 esr_fsc_is_permission_fault(esr));
+	else
+		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
+				     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.50.1.552.g942d659e1b-goog

