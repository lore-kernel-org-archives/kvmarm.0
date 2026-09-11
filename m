Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9616B13D886
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134671; cv=none; b=oQvz43eTXZdMGVKdeyxMBdbk0T6pDmgmKOYxx47HSDCm1droXKFvdnPfKLTUZpMKoRK38M/fdgatCkk4b2mUJk2MkPv0vXfmSSIrpbbZUxGfHDq3yIZcvAsDPNX+wuBGlu1B8eqFmoH3QMOuXjRme1qj55EMLDIDlnnVFdJ7uP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134671; c=relaxed/simple;
	bh=bmqgANpLi8Y2RY4tnSCrxP7wDkUayHv/l+GEF7udYZ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tEt0HOzWekHlpUU/gKEbuFtkQr6GI3fuuRWndeXtdRjHVGfj4bP0QGYC3BTMwv5v+axuuwQq914EguznN3Rx6Y7vheEBaSNNwKvy+umV3ddrQV8HdLNQ+ZrvrWaJsrNUSRVcYPBbk1JvgBJvTq2FLyABudYbA2DYLdMRMOPxsI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dKLnPC2A; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dKLnPC2A"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49b0e6638e3so7168765e9.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134668; x=1789739468; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AkCT1ho/uvoDJ+UpX9D2PLGW4nyUKa4Cm7tHEYRfN5c=;
        b=dKLnPC2ArJEINGKO7Oqm+UauY8CZcQHvJPOaj1A6f+Fg4ZgrJohVIQozVT3FcTXvNh
         ZJp0S96Y7uO7lY4FUx0/0kkjmhBE1D26gMIbQDI32+m40EWkIuEDX1O0/QbT0Bmi5uKC
         JTurOPkI/dbQf7+2c8eVJmTfcQz0oF5ckMNDP8f1LdX24Szfea9BViKCEu76coShjvIY
         33upzjGccVja6DD1Am/RuAQgaoPKthX2rlDtnNeZF2iLIY2p/pOZdEGL9kpknctfVtOx
         2DY5fIdF8C2SbBNCftPBWO/hnaJxjmirWSpBvednlKk6A5gr4CNZPSSrm1gsGNedt9Vi
         jujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134668; x=1789739468;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AkCT1ho/uvoDJ+UpX9D2PLGW4nyUKa4Cm7tHEYRfN5c=;
        b=Wqdl4alBdwTLPqQqOL84+MKP+XjiHbJuX5cLBtkMXHqAzhtm3rw4bhRP6xUsjDq2uq
         rGaaI6BT2TsHJ95ifhPGEcF/yUMJ5nFQcxvO/t+618GhPGgKO+3EzpRygcUpnTmHSYdP
         6oCJN5oleJ2MwRiKajMBuoaUaRPBP0wUTArnnfRdvRuqDkBfb2IXCSx9039Ss5F8tczT
         dCAbksMHvtqSS5vjHSl4CTKYyJwEFUPxRAbyR8GDdjYrffZIyneisL9Hr68RB7ywBul4
         mSfv6q3mEznHUtLNkyHBhpKsZazYlpVTC5aDaDIDBWH4t0gXD/SySRWiq6210L2758Dq
         roYA==
X-Forwarded-Encrypted: i=1; AKwUvBzSMn4PKpte9TZoSXM+xw+DThAr4MCI2MT86h8CWuSs/Qx1dwpYYWMpWXC+2Nr49MaAKboRfiw=@lists.linux.dev
X-Gm-Message-State: AFuF++nMnHFvG5w2xy9hShVxmo50d1Jf4PWIXtwV9oH8Sd2LHFuVMBOX
	2qImdX8k3ap/XI0FO7uZ9YGxjZdE0fd2s1Vr/aXvS+D9MIXOrPlTupvSBwJMrfLbH6xGsvAIuGg
	/jmEQFMQh2h8uUx6mO6Cg0w==
X-Received: from wmfv12.prod.google.com ([2002:a05:600c:15cc:b0:49d:1cf4:ba1a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:474c:b0:49c:fa21:e74a with SMTP id 5b1f17b1804b1-49e619e4e91mr51950335e9.32.1789134667334;
 Fri, 11 Sep 2026 06:51:07 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:36 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-6-vdonnefort@google.com>
Subject: [PATCH v2 05/22] KVM: arm64: Make pKVM ownership selftest an HVC
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
 arch/arm64/include/asm/kvm_pkvm.h             | 12 +++---
 arch/arm64/kvm/arm.c                          |  2 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 ++--
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  4 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 10 +++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 39 +++++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 12 +++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  8 ----
 arch/arm64/kvm/pkvm.c                         | 30 +++++++++++++-
 10 files changed, 92 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69..7fdec5d98201 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -62,6 +62,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
+	__KVM_HOST_SMCCC_FUNC___pkvm_ownership_selftest,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MIN_PKVM),
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index beea00e693a0..ff8e93efcd7a 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -23,6 +23,12 @@ bool pkvm_hyp_vm_is_created(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+void pkvm_ownership_selftest(void);
+#else
+static inline void pkvm_ownership_selftest(void) { }
+#endif
+
 /*
  * Check whether the specific capability is allowed in pKVM.
  *
@@ -161,12 +167,6 @@ static inline unsigned long host_s2_pgtable_pages(void)
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
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..fb36e73a8ffb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2914,6 +2914,8 @@ static int __init init_hyp_mode(void)
 			kvm_err("Failed to init hyp memory protection\n");
 			goto out_err;
 		}
+
+		pkvm_ownership_selftest();
 	}
 
 	return 0;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 29935c7da1de..e2a5d7ffec7d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -74,10 +74,9 @@ static __always_inline void __load_host_stage2(void)
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
index c904647d2f76..f04cea5ff389 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -93,5 +93,9 @@ bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
+#ifdef CONFIG_NVHE_EL2_DEBUG
+struct pkvm_hyp_vcpu *init_selftest_vm(void *virt, u64 nr_pages);
+void teardown_selftest_vm(void);
+#endif
 
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626ad..9fbe703fc595 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -751,6 +751,15 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 	cpu_reg(host_ctxt, 1) = haddr;
 }
 
+static void handle___pkvm_ownership_selftest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, pfn, host_ctxt, 1);
+	DECLARE_REG(u64, pgtable_pfn, host_ctxt, 2);
+	DECLARE_REG(unsigned long, pgtable_nr_pages, host_ctxt, 3);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_ownership_selftest(pfn, pgtable_pfn, pgtable_nr_pages);
+}
+
 static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 {
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
@@ -911,6 +920,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_enable_ssbs),
 	HANDLE_FUNC(__vgic_v3_init_lrs),
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
+	HANDLE_FUNC(__pkvm_ownership_selftest),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 
 	HANDLE_FUNC(__kvm_adjust_pc),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c3676243fddc..183ecd7058cf 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1748,24 +1748,36 @@ static void assert_page_state(void)
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
@@ -1926,8 +1938,11 @@ void pkvm_ownership_selftest(void *base)
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
index 459bd9eb7e4b..ad9afe2cd1b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -762,7 +762,7 @@ static struct pkvm_hyp_vcpu selftest_vcpu = {
 	},
 };
 
-struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
+struct pkvm_hyp_vcpu *init_selftest_vm(void *virt, u64 nr_pages)
 {
 	struct hyp_page *p = hyp_virt_to_page(virt);
 	unsigned long min_pages, seeded = 0;
@@ -778,7 +778,7 @@ struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
 	 */
 	min_pages = kvm_mmu_cache_min_pages(&selftest_vm.kvm.arch.mmu);
 
-	for (i = 0; i < pkvm_selftest_pages(); i++) {
+	for (i = 0; i < nr_pages; i++) {
 		if (p[i].refcount)
 			continue;
 		p[i].refcount = 1;
@@ -798,9 +798,17 @@ struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
 
 void teardown_selftest_vm(void)
 {
+	struct kvm_hyp_memcache *vcpu_mc = &selftest_vcpu.vcpu.arch.pkvm_memcache;
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
index 22200bb50990..38d3212f8678 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -28,7 +28,6 @@ static void *vmemmap_base;
 static void *vm_table_base;
 static void *hyp_pgt_base;
 static void *host_s2_pgt_base;
-static void *selftest_base;
 static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
@@ -39,11 +38,6 @@ static int divide_memory_pool(void *virt, unsigned long size)
 
 	hyp_early_alloc_init(virt, size);
 
-	nr_pages = pkvm_selftest_pages();
-	selftest_base = hyp_early_alloc_contig(nr_pages);
-	if (nr_pages && !selftest_base)
-		return -ENOMEM;
-
 	nr_pages = hyp_vmemmap_pages(sizeof(struct hyp_page));
 	vmemmap_base = hyp_early_alloc_contig(nr_pages);
 	if (!vmemmap_base)
@@ -365,8 +359,6 @@ void __noreturn __pkvm_init_finalise(void)
 		goto out;
 
 	pkvm_hyp_vm_table_init(vm_table_base);
-
-	pkvm_ownership_selftest(selftest_base);
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec12..b88c1fcaadbd 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -61,7 +61,6 @@ void __init kvm_hyp_reserve(void)
 	hyp_mem_pages += host_s2_pgtable_pages();
 	hyp_mem_pages += hyp_vm_table_pages();
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
-	hyp_mem_pages += pkvm_selftest_pages();
 	hyp_mem_pages += hyp_ffa_proxy_pages();
 
 	/*
@@ -257,6 +256,35 @@ static void __init _kvm_host_prot_finalize(void *arg)
 		WRITE_ONCE(*err, -EINVAL);
 }
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+void __init pkvm_ownership_selftest(void)
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
+		kvm_err("Failed to run %s (%ld)\n", __func__, ret);
+
+	free_pages(pgtable, pgtable_order);
+	free_page(page);
+}
+#endif
+
 static int __init pkvm_drop_host_privileges(void)
 {
 	int ret = 0;
-- 
2.55.0.1007.g17ff1f9808-goog

