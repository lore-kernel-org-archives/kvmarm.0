Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38FE425884;
	Thu, 16 Jul 2026 14:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211004; cv=none; b=j0TALeQjbf4RICX/UxSU4kCogypgg0NolXsTLeALMzuLnXy1wEmCZb0zbLRgtvJRNuTWENO6cUb0zIT7D8Xsb8Zlat8QOvfQWbBF1JqolTc8anolZN/X/yvW4Bodr4qMM4jC7ck+QfR8iaHgIhifjN1KzWEV6nj+Zx85+plPf8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211004; c=relaxed/simple;
	bh=Qkq4WHhNG2sp8SakFb2ZAOUpg/WLOqCsLiXhN2MZPFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaBusuAF2yn7vSa5aTcpQNQIaR7RLm1CckzTMQpmw5gbmfsFrAegpV1KrwzqYD1QsUeXvFEicWgUQzlKXTcXGEuHLmjKc5GYcVMpUTOrj4sew07c19HFNIEpzxpM9yWJRqB7l4AoKhFt2brbkbTYuz5TUyOR8WwjJHmu/FuIGBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I74tlGvr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I74tlGvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E6D1F00A3A;
	Thu, 16 Jul 2026 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784211002;
	bh=qVn/qwPXA97H6053Zd5tcPuPNzdGfESKigCqcNfJyJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I74tlGvrFWwGVKwTtbJ3bETrDuWXDc1tJqvFSERH63hVCDVaDxplfDOtvlbOB30kb
	 A1QK3LXx4dc0Ezu32LEOgk/pwAtoNhii8H89q76g/n/tjxdrGBSYR+Jst3x6XsF3Oa
	 qNKkjq/AWPRDBESqA0yCiN+PSOyWmKzDGLa9SJGITwhB7/ehrWba/dk3tkRZTpssrn
	 UEmxg7GOqer9ku3wM2X44lZVYJfss2XobeqF69A4njU6SO4a2M1MRzklOk/6hsrljF
	 /nIDVSViR0/EfEcPtmwugZSW142+deMgK8QlQkz4Cd4tTRppm0HT1n+b2/VsnWwIOx
	 f4FMZ6MSDEa1Q==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [RFC PATCH 3/5] KVM: arm64: Split hyp VA-to-PA conversion by address type
Date: Thu, 16 Jul 2026 19:39:34 +0530
Message-ID: <20260716140936.4003182-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
References: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing hyp VA-to-PA conversion uses one physvirt offset for both
kernel-image symbols and linear-map addresses. This only works while both
address types use the same EL2 VA transformation.

With hVHE TTBR1, hyp symbols retain their kernel-image VAs while pools,
per-CPU data and shared memory remain linear-map-derived. Introduce a
separate symbol physvirt offset and explicit symbol and linear conversion
helpers.

Update every caller according to its address type and remove the
ambiguous hyp_pa and __hyp_pa helpers. The offsets remain same as
hyp_physvirt_offset, making this preparatory for the TTBR1 layout.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h        |  2 ++
 arch/arm64/include/asm/kvm_mmu.h         | 17 ++++++++++++-----
 arch/arm64/kvm/arm.c                     |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 13 +++++++------
 arch/arm64/kvm/hyp/nvhe/early_alloc.c    |  1 +
 arch/arm64/kvm/hyp/nvhe/events.c         |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S           |  4 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 14 +++++++-------
 arch/arm64/kvm/hyp/nvhe/mm.c             | 11 ++++++-----
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     | 12 ++++++------
 arch/arm64/kvm/hyp/nvhe/setup.c          |  4 ++--
 arch/arm64/kvm/va_layout.c               |  2 ++
 12 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..d92e0d066de3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -827,6 +827,8 @@ extern struct kvm_host_psci_config kvm_nvhe_sym(kvm_host_psci_config);
 
 extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
 #define hyp_physvirt_offset CHOOSE_NVHE_SYM(hyp_physvirt_offset)
+extern s64 kvm_nvhe_sym(hyp_symbol_physvirt_offset);
+#define hyp_symbol_physvirt_offset CHOOSE_NVHE_SYM(hyp_symbol_physvirt_offset)
 
 extern u64 kvm_nvhe_sym(hyp_cpu_logical_map)[NR_CPUS];
 #define hyp_cpu_logical_map CHOOSE_NVHE_SYM(hyp_cpu_logical_map)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 8c2972aa83b0..bcc8e28985f7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -54,15 +54,21 @@
 #include <asm/alternative.h>
 
 /*
- * Convert a hypervisor VA to a PA
+ * Convert an address in the hypervisor linear map to a PA
  * reg: hypervisor address to be converted in place
  * tmp: temporary register
  */
-.macro hyp_pa reg, tmp
+.macro hyp_linear_pa reg, tmp
 	ldr_l	\tmp, hyp_physvirt_offset
 	add	\reg, \reg, \tmp
 .endm
 
+/* Convert a hypervisor kernel-image VA to a PA. */
+.macro hyp_symbol_pa reg, tmp
+	ldr_l	\tmp, hyp_symbol_physvirt_offset
+	add	\reg, \reg, \tmp
+.endm
+
 /*
  * Convert a hypervisor VA to a kernel image address
  * reg: hypervisor address to be converted in place
@@ -74,8 +80,8 @@
  * specific registers encoded in the instructions).
  */
 .macro hyp_kimg_va reg, tmp
-	/* Convert hyp VA -> PA. */
-	hyp_pa	\reg, \tmp
+	/* Convert hyp kernel-image VA -> PA. */
+	hyp_symbol_pa	\reg, \tmp
 
 	/* Load kimage_voffset. */
 alternative_cb ARM64_ALWAYS_SYSTEM, kvm_get_kimage_voffset
@@ -106,7 +112,6 @@ void kvm_compute_layout(void);
 u32 kvm_hyp_va_bits(void);
 void kvm_apply_hyp_relocations(void);
 
-#define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
 /**
  * kvm_hyp_kimg_kaddr - Select the kernel address used for an EL2 mapping
  * @ptr: Address within the kernel image
@@ -130,6 +135,8 @@ static __always_inline void *kvm_hyp_kimg_kaddr(void *ptr)
 	return lm_alias(ptr);
 }
 
+#define __hyp_linear_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
+#define __hyp_symbol_pa(x) (((phys_addr_t)(x)) + hyp_symbol_physvirt_offset)
 /*
  * Convert a kernel VA into a HYP VA.
  *
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e498bb780382..924f33c1a9d4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2835,7 +2835,7 @@ static int __init init_hyp_mode(void)
 		/*
 		 * Save the stack PA in nvhe_init_params. This will be needed
 		 * to recreate the stack mapping in protected nVHE mode.
-		 * __hyp_pa() won't do the right thing there, since the stack
+		 * __hyp_linear_pa() won't do the right thing there, since the stack
 		 * has been mapped in the flexible private VA space.
 		 */
 		params->stack_pa = __pa(stack_base);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index b50712d47f6d..a7c3e70f7256 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -73,16 +73,17 @@ struct hyp_page {
 extern u64 __hyp_vmemmap;
 #define hyp_vmemmap ((struct hyp_page *)__hyp_vmemmap)
 
-#define __hyp_va(phys)	((void *)((phys_addr_t)(phys) - hyp_physvirt_offset))
+#define __hyp_linear_va(phys) \
+	((void *)((phys_addr_t)(phys) - hyp_physvirt_offset))
 
 static inline void *hyp_phys_to_virt(phys_addr_t phys)
 {
-	return __hyp_va(phys);
+	return __hyp_linear_va(phys);
 }
 
 static inline phys_addr_t hyp_virt_to_phys(void *addr)
 {
-	return __hyp_pa(addr);
+	return __hyp_linear_pa(addr);
 }
 
 #define hyp_phys_to_pfn(phys)	((phys) >> PAGE_SHIFT)
@@ -94,12 +95,12 @@ static inline struct hyp_page *hyp_phys_to_page(phys_addr_t phys)
 	return &hyp_vmemmap[hyp_phys_to_pfn(phys)];
 }
 
-#define hyp_virt_to_page(virt)	hyp_phys_to_page(__hyp_pa(virt))
-#define hyp_virt_to_pfn(virt)	hyp_phys_to_pfn(__hyp_pa(virt))
+#define hyp_virt_to_page(virt)	hyp_phys_to_page(__hyp_linear_pa(virt))
+#define hyp_virt_to_pfn(virt)	hyp_phys_to_pfn(__hyp_linear_pa(virt))
 
 #define hyp_page_to_pfn(page)	((struct hyp_page *)(page) - hyp_vmemmap)
 #define hyp_page_to_phys(page)  hyp_pfn_to_phys((hyp_page_to_pfn(page)))
-#define hyp_page_to_virt(page)	__hyp_va(hyp_page_to_phys(page))
+#define hyp_page_to_virt(page)	__hyp_linear_va(hyp_page_to_phys(page))
 #define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
 
 static inline enum pkvm_page_state get_host_state(struct hyp_page *p)
diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
index 00de04153cc6..6002c61ae62c 100644
--- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
@@ -11,6 +11,7 @@
 
 struct kvm_pgtable_mm_ops hyp_early_alloc_mm_ops;
 s64 __ro_after_init hyp_physvirt_offset;
+s64 __ro_after_init hyp_symbol_physvirt_offset;
 
 static unsigned long base;
 static unsigned long end;
diff --git a/arch/arm64/kvm/hyp/nvhe/events.c b/arch/arm64/kvm/hyp/nvhe/events.c
index add9383aadb5..4204cf81f0e4 100644
--- a/arch/arm64/kvm/hyp/nvhe/events.c
+++ b/arch/arm64/kvm/hyp/nvhe/events.c
@@ -17,7 +17,7 @@ int __tracing_enable_event(unsigned short id, bool enable)
 	if (event_id >= __hyp_event_ids_end)
 		return -EINVAL;
 
-	enabled = hyp_fixmap_map(__hyp_pa(&event_id->enabled));
+	enabled = hyp_fixmap_map(__hyp_symbol_pa(&event_id->enabled));
 	atomic_set(enabled, enable);
 	hyp_fixmap_unmap();
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 9393fe3ea6a1..079788f152d1 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -133,7 +133,7 @@ SYM_FUNC_START(__hyp_do_panic)
 	mrs	x0, esr_el2
 	mov	x4, x3
 	mov	x3, x2
-	hyp_pa	x3, x6
+	hyp_symbol_pa	x3, x6
 	get_vcpu_ptr x5, x6
 	mrs	x6, far_el2
 	mrs	x7, hpfar_el2
@@ -163,7 +163,7 @@ alternative_else_nop_endif
 	 * Preserve x0-x4, which may contain stub parameters.
 	 */
 	adr_l	x5, __kvm_handle_stub_hvc
-	hyp_pa	x5, x6
+	hyp_symbol_pa	x5, x6
 	br	x5
 SYM_FUNC_END(__host_hvc)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7f815345d6a5..593359d04053 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -175,7 +175,7 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	if (ret)
 		return ret;
 
-	mmu->pgd_phys = __hyp_pa(host_mmu.pgt.pgd);
+	mmu->pgd_phys = __hyp_linear_pa(host_mmu.pgt.pgd);
 	mmu->pgt = &host_mmu.pgt;
 	atomic64_set(&mmu->vmid.id, 0);
 
@@ -243,9 +243,9 @@ static void __apply_guest_page(void *va, size_t size,
 		void *map;
 
 		if (IS_ALIGNED((unsigned long)va, PMD_SIZE) && size >= PMD_SIZE)
-			map = hyp_fixblock_map(__hyp_pa(va), &map_size);
+			map = hyp_fixblock_map(__hyp_linear_pa(va), &map_size);
 		else
-			map = hyp_fixmap_map(__hyp_pa(va));
+			map = hyp_fixmap_map(__hyp_linear_pa(va));
 
 		func(map, map_size);
 
@@ -300,7 +300,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 	if (ret)
 		return ret;
 
-	vm->kvm.arch.mmu.pgd_phys = __hyp_pa(vm->pgt.pgd);
+	vm->kvm.arch.mmu.pgd_phys = __hyp_linear_pa(vm->pgt.pgd);
 
 	return 0;
 }
@@ -1092,7 +1092,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 size = PAGE_SIZE * nr_pages;
-	void *virt = __hyp_va(phys);
+	void *virt = __hyp_linear_va(phys);
 	int ret;
 
 	if (!pfn_range_is_valid(pfn, nr_pages))
@@ -1123,7 +1123,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 size = PAGE_SIZE * nr_pages;
-	u64 virt = (u64)__hyp_va(phys);
+	u64 virt = (u64)__hyp_linear_va(phys);
 	int ret;
 
 	if (!pfn_range_is_valid(pfn, nr_pages))
@@ -1158,7 +1158,7 @@ int hyp_pin_shared_mem(void *from, void *to)
 {
 	u64 cur, start = ALIGN_DOWN((u64)from, PAGE_SIZE);
 	u64 end = PAGE_ALIGN((u64)to);
-	u64 phys = __hyp_pa(start);
+	u64 phys = __hyp_linear_pa(start);
 	u64 size = end - start;
 	struct hyp_page *p;
 	int ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 9150ff94b01a..061fca95a78a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -159,7 +159,7 @@ int pkvm_create_symbol_mappings(void *from, void *to,
 				enum kvm_pgtable_prot prot)
 {
 	unsigned long start = (unsigned long)from & PAGE_MASK;
-	phys_addr_t phys = __hyp_pa(start);
+	phys_addr_t phys = __hyp_symbol_pa(start);
 	int ret;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
@@ -242,7 +242,7 @@ int hyp_map_vectors(void)
 		return 0;
 	}
 
-	phys = __hyp_pa(__bp_harden_hyp_vecs);
+	phys = __hyp_symbol_pa(__bp_harden_hyp_vecs);
 	ret = __pkvm_create_private_mapping(phys, __BP_HARDEN_HYP_VECS_SZ,
 					    PAGE_HYP_EXEC, &bp_base);
 	if (ret)
@@ -418,7 +418,8 @@ int hyp_create_fixmap(void)
 			return ret;
 
 		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, PAGE_SIZE,
-					  __hyp_pa(__hyp_bss_start), PAGE_HYP);
+					  __hyp_symbol_pa(__hyp_bss_start),
+					  PAGE_HYP);
 		if (ret)
 			return ret;
 
@@ -434,10 +435,10 @@ int hyp_create_idmap(u32 hyp_va_bits)
 {
 	unsigned long start, end;
 
-	start = hyp_virt_to_phys((void *)__hyp_idmap_text_start);
+	start = __hyp_symbol_pa(__hyp_idmap_text_start);
 	start = ALIGN_DOWN(start, PAGE_SIZE);
 
-	end = hyp_virt_to_phys((void *)__hyp_idmap_text_end);
+	end = __hyp_symbol_pa(__hyp_idmap_text_end);
 	end = ALIGN(end, PAGE_SIZE);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index e20db999e328..91b658ac74ee 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -139,8 +139,8 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	wmb();
 
 	ret = psci_call(func_id, mpidr,
-			__hyp_pa(&kvm_hyp_cpu_entry),
-			__hyp_pa(init_params));
+			__hyp_symbol_pa(&kvm_hyp_cpu_entry),
+			__hyp_linear_pa(init_params));
 
 	/* If successful, the lock will be released by the target CPU. */
 	if (ret != PSCI_RET_SUCCESS)
@@ -173,8 +173,8 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	 * point if it is a deep sleep state.
 	 */
 	return psci_call(func_id, power_state,
-			 __hyp_pa(&kvm_hyp_cpu_resume),
-			 __hyp_pa(init_params));
+			 __hyp_symbol_pa(&kvm_hyp_cpu_resume),
+			 __hyp_linear_pa(init_params));
 }
 
 static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
@@ -197,8 +197,8 @@ static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 
 	/* Will only return on error. */
 	return psci_call(func_id,
-			 __hyp_pa(&kvm_hyp_cpu_resume),
-			 __hyp_pa(init_params), 0);
+			 __hyp_symbol_pa(&kvm_hyp_cpu_resume),
+			 __hyp_linear_pa(init_params), 0);
 }
 
 static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long r0)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 66a3d01cd79e..2ef1972cc3dd 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -169,7 +169,7 @@ static void update_nvhe_init_params(void)
 
 	for (i = 0; i < hyp_nr_cpus; i++) {
 		params = per_cpu_ptr(&kvm_init_params, i);
-		params->pgd_pa = __hyp_pa(pkvm_pgtable.pgd);
+		params->pgd_pa = __hyp_linear_pa(pkvm_pgtable.pgd);
 		dcache_clean_inval_poc((unsigned long)params,
 				    (unsigned long)params + sizeof(*params));
 	}
@@ -371,7 +371,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
 
 	/* Jump in the idmap page to switch to the new page-tables */
 	params = this_cpu_ptr(&kvm_init_params);
-	fn = (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
+	fn = (typeof(fn))__hyp_symbol_pa(__pkvm_init_switch_pgd);
 	fn(params->pgd_pa, params->stack_hyp_va, __pkvm_init_finalise);
 
 	unreachable();
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 63bb58a7868a..75a89ad8fecf 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -44,6 +44,8 @@ static void init_hyp_physvirt_offset(void)
 	kern_va = (u64)lm_alias(__hyp_text_start);
 	hyp_va = __early_kern_hyp_va(kern_va);
 	hyp_physvirt_offset = (s64)__pa(kern_va) - (s64)hyp_va;
+
+	hyp_symbol_physvirt_offset = hyp_physvirt_offset;
 }
 
 /*
-- 
2.43.0

