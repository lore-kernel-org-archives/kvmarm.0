Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE344854F2
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134694; cv=none; b=chfllEr55goR2dXKuahg0pjrJBOdHlxWFXE38CuJwIJf8PJbmL0sRFykQrYRXpuEgtHMrebxoM2lE/UN6PAH1ZHz1I2Bhancmf5+AOC90Hq4gshV7GErdtT4cDemcIyrQW/L/lSha+62yNAU/pPrtnYvnsb7ubIEZGkW6/mNbPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134694; c=relaxed/simple;
	bh=kcZR6sW1vOF1hGakdl9jt/VpVKmdEyYcEWpM8tljOjc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=odBOaYS9NfVUoYvW66wogLLHlF/2HXnyKGBHpqD5TRaiRKkBSBYne4QvJ+t+GnENQLJp4iIe/WtneqzMcJx8orp96/tsIOqqXMEl95Im9G2MwDHDZj1TMnmDqTk9HEcpBT3WM1Zlozc4FqhOydrAZwBFBLWqkxZ3K7714xyYLyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rLFvvDzP; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rLFvvDzP"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-486f1ecf9bbso153604f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134686; x=1789739486; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0VYYV6aC0VuQBjkk34XBrVlB6hVFJMMtfQoGOAROiRk=;
        b=rLFvvDzPHnq96XAeyXaoxtz8qaenMYEYq+hUhVQ6W+We9/OFzWSit8DG9vOLajKVmY
         kxNbOwnhQg5zT8a5a2Rr4fT6Q5Of2XyZgY4RHlk0Xrt1Z4nJp7OHEAY2lx7noJefCul1
         /8hXrFDCzd0Ar9+mlWa5XPbN6oYKYJq2G7MR+sZTl/E85lKkAyQHZ+hbqEZ3KTSkQzys
         sooPetTk4fCpvh9xZibJy3l7ybzv7eDjL0BHp/yrKFI1hKc+1wElQ1676AqwMXT1NA6s
         b/BZF2RE/YI/DUxMakFuyN6+Pa+tCwfub24BdlvjjYnvPbeuJdpp+iiI2ZfrU4ll/v0o
         L3Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134686; x=1789739486;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0VYYV6aC0VuQBjkk34XBrVlB6hVFJMMtfQoGOAROiRk=;
        b=ObDWUltDVc+zntqq41XhisaZsZrIwmhORQw3OS0bCBzoRmZCSZKA2sN2XWwxgs0dnM
         LegUw6ybsnTGcwuVpoUwOFlkingPCcWbBexs54oZG327ECBRHkUT3/Bcc66zW8+GjhQ7
         Fh+IAfWCVSCFYJUs9caTsLu6DbGl7PBO2T2QY9FAPUCAYqrq3WRW44K8UFUP/IuKhiAJ
         YK6elg+KEWUfE8w0Ftm+PMAVBXQvoKTRCsOJzH2cB/Fp1in75RPfdklYWXwNA2+1MugJ
         qW4yd+4jhjifRiYmN8C+pEu5g1Z4H7KYpR+VMEaTyUAArc4TfhSpFVf/5rNEBFNbKKlh
         R+Jw==
X-Forwarded-Encrypted: i=1; AKwUvBxx+9gfFVlKYE/A4zEIzelU5xhSQqrltQbQbh5nqKUbbf2IGlIS0iIcBz/Y8h6jGDagP7rk2C0=@lists.linux.dev
X-Gm-Message-State: AFuF++kb0xJr48j5fXefmYuX1OMDErB1Nt4LjLQvvhQRIHkka3Vx3ncy
	3jCye8ZgTvZU7NG8TRlKgwAw7YAyex0NXPEw9uR7D3mR1ZPe3aef/lgLKMQN1aSOJ1Gf3aPzXSn
	5mDt9U2ha9tukzrC9dcFwOQ==
X-Received: from wmpr23.prod.google.com ([2002:a05:600c:3217:b0:499:c849:1518])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8a1a:10b0:49c:ee22:364c with SMTP id 5b1f17b1804b1-49e6198d0a6mr38001395e9.9.1789134685985;
 Fri, 11 Sep 2026 06:51:25 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:51 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-21-vdonnefort@google.com>
Subject: [PATCH v2 20/22] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
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
---
 arch/arm64/include/asm/kvm_host.h |   7 ++
 arch/arm64/include/asm/kvm_pkvm.h |   5 +-
 arch/arm64/kvm/pkvm.c             | 145 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/trace_pkvm.h       |   5 +-
 4 files changed, 159 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ea76c0f3120e..c4cb2232d4c8 100644
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
index 7240dcc4f395..33c94f353eda 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -196,7 +196,10 @@ static inline size_t pkvm_host_sve_state_size(void)
 }
 
 struct pkvm_mapping {
-	struct rb_node node;
+	union {
+		struct rb_node node;
+		struct list_head list;
+	};
 	u64 gfn;
 	u64 pfn;
 	struct {
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 02ad686d7661..2840053ef2f4 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -362,6 +362,64 @@ INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
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
+		m = kzalloc_obj(*m, GFP_KERNEL_ACCOUNT);
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
@@ -624,6 +682,73 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
+	struct pkvm_mapping *mapping;
+	struct kvm *kvm = vcpu->kvm;
+	struct list_head spares;
+	u64 nr_pages;
+	int ret;
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
+	nr_pages = (size / PAGE_SIZE) - 1;
+
+	INIT_LIST_HEAD(&spares);
+	ret = pkvm_mapping_alloc_spares(&spares, nr_pages);
+	if (ret)
+		return ret;
+
+	write_lock(&kvm->mmu_lock);
+
+	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, ipa, ipa + size - 1);
+	if (!mapping) {
+		ret = -EPERM;
+		goto unlock_mmu;
+	} else if (mapping->nr_pages == 1) {
+		/* We've raced with another vCPU */
+		ret = 0;
+		goto unlock_mmu;
+	} else if (mapping->nr_pages * PAGE_SIZE != PMD_SIZE) {
+		ret = -EINVAL;
+		goto unlock_mmu;
+	}
+
+	ret = folio_add_pins(page_folio(pfn_to_page(mapping->pfn)), nr_pages);
+	if (ret)
+		goto unlock_mmu;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_host_split_guest, gpa_to_gfn(ipa), size / PAGE_SIZE);
+	if (ret) {
+		for (int i = 0; i < nr_pages; i++)
+			unpin_user_page(pfn_to_page(mapping->pfn + 1 + i));
+		goto unlock_mmu;
+	}
+
+	pkvm_mapping_split(mapping, pgt, &spares);
+
+unlock_mmu:
+	write_unlock(&kvm->mmu_lock);
+	pkvm_mapping_free_spares(&spares);
+
+	return ret;
+}
+
 /*
  * Forcefully reclaim a page from the guest, zeroing its contents and
  * poisoning the stage-2 pte so that pages can no longer be mapped at
@@ -636,11 +761,31 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
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
2.55.0.1007.g17ff1f9808-goog

