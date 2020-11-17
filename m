Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688F6C5519F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D2C632222C
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="vj91rGly"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2C632222C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2F44B8B9;
	Tue, 17 Nov 2020 13:17:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DD7qNkHtsNgu; Tue, 17 Nov 2020 13:17:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 544E84B7AC;
	Tue, 17 Nov 2020 13:17:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1C14B559
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nQeNGPaDH98u for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:58 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95B434B891
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:57 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id o19so2145212wme.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=MgizBMNnQpOXMuPbGh3Gv9pNQJdacDwGgNswbIKCgRM=;
 b=vj91rGlyBUiDaweBntl+5cvf32le9A/39kXxtbIkljG8ZEKn/l/CPd8HLS2CKj5WZz
 AnOXzv5VnD2+DDeBd1baBNBOt3sJC1ZZzjXs/+RjCpAxMaxU5MoJ5uLPYCq8so+TzN+m
 Lk9ci5ay+OQF82KAc7Na5JPfCxpOmzFkgXsc22LYMpnjKGZ1utArWX4ApIRtVwdzXUCw
 Q8/tshlSiEGdcHIqAYDr6YajRx8x/B+OMGMERGdEUUxq7tTg09BwiD0MowhQtAbEP0Q6
 mbqVsNcMNMO1q45lm2lpgzdYzjd/w0Hl4DBRWqJH/E9LRVRdPqy5O8neqkIeKISnsgzf
 QwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MgizBMNnQpOXMuPbGh3Gv9pNQJdacDwGgNswbIKCgRM=;
 b=IYLIjWCxnKeO6gaqQv3XTQ9H1jf3XZHsCNGEyH5iqgYlnzR5w50MK7mwc0NMTgzMtl
 qSrz8lDR7cmSZQ1eNp+pVRLC+DBovGwQ8TmBnExzcXYv+i+HeSq8qDuuoVRXAZi1Dkn+
 HNKYHw+IOsQtvc01pDY/OfnovLC3mQd0eYAaoFZA290iFRDjWXty4Od3DGKqw7oXuPgD
 DicAjPMsyTNu0tUmMPQVVKyomW0QGMegusAt77IQE7UuNPP9pydlr0Ex4b9yYpz6+Sg1
 +OmqpQqvA3yJPrZ+EaY2wqP1qbbP00KO+dNAHpYemoWEPBEqUQradFb3ov225vhzMno0
 zRhg==
X-Gm-Message-State: AOAM5316G450z8rfTC5v67qtbiLGgKkcRsFc1FWW/uGBXZMnyjRD+66H
 32Y72U5s4wiuu5a0gDgnqzdFvTHr+0b/
X-Google-Smtp-Source: ABdhPJz2eJqLEtX4wrSz5wgqPzcYPIYZ6U19THDj7bMfThHVEgY3yn4Tbc9CIRdWeU2TS/IWvG6covmrMsxf
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a1c:658b:: with SMTP id
 z133mr353482wmb.1.1605637016704; Tue, 17 Nov 2020 10:16:56 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:56 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-17-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

When memory protection is enabled, the Hyp code needs the ability to
create and manage its own page-table. To do so, introduce a new set of
hypercalls to initialize Hyp memory protection.

During the init hcall, the hypervisor runs with the host-provided
page-table and uses the trivial early page allocator to create its own
set of page-tables, using a memory pool that was donated by the host.
Specifically, the hypervisor creates its own mappings for __hyp_text,
the Hyp memory pool, the __hyp_bss, the portion of hyp_vmemmap
corresponding to the Hyp pool, among other things. It then jumps back in
the idmap page, switches to use the newly-created pgd (instead of the
temporary one provided by the host) and then installs the full-fledged
buddy allocator which will then be the only one in used from then on.

Note that for the sake of symplifying the review, this only introduces
the code doing this operation, without actually being called by anyhing
yet. This will be done in a subsequent patch, which will introduce the
necessary host kernel changes.

Credits to Will for __kvm_init_switch_pgd.

Co-authored-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h         |   6 +-
 arch/arm64/include/asm/kvm_host.h        |   8 +
 arch/arm64/include/asm/kvm_hyp.h         |   8 +
 arch/arm64/kernel/cpufeature.c           |   2 +-
 arch/arm64/kernel/image-vars.h           |  19 +++
 arch/arm64/kvm/hyp/Makefile              |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h |   6 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h     |  79 +++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile         |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S       |  30 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       |  44 +++++
 arch/arm64/kvm/hyp/nvhe/mm.c             | 175 ++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     |   2 -
 arch/arm64/kvm/hyp/nvhe/setup.c          | 196 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/reserved_mem.c        |  75 +++++++++
 arch/arm64/kvm/mmu.c                     |   2 +-
 arch/arm64/mm/init.c                     |   3 +
 17 files changed, 653 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mm.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/mm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/setup.c
 create mode 100644 arch/arm64/kvm/hyp/reserved_mem.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e4934f5e4234..9266b17f8ba9 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -57,6 +57,10 @@
 #define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
+#define __KVM_HOST_SMCCC_FUNC___kvm_hyp_protect			15
+#define __KVM_HOST_SMCCC_FUNC___hyp_create_mappings		16
+#define __KVM_HOST_SMCCC_FUNC___hyp_create_private_mapping	17
+#define __KVM_HOST_SMCCC_FUNC___hyp_cpu_set_vector		18
 
 #ifndef __ASSEMBLY__
 
@@ -171,7 +175,7 @@ struct kvm_vcpu;
 struct kvm_s2_mmu;
 
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
-DECLARE_KVM_NVHE_SYM(__kvm_hyp_host_vector);
+DECLARE_KVM_HYP_SYM(__kvm_hyp_host_vector);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
 #define __kvm_hyp_init			CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_host_vector		CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7a5d5f4b3351..ee8bb8021637 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -742,4 +742,12 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
+#ifdef CONFIG_KVM
+extern phys_addr_t hyp_mem_base;
+extern phys_addr_t hyp_mem_size;
+void __init reserve_kvm_hyp(void);
+#else
+static inline void reserve_kvm_hyp(void) { }
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 95a2bbbcc7e1..dbd2ef86afa9 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -105,5 +105,13 @@ void __noreturn hyp_panic(void);
 void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
 #endif
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+void __kvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
+			   phys_addr_t pgd, void *sp, void *cont_fn);
+int __kvm_hyp_protect(phys_addr_t phys, unsigned long size,
+		      unsigned long nr_cpus, unsigned long *per_cpu_base);
+void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
+#endif
+
 #endif /* __ARM64_KVM_HYP_H__ */
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3bc86d1423f8..010458f6d799 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1722,7 +1722,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 #endif /* CONFIG_ARM64_MTE */
 
 #ifdef CONFIG_KVM
-static bool enable_protected_kvm;
+bool enable_protected_kvm;
 
 static bool has_protected_kvm(const struct arm64_cpu_capabilities *entry, int __unused)
 {
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c35d768672eb..f2d43e6cd86d 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -118,6 +118,25 @@ __kvm_nvhe___memset			= __kvm_nvhe___pi_memset;
 
 _kvm_nvhe___flush_dcache_area		= __kvm_nvhe___pi___flush_dcache_area;
 
+/* Hypevisor VA size */
+KVM_NVHE_ALIAS(hyp_va_bits);
+
+/* Kernel memory sections */
+KVM_NVHE_ALIAS(__start_rodata);
+KVM_NVHE_ALIAS(__end_rodata);
+KVM_NVHE_ALIAS(__bss_start);
+KVM_NVHE_ALIAS(__bss_stop);
+
+/* Hyp memory sections */
+KVM_NVHE_ALIAS(__hyp_idmap_text_start);
+KVM_NVHE_ALIAS(__hyp_idmap_text_end);
+KVM_NVHE_ALIAS(__hyp_text_start);
+KVM_NVHE_ALIAS(__hyp_text_end);
+KVM_NVHE_ALIAS(__hyp_data_ro_after_init_start);
+KVM_NVHE_ALIAS(__hyp_data_ro_after_init_end);
+KVM_NVHE_ALIAS(__hyp_bss_start);
+KVM_NVHE_ALIAS(__hyp_bss_end);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 687598e41b21..b726332eec49 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,4 +10,4 @@ subdir-ccflags-y := -I$(incdir)				\
 		    -DDISABLE_BRANCH_PROFILING		\
 		    $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
+obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o reserved_mem.o
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index ed47674bc988..c8af6fe87bfb 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -6,6 +6,12 @@
 
 #include <linux/types.h>
 
+#define HYP_MEMBLOCK_REGIONS 128
+struct hyp_memblock_region {
+	phys_addr_t start;
+	phys_addr_t end;
+};
+
 struct hyp_pool;
 struct hyp_page {
 	unsigned int refcount;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
new file mode 100644
index 000000000000..5a3ad6f4e5bc
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_HYP_MM_H
+#define __KVM_HYP_MM_H
+
+#include <asm/kvm_pgtable.h>
+#include <asm/spectre.h>
+#include <linux/types.h>
+
+#include <nvhe/memory.h>
+#include <nvhe/spinlock.h>
+
+extern struct hyp_memblock_region kvm_nvhe_sym(hyp_memory)[];
+extern int kvm_nvhe_sym(hyp_memblock_nr);
+extern struct kvm_pgtable hyp_pgtable;
+extern hyp_spinlock_t __hyp_pgd_lock;
+extern struct hyp_pool hpool;
+extern u64 __io_map_base;
+extern u32 hyp_va_bits;
+
+int hyp_create_idmap(void);
+int hyp_map_vectors(void);
+int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
+int hyp_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
+int hyp_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
+int __hyp_create_mappings(unsigned long start, unsigned long size,
+			  unsigned long phys, unsigned long prot);
+unsigned long __hyp_create_private_mapping(phys_addr_t phys, size_t size,
+					   unsigned long prot);
+
+static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
+				     unsigned long *start, unsigned long *end)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct hyp_page *p = hyp_phys_to_page(phys);
+
+	*start = (unsigned long)p;
+	*end = *start + nr_pages * sizeof(struct hyp_page);
+	*start = ALIGN_DOWN(*start, PAGE_SIZE);
+	*end = ALIGN(*end, PAGE_SIZE);
+}
+
+static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
+{
+	unsigned long total = 0, i;
+
+	/* Provision the worst case scenario with 4 levels of page-table */
+	for (i = 0; i < 4; i++) {
+		nr_pages = DIV_ROUND_UP(nr_pages, PTRS_PER_PTE);
+		total += nr_pages;
+	}
+
+	return total;
+}
+
+static inline unsigned long hyp_s1_pgtable_size(void)
+{
+	struct hyp_memblock_region *reg;
+	unsigned long nr_pages, res = 0;
+	int i;
+
+	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
+		return 0;
+
+	for (i = 0; i < kvm_nvhe_sym(hyp_memblock_nr); i++) {
+		reg = &kvm_nvhe_sym(hyp_memory)[i];
+		nr_pages = (reg->end - reg->start) >> PAGE_SHIFT;
+		nr_pages = __hyp_pgtable_max_pages(nr_pages);
+		res += nr_pages << PAGE_SHIFT;
+	}
+
+	/* Allow 1 GiB for private mappings */
+	nr_pages = (1 << 30) >> PAGE_SHIFT;
+	nr_pages = __hyp_pgtable_max_pages(nr_pages);
+	res += nr_pages << PAGE_SHIFT;
+
+	return res;
+}
+
+#endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 72cfe53f106f..d7381a503182 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -11,9 +11,9 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
-	 cache.o cpufeature.o
+	 cache.o cpufeature.o setup.o mm.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-y += $(lib-objs)
 
 ##
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 8f3602f320ac..e2d62297edfe 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -247,4 +247,34 @@ alternative_else_nop_endif
 
 SYM_CODE_END(__kvm_handle_stub_hvc)
 
+SYM_FUNC_START(__kvm_init_switch_pgd)
+	/* Turn the MMU off */
+	pre_disable_mmu_workaround
+	mrs	x2, sctlr_el2
+	bic	x3, x2, #SCTLR_ELx_M
+	msr	sctlr_el2, x3
+	isb
+
+	tlbi	alle2
+
+	/* Install the new pgtables */
+	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
+	phys_to_ttbr x4, x3
+alternative_if ARM64_HAS_CNP
+	orr	x4, x4, #TTBR_CNP_BIT
+alternative_else_nop_endif
+	msr	ttbr0_el2, x4
+
+	/* Set the new stack pointer */
+	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
+	mov	sp, x0
+
+	/* And turn the MMU back on! */
+	dsb	nsh
+	isb
+	msr	sctlr_el2, x2
+	isb
+	ret	x1
+SYM_FUNC_END(__kvm_init_switch_pgd)
+
 	.popsection
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 933329699425..a0bfe0d26da6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -6,12 +6,15 @@
 
 #include <hyp/switch.h>
 
+#include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/mm.h>
+
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 #define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
@@ -106,6 +109,43 @@ static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
 	__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
 }
 
+static void handle___kvm_hyp_protect(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
+	DECLARE_REG(unsigned long, size, host_ctxt, 2);
+	DECLARE_REG(unsigned long, nr_cpus, host_ctxt, 3);
+	DECLARE_REG(unsigned long *, per_cpu_base, host_ctxt, 4);
+
+	cpu_reg(host_ctxt, 1) = __kvm_hyp_protect(phys, size, nr_cpus,
+						  per_cpu_base);
+}
+
+static void handle___hyp_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(enum arm64_hyp_spectre_vector, slot, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = hyp_cpu_set_vector(slot);
+}
+
+static void handle___hyp_create_mappings(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned long, start, host_ctxt, 1);
+	DECLARE_REG(unsigned long, size, host_ctxt, 2);
+	DECLARE_REG(unsigned long, phys, host_ctxt, 3);
+	DECLARE_REG(unsigned long, prot, host_ctxt, 4);
+
+	cpu_reg(host_ctxt, 1) = __hyp_create_mappings(start, size, phys, prot);
+}
+
+static void handle___hyp_create_private_mapping(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
+	DECLARE_REG(size_t, size, host_ctxt, 2);
+	DECLARE_REG(unsigned long, prot, host_ctxt, 3);
+
+	cpu_reg(host_ctxt, 1) = __hyp_create_private_mapping(phys, size, prot);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = kimg_fn_ptr(handle_##x)
@@ -125,6 +165,10 @@ static const hcall_t *host_hcall[] = {
 	HANDLE_FUNC(__kvm_get_mdcr_el2),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_aprs),
+	HANDLE_FUNC(__kvm_hyp_protect),
+	HANDLE_FUNC(__hyp_cpu_set_vector),
+	HANDLE_FUNC(__hyp_create_mappings),
+	HANDLE_FUNC(__hyp_create_private_mapping),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
new file mode 100644
index 000000000000..cad5dae197c6
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/spectre.h>
+
+#include <nvhe/early_alloc.h>
+#include <nvhe/gfp.h>
+#include <nvhe/memory.h>
+#include <nvhe/mm.h>
+#include <nvhe/spinlock.h>
+
+struct kvm_pgtable hyp_pgtable;
+
+hyp_spinlock_t __hyp_pgd_lock;
+u64 __io_map_base;
+
+struct hyp_memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
+int hyp_memblock_nr;
+
+int __hyp_create_mappings(unsigned long start, unsigned long size,
+			  unsigned long phys, unsigned long prot)
+{
+	int err;
+
+	hyp_spin_lock(&__hyp_pgd_lock);
+	err = kvm_pgtable_hyp_map(&hyp_pgtable, start, size, phys, prot);
+	hyp_spin_unlock(&__hyp_pgd_lock);
+
+	return err;
+}
+
+unsigned long __hyp_create_private_mapping(phys_addr_t phys, size_t size,
+					   unsigned long prot)
+{
+	unsigned long addr;
+	int ret;
+
+	hyp_spin_lock(&__hyp_pgd_lock);
+
+	size = PAGE_ALIGN(size + offset_in_page(phys));
+	addr = __io_map_base;
+	__io_map_base += size;
+
+	/* Are we overflowing on the vmemmap ? */
+	if (__io_map_base > __hyp_vmemmap) {
+		__io_map_base -= size;
+		addr = 0;
+		goto out;
+	}
+
+	ret = kvm_pgtable_hyp_map(&hyp_pgtable, addr, size, phys, prot);
+	if (ret) {
+		addr = 0;
+		goto out;
+	}
+
+	addr = addr + offset_in_page(phys);
+out:
+	hyp_spin_unlock(&__hyp_pgd_lock);
+
+	return addr;
+}
+
+int hyp_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
+{
+	unsigned long start = (unsigned long)from;
+	unsigned long end = (unsigned long)to;
+	unsigned long virt_addr;
+	phys_addr_t phys;
+
+	start = start & PAGE_MASK;
+	end = PAGE_ALIGN(end);
+
+	for (virt_addr = start; virt_addr < end; virt_addr += PAGE_SIZE) {
+		int err;
+
+		phys = hyp_virt_to_phys((void *)virt_addr);
+		err = __hyp_create_mappings(virt_addr, PAGE_SIZE, phys, prot);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back)
+{
+	unsigned long start, end;
+
+	hyp_vmemmap_range(phys, size, &start, &end);
+
+	return __hyp_create_mappings(start, end - start, back, PAGE_HYP);
+}
+
+static void *__hyp_bp_vect_base;
+int hyp_cpu_set_vector(enum arm64_hyp_spectre_vector slot)
+{
+	void *vector;
+
+	switch (slot) {
+	case HYP_VECTOR_DIRECT: {
+		vector = hyp_symbol_addr(__kvm_hyp_vector);
+		break;
+	}
+	case HYP_VECTOR_SPECTRE_DIRECT: {
+		vector = hyp_symbol_addr(__bp_harden_hyp_vecs);
+		break;
+	}
+	case HYP_VECTOR_INDIRECT:
+	case HYP_VECTOR_SPECTRE_INDIRECT: {
+		vector = (void *)__hyp_bp_vect_base;
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	vector = __kvm_vector_slot2addr(vector, slot);
+	*this_cpu_ptr(&kvm_hyp_vector) = (unsigned long)vector;
+
+	return 0;
+}
+
+int hyp_map_vectors(void)
+{
+	unsigned long bp_base;
+
+	if (!cpus_have_const_cap(ARM64_SPECTRE_V3A))
+		return 0;
+
+	bp_base = (unsigned long)hyp_symbol_addr(__bp_harden_hyp_vecs);
+	bp_base = __hyp_pa(bp_base);
+	bp_base = __hyp_create_private_mapping(bp_base, __BP_HARDEN_HYP_VECS_SZ,
+					       PAGE_HYP_EXEC);
+	if (!bp_base)
+		return -1;
+
+	__hyp_bp_vect_base = (void *)bp_base;
+
+	return 0;
+}
+
+int hyp_create_idmap(void)
+{
+	unsigned long start, end;
+
+	start = (unsigned long)hyp_symbol_addr(__hyp_idmap_text_start);
+	start = hyp_virt_to_phys((void *)start);
+	start = ALIGN_DOWN(start, PAGE_SIZE);
+
+	end = (unsigned long)hyp_symbol_addr(__hyp_idmap_text_end);
+	end = hyp_virt_to_phys((void *)end);
+	end = ALIGN(end, PAGE_SIZE);
+
+	/*
+	 * One half of the VA space is reserved to linearly map portions of
+	 * memory -- see va_layout.c for more details. The other half of the VA
+	 * space contains the trampoline page, and needs some care. Split that
+	 * second half in two and find the quarter of VA space not conflicting
+	 * with the idmap to place the IOs and the vmemmap. IOs use the lower
+	 * half of the quarter and the vmemmap the upper half.
+	 */
+	__io_map_base = start & BIT(hyp_va_bits - 2);
+	__io_map_base ^= BIT(hyp_va_bits - 2);
+	__hyp_vmemmap = __io_map_base | BIT(hyp_va_bits - 3);
+
+	return __hyp_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index dbe57ae84a0c..cfc6dac0f0ac 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -193,8 +193,6 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	return ret;
 }
 
-void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
-
 asmlinkage void __noreturn __kvm_hyp_psci_cpu_entry(void)
 {
 	struct kvm_host_psci_state *cpu_state = this_cpu_ptr(&kvm_host_psci_state);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
new file mode 100644
index 000000000000..9679c97b875b
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pgtable.h>
+
+#include <nvhe/early_alloc.h>
+#include <nvhe/gfp.h>
+#include <nvhe/memory.h>
+#include <nvhe/mm.h>
+
+struct hyp_pool hpool;
+struct kvm_pgtable_mm_ops hyp_pgtable_mm_ops;
+unsigned long hyp_nr_cpus;
+
+#define hyp_percpu_size ((unsigned long)__per_cpu_end - \
+			 (unsigned long)__per_cpu_start)
+
+static void *stacks_base;
+static void *vmemmap_base;
+static void *hyp_pgt_base;
+
+static int divide_memory_pool(void *virt, unsigned long size)
+{
+	unsigned long vstart, vend, nr_pages;
+
+	hyp_early_alloc_init(virt, size);
+
+	stacks_base = hyp_early_alloc_contig(hyp_nr_cpus);
+	if (!stacks_base)
+		return -ENOMEM;
+
+	hyp_vmemmap_range(__hyp_pa(virt), size, &vstart, &vend);
+	nr_pages = (vend - vstart) >> PAGE_SHIFT;
+	vmemmap_base = hyp_early_alloc_contig(nr_pages);
+	if (!vmemmap_base)
+		return -ENOMEM;
+
+	nr_pages = hyp_s1_pgtable_size() >> PAGE_SHIFT;
+	hyp_pgt_base = hyp_early_alloc_contig(nr_pages);
+	if (!hyp_pgt_base)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
+				 unsigned long *per_cpu_base)
+{
+	void *start, *end, *virt = hyp_phys_to_virt(phys);
+	int ret, i;
+
+	/* Recreate the hyp page-table using the early page allocator */
+	hyp_early_alloc_init(hyp_pgt_base, hyp_s1_pgtable_size());
+	ret = kvm_pgtable_hyp_init(&hyp_pgtable, hyp_va_bits,
+				   &hyp_early_alloc_mm_ops);
+	if (ret)
+		return ret;
+
+	ret = hyp_create_idmap();
+	if (ret)
+		return ret;
+
+	ret = hyp_map_vectors();
+	if (ret)
+		return ret;
+
+	ret = hyp_back_vmemmap(phys, size, hyp_virt_to_phys(vmemmap_base));
+	if (ret)
+		return ret;
+
+	ret = hyp_create_mappings(hyp_symbol_addr(__hyp_text_start),
+				  hyp_symbol_addr(__hyp_text_end),
+				  PAGE_HYP_EXEC);
+	if (ret)
+		return ret;
+
+	ret = hyp_create_mappings(hyp_symbol_addr(__start_rodata),
+				  hyp_symbol_addr(__end_rodata), PAGE_HYP_RO);
+	if (ret)
+		return ret;
+
+	ret = hyp_create_mappings(hyp_symbol_addr(__hyp_data_ro_after_init_start),
+				  hyp_symbol_addr(__hyp_data_ro_after_init_end),
+				  PAGE_HYP_RO);
+	if (ret)
+		return ret;
+
+	ret = hyp_create_mappings(hyp_symbol_addr(__bss_start),
+				  hyp_symbol_addr(__hyp_bss_end), PAGE_HYP);
+	if (ret)
+		return ret;
+
+	ret = hyp_create_mappings(hyp_symbol_addr(__hyp_bss_end),
+				  hyp_symbol_addr(__bss_stop), PAGE_HYP_RO);
+	if (ret)
+		return ret;
+
+	ret = hyp_create_mappings(virt, virt + size - 1, PAGE_HYP);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		start = (void *)kern_hyp_va(per_cpu_base[i]);
+		end = start + PAGE_ALIGN(hyp_percpu_size);
+		ret = hyp_create_mappings(start, end, PAGE_HYP);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void update_nvhe_init_params(void)
+{
+	struct kvm_nvhe_init_params *params;
+	unsigned long i, stack;
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		stack = (unsigned long)stacks_base + (i << PAGE_SHIFT);
+		params = per_cpu_ptr(&kvm_init_params, i);
+		params->stack_hyp_va = stack + PAGE_SIZE;
+		params->pgd_pa = __hyp_pa(hyp_pgtable.pgd);
+		__flush_dcache_area(params, sizeof(*params));
+	}
+}
+
+static void *hyp_zalloc_hyp_page(void *arg)
+{
+	return hyp_alloc_pages(&hpool, HYP_GFP_ZERO, 0);
+}
+
+void __noreturn __kvm_hyp_protect_finalise(void)
+{
+	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
+	struct kvm_cpu_context *host_ctxt = &host_data->host_ctxt;
+	unsigned long nr_pages, used_pages;
+	int ret;
+
+	/* Now that the vmemmap is backed, install the full-fledged allocator */
+	nr_pages = hyp_s1_pgtable_size() >> PAGE_SHIFT;
+	used_pages = hyp_early_alloc_nr_pages();
+	ret = hyp_pool_init(&hpool, __hyp_pa(hyp_pgt_base), nr_pages, used_pages);
+	if (ret)
+		goto out;
+
+	hyp_pgtable_mm_ops.zalloc_page = hyp_zalloc_hyp_page;
+	hyp_pgtable_mm_ops.phys_to_virt = hyp_phys_to_virt;
+	hyp_pgtable_mm_ops.virt_to_phys = hyp_virt_to_phys;
+	hyp_pgtable_mm_ops.get_page = hyp_get_page;
+	hyp_pgtable_mm_ops.put_page = hyp_put_page;
+	hyp_pgtable.mm_ops = &hyp_pgtable_mm_ops;
+
+out:
+	host_ctxt->regs.regs[0] = SMCCC_RET_SUCCESS;
+	host_ctxt->regs.regs[1] = ret;
+
+	__host_enter(host_ctxt);
+}
+
+int __kvm_hyp_protect(phys_addr_t phys, unsigned long size,
+		      unsigned long nr_cpus, unsigned long *per_cpu_base)
+{
+	struct kvm_nvhe_init_params *params;
+	void *virt = hyp_phys_to_virt(phys);
+	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
+	int ret;
+
+	if (phys % PAGE_SIZE || size % PAGE_SIZE || (u64)virt % PAGE_SIZE)
+		return -EINVAL;
+
+	hyp_spin_lock_init(&__hyp_pgd_lock);
+	hyp_nr_cpus = nr_cpus;
+
+	ret = divide_memory_pool(virt, size);
+	if (ret)
+		return ret;
+
+	ret = recreate_hyp_mappings(phys, size, per_cpu_base);
+	if (ret)
+		return ret;
+
+	update_nvhe_init_params();
+
+	/* Jump in the idmap page to switch to the new page-tables */
+	params = this_cpu_ptr(&kvm_init_params);
+	fn = (typeof(fn))__hyp_pa(hyp_symbol_addr(__kvm_init_switch_pgd));
+	fn(__hyp_pa(params), hyp_symbol_addr(__kvm_hyp_protect_finalise));
+
+	unreachable();
+}
diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
new file mode 100644
index 000000000000..02b0b18006f5
--- /dev/null
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 - Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/memblock.h>
+
+#include <asm/kvm_host.h>
+
+#include <nvhe/memory.h>
+#include <nvhe/mm.h>
+
+phys_addr_t hyp_mem_base;
+phys_addr_t hyp_mem_size;
+
+void __init early_init_dt_add_memory_hyp(u64 base, u64 size)
+{
+	struct hyp_memblock_region *reg;
+
+	if (kvm_nvhe_sym(hyp_memblock_nr) >= HYP_MEMBLOCK_REGIONS)
+		kvm_nvhe_sym(hyp_memblock_nr) = -1;
+
+	if (kvm_nvhe_sym(hyp_memblock_nr) < 0)
+		return;
+
+	reg = kvm_nvhe_sym(hyp_memory);
+	reg[kvm_nvhe_sym(hyp_memblock_nr)].start = base;
+	reg[kvm_nvhe_sym(hyp_memblock_nr)].end = base + size;
+	kvm_nvhe_sym(hyp_memblock_nr)++;
+}
+
+extern bool enable_protected_kvm;
+void __init reserve_kvm_hyp(void)
+{
+	u64 nr_pages, prev;
+
+	if (!enable_protected_kvm)
+		return;
+
+	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
+		return;
+
+	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
+		return;
+
+	hyp_mem_size += num_possible_cpus() << PAGE_SHIFT;
+	hyp_mem_size += hyp_s1_pgtable_size();
+
+	/*
+	 * The hyp_vmemmap needs to be backed by pages, but these pages
+	 * themselves need to be present in the vmemmap, so compute the number
+	 * of pages needed by looking for a fixed point.
+	 */
+	nr_pages = 0;
+	do {
+		prev = nr_pages;
+		nr_pages = (hyp_mem_size >> PAGE_SHIFT) + prev;
+		nr_pages = DIV_ROUND_UP(nr_pages * sizeof(struct hyp_page), PAGE_SIZE);
+		nr_pages += __hyp_pgtable_max_pages(nr_pages);
+	} while (nr_pages != prev);
+	hyp_mem_size += nr_pages << PAGE_SHIFT;
+
+	hyp_mem_base = memblock_find_in_range(0, memblock_end_of_DRAM(),
+					      hyp_mem_size, SZ_2M);
+	if (!hyp_mem_base) {
+		kvm_err("Failed to reserve hyp memory\n");
+		return;
+	}
+	memblock_reserve(hyp_mem_base, hyp_mem_size);
+
+	kvm_info("Reserved %lld MiB at 0x%llx\n", hyp_mem_size >> 20,
+		 hyp_mem_base);
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 278e163beda4..3cf9397dabdb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1264,10 +1264,10 @@ static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
 	.virt_to_phys		= kvm_host_pa,
 };
 
+u32 hyp_va_bits;
 int kvm_mmu_init(void)
 {
 	int err;
-	u32 hyp_va_bits;
 
 	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
 	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 095540667f0f..f81da019b677 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -34,6 +34,7 @@
 #include <asm/fixmap.h>
 #include <asm/kasan.h>
 #include <asm/kernel-pgtable.h>
+#include <asm/kvm_host.h>
 #include <asm/memory.h>
 #include <asm/numa.h>
 #include <asm/sections.h>
@@ -390,6 +391,8 @@ void __init arm64_memblock_init(void)
 
 	reserve_elfcorehdr();
 
+	reserve_kvm_hyp();
+
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
 
 	dma_contiguous_reserve(arm64_dma32_phys_limit);
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
