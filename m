Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A0C207A08
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371927; cv=none; b=BP9MUQ1uD2qYiHs2JczE3ksMdRyGQX/6MuRNPWgTcs0GaSNRn05NVZAY/ygnrwC9CPDeaFHmAR0gktMs3MUYMc34Mf7riMRFmNMnro6nvVQCrj7XVAasyI3FjVluacBf9dK5PyLvKXwjnRP9kCuadU31zksVNJjlpdBJIiyA8OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371927; c=relaxed/simple;
	bh=FVmnx3tEtWToIEfDoX2uZSWUX5XEpJlCzoydyXN99aM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sj4ZzR0LsCdi00vVadJGvGV7gTSoEkCKs+/bAkpusQAWUIt2v71QAbKpOhyCz+utW3SJ191uZe9E5Hi3y+J1nUVq0hbYSybjnXi1Myax/CYXB/ygnxY6CsEYG0ugJk2IMPCxNlPMWTqakUzR5fCa9rVmmv7HxU9PfBPrLz16n4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P7rTtKkH; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P7rTtKkH"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa6a1bf7a82so326245566b.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371923; x=1734976723; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0WLd7b4UlDBftWKgCzWDkFinsnMNAvtsNvXfdB6R70k=;
        b=P7rTtKkH213oKLHwwPa6uDI+jIYG/4FPrOkut8CTlqxytCI8IyyzxSgWYjp/6B4spN
         l4afu/5/tQ5c4OkZyehIx/pXyHGhCDuwpoQASS7DLeJYRj2dv6W3Yhi12U7kyMl5EjnV
         bL9pD7XJCx46eLty/wXEe0cBpoluyv/e0Vo1NkiiVxf8gqQxHWVGt9aqiQMP5MwYLKMj
         cM9xoxMdEPlHjyNu54rE3PB3wbXRDnjuMIIH4AmoPqdxI7CWfhygpItcbmRQYJAko4Qs
         AL/+h/3k88rKngtZJoOVTusd0J/bH4aBDZ1psoFmd+8jehxMYBIVqCM2ssyAbg7n5Nq+
         KPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371923; x=1734976723;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0WLd7b4UlDBftWKgCzWDkFinsnMNAvtsNvXfdB6R70k=;
        b=fyy8ggX3vZeSrENV1okHta67cqP0eItmGvTUpVrMkXcLYxGfP1ZeXT43c21TVHy2sW
         5LWeATyioN3ldS44/chFynxArboOwEnXtj3AJZOpgCHcvNbfDVPUw/DoMrQzYjVKOb2q
         yW/sQn0SfybfNmeqc7wKYXOruVtza6gYUXAfMNYzKhqIi6G3T+Ku6lf6pzl1VC3IqUL5
         sBZtPdlRJxyRFxRaidXAnBo/B4Rd8vKQ0boUMqoBDsw1oETAo+PEDaXxuU8ZU0V7QbOr
         Yhxi0kMoiTnNrniyDjlP4WuazZeQTFnbVRMXtQ0KNA9X2X/008wr+wGmiAK86F5GxI04
         iVIw==
X-Forwarded-Encrypted: i=1; AJvYcCX8hpEnRgnc3q9yfiE6fPqDzwQyJE2RBljySptxV3N5vKo+fhxbvqmsG7zScH7e1dwx7JdRFEM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0BdRT1trhNhEVIzSI4JJG2wrpVBFKDMHpBaHTnPeBKM3CpMyR
	FX/IGHDNyFzCp/7aRr9AYoEBsyLgem5WW+du4wp9sM0FheTOPAGZYR7MXCeXUuTEvUS0WaopYq4
	yR1XMuA==
X-Google-Smtp-Source: AGHT+IHKLg6kMvyS5z7roX/cFF+XVRsVkjcGlNEAY1Fj07XnCutqrkNlyaRElEPNtXSoIn6/RJ2zk88JSi3I
X-Received: from ejcvg16.prod.google.com ([2002:a17:907:d310:b0:aab:d747:ee70])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:72c6:b0:aa5:2a57:1779
 with SMTP id a640c23a62f3a-aab77eecc9cmr1409090666b.59.1734371923561; Mon, 16
 Dec 2024 09:58:43 -0800 (PST)
Date: Mon, 16 Dec 2024 17:58:03 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-19-qperret@google.com>
Subject: [PATCH v3 18/18] KVM: arm64: Plumb the pKVM MMU in KVM
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce the KVM_PGT_S2() helper macro to allow switching from the
traditional pgtable code to the pKVM version easily in mmu.c. The cost
of this 'indirection' is expected to be very minimal due to
is_protected_kvm_enabled() being backed by a static key.

With this, everything is in place to allow the delegation of
non-protected guest stage-2 page-tables to pKVM, so let's stop using the
host's kvm_s2_mmu from EL2 and enjoy the ride.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h   |  16 +++++
 arch/arm64/kvm/arm.c               |   9 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |   2 -
 arch/arm64/kvm/mmu.c               | 107 +++++++++++++++++++++--------
 4 files changed, 101 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 66d93e320ec8..d116ab4230e8 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -353,6 +353,22 @@ static inline bool kvm_is_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	return &kvm->arch.mmu != mmu;
 }
 
+static inline void kvm_fault_lock(struct kvm *kvm)
+{
+	if (is_protected_kvm_enabled())
+		write_lock(&kvm->mmu_lock);
+	else
+		read_lock(&kvm->mmu_lock);
+}
+
+static inline void kvm_fault_unlock(struct kvm *kvm)
+{
+	if (is_protected_kvm_enabled())
+		write_unlock(&kvm->mmu_lock);
+	else
+		read_unlock(&kvm->mmu_lock);
+}
+
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
 #else
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 55cc62b2f469..9bcbc7b8ed38 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -502,7 +502,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	if (!is_protected_kvm_enabled())
+		kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	else
+		free_hyp_memcache(&vcpu->arch.pkvm_memcache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 	kvm_vgic_vcpu_destroy(vcpu);
@@ -574,6 +577,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
+	if (is_protected_kvm_enabled())
+		goto nommu;
+
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_load_hw_mmu(vcpu);
 
@@ -594,6 +600,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		*last_ran = vcpu->vcpu_idx;
 	}
 
+nommu:
 	vcpu->cpu = cpu;
 
 	kvm_vgic_load(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 130f5f23bcb5..258d572eed62 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -103,8 +103,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	/* Limit guest vector length to the maximum supported by the host.  */
 	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
 
-	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
-
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 641e4fec1659..7c2995cb4577 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -15,6 +15,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_pgtable.h>
+#include <asm/kvm_pkvm.h>
 #include <asm/kvm_ras.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -31,6 +32,14 @@ static phys_addr_t __ro_after_init hyp_idmap_vector;
 
 static unsigned long __ro_after_init io_map_base;
 
+#define KVM_PGT_S2(fn, ...)								\
+	({										\
+		typeof(kvm_pgtable_stage2_ ## fn) *__fn = kvm_pgtable_stage2_ ## fn;	\
+		if (is_protected_kvm_enabled())						\
+			__fn = pkvm_pgtable_ ## fn;					\
+		__fn(__VA_ARGS__);							\
+	})
+
 static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
 					   phys_addr_t size)
 {
@@ -147,7 +156,7 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
 			return -EINVAL;
 
 		next = __stage2_range_addr_end(addr, end, chunk_size);
-		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache);
+		ret = KVM_PGT_S2(split, pgt, addr, next - addr, cache);
 		if (ret)
 			break;
 	} while (addr = next, addr != end);
@@ -168,15 +177,23 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
+	if (is_protected_kvm_enabled())
+		kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
+	else
+		kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 	return 0;
 }
 
 int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
 				      gfn_t gfn, u64 nr_pages)
 {
-	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
-				gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
+	u64 size = nr_pages << PAGE_SHIFT;
+	u64 addr = gfn << PAGE_SHIFT;
+
+	if (is_protected_kvm_enabled())
+		kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
+	else
+		kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
 	return 0;
 }
 
@@ -225,7 +242,7 @@ static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
 	void *pgtable = page_to_virt(page);
 	s8 level = page_private(page);
 
-	kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
+	KVM_PGT_S2(free_unlinked, &kvm_s2_mm_ops, pgtable, level);
 }
 
 static void stage2_free_unlinked_table(void *addr, s8 level)
@@ -280,6 +297,11 @@ static void invalidate_icache_guest_page(void *va, size_t size)
 	__invalidate_icache_guest_page(va, size);
 }
 
+static int kvm_s2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	return KVM_PGT_S2(unmap, pgt, addr, size);
+}
+
 /*
  * Unmapping vs dcache management:
  *
@@ -324,8 +346,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
-	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
-				   may_block));
+	WARN_ON(stage2_apply_range(mmu, start, end, kvm_s2_unmap, may_block));
 }
 
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
@@ -334,9 +355,14 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 	__unmap_stage2_range(mmu, start, size, may_block);
 }
 
+static int kvm_s2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	return KVM_PGT_S2(flush, pgt, addr, size);
+}
+
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
-	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_flush);
+	stage2_apply_range_resched(mmu, addr, end, kvm_s2_flush);
 }
 
 static void stage2_flush_memslot(struct kvm *kvm,
@@ -942,10 +968,14 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		return -ENOMEM;
 
 	mmu->arch = &kvm->arch;
-	err = kvm_pgtable_stage2_init(pgt, mmu, &kvm_s2_mm_ops);
+	err = KVM_PGT_S2(init, pgt, mmu, &kvm_s2_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
+	mmu->pgt = pgt;
+	if (is_protected_kvm_enabled())
+		return 0;
+
 	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
 	if (!mmu->last_vcpu_ran) {
 		err = -ENOMEM;
@@ -959,7 +989,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
 	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
 
-	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
@@ -968,7 +997,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return 0;
 
 out_destroy_pgtable:
-	kvm_pgtable_stage2_destroy(pgt);
+	KVM_PGT_S2(destroy, pgt);
 out_free_pgtable:
 	kfree(pgt);
 	return err;
@@ -1065,7 +1094,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
-		kvm_pgtable_stage2_destroy(pgt);
+		KVM_PGT_S2(destroy, pgt);
 		kfree(pgt);
 	}
 }
@@ -1082,9 +1111,11 @@ static void *hyp_mc_alloc_fn(void *unused)
 
 void free_hyp_memcache(struct kvm_hyp_memcache *mc)
 {
-	if (is_protected_kvm_enabled())
-		__free_hyp_memcache(mc, hyp_mc_free_fn,
-				    kvm_host_va, NULL);
+	if (!is_protected_kvm_enabled())
+		return;
+
+	kfree(mc->mapping);
+	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, NULL);
 }
 
 int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
@@ -1092,6 +1123,12 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
 	if (!is_protected_kvm_enabled())
 		return 0;
 
+	if (!mc->mapping) {
+		mc->mapping = kzalloc(sizeof(struct pkvm_mapping), GFP_KERNEL_ACCOUNT);
+		if (!mc->mapping)
+			return -ENOMEM;
+	}
+
 	return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_fn,
 				    kvm_host_pa, NULL);
 }
@@ -1130,8 +1167,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			break;
 
 		write_lock(&kvm->mmu_lock);
-		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
-					     &cache, 0);
+		ret = KVM_PGT_S2(map, pgt, addr, PAGE_SIZE, pa, prot, &cache, 0);
 		write_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
@@ -1143,6 +1179,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	return ret;
 }
 
+static int kvm_s2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	return KVM_PGT_S2(wrprotect, pgt, addr, size);
+}
 /**
  * kvm_stage2_wp_range() - write protect stage2 memory region range
  * @mmu:        The KVM stage-2 MMU pointer
@@ -1151,7 +1191,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
  */
 void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
-	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_wrprotect);
+	stage2_apply_range_resched(mmu, addr, end, kvm_s2_wrprotect);
 }
 
 /**
@@ -1442,9 +1482,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
 	short vma_shift;
+	void *memcache;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
@@ -1472,8 +1512,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
 	if (!fault_is_perm || (logging_active && write_fault)) {
-		ret = kvm_mmu_topup_memory_cache(memcache,
-						 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
+
+		if (!is_protected_kvm_enabled()) {
+			memcache = &vcpu->arch.mmu_page_cache;
+			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
+		} else {
+			memcache = &vcpu->arch.pkvm_memcache;
+			ret = topup_hyp_memcache(memcache, min_pages);
+		}
 		if (ret)
 			return ret;
 	}
@@ -1494,7 +1541,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active) {
+	if (logging_active || is_protected_kvm_enabled()) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1634,7 +1681,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot |= kvm_encode_nested_level(nested);
 	}
 
-	read_lock(&kvm->mmu_lock);
+	kvm_fault_lock(kvm);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
 		ret = -EAGAIN;
@@ -1696,16 +1743,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * PTE, which will be preserved.
 		 */
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot, flags);
+		ret = KVM_PGT_S2(relax_perms, pgt, fault_ipa, prot, flags);
 	} else {
-		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
+		ret = KVM_PGT_S2(map, pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache, flags);
 	}
 
 out_unlock:
 	kvm_release_faultin_page(kvm, page, !!ret, writable);
-	read_unlock(&kvm->mmu_lock);
+	kvm_fault_unlock(kvm);
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret)
@@ -1724,7 +1771,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	read_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
-	kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa, flags);
+	KVM_PGT_S2(mkyoung, mmu->pgt, fault_ipa, flags);
 	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
@@ -1764,7 +1811,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 
 		/* Falls between the IPA range and the PARange? */
-		if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
+		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
 			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
 
 			if (is_iabt)
@@ -1930,7 +1977,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
+	return KVM_PGT_S2(test_clear_young, kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
 	/*
@@ -1946,7 +1993,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
+	return KVM_PGT_S2(test_clear_young, kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, false);
 }
-- 
2.47.1.613.gc27f4b7a9f-goog

