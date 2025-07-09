Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9794B293B69
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058817; cv=none; b=X7EKWTj5y0vnL55KNrSC99nOIS1+fHmgimC7lBaAL9/tWC6CL3q4n6KjjZuze8SgURgWwExNaxFpZoO9kuukST7B6tkk10lfo4CLHvS4MwN5ScO5XznjpG5Pq4Krf7psmPJpVinsJt4mCOYywcx/cZyCPmF+AhxuLLl/eDZVb2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058817; c=relaxed/simple;
	bh=FMR9sDSSeDgU4gUTz4eUUmDjamlXArj22D/zxO/kOdg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cQ88k9KYeXIKdLoSv8gJLHSu7Z8dSbIyB8N7UVp2gL2cxRBcr0ewmsUS7xR+IntB8ZRPySWW4wh34bJzF1tKLHzxU+9CEA2UORfFwiyRdNm6g+zThb8DZqWZ9wOUFgsNEE2aM+zVPjCaMQaYjHbPWjjdQrRhUKTF9GCgtcohx+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I/LNfolU; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I/LNfolU"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4538f375e86so44706865e9.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058814; x=1752663614; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UaUwxTScFAZ1KHnv3Pyvr3YYeYpiKzC/UYnl14S+xII=;
        b=I/LNfolUBlQAU65CaE9ElRD5aXf6Jhn20G09VsdVfO08Y+XdCjgn2LkqqTUAEv4eK8
         R6G1E3YATDkXT2bChLK7p4woafarfMCJTldZKREiXzldNmJ3whbX/HOi3ud2pWqKz1f9
         ydhRJrNOQzD245pCCJ5qkFoeaoDrY7hle/KMwZa0iBOnDcw+jqw4OJ7loRHbhBAam5dY
         yhdAuq+9Z9KEjlhHPwOU1UbQBemTJrsgC6fZ01pc1xlsnWPHMXcjKWgcgsBkEmRtmujX
         IXKDHlv/eH26l8M8EE9RNDzWiLcbI2xBUGp3dwG5amzGF7U1TDk059YUXCYViN2WQq3g
         sJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058814; x=1752663614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UaUwxTScFAZ1KHnv3Pyvr3YYeYpiKzC/UYnl14S+xII=;
        b=vMYkKNRXljYgDTbgasp3i4RWP9aRD2dAKUqfrD5xci4PUyCzFZ4VyxCGYbUNIYbt+5
         lxHcJ7iL7UUYjsxXjcBcV0+oXm5rMbvSpYqTgvneDmX0350A4HEIKG2JGD49X/3MiOZX
         k9QNz1rjamKRTW2GBDObMumA8IfsH1ZkFBzAz6LAuYj3zj0clxfBk5A2X+y6R7DI64xf
         lSKqL5GsaM7vdoJ3vVyaeDOAOmyejyIbP1hTgNgSYWYKBigVUSXtmpzLwCmrHwFlKzNr
         Vunv7PVW4juETAUDxe97XMP7+6dvGK0QRjoQn8TT4Q2iBB9zvIPshlzLeRZuul1tHGLY
         GAZg==
X-Forwarded-Encrypted: i=1; AJvYcCVfkP+/eXI35qnTakPgnLKk7YDRlfUGW9zpFCa2iv/WgWqm9YxBaXOIRq+FAn4XldYdskKLRO0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5tioVsJ8h5TsMJ1ZZmsNZ7YNoEGifOgK/v2yQOeTmZdE941uE
	dF4elcg1DQaotT7E0Q4KyL1I01ter8AXhu8MTTcQr/pUduczkbgZKoQZeX4Yyaxt8V/dmQZLfhL
	c6w==
X-Google-Smtp-Source: AGHT+IGMn7XkMgrUdBk/ivBuJpGwNPA2Q7ebQymW3M2klLX0THE5Cc8XW0j7s3/fzZMIZ9xlnwtAe0ePng==
X-Received: from wmqd14.prod.google.com ([2002:a05:600c:34ce:b0:453:86cc:7393])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e09:b0:43c:fa24:873e
 with SMTP id 5b1f17b1804b1-454d532656emr20423845e9.13.1752058813962; Wed, 09
 Jul 2025 04:00:13 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:38 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-13-tabba@google.com>
Subject: [PATCH v13 12/20] KVM: x86/mmu: Consult guest_memfd when computing max_mapping_level
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Modify kvm_mmu_max_mapping_level() to consult guest_memfd for memory
regions backed by it when computing the maximum mapping level,
especially during huge page recovery.

Previously, kvm_mmu_max_mapping_level() was designed primarily for
host-backed memory and private pages. With guest_memfd now supporting
non-private memory, it's necessary to factor in guest_memfd's influence
on mapping levels for such memory.

Since guest_memfd can now be used for non-private memory, make
kvm_max_max_mapping_level, when recovering huge pages, take input from
guest_memfd.

Input is taken from guest_memfd as long as a fault to that slot and gfn
would have been served from guest_memfd. For now, take a shortcut if the
slot and gfn points to memory that is private, since recovering huge
pages aren't supported for private memory yet.

Since guest_memfd memory can also be faulted into host page tables,
__kvm_mmu_max_mapping_level() still applies since consulting lpage_info
and host page tables are required.

Move functions kvm_max_level_for_order() and
kvm_gmem_max_mapping_level() so kvm_mmu_max_mapping_level() can use
those functions.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 90 ++++++++++++++++++++++++----------------
 include/linux/kvm_host.h |  7 ++++
 virt/kvm/guest_memfd.c   | 17 ++++++++
 3 files changed, 79 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 495dcedaeafa..6d997063f76f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3282,13 +3282,67 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 	return min(host_level, max_level);
 }
 
+static u8 kvm_max_level_for_order(int order)
+{
+	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
+
+	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
+		return PG_LEVEL_1G;
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
+				     struct kvm_page_fault *fault)
+{
+	u8 req_max_level;
+	u8 max_level;
+
+	max_level = kvm_max_level_for_order(order);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
+	if (req_max_level)
+		max_level = min(max_level, req_max_level);
+
+	return max_level;
+}
+
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	bool is_private = kvm_slot_has_gmem(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
+	int max_level = PG_LEVEL_NUM;
+
+	/*
+	 * For now, kvm_mmu_max_mapping_level() is only called from
+	 * kvm_mmu_recover_huge_pages(), and that's not yet supported for
+	 * private memory, hence we can take a shortcut and return early.
+	 */
+	if (is_private)
+		return PG_LEVEL_4K;
 
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
+	/*
+	 * For non-private pages that would have been faulted from guest_memfd,
+	 * let guest_memfd influence max_mapping_level.
+	 */
+	if (kvm_memslot_is_gmem_only(slot)) {
+		int order = kvm_gmem_mapping_order(slot, gfn);
+
+		max_level = min(max_level,
+				kvm_gmem_max_mapping_level(kvm, order, NULL));
+	}
+
+	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level, is_private);
 }
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -4450,40 +4504,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		vcpu->stat.pf_fixed++;
 }
 
-static inline u8 kvm_max_level_for_order(int order)
-{
-	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
-
-	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
-		return PG_LEVEL_1G;
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
-		return PG_LEVEL_2M;
-
-	return PG_LEVEL_4K;
-}
-
-static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
-				     struct kvm_page_fault *fault)
-{
-	u8 req_max_level;
-	u8 max_level;
-
-	max_level = kvm_max_level_for_order(order);
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
-
-	return max_level;
-}
-
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d2218ec57ceb..662271314778 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2574,6 +2574,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
+int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2583,6 +2584,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
+					 gfn_t gfn)
+{
+	WARN_ONCE(1, "Unexpected call since gmem is disabled.");
+	return 0;
+}
 #endif /* CONFIG_KVM_GMEM */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2b00f8796a15..d01bd7a2c2bd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -713,6 +713,23 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
+/**
+ * kvm_gmem_mapping_order() - Get the mapping order for this @gfn in @slot.
+ *
+ * @slot: the memslot that gfn belongs to.
+ * @gfn: the gfn to look up mapping order for.
+ *
+ * This is equal to max_order that would be returned if kvm_gmem_get_pfn() were
+ * called now.
+ *
+ * Return: the mapping order for this @gfn in @slot.
+ */
+int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_mapping_order);
+
 #ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
-- 
2.50.0.727.gbf7dc18ff4-goog

