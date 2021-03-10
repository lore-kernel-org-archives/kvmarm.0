Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92FBC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 786A564FB3
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 786A564FB3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 057C64B686;
	Wed, 10 Mar 2021 12:59:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gA3hRv1UyDBU; Wed, 10 Mar 2021 12:59:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5894D4B62B;
	Wed, 10 Mar 2021 12:59:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84C9A4B661
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:59:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pf949JN39tVR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:59:04 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC1D44B68D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:59:03 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id p15so8233663wre.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CYUgjPCTwAZhevieC0Mxy3/co0eV77+l7/T8QyaZKic=;
 b=ifxq8HRvBBXoYKSgbPXr1K2yfYOPuL/eXvsiyCqeXHBkB28UWHtx9CdqpC36R6+m8w
 idCph9BKRw2op3MnltdECYmpnUtlZ77hrccyIM+7OLpQDfQR5HtOpfmzHnemhGhrCI8c
 mYZHRUBN7yfkZMu8DFZLtLMdT+e2Az7LF0LGclxrPQKNeMyt8Sd2mEHi6OdiTQmTXMeQ
 nFeAaAQtWv4klLWa12xwT5I5EQx+qVetLZo2jxNVMgyuEM/IcrMpL8MXJIinTns79FJp
 pwg6RzjyxJp92aeW2amxJz9YSV5nMrtekAkh25T9R11gEiEG1bHQ1xxGgunPb8hL0xa8
 jbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CYUgjPCTwAZhevieC0Mxy3/co0eV77+l7/T8QyaZKic=;
 b=CdBO23MK6AbJCTJnga6z3C2g/pZY7qf/r215Jo17jFp02y+rxedGNsMaIR+Ai7tyEe
 f0ik6cE9PN7oQAMbSdnVBLutmIqwJ2RuGnR0cNYw4Rn6NaMguefurd1AIpqJYxc0XB9+
 FEppF+LTfIz6laAlWeIfep1C2pl8hVn+xQAHBGKKjLph+HkEJo1GrLrvlLVUh+PsYBeZ
 Hwy9Otha2o6sbJcgqBQ+RILJ/iwcyfueyLdm+O21x9WAsjVINoh971p2WmCxNNs/PGDB
 F9eFbrIoEvIOkByvaaWI4ApQ1qS5liJ6D2YFTUQoeGzeArGCrM5RvPMATJoUwvhRYuaJ
 UIeg==
X-Gm-Message-State: AOAM532AiXQwge7M0OqTqTofpyUynOgaZ2Y7+bvnRYIlrUN9Fjs2PmMq
 LITjEHL2N/97MpLIaz04eY+elfvIfshw
X-Google-Smtp-Source: ABdhPJwrylHLc9EjnEo3QMwuGtetyPOrqoXFSRms3vEYNxR/2gbPzd3IMyAxX6mUFbpiO59A/QMaavzWC5bk
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:4ca9:: with SMTP id
 g41mr4572026wmp.150.1615399142908; Wed, 10 Mar 2021 09:59:02 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:48 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-32-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 31/34] KVM: arm64: Wrap the host with a stage 2
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

When KVM runs in protected nVHE mode, make use of a stage 2 page-table
to give the hypervisor some control over the host memory accesses. The
host stage 2 is created lazily using large block mappings if possible,
and will default to page mappings in absence of a better solution.

From this point on, memory accesses from the host to protected memory
regions (e.g. marked PROT_NONE) are fatal and lead to hyp_panic().

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_cpufeature.h       |   2 +
 arch/arm64/kernel/image-vars.h                |   3 +
 arch/arm64/kvm/arm.c                          |  10 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  34 +++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 246 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   5 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |   7 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
 12 files changed, 319 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6dce860f8bca..b127af02bd45 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -61,6 +61,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_create_mappings		16
 #define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
+#define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
index d34f85cba358..74043a149322 100644
--- a/arch/arm64/include/asm/kvm_cpufeature.h
+++ b/arch/arm64/include/asm/kvm_cpufeature.h
@@ -15,3 +15,5 @@
 #endif
 
 KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0)
+KVM_HYP_CPU_FTR_REG(SYS_ID_AA64MMFR0_EL1, arm64_ftr_reg_id_aa64mmfr0_el1)
+KVM_HYP_CPU_FTR_REG(SYS_ID_AA64MMFR1_EL1, arm64_ftr_reg_id_aa64mmfr1_el1)
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 940c378fa837..d5dc2b792651 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -131,6 +131,9 @@ KVM_NVHE_ALIAS(__hyp_bss_end);
 KVM_NVHE_ALIAS(__hyp_rodata_start);
 KVM_NVHE_ALIAS(__hyp_rodata_end);
 
+/* pKVM static key */
+KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d474eec606a3..7e6a81079652 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1889,12 +1889,22 @@ static int init_hyp_mode(void)
 	return err;
 }
 
+void _kvm_host_prot_finalize(void *discard)
+{
+	WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize));
+}
+
 static int finalize_hyp_mode(void)
 {
 	if (!is_protected_kvm_enabled())
 		return 0;
 
+	/*
+	 * Flip the static key upfront as that may no longer be possible
+	 * once the host stage 2 is installed.
+	 */
 	static_branch_enable(&kvm_protected_mode_initialized);
+	on_each_cpu(_kvm_host_prot_finalize, NULL, 1);
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
new file mode 100644
index 000000000000..d293cb328cc4
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2020 Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#ifndef __KVM_NVHE_MEM_PROTECT__
+#define __KVM_NVHE_MEM_PROTECT__
+#include <linux/kvm_host.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/virt.h>
+#include <nvhe/spinlock.h>
+
+struct host_kvm {
+	struct kvm_arch arch;
+	struct kvm_pgtable pgt;
+	struct kvm_pgtable_mm_ops mm_ops;
+	hyp_spinlock_t lock;
+};
+extern struct host_kvm host_kvm;
+
+int __pkvm_prot_finalize(void);
+int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool);
+void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
+
+static __always_inline void __load_host_stage2(void)
+{
+	if (static_branch_likely(&kvm_protected_mode_initialized))
+		__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
+	else
+		write_sysreg(0, vttbr_el2);
+}
+#endif /* __KVM_NVHE_MEM_PROTECT__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index e204ea77ab27..ce49795324a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
-	 cache.o cpufeature.o setup.o mm.o
+	 cache.o cpufeature.o setup.o mm.o mem_protect.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index a50ad9e9fc05..c164045af238 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -119,6 +119,7 @@ alternative_else_nop_endif
 
 	/* Invalidate the stale TLBs from Bootloader */
 	tlbi	alle2
+	tlbi	vmalls12e1
 	dsb	sy
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ae6503c9be15..f47028d3fd0a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/trap_handler.h>
 
@@ -151,6 +152,10 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, prot);
 }
 
+static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
+}
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -174,6 +179,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_cpu_set_vector),
 	HANDLE_FUNC(__pkvm_create_mappings),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
+	HANDLE_FUNC(__pkvm_prot_finalize),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
@@ -226,6 +232,11 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_SMC64:
 		handle_host_smc(host_ctxt);
 		break;
+	case ESR_ELx_EC_IABT_LOW:
+		fallthrough;
+	case ESR_ELx_EC_DABT_LOW:
+		handle_host_mem_abort(host_ctxt);
+		break;
 	default:
 		hyp_panic();
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
new file mode 100644
index 000000000000..5c88a325e6fc
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -0,0 +1,246 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_cpufeature.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/stage2_pgtable.h>
+
+#include <hyp/switch.h>
+
+#include <nvhe/gfp.h>
+#include <nvhe/memory.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/mm.h>
+
+extern unsigned long hyp_nr_cpus;
+struct host_kvm host_kvm;
+
+struct hyp_pool host_s2_mem;
+struct hyp_pool host_s2_dev;
+
+static void *host_s2_zalloc_pages_exact(size_t size)
+{
+	return hyp_alloc_pages(&host_s2_mem, get_order(size));
+}
+
+static void *host_s2_zalloc_page(void *pool)
+{
+	return hyp_alloc_pages(pool, 0);
+}
+
+static int prepare_s2_pools(void *mem_pgt_pool, void *dev_pgt_pool)
+{
+	unsigned long nr_pages, pfn;
+	int ret;
+
+	pfn = hyp_virt_to_pfn(mem_pgt_pool);
+	nr_pages = host_s2_mem_pgtable_pages();
+	ret = hyp_pool_init(&host_s2_mem, pfn, nr_pages, 0);
+	if (ret)
+		return ret;
+
+	pfn = hyp_virt_to_pfn(dev_pgt_pool);
+	nr_pages = host_s2_dev_pgtable_pages();
+	ret = hyp_pool_init(&host_s2_dev, pfn, nr_pages, 0);
+	if (ret)
+		return ret;
+
+	host_kvm.mm_ops = (struct kvm_pgtable_mm_ops) {
+		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
+		.zalloc_page = host_s2_zalloc_page,
+		.phys_to_virt = hyp_phys_to_virt,
+		.virt_to_phys = hyp_virt_to_phys,
+		.page_count = hyp_page_count,
+		.get_page = hyp_get_page,
+		.put_page = hyp_put_page,
+	};
+
+	return 0;
+}
+
+static void prepare_host_vtcr(void)
+{
+	u32 parange, phys_shift;
+	u64 mmfr0, mmfr1;
+
+	mmfr0 = arm64_ftr_reg_id_aa64mmfr0_el1.sys_val;
+	mmfr1 = arm64_ftr_reg_id_aa64mmfr1_el1.sys_val;
+
+	/* The host stage 2 is id-mapped, so use parange for T0SZ */
+	parange = kvm_get_parange(mmfr0);
+	phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
+
+	host_kvm.arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
+}
+
+int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool)
+{
+	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
+	int ret;
+
+	prepare_host_vtcr();
+	hyp_spin_lock_init(&host_kvm.lock);
+
+	ret = prepare_s2_pools(mem_pgt_pool, dev_pgt_pool);
+	if (ret)
+		return ret;
+
+	ret = kvm_pgtable_stage2_init(&host_kvm.pgt, &host_kvm.arch,
+				      &host_kvm.mm_ops);
+	if (ret)
+		return ret;
+
+	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
+	mmu->arch = &host_kvm.arch;
+	mmu->pgt = &host_kvm.pgt;
+	mmu->vmid.vmid_gen = 0;
+	mmu->vmid.vmid = 0;
+
+	return 0;
+}
+
+int __pkvm_prot_finalize(void)
+{
+	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
+	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
+
+	params->vttbr = kvm_get_vttbr(mmu);
+	params->vtcr = host_kvm.arch.vtcr;
+	params->hcr_el2 |= HCR_VM;
+	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		params->hcr_el2 |= HCR_FWB;
+	kvm_flush_dcache_to_poc(params, sizeof(*params));
+
+	write_sysreg(params->hcr_el2, hcr_el2);
+	__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
+
+	/*
+	 * Make sure to have an ISB before the TLB maintenance below but only
+	 * when __load_stage2() doesn't include one already.
+	 */
+	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
+
+	/* Invalidate stale HCR bits that may be cached in TLBs */
+	__tlbi(vmalls12e1);
+	dsb(nsh);
+	isb();
+
+	return 0;
+}
+
+static int host_stage2_unmap_dev_all(void)
+{
+	struct kvm_pgtable *pgt = &host_kvm.pgt;
+	struct memblock_region *reg;
+	u64 addr = 0;
+	int i, ret;
+
+	/* Unmap all non-memory regions to recycle the pages */
+	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
+		reg = &hyp_memory[i];
+		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
+		if (ret)
+			return ret;
+	}
+	return kvm_pgtable_stage2_unmap(pgt, addr, BIT(pgt->ia_bits) - addr);
+}
+
+static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
+{
+	int cur, left = 0, right = hyp_memblock_nr;
+	struct memblock_region *reg;
+	phys_addr_t end;
+
+	range->start = 0;
+	range->end = ULONG_MAX;
+
+	/* The list of memblock regions is sorted, binary search it */
+	while (left < right) {
+		cur = (left + right) >> 1;
+		reg = &hyp_memory[cur];
+		end = reg->base + reg->size;
+		if (addr < reg->base) {
+			right = cur;
+			range->end = reg->base;
+		} else if (addr >= end) {
+			left = cur + 1;
+			range->start = end;
+		} else {
+			range->start = reg->base;
+			range->end = end;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static inline int __host_stage2_idmap(u64 start, u64 end,
+				      enum kvm_pgtable_prot prot,
+				      struct hyp_pool *pool)
+{
+	return kvm_pgtable_stage2_map(&host_kvm.pgt, start, end - start, start,
+				      prot, pool);
+}
+
+static int host_stage2_idmap(u64 addr)
+{
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
+	struct kvm_mem_range range;
+	bool is_memory = find_mem_range(addr, &range);
+	struct hyp_pool *pool = is_memory ? &host_s2_mem : &host_s2_dev;
+	int ret;
+
+	if (is_memory)
+		prot |= KVM_PGTABLE_PROT_X;
+
+	hyp_spin_lock(&host_kvm.lock);
+	ret = kvm_pgtable_stage2_find_range(&host_kvm.pgt, addr, prot, &range);
+	if (ret)
+		goto unlock;
+
+	ret = __host_stage2_idmap(range.start, range.end, prot, pool);
+	if (is_memory || ret != -ENOMEM)
+		goto unlock;
+
+	/*
+	 * host_s2_mem has been provided with enough pages to cover all of
+	 * memory with page granularity, so we should never hit the ENOMEM case.
+	 * However, it is difficult to know how much of the MMIO range we will
+	 * need to cover upfront, so we may need to 'recycle' the pages if we
+	 * run out.
+	 */
+	ret = host_stage2_unmap_dev_all();
+	if (ret)
+		goto unlock;
+
+	ret = __host_stage2_idmap(range.start, range.end, prot, pool);
+
+unlock:
+	hyp_spin_unlock(&host_kvm.lock);
+
+	return ret;
+}
+
+void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_vcpu_fault_info fault;
+	u64 esr, addr;
+	int ret = 0;
+
+	esr = read_sysreg_el2(SYS_ESR);
+	if (!__get_fault_info(esr, &fault))
+		hyp_panic();
+
+	addr = (fault.hpfar_el2 & HPFAR_MASK) << 8;
+	ret = host_stage2_idmap(addr);
+	if (ret && ret != -EAGAIN)
+		hyp_panic();
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index c1a3e7e0ebbc..7488f53b0aa2 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -12,6 +12,7 @@
 #include <nvhe/early_alloc.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/trap_handler.h>
 
@@ -157,6 +158,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = kvm_host_prepare_stage2(host_s2_mem_pgt_base, host_s2_dev_pgt_base);
+	if (ret)
+		goto out;
+
 	pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
 		.zalloc_page = hyp_zalloc_hyp_page,
 		.phys_to_virt = hyp_phys_to_virt,
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 979a76cdf9fb..31bc1a843bf8 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -28,6 +28,8 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+#include <nvhe/mem_protect.h>
+
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
@@ -102,11 +104,6 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
-static void __load_host_stage2(void)
-{
-	write_sysreg(0, vttbr_el2);
-}
-
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index fbde89a2c6e8..255a23a1b2db 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -8,6 +8,8 @@
 #include <asm/kvm_mmu.h>
 #include <asm/tlbflush.h>
 
+#include <nvhe/mem_protect.h>
+
 struct tlb_inv_context {
 	u64		tcr;
 };
@@ -43,7 +45,7 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 
 static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 {
-	write_sysreg(0, vttbr_el2);
+	__load_host_stage2();
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/* Ensure write of the host VMID */
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
