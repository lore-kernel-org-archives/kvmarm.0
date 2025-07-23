Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E322E2F10
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267654; cv=none; b=gih2AjE1wFmNRdWFbZWNDfp2YhH7si+nwgxIKK0ccyLAd7BIH6rEUwsSRrwS1JNo1hk/XtvvoOCr7tF1vzVS0GW8ObhecpEH4Cy2HxRPoIjpCC1n5UZIJlD6hTttaUJ4auzNIOlAic1Vl4b8Ud+njPPtXckBGIKPeaywmzOAaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267654; c=relaxed/simple;
	bh=I4odZiqpT5ob4lu2mZ8it82J1ZHitKeR782mWtLz8sk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qzhu+ucPsJ/F3YDk0d0iGhEyQnlJ8gjQO4BpXd6Xbnx7U0O40SudBGMAxnTHTOBHcGIWzuCDezPHYmb8hHXYJ+aYYk8z/rQwZl9E3Bs+0v+2ZF0AIWRGr4MvJDE2x9o8cXFJ4gAz6pQ/WRurl9Z6WiyCGbaVkCZPizRvXXh3tbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o6Mp3Iv5; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o6Mp3Iv5"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a50049f8eeso3692448f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267650; x=1753872450; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kNpw8dEYDgHm3c1x7JAg5Wcl6lEIP1F4CrB+GslJPCY=;
        b=o6Mp3Iv5eR1nMPYhf1O6ntIOyRiFZEK7gwsBzP9st7PUCCLMcG4uIaORrx41BhifPb
         sdMm9wbhdcUBNFm1lFveA+xO6cW7nBq8N0RJ+T9nFfj2j+BpPn0CcznLaZce2Va0WzFD
         rRE9DzNLSg7VCkXl2OChfOHzmhjj6SMV4Yw+R13SQJ2KYmQbMMjUvJDuNOyEb4vqh00P
         9v6vaZROtSZMSp2Z6YzEVEv7Uo5hzkMIskpPoGywaZopd16G1PeZTymRc1/FAV46ptd4
         EhMKQ7RDQ7YHrzxxIgeVD4iC+wF22OzUlx2+AXxD8WUthMQx4C9nMRUIQodtURcijCnj
         ofig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267650; x=1753872450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kNpw8dEYDgHm3c1x7JAg5Wcl6lEIP1F4CrB+GslJPCY=;
        b=LeRukGg8Cvkk/6X7uoXe6qsIEbYXvfPwtmfb4CJL3hXVdAVOBFgfcRe58Cu/1Jgiq+
         MJV9HU/PK/xouIQNLqy9MzxHsAfJfKYp6GOtaJHXgTHMSjBQT5jvB/wpt5XpGXp/QnVX
         GZNFrv1DrQM8GSKfA7sxHwSFPShwTbRIVALw9Ez4QPwTNjU0iCAEpjgIGoVHA/hei7ox
         jqojfoMjwvEjChuyUgAS+0imXDsF4js3g5oFc2tRWMt4aNXvKePf/a8KHPaKomOodHfZ
         DtZ4ev3ipatb9ywW/jg1bWdriWdsEKBwA5sbCe7GaKBlj29LLI3HlBW8JEYgSJiaOWTV
         VGIw==
X-Forwarded-Encrypted: i=1; AJvYcCUdugOx1EqznxTKIZrHh45iMgnTSSUVZZdFUKtxb2WMCBAFBRp4xZcWD+/1tmmYgfduMY6DqbA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNee+G6NgW9dJ+RaBhgKAGZucq1FRhIj+DiW7DLNsKAqX+TOPA
	ZqW8jMJ0gp1KSwiILYz5sL15ktDa2h+l+iSpfD9U9f2/QhvqEXQUZAZRw6YoK3/9M1+sMTvzyqG
	M8Q==
X-Google-Smtp-Source: AGHT+IGPjBKj+KAWv4XkFzcfTl/YRyCMWXzAl83SWfZSthKuLUV9vgxqxBfiL6V7YHmBDUBAbKathzOw8w==
X-Received: from wmqa3.prod.google.com ([2002:a05:600c:3483:b0:456:2817:b9ba])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d0f:0:b0:3b7:6716:12c5
 with SMTP id ffacd0b85a97d-3b768f2e272mr2065909f8f.54.1753267649660; Wed, 23
 Jul 2025 03:47:29 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:06 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-15-tabba@google.com>
Subject: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order when
 recovering hugepages
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

From: Sean Christopherson <seanjc@google.com>

Rework kvm_mmu_max_mapping_level() to consult guest_memfd (and relevant)
vendor code when recovering hugepages, e.g. after disabling live migration.
The flaw has existed since guest_memfd was originally added, but has gone
unnoticed due to lack of guest_memfd hugepage support.

Get all information on-demand from the memslot and guest_memfd instance,
even though KVM could pull the pfn from the SPTE.  However, the max
order/level needs to come from guest_memfd, and using kvm_gmem_get_pfn()
avoids adding a new gmem API, and avoids having to retrieve the pfn and
plumb it into kvm_mmu_max_mapping_level() (the pfn is needed for SNP to
consult the RMP).

Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
of the gfn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 83 +++++++++++++++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 3 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 20dd9f64156e..6148cc96f7d4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,31 +3302,55 @@ static u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+					const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	u8 req_max_level;
+	struct page *page;
+	kvm_pfn_t pfn;
+	u8 max_level;
 
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+	/* For faults, use the gmem information that was resolved earlier. */
+	if (fault) {
+		pfn = fault->pfn;
+		max_level = fault->max_level;
+	} else {
+		/* TODO: Constify the guest_memfd chain. */
+		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
+		int max_order, r;
 
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
+		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
+		if (r)
+			return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
+		if (page)
+			put_page(page);
 
-	return max_level;
+		max_level = kvm_max_level_for_order(max_order);
+	}
+
+	if (max_level == PG_LEVEL_4K)
+		return max_level;
+
+	return min(max_level,
+		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
 }
 
-static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
+			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
+	int host_level, max_level;
+	bool is_private;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (fault) {
+		max_level = fault->max_level;
+		is_private = fault->is_private;
+	} else {
+		max_level = PG_LEVEL_NUM;
+		is_private = kvm_mem_is_private(kvm, gfn);
+	}
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3335,25 +3359,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
-	if (is_private)
-		return max_level;
-
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
+	if (is_private)
+		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
+	else
+		host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	bool is_private = kvm_slot_has_gmem(slot) &&
-			  kvm_mem_is_private(kvm, gfn);
-
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
-}
-
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -3374,9 +3389,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						       fault->gfn, fault->max_level,
-						       fault->is_private);
+	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
+						     fault->slot, fault->gfn);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4564,8 +4578,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
 }
@@ -7165,7 +7178,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct &&
-		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
+		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_remote_tlbs_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 65f3c89d7c5d..b776be783a2f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return r;
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
 			      const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..740cb06accdb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
 		if (iter.gfn < start || iter.gfn >= end)
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
 		if (max_mapping_level < iter.level)
 			continue;
 
-- 
2.50.1.470.g6ba607880d-goog

