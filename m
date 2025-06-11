Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D411E2BD030
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648836; cv=none; b=KPpNhhiXf95Gs9p5FhVV21pcie/gLeJLYWYtwRe8RGzK8Uy4A5gvB4sj5/WE+60xH1IYMOkNk2Uy6aI3EySXeJq8hL3YcFmDUNz+0kQe+bvogWI+M5ZcdL05h41ed6D8BLc+YLGc9DerAcPcIeWLeooDlAUlY7ASZf753OHE7SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648836; c=relaxed/simple;
	bh=ndUTJwepqYwEfponWZYA+LKiY/F05t1HO7+9wLu2cKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sjmL99wRwT7+PT31QVJ4AtBCuc62gclvYFGu7ML/jhrFmu4YmsPbUWXlOhk0D+ghY7nT0lCKMm5Y/lb/ENGVNzadHXIAk8EkE6Gb8cn2tbn/mtVLYZB8QKTNjX0oDeAP1SHLQXoETyazFBsXK7OO0qOKmE1XHLDfajfQ53NleRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=COGAs0xv; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="COGAs0xv"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450eaae2934so59537045e9.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648833; x=1750253633; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VsETe8JP2RK+jwc0W86kgeiqvrWmEHj3D0sgGemuJ58=;
        b=COGAs0xvIhxd468eoPFfJfSs8D2r5oMnstGTmNhoMamfLMOqp2bwW6EUwQFN8M2YUS
         QzGb9giXobIzvQjDglx+k7ALhG0bNJX7LWUvLoy7uVRl2z35B3u076UCS6e8WPf7OBpg
         BWTAwiMxRASetQ/QZ3kSnQgKvV+40UCmGVoyK7mvEnNcehuA4Gbcc6kVHMQnO5dSOT4y
         JOmoDGDv4NZ/LUKxuAj+76258ufeRRkMGgghYWsMupFEIYD8Rr/HoYF4dkrV0VF9jUhE
         NyoGQb6gGSoKbZ5S56tZWuRuHWU49xRf7VMyUgNqfh+OiZJzqAKt5pHtbhU1dTniKgVy
         M9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648833; x=1750253633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VsETe8JP2RK+jwc0W86kgeiqvrWmEHj3D0sgGemuJ58=;
        b=LUN/asuSV615fXeDOCm4gyk0azOge6atN9HERLqh8WKyrYSwZAV1LcN3AIj2nfYkeN
         xYgxHhlIpJYOJLa4U0Z2jesKcm0HAc10eypXk8hY8UbFIX5aL+8BjFr6LMC5MjBSuoP3
         6/u4I0sh3eCMnrOqnkMCZjJQrhvMjwKLzsX51ku/MSzgqcmyPG/5MJ7IoF2ZqM4TI7Ek
         EekAhvAKRtLl4/xOdH5KS77e1bXj5BlQ4Y2jhLCU00PrZJVYwIHf0HlkqiSKoTK69m5+
         +d6Ni+PGG+kQcHz76Dg32Iz70u/kddxDxgLcPXW2vyKqBKy3T8Sd0NWR6Vz3ya1YD8Sf
         Q2lA==
X-Forwarded-Encrypted: i=1; AJvYcCW23fY16fD6TXxz0COxjG43rMAsc5wn6WP8nQ49HEWRvHkb09NJxoVgnVnl6nh61x4Wppjhlv8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx71+cTWKIkFYpcTZWZxTWbzxcq8jwYEqNTnVjD5Id+IEzF0JJ/
	Nyh+Sbb+8eGVeSgstIWN4GGBy3MmKJe6I0N9yC0T2BhyYj8x/Z9GhD9flbsi3QGNeA/VgCN3nR3
	e7Q==
X-Google-Smtp-Source: AGHT+IEOpTQLWb/W99hYWPydN9AF4WxIXy9RQ1ao2fIs6Oh5u3U5LCTeCP7RQZ+lgMAn59d3H/C1V9UDvQ==
X-Received: from wmbhe6.prod.google.com ([2002:a05:600c:5406:b0:453:f28:e99f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:190e:b0:442:dcdc:41c8
 with SMTP id 5b1f17b1804b1-45325965490mr23058795e9.19.1749648833055; Wed, 11
 Jun 2025 06:33:53 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:22 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-11-tabba@google.com>
Subject: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
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

For memslots backed by guest_memfd with shared mem support, the KVM MMU
must always fault in pages from guest_memfd, and not from the host
userspace_addr. Update the fault handler to do so.

This patch also refactors related function names for accuracy:

kvm_mem_is_private() returns true only when the current private/shared
state (in the CoCo sense) of the memory is private, and returns false if
the current state is shared explicitly or impicitly, e.g., belongs to a
non-CoCo VM.

kvm_mmu_faultin_pfn_gmem() is updated to indicate that it can be used to
fault in not just private memory, but more generally, from guest_memfd.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 38 +++++++++++++++++++++++---------------
 include/linux/kvm_host.h | 25 +++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 75b7b02cfcb7..2aab5a00caee 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3291,6 +3291,11 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
 }
 
+static inline bool fault_from_gmem(struct kvm_page_fault *fault)
+{
+	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
+}
+
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -4467,21 +4472,25 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,
+					    struct kvm_page_fault *fault,
+					    int order)
 {
-	u8 req_max_level;
+	u8 max_level = fault->max_level;
 
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	max_level = min(kvm_max_level_for_order(order), max_level);
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
+	if (fault->is_private) {
+		u8 level = kvm_x86_call(private_max_mapping_level)(kvm, fault->pfn);
+
+		if (level)
+			max_level = min(max_level, level);
+	}
 
 	return max_level;
 }
@@ -4493,10 +4502,10 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				 r == RET_PF_RETRY, fault->map_writable);
 }
 
-static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-				       struct kvm_page_fault *fault)
+static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
-	int max_order, r;
+	int gmem_order, r;
 
 	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
@@ -4504,15 +4513,14 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &fault->refcounted_page, &max_order);
+			     &fault->refcounted_page, &gmem_order);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_level_for_fault_and_order(vcpu->kvm, fault, gmem_order);
 
 	return RET_PF_CONTINUE;
 }
@@ -4522,8 +4530,8 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private)
-		return kvm_mmu_faultin_pfn_private(vcpu, fault);
+	if (fault_from_gmem(fault))
+		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bba7d2c14177..8f7069385189 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2547,10 +2547,31 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 
+/*
+ * Returns true if the given gfn's private/shared status (in the CoCo sense) is
+ * private.
+ *
+ * A return value of false indicates that the gfn is explicitly or implicitly
+ * shared (i.e., non-CoCo VMs).
+ */
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return IS_ENABLED(CONFIG_KVM_GMEM) &&
-	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
+	struct kvm_memory_slot *slot;
+
+	if (!IS_ENABLED(CONFIG_KVM_GMEM))
+		return false;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
+		/*
+		 * Without in-place conversion support, if a guest_memfd memslot
+		 * supports shared memory, then all the slot's memory is
+		 * considered not private, i.e., implicitly shared.
+		 */
+		return false;
+	}
+
+	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
-- 
2.50.0.rc0.642.g800a2b2222-goog

