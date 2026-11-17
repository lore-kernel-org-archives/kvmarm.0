Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937464;
	b=fI9cmRgNCYH/pAtzIHdnnWvz046IrseYwfMTDi7OenoUcweV//D0G5drkH0WVzGkL8aq
	 mJw1AncenNUk8KOhvQqfqAgt++MRxFv27aFQs7kgrzz6m2l8RdF1J0ggcQq2p3eKyYfCN
	 YpjA4a/g21cQNobEh5xfeUlwvjAVr2QOcsQ3mFcydJI+Qd8Y1SReFNwuTfuVeR4qWVqxr
	 3LIOqWRVQXY7TGMGSRH0sur2gk0MZPS8Iv39B7vmltGOrt6lpUqt156kk2ZGtnYWQKceJ
	 Ji5AHoaN2RD2B7uYTpm7Of7vy4sBqZycVQGUKbUHIZZAnhqlikUWiXORgpqzPVH+3+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937464;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=VMrFoBiqnqC9tIoSTJNjvrF9y5PTc50wr5w0TnkAf0o=;
	b=z/8svADq39fGR2+40nMd/Y0jIr1H4Utdg1vcmGJIht8lCfd79uRPJNcgOVSclCtb+GGQ
	 Yp9w4xWUYev4mygsJZMjksoC3m/TTYDksSLa3OvMOIgI9XJcibrcxXeqR0pJpdD+u+pR4
	 36hG9CV3MWQ336hCCaSuL9dVHmzyAzXgfO5PxbZcuv5NHlQsDl3dkk42kXjwqOyv5zq2T
	 TLqb29+Cu8dBnbLkeozG22Dnd0FNB0h7g+CW0xdCe9Lj1rYMai6k+nlykyMF24FFKwkUj
	 p/1a2KWeHsvdA8bklOadQ5BGg3VxSpmj0ulxHKH3U6dVwNmFNL4DjTcQsTV3HI8zntg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="kj/5elvI";
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E388A606A335
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E388A606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kj/5elvI
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4a370217dcfso29531f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937462; x=1795542262; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VMrFoBiqnqC9tIoSTJNjvrF9y5PTc50wr5w0TnkAf0o=;
        b=kj/5elvIybgHxEtR8L2+5vWj34p1Ikp5cfp5LDaaFm78xfNKcsdmuxQzVy5FY8PNWI
         7saoiSxAbvh3S0mZYvsjiIyDf/KLdjfgaubWHUSYc6Wve+NQEKx4RAGvU/k6j4i0MmyS
         B06q+plz9e1UVfAlYCnEb8ed5hSlJXCuhoe+amp+KtXjKPzH6u47Vo3hUfmpRirGxU0o
         pVAwqVIt3mh2W29bWMnhTU11zBWQuCxoOOKTlujCtd29l1KjhjevmIE9o+6QJnT/TxWd
         Fynkx8XD9RvRZyLWFYJKP5Jm73q2BGd80gR1Iexq2/r+wAK2E2iGDrl/6MD+L1YwbmBh
         /QCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937462; x=1795542262;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VMrFoBiqnqC9tIoSTJNjvrF9y5PTc50wr5w0TnkAf0o=;
        b=Cuq3hCZU3KQC4Cro9xyW+V9IICXlTqsPPkE4eDr5OFDmnpsBCjAXKUrwMDMqtkkhhK
         1LL24sedeZ3aaZJt8ACl52jV6DFAiWjIsgdIIhQF7anAcKeLGGputRd0BJABKaNHmc3z
         +j1tLhxuxJ2yDlJDs6ojr/uHTh9ShDADp6LucTi3uCS5Qq3Ge5lJso0GbbPih+pZCyVC
         dmJQqmf8Imd4pmcWsAv83IiVtBr6+0qg5Iqx+vVOKuERb9QskgUSTtjjFtNmi2frSJH8
         GmvPmg5wMgJ81Oyc7D/TG9h4DsnVAHRCRZlF5nEfWdX6nJctx0T7YnI/PB8Gx3ulLpQH
         uMuw==
X-Forwarded-Encrypted: i=1; AL+hErGzBH/Wb+y8IssIgv1e13vKFwLm/Q5wlwn5pAuiIS+l/CR5u/M4XaCW7QNaiZYh6xz8/hvayOE=@lists.linux.dev
X-Gm-Message-State: APuU4Z9Y3XUu7vxlMC+arW88uILLlBxvrThvFcmcfayoUqWFZKW9HED8
	ZAi5od5oqJ8pzGntub3E4tyEwqWzT2XinX5aNhGpciKqhPZwrx06uuhphpzAvO5V4Z5Y6VNVulg
	TiyBPM/rmQW2W+Yjb6id13Q==
X-Received: from wmuh1.prod.google.com ([2002:a05:600d:4121:b0:4a1:f082:d6ca])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ecd:b0:4a2:1655:87db with SMTP id 5b1f17b1804b1-4bb5599d31bmr319808335e9.0.1794937462147;
 Tue, 17 Nov 2026 09:44:22 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:44 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-6-vdonnefort@google.com>
Subject: [PATCH v4 05/23] KVM: arm64: Make pKVM ownership selftest an HVC
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for testing the pKVM ownership with huge mappings,
refactor the selftest to be triggered via an HVC using dynamically
allocated memory from the host. This avoids wasting memory which would
be even worse for testing ownership transitions for huge stage-2
mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/include/asm/kvm_hcall.h            |  2 +
 arch/arm64/include/asm/kvm_pkvm.h             |  6 ---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 ++--
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  4 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  7 ++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 39 +++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 12 +++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  8 ----
 arch/arm64/kvm/pkvm.c                         | 42 +++++++++++++++++--
 10 files changed, 92 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index abda476e023d..ed7bd93aea1b 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -63,6 +63,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_selftest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_ownership_selftest,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdpend,
diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index 5f77a8aa2963..64d18b7f2392 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -156,6 +156,8 @@ DECLARE_KVM_HOST_HCALL0(void, __kvm_enable_ssbs)
 DECLARE_KVM_HOST_HCALL0(void, __vgic_v3_init_lrs)
 DECLARE_KVM_HOST_HCALL0(u64, __vgic_v3_get_gic_config)
 DECLARE_KVM_HOST_HCALL0(int, __pkvm_hyp_alloc_selftest)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_ownership_selftest,
+	u64, pfn, u64, pgtable_pfn, unsigned long, pgtable_nr_pages)
 
 DECLARE_KVM_HOST_HCALL0(int, __pkvm_prot_finalize)
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fd042d2b5462..b75dc3d03a98 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -193,12 +193,6 @@ static inline unsigned long host_s2_pgtable_pages(void)
 	return res;
 }
 
-#ifdef CONFIG_NVHE_EL2_DEBUG
-static inline unsigned long pkvm_selftest_pages(void) { return 32; }
-#else
-static inline unsigned long pkvm_selftest_pages(void) { return 0; }
-#endif
-
 #define KVM_FFA_MBOX_NR_PAGES	1
 
 static inline unsigned long hyp_ffa_proxy_pages(void)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ec85a9547120..a1c9c71beb36 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -76,10 +76,9 @@ static __always_inline void __load_host_stage2(void)
 }
 
 #ifdef CONFIG_NVHE_EL2_DEBUG
-void pkvm_ownership_selftest(void *base);
-struct pkvm_hyp_vcpu *init_selftest_vm(void *virt);
-void teardown_selftest_vm(void);
+int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr_pages);
 #else
-static inline void pkvm_ownership_selftest(void *base) { }
+static inline int
+__pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr_pages) { return 0; }
 #endif
 #endif /* __KVM_NVHE_MEM_PROTECT__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 0261b2bc681f..aa5cf5568504 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -133,6 +133,10 @@ bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
 void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
+#ifdef CONFIG_NVHE_EL2_DEBUG
+struct pkvm_hyp_vcpu *init_selftest_vm(void *virt, u64 nr_pages);
+void teardown_selftest_vm(void);
+#endif
 
 int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *vm, unsigned long mpidr);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 179d7c8277b8..bf3d13a15b2f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1313,6 +1313,12 @@ DEFINE_KVM_HOST_HCALL(ulong, __pkvm_create_private_mapping,
 	return haddr;
 }
 
+DEFINE_KVM_HOST_HCALL(int, __pkvm_ownership_selftest,
+	u64, pfn, u64, pgtable_pfn, unsigned long, pgtable_nr_pages)
+{
+	return __pkvm_ownership_selftest(pfn, pgtable_pfn, pgtable_nr_pages);
+}
+
 DEFINE_KVM_HOST_HCALL0(int, __pkvm_prot_finalize)
 {
 	return __pkvm_prot_finalize();
@@ -1550,6 +1556,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_init_lrs),
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
 	HANDLE_FUNC(__pkvm_hyp_alloc_selftest),
+	HANDLE_FUNC(__pkvm_ownership_selftest),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 
 	HANDLE_FUNC(__kvm_adjust_pc),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 58094d52b8a2..8d5bfae67396 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1768,24 +1768,36 @@ static void assert_page_state(void)
 		assert_page_state();			\
 	} while (0)
 
-void pkvm_ownership_selftest(void *base)
+int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr_pages)
 {
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RWX;
-	void *virt = hyp_alloc_pages(&host_s2_pool, 0);
 	struct pkvm_hyp_vcpu *vcpu;
-	u64 phys, size, pfn, gfn;
 	struct pkvm_hyp_vm *vm;
+	u64 phys, size, gfn;
+	void *virt;
+	int ret;
 
-	WARN_ON(!virt);
-	selftest_page = hyp_virt_to_page(virt);
-	selftest_page->refcount = 0;
-	selftest_vcpu = vcpu = init_selftest_vm(base);
+	ret = __pkvm_host_donate_hyp(pgtable_pfn, pgtable_nr_pages);
+	if (ret)
+		return ret;
+
+	ret = __pkvm_host_donate_hyp(pfn, 1);
+	if (ret) {
+		WARN_ON(__pkvm_hyp_donate_host(pgtable_pfn, pgtable_nr_pages));
+		return ret;
+	}
+
+	selftest_vcpu = vcpu = init_selftest_vm(hyp_phys_to_virt(hyp_pfn_to_phys(pgtable_pfn)),
+						pgtable_nr_pages);
 	vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 
-	size = PAGE_SIZE << selftest_page->order;
-	phys = hyp_virt_to_phys(virt);
-	pfn = hyp_phys_to_pfn(phys);
+	phys = hyp_pfn_to_phys(pfn);
+	virt = hyp_phys_to_virt(phys);
 	gfn = hyp_phys_to_pfn(selftest_ipa());
+	size = PAGE_SIZE;
+
+	selftest_page = hyp_virt_to_page(virt);
+	selftest_page->refcount = 0;
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.hyp = PKVM_PAGE_OWNED;
@@ -1946,8 +1958,11 @@ void pkvm_ownership_selftest(void *base)
 	selftest_state.hyp = PKVM_PAGE_OWNED;
 	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, 1);
 
+	/* This also gives back the ownership to the host */
 	teardown_selftest_vm();
-	selftest_page->refcount = 1;
-	hyp_put_page(&host_s2_pool, virt);
+
+	WARN_ON(__pkvm_hyp_donate_host(pfn, 1));
+
+	return 0;
 }
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fc0475f0877d..ae34c09f1f39 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -843,7 +843,7 @@ static struct pkvm_hyp_vcpu selftest_vcpu = {
 	},
 };
 
-struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
+struct pkvm_hyp_vcpu *init_selftest_vm(void *virt, u64 nr_pages)
 {
 	struct hyp_page *p = hyp_virt_to_page(virt);
 	unsigned long min_pages, seeded = 0;
@@ -859,7 +859,7 @@ struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
 	 */
 	min_pages = kvm_mmu_cache_min_pages(&selftest_vm.kvm.arch.mmu);
 
-	for (i = 0; i < pkvm_selftest_pages(); i++) {
+	for (i = 0; i < nr_pages; i++) {
 		if (p[i].refcount)
 			continue;
 		p[i].refcount = 1;
@@ -879,9 +879,17 @@ struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
 
 void teardown_selftest_vm(void)
 {
+	struct kvm_hyp_memcache *vcpu_mc = &selftest_vcpu.vcpu.arch.stage2_mc;
+	struct kvm_hyp_memcache mc = { 0 };
+
+	while (vcpu_mc->nr_pages)
+		hyp_put_page(&selftest_vm.pool, pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt));
+
 	hyp_spin_lock(&vm_table_lock);
 	remove_vm_table_entry(selftest_vm.kvm.arch.pkvm.handle);
 	hyp_spin_unlock(&vm_table_lock);
+
+	reclaim_pgtable_pages(&selftest_vm, &mc);
 }
 #endif /* CONFIG_NVHE_EL2_DEBUG */
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e72b7626799d..b2a953adedc3 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -29,7 +29,6 @@ static void *vmemmap_base;
 static void *vm_table_base;
 static void *hyp_pgt_base;
 static void *host_s2_pgt_base;
-static void *selftest_base;
 static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
@@ -40,11 +39,6 @@ static int divide_memory_pool(void *virt, unsigned long size)
 
 	hyp_early_alloc_init(virt, size);
 
-	nr_pages = pkvm_selftest_pages();
-	selftest_base = hyp_early_alloc_contig(nr_pages);
-	if (nr_pages && !selftest_base)
-		return -ENOMEM;
-
 	nr_pages = hyp_vmemmap_pages(sizeof(struct hyp_page));
 	vmemmap_base = hyp_early_alloc_contig(nr_pages);
 	if (!vmemmap_base)
@@ -385,8 +379,6 @@ void __noreturn __pkvm_init_finalise(void)
 		goto out;
 
 	pkvm_hyp_vm_table_init(vm_table_base);
-
-	pkvm_ownership_selftest(selftest_base);
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 016997288fd2..29e7a51a1c03 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -64,7 +64,6 @@ void __init kvm_hyp_reserve(void)
 	hyp_mem_pages += host_s2_pgtable_pages();
 	hyp_mem_pages += hyp_vm_table_pages();
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
-	hyp_mem_pages += pkvm_selftest_pages();
 	hyp_mem_pages += hyp_ffa_proxy_pages();
 
 	/*
@@ -333,9 +332,36 @@ static int __init pkvm_drop_host_privileges(void)
 	return ret;
 }
 
-static void __init pkvm_selftests(void)
-{
 #ifdef CONFIG_NVHE_EL2_DEBUG
+static void __init pkvm_ownership_selftest(void)
+{
+	unsigned long pgtable_order = 5;
+	unsigned long pgtable = 0;
+	unsigned long page = 0;
+	long ret = -ENOMEM;
+
+	/* Memory for the VM page-table */
+	pgtable = __get_free_pages(GFP_KERNEL, pgtable_order);
+	if (!pgtable)
+		goto out;
+
+	/* Page whose ownership will be tested */
+	page = __get_free_page(GFP_KERNEL);
+	if (!page)
+		goto out;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_ownership_selftest, virt_to_pfn((void *)page),
+				virt_to_pfn((void *)pgtable), 1 << pgtable_order);
+out:
+	if (ret)
+		kvm_err("pKVM ownership selftest failed (%ld)\n", ret);
+
+	free_pages(pgtable, pgtable_order);
+	free_page(page);
+}
+
+static void __init pkvm_hyp_alloc_selftest(void)
+{
 	int ret = pkvm_call_hyp_req(__pkvm_hyp_alloc_selftest);
 	unsigned long reclaimed;
 
@@ -346,9 +372,17 @@ static void __init pkvm_selftests(void)
 		WARN_ON(reclaimed != 6 /* SELFTEST_MAX_PAGES */);
 	else
 		kvm_err("pKVM hyp allocator selftest failed (%d)\n", ret);
-#endif
 }
 
+static void __init pkvm_selftests(void)
+{
+	pkvm_ownership_selftest();
+	pkvm_hyp_alloc_selftest();
+}
+#else
+static void __init pkvm_selftests(void) { }
+#endif
+
 static unsigned long pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	unsigned long reclaimable = 0;
-- 
2.56.1.708.g77570a6a1d-goog

