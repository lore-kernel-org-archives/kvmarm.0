Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C721F37DBD3
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855012; cv=none; b=Pux93zbLv3CQR7XpIENVrk7FuVjX0jIm7NdCKiwGKNS1EiqiBqDcgpta5dfywnoZGcrH2qrjaDXfUx8cgLL+ACwg4EV0yTIU1l5mNgpmgsZB+UYH/80dp1C/GUhBSi+yW/0bvnJLfOFVgKTBTaS2zRxMk6ajyh8jbUDistvizpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855012; c=relaxed/simple;
	bh=SegAjPYWds/TZjfbFAHGrF/2ieYqFxZV5by845zNTko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RwJjQMXk+GlcL2jvMdLkUDiShDDAXdLcIsqBBvrZWeIcudNJy6YmaKP6yCvituWtQvZBBDrpPn3CEavEck8WRZZmY5XSgouSGYlBU2BZ5vECemoB+vtQ2ju0Lo6wxI6l/Qq6X6R2OmvQ7tC0r/GCGVZLs3XoJjD53ZbrJq4MwyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=deOr1IiG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="deOr1IiG"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2697410e7f9so34487555ad.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855009; x=1762459809; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AWjqyewTSxAo5goVGUIy0m+TBQ84l/fAmH7ugD3Pbw4=;
        b=deOr1IiGiuEj8DehRcJYfEjEoPFqILX7qh+Qgxbq04PxSMqF0ZUahxbaoMSPLeZmno
         qfU/mRhYOLedJ+hQgbELaNzWO3MW/RhgmTmBTYjST4hTYUm5us0J1dm7PDPf2bMoQW2v
         8zNMHkGxV7iATgW5DnZILrjyAm6ebNjarRqPXHAjtNHsIzrXsOTmMIR9CqW8ZjifU/LW
         gOtAxZotlT5/aNbA4UneZiRpfDYTgAFp9SEypeaihvRYwdGn+Kl+9bZyk00H21PVvH4U
         yZwEhqo8rk2JXDMoK7rTqaMsI+aCQ5QG4OJrpiM8ZexuWyjw1sGNKHlsGMH7MaWf3m9d
         ahEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855009; x=1762459809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AWjqyewTSxAo5goVGUIy0m+TBQ84l/fAmH7ugD3Pbw4=;
        b=DNc2IIAyRf8SuzCHmz+yyaFwCh5Op2JVByqQSKLove1OoVUBWZdgAg1NhJ56uh5bSg
         akCdZU7fDoCnew4hUjw2i2CpYtFbrVMHIAuLdv5X7N61aagBVJ/I7l25Uad4bBIsOLtk
         vuiyGEijq4ZqOgsflgsU5PERB7LOgRf3c7L9M9GomEvc7K4vSw82sNLxA1MIcecditUb
         et/nwOIFVW99g9cCcWgXmxUGIAPtTooZoL5LgP0rcB/GHvyfXa2mZMvj5USqgHMhXefS
         UME7VANwqw/jj0EldgMXg4tRbNJ1MjoyTLeBhDRHOcmfnhBVmX8N9cv+ckAacsgwmOdY
         0Hpg==
X-Forwarded-Encrypted: i=1; AJvYcCXQMn343HWwTcbxtSwj8VwIM3sTxC8KelgjIxmnxdzS8yrrVohW3N/VhRXsG3YrxERDtZMtiUA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMFU+hm5SDPrxq8tkRtqPN2EOSV6lMQEdQt6dftqueQQYO9q40
	t6yI7LXXP+EeHvwo8WdxsZ08k3Py8ESOQhgYEiD3XoPtkRxmTUZpu4W83/Jl7BWW9AJUw93NBjU
	N+X6W1Q==
X-Google-Smtp-Source: AGHT+IEOd6dhhOrMyLm5rAPRaBNRm2puNA7otVNJLczO2HSlc5/6mK5syWdypSUA75SSISTWcIWOwk769kE=
X-Received: from plkn2.prod.google.com ([2002:a17:902:6a82:b0:292:4a9c:44cf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2452:b0:267:a55a:8684
 with SMTP id d9443c01a7336-2951a36417cmr13224335ad.2.1761855009104; Thu, 30
 Oct 2025 13:10:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:27 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-5-seanjc@google.com>
Subject: [PATCH v4 04/28] KVM: x86/mmu: Add dedicated API to map guest_memfd
 pfn into TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add and use a new API for mapping a private pfn from guest_memfd into the
TDP MMU from TDX's post-populate hook instead of partially open-coding the
functionality into the TDX code.  Sharing code with the pre-fault path
sounded good on paper, but it's fatally flawed as simulating a fault loses
the pfn, and calling back into gmem to re-retrieve the pfn creates locking
problems, e.g. kvm_gmem_populate() already holds the gmem invalidation
lock.

Providing a dedicated API will also removing several MMU exports that
ideally would not be exposed outside of the MMU, let alone to vendor code.
On that topic, opportunistically drop the kvm_mmu_load() export.  Leave
kvm_tdp_mmu_gpa_is_mapped() alone for now; the entire commit that added
kvm_tdp_mmu_gpa_is_mapped() will be removed in the near future.

Gate the API on CONFIG_KVM_GUEST_MEMFD=y as private memory _must_ be backed
by guest_memfd.  Add a lockdep-only assert to that the incoming pfn is
indeed backed by guest_memfd, and that the gmem instance's invalidate lock
is held (which, combined with slots_lock being held, obviates the need to
check for a stale "fault").

Cc: Michael Roth <michael.roth@amd.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/all/20250709232103.zwmufocd3l7sqk7y@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h     |  1 +
 arch/x86/kvm/mmu/mmu.c | 81 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.c | 10 ++----
 3 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f63074048ec6..2f108e381959 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -259,6 +259,7 @@ extern bool tdp_mmu_enabled;
 
 bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
 int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
+int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 18d69d48bc55..bad0480bdb0d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5014,6 +5014,86 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	return min(range->size, end - range->gpa);
 }
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+static void kvm_assert_gmem_invalidate_lock_held(struct kvm_memory_slot *slot)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	if (WARN_ON_ONCE(!kvm_slot_has_gmem(slot)) ||
+	    WARN_ON_ONCE(!slot->gmem.file) ||
+	    WARN_ON_ONCE(!file_count(slot->gmem.file)))
+		return;
+
+	lockdep_assert_held(&file_inode(slot->gmem.file)->i_mapping->invalidate_lock);
+#endif
+}
+
+int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct kvm_page_fault fault = {
+		.addr = gfn_to_gpa(gfn),
+		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
+		.prefetch = true,
+		.is_tdp = true,
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
+
+		.max_level = PG_LEVEL_4K,
+		.req_level = PG_LEVEL_4K,
+		.goal_level = PG_LEVEL_4K,
+		.is_private = true,
+
+		.gfn = gfn,
+		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
+		.pfn = pfn,
+		.map_writable = true,
+	};
+	struct kvm *kvm = vcpu->kvm;
+	int r;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	/*
+	 * Mapping a pre-determined private pfn is intended only for use when
+	 * populating a guest_memfd instance.  Assert that the slot is backed
+	 * by guest_memfd and that the gmem instance's invalidate_lock is held.
+	 */
+	kvm_assert_gmem_invalidate_lock_held(fault.slot);
+
+	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
+		return -EIO;
+
+	if (kvm_gfn_is_write_tracked(kvm, fault.slot, fault.gfn))
+		return -EPERM;
+
+	r = kvm_mmu_reload(vcpu);
+	if (r)
+		return r;
+
+	r = mmu_topup_memory_caches(vcpu, false);
+	if (r)
+		return r;
+
+	do {
+		if (signal_pending(current))
+			return -EINTR;
+
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
+			return -EIO;
+
+		cond_resched();
+
+		guard(read_lock)(&kvm->mmu_lock);
+
+		r = kvm_tdp_mmu_map(vcpu, &fault);
+	} while (r == RET_PF_RETRY);
+
+	if (r != RET_PF_FIXED)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_mmu_map_private_pfn);
+#endif
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
@@ -5997,7 +6077,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4c3014befe9f..29f344af4cc2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3157,15 +3157,12 @@ struct tdx_gmem_post_populate_arg {
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				  void __user *src, int order, void *_arg)
 {
-	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct tdx_gmem_post_populate_arg *arg = _arg;
-	struct kvm_vcpu *vcpu = arg->vcpu;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err, entry, level_state;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	u8 level = PG_LEVEL_4K;
 	struct page *src_page;
 	int ret, i;
-	u64 err, entry, level_state;
 
 	/*
 	 * Get the source page if it has been faulted in. Return failure if the
@@ -3177,7 +3174,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (ret != 1)
 		return -ENOMEM;
 
-	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
+	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	if (ret < 0)
 		goto out;
 
@@ -3240,7 +3237,6 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
 		return -EINVAL;
 
-	kvm_mmu_reload(vcpu);
 	ret = 0;
 	while (region.nr_pages) {
 		if (signal_pending(current)) {
-- 
2.51.1.930.gacf6e81ea2-goog

