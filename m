Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AFD3769EF
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751880; cv=none; b=dcpAGLoH/7wyMRCkox4tN581MeahGfWsTcCzAk18UUA3TKpu1gFMORIhaOaUhoixzKDR10UAJ5wN3/I7geg8pMt0oGKLhVms6TOISSZcdHOp+YljwMi6dhZze65ZX59npVpYUSzsmKCW1zw/zNrZ0ISeqSjDEhYDcUnabQHZkK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751880; c=relaxed/simple;
	bh=vyDNRPECcZnKyiM3WDUDYBnfpvpvZ8MRFt30l/Bpv20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s31TVNFP5nF9chmylnsxauLbqNncyf2xJJPHTNvxvXhl89RU/MARbG6Zc1sEMY3n4sK4DnBny1ZwryPMioE12NOOR5Q1ex9CEnqzFXXPorXE5UMnl/seeD+m942bp5uILdl4Xk57ozIhNGcqLD0So53K2u/iRTKZnQl2ErHSrvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lVdQdCEp; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lVdQdCEp"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a22bf0so2737409a12.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751877; x=1786356677; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CBRFHYOL2ugysE5dNDzIh6xnN0zoWtq/Z1MnD4d5fkU=;
        b=lVdQdCEplKpSfZDWSNHRkLDv3vfb3NKE2nYkM0mavWUpNtgbAuztN6L+T7AirmAyva
         HVBmF/bvfWkRCQcrYgNvXCmN+tmQ+95t6yi4Hz11O38gVWBQX6Tqk8/Fo2SBTdbLj/Z8
         5EmJi8wSc06p+50i4U/nUTX75tDqT3TwgUoOLPb5n92tBMZA7t/kMa5+x84lbljXbm3u
         4VWBx+80fhe6l7m65KN1wyp4aM3Aq3Void0DLTa+Y0lMlohmg9V76YBJU4ypslpC9MTO
         re8522L1bn8448WCdupb6jITT0QabU9WH8T8alL9fXvcnlEZxY4PlSbHHoqOtMPp6Es7
         rlfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751877; x=1786356677;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CBRFHYOL2ugysE5dNDzIh6xnN0zoWtq/Z1MnD4d5fkU=;
        b=loH3JLma+31WU/bxSUl+2SlND1TuvdnCD/XJGMD3VPyCWNaQKpVXYyhc+1RQYS7Wg5
         x8XyUilvMik9c96MP6+SHbjUFcw+sPhmQxpm4sOC5hAZXKbv1Qlvb7VAyCxc3QhE3bgj
         O17lCOfVqThFHYNh9kaInvJqMpe41peBKyO12hn4jEFAto+I1w4HHDYY47WcdUYz+ETa
         rCV96yXPBUdbF4MIU9eoRtDvURUU7EjARFgYqiBd1ZAdqSHYqg4dgvPpso5xNQUuoNkF
         RDdT+frJHfOJ23lnSiL/oNEiKzux90gLwJ+LHGsI0w14FnWX0cqzB5zyuJRNXuoO+N3U
         pPsg==
X-Forwarded-Encrypted: i=1; AHgh+RrV1hxRUjMil+M6ZUyiLqFXpaueohTh5t4t4FauEcovuR0/11BZ6epNH15V+AR/lu/qeD1NgxE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0nT4vkSNi0Xdp9hlR6caR00/ERK2Mq9mvC7CW6e0AsceT2YDT
	TQ6RBEQCD4ephx/Qns3IFGzXxP+EwPZdDX/563QfqnioKCu8F1acQgIPlqnW+jWZtPwhpx3rYmi
	Ikq826ttPxbtjAc6JesCpfw==
X-Received: from edvh22.prod.google.com ([2002:aa7:de16:0:b0:6a0:10fb:ecbc])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1f48:b0:6a0:33f6:13b4 with SMTP id 4fb4d7f45d1cf-6a0a7cae888mr6718653a12.13.1785751876652;
 Mon, 03 Aug 2026 03:11:16 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:09:02 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-19-vdonnefort@google.com>
Subject: [PATCH 18/20] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

With the upcoming support for stage-2 huge mappings for protected VMs,
we need a way to split blocks. Since the host has its own "copy" of the
guest stage-2 in the pkvm_mappings rb-tree, the split must be done
simultaneously for both that tree and the guest stage-2. Therefore the
hypervisor can't do it on its own and must rely on the host for this
operation.

Create a pKVM hypervisor request to ask the host to split a specified
region of the guest. On this request, the host can synchronise the split
of both guest stage-2 (HVC __pkvm_host_split_guest) and the
pkvm_mappings tree. It ensures a concurrent VM teardown can't observe a
PMD_SIZE pkvm_mapping while the guest stage-2 is PAGE_SIZE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d01e6954d363..927d9de643fa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -87,11 +87,18 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 enum pkvm_hyp_req_type {
 	PKVM_HYP_NO_REQ = 0,
+	PKVM_HYP_REQ_SPLIT,
 	__PKVM_HYP_REQ_TYPE_MAX,
 };
 
 struct pkvm_hyp_req {
 	u8 type;
+	union {
+		struct {
+			u32	nr_pages;
+			u64	gfn;
+		} split;
+	};
 };
 
 struct kvm_hyp_memcache {
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index baafbd7ca215..370eddeefbae 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -193,7 +193,10 @@ static inline size_t pkvm_host_sve_state_size(void)
 }
 
 struct pkvm_mapping {
-	struct rb_node node;
+	union {
+		struct rb_node node;
+		struct list_head list;
+	};
 	u64 gfn;
 	u64 pfn;
 	u64 nr_pages;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 379bdc2b258a..089b77cf2f6a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -365,6 +365,69 @@ INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
 		       });									\
 	    )
 
+static void pkvm_mapping_free_spares(struct list_head *spares)
+{
+	struct pkvm_mapping *m, *tmp;
+
+	list_for_each_entry_safe(m, tmp, spares, list) {
+		list_del(&m->list);
+		kfree(m);
+	}
+}
+
+static int pkvm_mapping_alloc_spares(struct list_head *head, u64 nr_spares)
+{
+	struct pkvm_mapping *m;
+
+	while (nr_spares--) {
+		m = kzalloc_obj(*m);
+		if (!m) {
+			pkvm_mapping_free_spares(head);
+			return -ENOMEM;
+		}
+
+		list_add(&m->list, head);
+	}
+
+	return 0;
+}
+
+static bool pkvm_mapping_can_split(struct pkvm_mapping *mapping)
+{
+	return mapping && (mapping->nr_pages * PAGE_SIZE == PMD_SIZE);
+}
+
+static void pkvm_mapping_split(struct pkvm_mapping *mapping, struct kvm_pgtable *pgt,
+			       struct list_head *spares)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	u64 nr_pages = mapping->nr_pages - 1;
+	gfn_t gfn = mapping->gfn + 1;
+	u64 pfn = mapping->pfn + 1;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
+	mapping->nr_pages = 1;
+	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
+
+	while (nr_pages--) {
+		struct pkvm_mapping *m;
+
+		if (WARN_ON(list_empty(spares)))
+			break;
+
+		m = list_first_entry(spares, struct pkvm_mapping, list);
+		list_del(&m->list);
+
+		m->nr_pages = 1;
+		m->gfn = gfn++;
+		m->pfn = pfn++;
+
+		pkvm_mapping_insert(m, &pgt->pkvm_mappings);
+	}
+}
+
 int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			     struct kvm_pgtable_mm_ops *mm_ops)
 {
@@ -619,6 +682,91 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void
 	return -EINVAL;
 }
 
+/*
+ * Splitting is only expected on the back of a guest HVC, while
+ * pkvm_pgtable_stage2_split() can be called with dirty logging.
+ */
+static int __pkvm_pgtable_stage2_split(struct kvm_vcpu *vcpu, phys_addr_t ipa, u64 size)
+{
+	struct kvm_hyp_memcache *mc = &vcpu->arch.pkvm_memcache;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	struct page **pages __free(kfree) = NULL;
+	struct mm_struct *mm = current->mm;
+	struct kvm_memory_slot *memslot;
+	struct pkvm_mapping *mapping;
+	struct kvm *kvm = vcpu->kvm;
+	struct list_head spares;
+	unsigned long hva;
+	bool writable;
+	u64 nr_pages;
+	int ret, idx;
+	gfn_t gfn;
+
+	if (WARN_ON(!kvm_vm_is_protected(kvm)))
+		return -EINVAL;
+
+	if (!IS_ALIGNED(ipa, PMD_SIZE) || size != PMD_SIZE)
+		return -EINVAL;
+
+	ret = topup_hyp_memcache(mc, 1);
+	if (ret)
+		return ret;
+
+	/* We already have 1 pin on the huge-page */
+	gfn = gpa_to_gfn(ipa) + 1;
+	nr_pages = (size / PAGE_SIZE) - 1;
+	pages = kmalloc_objs(struct page *, nr_pages);
+	if (!pages)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&spares);
+	ret = pkvm_mapping_alloc_spares(&spares, nr_pages);
+	if (ret)
+		return ret;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	memslot = gfn_to_memslot(kvm, gfn);
+	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
+	if (kvm_is_error_hva(hva) || !writable) {
+		ret = -EFAULT;
+		goto unlock_srcu;
+	}
+
+	mmap_read_lock(mm);
+	ret = pin_user_pages(hva, nr_pages, FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE, pages);
+	mmap_read_unlock(mm);
+	if (ret != nr_pages) {
+		if (ret > 0)
+			unpin_user_pages(pages, ret);
+		ret = -EFAULT;
+		goto unlock_srcu;
+	}
+
+	write_lock(&kvm->mmu_lock);
+	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, ipa, ipa + size - 1);
+	if (!pkvm_mapping_can_split(mapping)) {
+		ret = -EINVAL;
+		goto unlock_mmu;
+	}
+
+	ret = kvm_call_hyp_nvhe(__pkvm_host_split_guest, gpa_to_gfn(ipa), size / PAGE_SIZE);
+	if (ret)
+		goto unlock_mmu;
+
+	pkvm_mapping_split(mapping, pgt, &spares);
+
+unlock_mmu:
+	write_unlock(&kvm->mmu_lock);
+	if (ret)
+		unpin_user_pages(pages, nr_pages);
+
+unlock_srcu:
+	srcu_read_unlock(&kvm->srcu, idx);
+	pkvm_mapping_free_spares(&spares);
+
+	return ret;
+}
+
 /*
  * Forcefully reclaim a page from the guest, zeroing its contents and
  * poisoning the stage-2 pte so that pages can no longer be mapped at
@@ -631,11 +779,31 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
 	return !ret || ret == -EAGAIN;
 }
 
+static int pkvm_hyp_req_handle_split(struct kvm_vcpu *vcpu, u64 gfn, u64 nr_pages)
+{
+	phys_addr_t addr = ALIGN_DOWN(gfn << PAGE_SHIFT, PMD_SIZE);
+	phys_addr_t end = ALIGN((gfn + nr_pages) << PAGE_SHIFT, PMD_SIZE);
+
+	while (addr < end) {
+		int ret = __pkvm_pgtable_stage2_split(vcpu, addr, PMD_SIZE);
+
+		if (ret)
+			return ret;
+
+		addr += PMD_SIZE;
+	}
+
+	return 0;
+}
+
 static int pkvm_hyp_req_handle(struct pkvm_hyp_req *req, struct kvm_vcpu *vcpu)
 {
 	int ret = -EINVAL;
 
 	switch (req->type) {
+	case PKVM_HYP_REQ_SPLIT:
+		ret = pkvm_hyp_req_handle_split(vcpu, req->split.gfn, req->split.nr_pages);
+		break;
 	}
 
 	trace_kvm_handle_pkvm_hyp_req(req, ret);
diff --git a/arch/arm64/kvm/trace_pkvm.h b/arch/arm64/kvm/trace_pkvm.h
index 3966c111e3ad..801c6e9aaa4c 100644
--- a/arch/arm64/kvm/trace_pkvm.h
+++ b/arch/arm64/kvm/trace_pkvm.h
@@ -10,8 +10,9 @@
 
 TRACE_DEFINE_ENUM(PKVM_HYP_NO_REQ);
 
-#define PKVM_HYP_REQ_TYPES \
-	{ PKVM_HYP_NO_REQ, "NO_REQ" }
+#define PKVM_HYP_REQ_TYPES			\
+	{ PKVM_HYP_NO_REQ, "NO_REQ" },		\
+	{ PKVM_HYP_REQ_SPLIT, "SPLIT" },
 
 TRACE_EVENT(kvm_handle_pkvm_hyp_req,
 	TP_PROTO(struct pkvm_hyp_req *req, int ret),
-- 
2.55.0.508.g3f0d502094-goog

